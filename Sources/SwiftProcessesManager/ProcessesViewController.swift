//
//  ProcessesViewController.swift
//  SwiftProcessesManager
//
//  Created by Dmitry Lobanov on 12.06.2021.
//

import AppKit
import Combine
import CommunicationProtocolSDK

class ProcessesViewController: NSViewController {
    // MARK: - Outlets
    @IBOutlet private var collectionView: NSCollectionView!
    @IBOutlet private var tableView: NSTableView!

    // MARK: - CollectionView Convenients
    let collectionViewItemIdentifier = NSUserInterfaceItemIdentifier(NSStringFromClass(ProcessCollectionViewItem.self))
    
    // MARK: - Subscriptions
    private var subscription: AnyCancellable?
    
    // MARK: - Model
    private(set) var model: ViewModel = .init()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUIElements()
//        self.addLayout()
        self.setupDataSources()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.setupToolbars()
    }
    
    // MARK: - Setup
    func setupUIElements() {
        self.setupCollectionView()
    }
    
    func setupCollectionView() {
        self.collectionView.collectionViewLayout = Layout.create()
        self.collectionView.dataSource = self
        self.collectionView.register(ProcessCollectionViewItem.self, forItemWithIdentifier: self.collectionViewItemIdentifier)
//        self.view.addSubview(self.collectionView)
    }
    
    func setupToolbars() {
        let killButton = self.view.window?.toolbar?.items.first
        killButton?.target = self
        killButton?.action = #selector(Self.killButtonClicked(sender:))
        let reconnectButton = self.view.window?.toolbar?.items[1]
        reconnectButton?.target = self
        reconnectButton?.action = #selector(Self.reconnectButtonClicked(sender:))
    }
    
    // MARK: - Layout
    func addLayout() {
        if let view = self.collectionView, let superview = view.superview {
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let constraints = [
                view.leftAnchor.constraint(equalTo: superview.leftAnchor),
                view.rightAnchor.constraint(equalTo: superview.rightAnchor),
                view.topAnchor.constraint(equalTo: superview.topAnchor),
                view.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            ]
            
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    // MARK: - Data Sources
    func setupDataSources() {
        self.subscription = self.model.didReceiveUpdatesPublisher.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.reload()
        }
        self.model.configureConnection()
        self.model.askUpdates()
    }
    
    // MARK: - Reload
    @objc func reload() {
        /// Ask if we need an update.
        if self.model.shouldUpdateCollection() {
            self.reloadCollectionView()
        }
    }
    func reloadCollectionView() {
        /// keep item.
        if let indexPath = self.collectionView.selectionIndexPaths.first {
            self.model.preserveItem(at: indexPath)
        }
        
        self.collectionView.reloadData()
        
        /// and select it.
        if let item = self.model.preservedItemIndex() {
            self.collectionView.selectItems(at: [.init(item: item, section: 0)], scrollPosition: .centeredVertically)
        }
    }
}

// MARK: - Toolbar Actions
extension ProcessesViewController {
    @IBAction func killButtonClicked(sender: NSToolbarItem) {
        let indexPaths = self.collectionView.selectionIndexPaths
        if indexPaths.count == 1, let item = indexPaths.first {
            self.model.shouldAbortProcess(at: item)
        }
    }
    @IBAction func reconnectButtonClicked(sender: NSToolbarItem) {
        self.model.configureConnection()
        self.model.askUpdates()
    }
}

// MARK: - NSCollectionViewDataSource
extension ProcessesViewController: NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        self.model.countOfSections()
    }
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        self.model.count(section: section)
    }
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let view = collectionView.makeItem(withIdentifier: self.collectionViewItemIdentifier, for: indexPath) as? ProcessCollectionViewItem
        guard let item = self.model.item(at: indexPath), let itemView = view else {
            return .init()
        }
        itemView.update(id: item.processId)
        itemView.update(name: item.compactName)
        itemView.update(owner: item.processOwner)
        return itemView
    }
}

// MARK: - NSCollectionViewLayout
extension ProcessesViewController {
    class Layout {
        static func create() -> NSCollectionViewLayout {            
            let itemSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
            let groupSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(20))
            let group: NSCollectionLayoutGroup = .horizontal(layoutSize: groupSize, subitems: [item])
            let section: NSCollectionLayoutSection = .init(group: group)
            let layout: NSCollectionViewCompositionalLayout = .init(section: section)
            return layout
        }
    }
}
