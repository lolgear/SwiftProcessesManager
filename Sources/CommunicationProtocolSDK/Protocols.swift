//
//  Protocols.swift
//  CommunicationProtocolSDK
//
//  Created by Dmitry Lobanov on 12.06.2021.
//

import Foundation

//// (XPC) Service protocol.
@objc public protocol ProcessServiceProtocol {
    func attach(on endpoint: NSXPCListenerEndpoint)
    func kill(process: Int, reply: @escaping (NSError?) -> ())
    func askUpdates() // Will call receiveUpdates on attached remoteObjectProxy.
    func askUpdates(reply: @escaping (ProcessList) -> ()) // Without monitor
}

/// App protocol.
@objc public protocol ProcessMonitoringProtocol {
    func receiveUpdates(_ updates: ProcessList)
}
