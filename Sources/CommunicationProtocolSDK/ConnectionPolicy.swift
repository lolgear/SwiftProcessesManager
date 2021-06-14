//
//  ConnectionPolicy.swift
//  CommunicationProtocolSDK
//
//  Created by Dmitry Lobanov on 12.06.2021.
//

import Foundation

enum ConnectionPolicy {
    case `noPolicy`
    case `verifyToken`
    func check(_ connection: NSXPCConnection?) -> Result<Bool, Error> {
        switch self {
        case .noPolicy: return .success(true)
        case .verifyToken:            
            return.success(true)
        }
    }
}
