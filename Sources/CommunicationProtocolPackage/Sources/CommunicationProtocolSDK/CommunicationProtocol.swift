//
//  CommunicationProtocol.swift
//  CommunicationProtocolSDK
//
//  Created by Dmitry Lobanov on 12.06.2021.
//

import Foundation
public enum CommunicationProtocol {
    public enum EmbeddedXPC {
        public static let name: String = "org.opensource.SwiftProcessesManagerXPCService"
    }
    public enum LaunchAgent {
        public static let name: String = "org.opensource.SwiftProcessesManagerLaunchAgent"
    }
}

