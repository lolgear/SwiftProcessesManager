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
    private var authorizationService: AuthorizationService = .init()
    private var service: RemoteProxyHolder<ProcessServiceProtocol>?
    private var monitor: ProcessMonitor = .init()
    private let serviceKind: ServiceKind = .privilegedHelper
    public var updatesPublisher: AnyPublisher<ProcessesModel, Never> {
        self.monitor.updatesPublisher().map(ProcessesModel.ProcessesConverter.asProcessesModel).eraseToAnyPublisher()
    }
}

// MARK: - ServiceKind
extension ServiceConnector {
    enum ServiceKind {
        case xpc
        case privilegedHelper
        var createConnection: NSXPCConnection {
            switch self {
            case .xpc: return .init(serviceName: CommunicationProtocol.EmbeddedXPC.name)
            case .privilegedHelper: return .init(machServiceName: CommunicationProtocol.LaunchAgent.name, options: .privileged)
            }
        }
    }
}

// MARK: - Start/Stop
extension ServiceConnector {
    func authorize() -> Bool {
        if self.serviceKind == .privilegedHelper {
            return self.authorizationService.authorize(label: CommunicationProtocol.LaunchAgent.name)
        }
        return true
    }
    func start() {
        self.stop()
        if self.authorize() {
            let connection: NSXPCConnection = self.serviceKind.createConnection
            connection.remoteObjectInterface = .init(with: ProcessServiceProtocol.self)
            connection.resume()
            self.service = .init(value: connection, sync: false)
        }
    }
    func stop() {
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
