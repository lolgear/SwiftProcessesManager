//
//  TimeObserver.swift
//  SwiftProcessesManager
//
//  Created by Dmitry Lobanov on 14.06.2021.
//

import Foundation
import Combine

class TimeObserver {
    private let timeInterval: TimeInterval = 5.0
    private var timer: Timer?
    private var didReceiveUpdatesSubject: PassthroughSubject<Void, Never> = .init()
    public var didReceiveUpdates: AnyPublisher<Void, Never> {
        self.didReceiveUpdatesSubject.eraseToAnyPublisher()
    }

    func configure() {
        self.timer = .scheduledTimer(withTimeInterval: self.timeInterval, repeats: true, block: { [weak self] value in
            self?.didReceiveUpdatesSubject.send()
        })
    }
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
}
