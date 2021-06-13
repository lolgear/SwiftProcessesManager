//
//  ProcessService.swift
//  CommunicationProtocolSDK
//
//  Created by Dmitry Lobanov on 12.06.2021.
//

import Foundation

public class ProcessService: NSObject {
    private var remoteProxyHolder: RemoteProxyHolder<ProcessMonitoringProtocol>?
    private var remoteObjectProxy: ProcessMonitoringProtocol? {
        self.remoteProxyHolder?.remoteProxyObject
    }
}

extension ProcessService: ProcessServiceProtocol {
    /// Actually, we may pass some data to check that endpoint is coming from registered facility.
    
    public func attach(on endpoint: NSXPCListenerEndpoint) {
        let connection: NSXPCConnection = .init(listenerEndpoint: endpoint)
        connection.remoteObjectInterface = .init(with: ProcessMonitoringProtocol.self)
        
        connection.resume()
        self.remoteProxyHolder = .init(value: connection, sync: false)
    }
    
    public func kill(process: Int, reply: @escaping (NSError?) -> ()) {
        let result = ProcessHitman.kill(processId: process)
        
        switch result {
        case 0: reply(nil)
        case let value: reply(.init(domain: "serviceDomain", code: Int(value), userInfo: [:]))
        }
    }
    
    public func askUpdates() {
        let processes = self.gatherProcesses()
        guard let proxy = self.remoteObjectProxy else {
            print("proxy is not set")
            return
        }
        proxy.receiveUpdates(processes)
    }
    
    public func askUpdates(reply: @escaping (ProcessList) -> ()) {
        let processes = self.gatherProcesses()
        reply(processes)
    }
}

/// Gather Processes
extension ProcessService {
    func gatherProcesses() -> ProcessList {
        ProcessGatherer.gatherProcesses()
    }
}

