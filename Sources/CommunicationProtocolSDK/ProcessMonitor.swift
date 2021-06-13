//
//  ProcessMonitor.swift
//  CommunicationProtocolSDK
//
//  Created by Dmitry Lobanov on 12.06.2021.
//

import Foundation
import Combine

public class ProcessMonitor {
    private var updatesSubject: PassthroughSubject<ProcessList, Never> = .init()
    public func updatesPublisher() -> AnyPublisher<ProcessList, Never> {
        self.updatesSubject.eraseToAnyPublisher()
    }
    public init() {}
}

/// MARK: - ProcessMonitoringProtocol
extension ProcessMonitor: ProcessMonitoringProtocol {
    public func receiveUpdates(_ updates: ProcessList) {
        self.updatesSubject.send(updates)
    }
}
