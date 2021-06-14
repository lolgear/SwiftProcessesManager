//
//  TimeObserver.swift
//  SwiftProcessesManager
//
//  Created by Dmitry Lobanov on 14.06.2021.
//

import Foundation
import Combine

class TimeObserver {
    private var timer: Timer?
    private var didReceiveUpdatesSubject: PassthroughSubject<Void, Never> = .init()
    public var didReceiveUpdates: AnyPublisher<Void, Never> {
        self.didReceiveUpdatesSubject.eraseToAnyPublisher()
    }

    func configure() {
        self.timer = .scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] value in
            self?.didReceiveUpdatesSubject.send()
        })
    }
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
}
