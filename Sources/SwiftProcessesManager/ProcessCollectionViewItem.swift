//
//  ProcessCollectionViewItem.swift
//  SwiftProcessesManager
//
//  Created by Dmitry Lobanov on 12.06.2021.
//

import AppKit

class ProcessCollectionViewItem: NSCollectionViewItem {
    @IBOutlet var idLabel: NSTextField!
    @IBOutlet var nameLabel: NSTextField!
    @IBOutlet var ownerLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func update(id: String) {
        self.idLabel.stringValue = id
    }
    func update(name: String) {
        self.nameLabel.stringValue = name
    }
    func update(owner: String) {
        self.ownerLabel.stringValue = owner
    }
    
    override var isSelected: Bool {
        didSet {
            self.view.layer?.backgroundColor = self.isSelected ? NSColor.red.cgColor : NSColor.clear.cgColor
        }
    }
}

class ProcessTableViewCell : NSTableCellView {
    @IBOutlet var idLabel: NSTextField!
    @IBOutlet var nameLabel: NSTextField!
    @IBOutlet var ownerLabel: NSTextField!
    
    func update(id: String) {
        self.idLabel.stringValue = id
    }
    func update(name: String) {
        self.nameLabel.stringValue = name
    }
    func update(owner: String) {
        self.ownerLabel.stringValue = owner
    }
}
