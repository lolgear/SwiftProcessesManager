//
//  EasySecureProcessMonitor.swift
//  CommunicationProtocolSDK
//
//  Created by Dmitry Lobanov on 14.06.2021.
//

import Foundation
import Combine

public class EasySecureProcessMonitor {
    private var updatesSubject: PassthroughSubject<ProcessList, Never> = .init()
    public func updatesPublisher() -> AnyPublisher<ProcessList, Never> {
        self.updatesSubject.eraseToAnyPublisher()
    }
    public init() {}
}

/// MARK: - ProcessMonitoringProtocol
extension EasySecureProcessMonitor: EasySecureProcessMonitoringProtocol {
    public func secureReceiveUpdates(authorization: NSData, updates: ProcessList) {
        let error = AuthorizationVerifier.checkAuthorization(authorization as Data, command: AuthorizationRightsCommands.receiveUpdates)
        if let error = error {
            print("Authorization error occurred. \(error)")
        }
        else {
            self.updatesSubject.send(updates)
        }
    }
}
