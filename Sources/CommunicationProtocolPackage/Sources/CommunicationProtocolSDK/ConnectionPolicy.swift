//
//  ConnectionPolicy.swift
//  CommunicationProtocolSDK
//
//  Created by Dmitry Lobanov on 12.06.2021.
//

import Foundation

public enum ConnectionPolicy {
    case `noPolicy`
    case `verifyToken`
    private static func checkToken(for connection: NSXPCConnection) -> Bool {
        var token = connection.auditToken
        let tokenData = Data(bytes: &token, count: MemoryLayout.size(ofValue:token))
        let attributes = [kSecGuestAttributeAudit : tokenData]
        
        // Check which flags you need
        let flags: SecCSFlags = []
        var code: SecCode? = nil
        var status = SecCodeCopyGuestWithAttributes(nil, attributes as CFDictionary, flags, &code)
        
        if status != errSecSuccess {
            return false
        }
        
        guard let dynamicCode = code else {
            return false
        }
        // in this sample we duplicate the requirements from the Info.plist for simplicity
        // in a commercial application you could want to put the requirements in one place, for example in Active Compilation Conditions (Swift), or in preprocessor definitions (C, Objective-C)
        let entitlements = "identifier \"org.opensource.SwiftProcessesManager\" and anchor apple generic and certificate leaf[subject.CN] = \"Apple Development: gaussblurinc@gmail.com (XM5F53699F)\" and certificate 1[field.1.2.840.113635.100.6.2.1] /* exists */"
        var requirement: SecRequirement?
        
        status = SecRequirementCreateWithString(entitlements as CFString, flags, &requirement)
        
        if status != errSecSuccess {
            return false
        }
        
        status = SecCodeCheckValidity(dynamicCode, flags, requirement)
        
        return status == errSecSuccess
    }

    public func check(_ connection: NSXPCConnection) -> Result<Bool, Error> {
        switch self {
        case .noPolicy: return .success(true)
        case .verifyToken:
            return.success(Self.checkToken(for: connection))
        }
    }
}
