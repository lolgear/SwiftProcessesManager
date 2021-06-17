//
//  Settings.swift
//  ProcessessManagerSettingsSDK
//
//  Created by Dmitry Lobanov on 14.06.2021.
//

import Foundation

public enum SettingsScope {
    public enum Names {
        public static let shouldDisplayOnlyMyOwnProcesses: String = "ShouldDisplayOnlyMyOwnProcesses"
    }
    public enum Notifications {
        public static let preferencesDidChange: String = "PreferencesDidChange"
    }
    public static let domain: String = "org.opensource.SwiftProcessesManager"
}


public extension SettingsScope {
    struct Settings {
        public var shouldDisplayOnlyMyOwnProcesses: Bool
        public static let `default`: Self = .init(shouldDisplayOnlyMyOwnProcesses: false)
        
        public init(shouldDisplayOnlyMyOwnProcesses: Bool) {
            self.shouldDisplayOnlyMyOwnProcesses = shouldDisplayOnlyMyOwnProcesses
        }
    }
}

///  For ObjectiveC
@objcMembers
public class SettingsObjectiveC : NSObject {
    @objc public static var Names_ShouldDisplayOnlyMyOwnProcesses: String = SettingsScope.Names.shouldDisplayOnlyMyOwnProcesses
    @objc public static var Names_Domain: String = SettingsScope.domain
    @objc public static var Notifications_PreferencesDidChange: String = SettingsScope.Notifications.preferencesDidChange
}
