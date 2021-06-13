//
//  ConnectionPolicy.swift
//  CommunicationProtocolSDK
//
//  Created by Dmitry Lobanov on 12.06.2021.
//

import Foundation

enum ConnectionPolicy {
    static func check(_ connection: NSXPCConnection?) -> Result<Bool, Error> {
        .success(true)
    }
}
