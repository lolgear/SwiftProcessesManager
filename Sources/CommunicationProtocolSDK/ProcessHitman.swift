//
//  ProcessHitman.swift
//  CommunicationProtocolSDK
//
//  Created by Dmitry Lobanov on 12.06.2021.
//

import Foundation

enum ProcessHitman {
    enum Signals {
        static let kill: Int32 = Darwin.SIGKILL
    }
    
    static func kill(processId: Int) -> Int32 {
        let pid: pid_t = .init(processId)
        return Darwin.killpg(pid, Signals.kill)        
    }
}
