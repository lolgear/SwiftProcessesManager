//
//  ViewController.swift
//  SwiftProcessesManager
//
//  Created by Dmitry Lobanov on 12.06.2021.
//

import Cocoa

class ViewController: NSViewController {

    // MARK: - Outlets
    @IBOutlet weak var processesView: NSView!
    private var processesViewController: ProcessesViewController!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUIElements()
        self.addLayout()
    }
    
    // MARK: - Setup
    func setupUIElements() {
        self.setupProcessesView()
    }
    
    func setupProcessesView() {
        self.processesViewController = .init()
        if let view = self.processesView {
            view.addSubview(self.processesViewController.view)
        }
    }
    
    // MARK: - Layout
    func addLayout() {
        let view = self.processesViewController.view
        if let superview = view.superview {
            view.translatesAutoresizingMaskIntoConstraints = false
            superview.translatesAutoresizingMaskIntoConstraints = false
            
            let constraints = [
                view.leftAnchor.constraint(equalTo: superview.leftAnchor),
                view.rightAnchor.constraint(equalTo: superview.rightAnchor),
                view.topAnchor.constraint(equalTo: superview.topAnchor),
                view.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            ]
            
            NSLayoutConstraint.activate(constraints)
        }
    }
}

