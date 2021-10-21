//
//  EasySecureEasySecureProcessService.swift
//  CommunicationProtocolSDK
//
//  Created by Dmitry Lobanov on 14.06.2021.
//

import Foundation
import CommunicationProtocolUtilities

public class EasySecureProcessService: NSObject {
    private var remoteProxyHolder: RemoteProxyHolder<EasySecureProcessMonitoringProtocol>?
    private var remoteObjectProxy: EasySecureProcessMonitoringProtocol? {
        self.remoteProxyHolder?.remoteProxyObject
    }
}

extension EasySecureProcessService: EasySecureProcessServiceProtocol {
    public func secureAttach(authorization: NSData, on endpoint: NSXPCListenerEndpoint) {
        
        let error = AuthorizationVerifier.checkAuthorization(authorization as Data, command: AuthorizationRightsCommands.attachToEndpoint)
        if let error = error {
            print("Authorization error occurred. \(error)")
            return
        }
        
        let connection: NSXPCConnection = .init(listenerEndpoint: endpoint)
        connection.remoteObjectInterface = .init(with: ProcessMonitoringProtocol.self)

        connection.resume()
        self.remoteProxyHolder = .init(value: connection, sync: false)
    }
    
    public func secureKill(authorization: NSData, process: Int, reply: @escaping (NSError?) -> ()) {
        let error = AuthorizationVerifier.checkAuthorization(authorization as Data, command: AuthorizationRightsCommands.killProcess)
        if let error = error {
            print("Authorization error occurred. \(error)")
            return
        }
        
        let result = ProcessHitman.kill(processId: process)

        switch result {
        case 0: reply(nil)
        case let value: reply(.init(domain: "serviceDomain", code: Int(value), userInfo: [:]))
        }
    }
    
    public func secureAskUpdates(authorization: NSData) {
        let error = AuthorizationVerifier.checkAuthorization(authorization as Data, command: AuthorizationRightsCommands.askUpdates)
        if let error = error {
            print("Authorization error occurred. \(error)")
            return
        }
        let processes = self.gatherProcesses()
        guard let proxy = self.remoteObjectProxy else {
            print("proxy is not set")
            return
        }
        proxy.secureReceiveUpdates(authorization: authorization, updates: processes)
    }
    
    public func secureAskUpdates(authorization: NSData, reply: @escaping (ProcessList) -> ()) {
        let error = AuthorizationVerifier.checkAuthorization(authorization as Data, command: AuthorizationRightsCommands.askUpdatesWithReply)
        if let error = error {
            print("Authorization error occurred. \(error)")
            return
        }
        let processes = self.gatherProcesses()
        reply(processes)
    }
}

/// Gather Processes
extension EasySecureProcessService {
    func gatherProcesses() -> ProcessList {
        ProcessGatherer.gatherProcesses()
    }
}

