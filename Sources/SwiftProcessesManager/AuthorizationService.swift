//
//  AuthorizationService.swift
//  SwiftProcessesManager
//
//  Created by Dmitry Lobanov on 13.06.2021.
//

import Foundation
import ServiceManagement
import CommunicationProtocolSDK
import CommunicationProtocolUtilities

/// The purpose of this service is simple.
/// Authorized a launch service with a given mach name.

class AuthorizationService {
    private var authorization: AuthorizationRef?
    public var authorizationExternalForm: NSData? {
        self.authorization.flatMap(AuthorizationTools.externalData) as NSData?
    }

    @discardableResult
    func authorize(label: String, _ saveAuthorization: Bool = true) -> Bool {
        guard let authorization = self.askAuthorization() else {
            self.authorization = nil
            return false
        }
        let result = self.blessHelper(label: label, authorization: authorization)
        if !result {
            self.authorization = nil
        }
        self.authorization = authorization
        return result
    }
    
    func askAuthorization() -> AuthorizationRef? {
        NewAuthorizationService.obtainDefaultAuthorization()
    }
    
    @discardableResult
    func blessHelper(label: String, authorization: AuthorizationRef) -> Bool {
        NewAuthorizationService.authorizeLabel(label, reference: authorization)
    }
}
