//
//  PreferencesObserver.swift
//  SwiftProcessesManager
//
//  Created by Dmitry Lobanov on 14.06.2021.
//

import Foundation
import ProcessessManagerSettingsSDK
import Combine

class PreferencesObserver : NSObject {
    var settings: SettingsScope.Settings = .default
    private var didReceiveUpdatesSubject: PassthroughSubject<SettingsScope.Settings, Never> = .init()
    public var didReceiveUpdates: AnyPublisher<SettingsScope.Settings, Never> {
        self.didReceiveUpdatesSubject.eraseToAnyPublisher()
    }
    
    func retrieveSettings() {
        let domain = SettingsScope.domain as CFString
        let shouldDisplayOnlyMyOwnProcesses = SettingsScope.Names.shouldDisplayOnlyMyOwnProcesses as CFString
        let value = CFPreferencesCopyAppValue(shouldDisplayOnlyMyOwnProcesses, domain)
        if let value = value {
            self.settings.shouldDisplayOnlyMyOwnProcesses = value.boolValue
        }
    }
    func startObserving() {
        let domain = SettingsScope.domain
        let notificationName = SettingsScope.Names.shouldDisplayOnlyMyOwnProcesses
        let center = DistributedNotificationCenter.default()
        center.addObserver(self, selector: #selector(Self.callback(with:)), name: NSNotification.Name.init(rawValue: notificationName), object: domain)
    }
    @objc private func callback(with notification: NSNotification?) {
        self.retrieveSettings()
        self.didReceiveUpdatesSubject.send(self.settings)
    }
    deinit {
        let center = DistributedNotificationCenter.default()
        center.removeObserver(self)
    }
}
