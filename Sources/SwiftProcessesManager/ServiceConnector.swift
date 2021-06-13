//
//  ServiceConnector.swift
//  SwiftProcessesManager
//
//  Created by Dmitry Lobanov on 12.06.2021.
//

import Foundation
import CommunicationProtocolSDK
import Combine

class ServiceConnector {
    private var service: RemoteProxyHolder<ProcessServiceProtocol>?
    private var monitor: ProcessMonitor = .init()
    public var updatesPublisher: AnyPublisher<ProcessesModel, Never> {
        self.monitor.updatesPublisher().map(ProcessesModel.ProcessesConverter.asProcessesModel).eraseToAnyPublisher()
    }
}

// MARK: - Start/Stop
extension ServiceConnector {
    func start() {
        self.stop()
        let connection: NSXPCConnection = .init(serviceName: CommunicationProtocol.ServiceName.name)
        connection.remoteObjectInterface = .init(with: ProcessServiceProtocol.self)
        connection.resume()
        self.service = .init(value: connection, sync: false)
    }
    func stop() {
        self.service?.value.suspend()
        self.service?.value.invalidate()
        self.service = nil
    }
}

// MARK: - Hitman
extension ServiceConnector {
    func kill(process: Int, reply: @escaping (NSError?) -> ()) {
        self.service?.remoteProxyObject?.kill(process: process, reply: reply)
    }
}

// MARK: - Gather
extension ServiceConnector {
    func askUpdates() {
        self.service?.remoteProxyObject?.askUpdates(reply: { [weak self] list in
            self?.monitor.receiveUpdates(list)
        })
    }
}
