//
//  main.swift
//  SwiftProcessesManagerLaunchAgent
//
//  Created by Dmitry Lobanov on 13.06.2021.
//

import Foundation
import os
//import CommunicationProtocolSDK

enum Logging {
    static let logger: OSLog = .init(subsystem: "org.opensource.SwiftProcessesManagerLaunchAgent", category: "my_example")
}

class ListenerDelegate: NSObject, NSXPCListenerDelegate {
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        
        os_log("Got a connection", log: Logging.logger, type: .info)
        
        newConnection.exportedInterface = NSXPCInterface(with: ProcessServiceProtocol.self)
        let exportedObject = ProcessService()
        newConnection.exportedObject = exportedObject
        newConnection.resume()

        return true
    }
}

struct ListenerHolder {
    static var shared: Self = .init()
    var delegate: NSXPCListenerDelegate?
    mutating func configured() {
        let listener: NSXPCListener = .init(machServiceName: CommunicationProtocol.LaunchAgent.name)
        let delegate: NSXPCListenerDelegate = ListenerDelegate()
        self.delegate = delegate
        listener.delegate = delegate
        os_log("I am alive", log: Logging.logger, type: .info)
        listener.resume()
        
        RunLoop.current.run()
    }
}
    
ListenerHolder.shared.configured()
