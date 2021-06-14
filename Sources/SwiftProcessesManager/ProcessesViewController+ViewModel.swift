//
//  ProcessesViewController+ViewModel.swift
//  SwiftProcessesManager
//
//  Created by Dmitry Lobanov on 12.06.2021.
//

import Foundation
import Combine

extension ProcessesViewController {
    class ViewModel {
        // Actually, we may remove this model.
        // It is better to use DiffableDataSource.
        // Dirty hacks.
        private var subscription: AnyCancellable?
        private var preferencesSubscription: AnyCancellable?
        private var didReceiveUpdatesSubject: PassthroughSubject<Void, Never> = .init()
        public var didReceiveUpdatesPublisher: AnyPublisher<Void, Never> {
            self.didReceiveUpdatesSubject.eraseToAnyPublisher()
        }
        
        private let preferencesObserver: PreferencesObserver = .init()
        private var model: ProcessesModel = .mock()
        private let serviceConnector: ServiceConnector = .init()
        init() {
            self.setup()
        }
    }
}

// MARK: - Updates
extension ProcessesViewController.ViewModel {
    func didReceiveUpdatesHandler(model: ProcessesModel) {
        self.model = self.filter(model: model)
        self.didReceiveUpdatesSubject.send()
    }
    func didReceiveUpdatesHandler() {
        self.didReceiveUpdatesHandler(model: self.model)
    }
}

// MARK: - Filtering
extension ProcessesViewController.ViewModel {
    func filter(model: ProcessesModel) -> ProcessesModel {
        if self.preferencesObserver.settings.shouldDisplayOnlyMyOwnProcesses {
            return .init(model.items.filter({$0.owner == "dmitry"}))
        }
        else {
            return model
        }
    }
}

// MARK: - Setup
extension ProcessesViewController.ViewModel {
    func setup() {
        self.configureSubscriptions()
        self.preferencesObserver.retrieveSettings()
        self.preferencesObserver.startObserving()
    }
}

// MARK: - Subscriptions
extension ProcessesViewController.ViewModel {
    func configureSubscriptions() {
        self.subscription = self.serviceConnector.updatesPublisher.receive(on: DispatchQueue.main).sink { [weak self] value in
            self?.didReceiveUpdatesHandler(model: value)
        }
        
        self.preferencesSubscription = self.preferencesObserver.didReceiveUpdates.sink(receiveValue: { [weak self] value in
            self?.didReceiveUpdatesHandler()
        })
    }
}

// MARK: - Load Data
extension ProcessesViewController.ViewModel {
    func configureConnection() {
        self.serviceConnector.start()
    }
    
    func askUpdates() {
        self.serviceConnector.askUpdates()
    }
    
    func loadData() {
        self.configureConnection()
        self.askUpdates()
    }
    
    func abortConnection() {
        self.serviceConnector.stop()
    }
}

// MARK: - Collection
extension ProcessesViewController.ViewModel {
    func countOfSections() -> Int {
        self.model.items.count
    }
    func count(section: Int) -> Int {
        guard section == 0 else { return 0 }
        return self.model.items.count
    }
    func item(at: IndexPath) -> Item? {
        guard self.model.items.indices.contains(at.item) else {
            return nil
        }
        return ItemConverter.asItem(self.model.items[at.item])
    }
    func shouldAbortProcess(at: IndexPath) {
        guard self.model.items.indices.contains(at.item) else {
            return
        }
        let item = self.model.items[at.item]
        self.serviceConnector.kill(process: item.id) { [weak self] value in
            if let error = value {
                print("error during killing process: \(error)")
            }
            else {
                self?.askUpdates()
            }
        }
    }
}

// MARK: - Visible Item
extension ProcessesViewController.ViewModel {
    struct Item {
        let processId: String
        let processName: String
        let processOwner: String
        var compactName: String {
            if let name = self.processName.components(separatedBy: "/").last {
                return name
            }
            return self.processName
        }
    }
}

// MARK: Item Converter
private extension ProcessesViewController.ViewModel {
    enum ItemConverter {
        static func asItem(_ model: ProcessesModel.Process) -> Item {
            .init(processId: "\(model.id)", processName: model.name, processOwner: model.owner)
        }
    }
}
