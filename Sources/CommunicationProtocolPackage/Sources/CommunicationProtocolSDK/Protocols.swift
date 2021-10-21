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
    func obtainAuthorization(reply: @escaping (Data) -> ())
}

/// App protocol.
@objc public protocol ProcessMonitoringProtocol {
    func receiveUpdates(_ updates: ProcessList)
}

/// (XPC) Service Protocol.
@objc public protocol EasySecureProcessServiceProtocol {
    func secureAttach(authorization: NSData, on endpoint: NSXPCListenerEndpoint)
    func secureKill(authorization: NSData, process: Int, reply: @escaping (NSError?) -> ())
    func secureAskUpdates(authorization: NSData)
    func secureAskUpdates(authorization: NSData, reply: @escaping (ProcessList) -> ())
}

/// App protocol.
@objc public protocol EasySecureProcessMonitoringProtocol {
    func secureReceiveUpdates(authorization: NSData, updates: ProcessList)
}
