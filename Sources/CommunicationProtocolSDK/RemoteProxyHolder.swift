//
//  RemoteProxyHolder.swift
//  CommunicationProtocolSDK
//
//  Created by Dmitry Lobanov on 12.06.2021.
//

import Foundation

public struct RemoteProxyHolder<Protocol> {
    public let value: NSXPCConnection
    public private(set) var remoteProxyObject: Protocol?
    public init(_ value: NSXPCConnection) {
        self.value = value
        self.configure(self.value)
    }
    
    public init(value: NSXPCConnection, sync: Bool = false) {
        self.init(value)
        self.remoteProxyObject = self.remoteProxyObject(sync: false)
    }
    
    public func remoteProxyObject(sync: Bool = false) -> Protocol? {
        if sync {
            return value.remoteObjectProxyWithErrorHandler { error in
                print("\(#function) error: \(error)")
            } as? Protocol
        }
        return value.synchronousRemoteObjectProxyWithErrorHandler { error in
            print("\(#function) error: \(error)")
        } as? Protocol
    }
    
    private func configure(_ connection: NSXPCConnection) {
        connection.invalidationHandler = {
            print("\(#function) connection has been invalidated")
        }
        connection.interruptionHandler = {
            print("\(#function) connection has been interrupted")
        }
    }
}
