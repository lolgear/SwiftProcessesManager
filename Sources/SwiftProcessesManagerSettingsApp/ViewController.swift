//
//  ViewController.swift
//  SwiftProcessesManagerSettingsApp
//
//  Created by Dmitry Lobanov on 14.06.2021.
//

import Cocoa
import ProcessessManagerSettingsSDK

class ViewController: NSViewController {
    @IBOutlet var button: NSButton!
    var settings: SettingsScope.Settings = .default
    private func retrieveSettings() {
        let domain = SettingsScope.domain as CFString
        let shouldDisplayOnlyMyOwnProcesses = SettingsScope.Names.shouldDisplayOnlyMyOwnProcesses as CFString
        let value = CFPreferencesCopyAppValue(shouldDisplayOnlyMyOwnProcesses, domain)
        if let value = value {
            self.settings.shouldDisplayOnlyMyOwnProcesses = value.boolValue
        }
    }
    
    func applySettings() {
        self.button.integerValue = self.settings.shouldDisplayOnlyMyOwnProcesses ? 1 : 0
    }
  
    @IBAction func checkboxClicked(_ sender: Any) {
        let domain = SettingsScope.domain as CFString
        let setting = SettingsScope.Names.shouldDisplayOnlyMyOwnProcesses as CFString
        let notificationName = SettingsScope.Names.shouldDisplayOnlyMyOwnProcesses
        if (sender as? NSButton)?.integerValue == 1 {
            CFPreferencesSetAppValue(setting, kCFBooleanTrue, domain)
        }
        else {
            CFPreferencesSetAppValue(setting, kCFBooleanFalse, domain)
        }
        let center = DistributedNotificationCenter.default()
        center.postNotificationName(.init(rawValue: notificationName), object: domain as String, userInfo: nil, deliverImmediately: true)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.retrieveSettings()
        self.applySettings()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

