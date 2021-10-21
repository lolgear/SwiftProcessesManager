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
//        let authItem = kSMRightBlessPrivilegedHelper.withCString { authorizationString in
//            AuthorizationItem(name: authorizationString, valueLength: 0, value: nil, flags: 0)
//        }
//
//        // it's required to pass a pointer to the call of the AuthorizationRights.init function
//        let pointer = UnsafeMutablePointer<AuthorizationItem>.allocate(capacity: 1)
//        pointer.initialize(to: authItem)
//
//        let rights = AuthorizationRights.init(count: 1, items: pointer)
        
        var auth: AuthorizationRef?
        let status: OSStatus = AuthorizationCreate(nil, nil, [.interactionAllowed], &auth)
        if status != errAuthorizationSuccess {
            print("[SMJBS]: Authorization failed with status code \(status)")
            return nil
        }
                
        return auth
    }
    
    @discardableResult
    func blessHelper(label: String, authorization: AuthorizationRef) -> Bool {
        
        var error: Unmanaged<CFError>?
        let blessStatus = SMJobBless(kSMDomainSystemLaunchd, label as CFString, authorization, &error)
        
        if !blessStatus {
            print("[SMJBS]: Helper bless failed with error \(error!.takeUnretainedValue())")
        }
        
        return blessStatus
    }
}

//- (AuthorizationRef)createAuthRef
//{
//    AuthorizationRef authRef = NULL;
//    AuthorizationItem authItem = { kSMRightBlessPrivilegedHelper, 0, NULL, 0 };
//    AuthorizationRights authRights = { 1, &authItem };
//    AuthorizationFlags flags = kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed | kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights;
//
//    OSStatus status = AuthorizationCreate(&authRights, kAuthorizationEmptyEnvironment, flags, &authRef);
//    if (status != errAuthorizationSuccess) {
//        NSLog(@"Failed to create AuthorizationRef, return code %i", status);
//    }
//
//    return authRef;
//}


//static func askAuthorization() -> AuthorizationRef? {
//
//    var auth: AuthorizationRef?
//    let status: OSStatus = AuthorizationCreate(nil, nil, [], &auth)
//    if status != errAuthorizationSuccess {
//        NSLog("[SMJBS]: Authorization failed with status code \(status)")
//
//        return nil
//    }
//
//    return auth
//}
//
//@discardableResult
//static func blessHelper(label: String, authorization: AuthorizationRef) -> Bool {
//
//    var error: Unmanaged<CFError>?
//    let blessStatus = SMJobBless(kSMDomainSystemLaunchd, label as CFString, authorization, &error)
//
//    if !blessStatus {
//        NSLog("[SMJBS]: Helper bless failed with error \(error!.takeUnretainedValue())")
//    }
//
//    return blessStatus
//}

//- (AuthorizationRef)createAuthRef
//{
//    AuthorizationRef authRef = NULL;
//    AuthorizationItem authItem = { kSMRightBlessPrivilegedHelper, 0, NULL, 0 };
//    AuthorizationRights authRights = { 1, &authItem };
//    AuthorizationFlags flags = kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed | kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights;
//
//    OSStatus status = AuthorizationCreate(&authRights, kAuthorizationEmptyEnvironment, flags, &authRef);
//    if (status != errAuthorizationSuccess) {
//        NSLog(@"Failed to create AuthorizationRef, return code %i", status);
//    }
//
//    return authRef;
//}
//
//- (BOOL)blessHelperWithLabel:(NSString *)label withAuthRef:(AuthorizationRef)authRef error:(NSError **)error
//{
//    CFErrorRef err;
//    BOOL result = SMJobBless(kSMDomainSystemLaunchd, (__bridge CFStringRef)label, authRef, &err);
//    *error = (__bridge NSError *)err;
//
//    return result;
//}

//static func newAuthorize(label: String) -> Bool {
//    // try to get a valid empty authorisation
//    var authRef: AuthorizationRef?
//    var authStatus = AuthorizationCreate(nil, nil, [.preAuthorize], &authRef)
//
//    guard authStatus == errAuthorizationSuccess else {
//        print("Unable to get a valid empty authorization reference to load Helper daemon")
//        return false
//    }
//
//    // create an AuthorizationItem to specify we want to bless a privileged Helper
//    let authItem = kSMRightBlessPrivilegedHelper.withCString { authorizationString in
//        AuthorizationItem(name: authorizationString, valueLength: 0, value: nil, flags: 0)
//    }
//
//    // it's required to pass a pointer to the call of the AuthorizationRights.init function
//    let pointer = UnsafeMutablePointer<AuthorizationItem>.allocate(capacity: 1)
//    pointer.initialize(to: authItem)
//
//    defer {
//        // as we instantiate a pointer, it's our responsibility to make sure it's deallocated
//        pointer.deinitialize(count: 1)
//        pointer.deallocate()
//    }
//
//    // store the authorization items inside an AuthorizationRights object
//    var authRights = AuthorizationRights(count: 1, items: pointer)
//
//    let flags: AuthorizationFlags = [.interactionAllowed, .extendRights, .preAuthorize]
//    authStatus = AuthorizationCreate(&authRights, nil, flags, &authRef)
//
//    guard authStatus == errAuthorizationSuccess else {
//        print("Unable to get a valid loading authorization reference to load Helper daemon")
//        return false
//    }
//
//    // Try to install the helper and to load the daemon with authorization
//    var error: Unmanaged<CFError>?
//    if SMJobBless(kSMDomainSystemLaunchd, label as CFString, authRef, &error) == false {
//        let blessError = error!.takeRetainedValue() as Error
//        print("Error while installing the Helper: \(blessError.localizedDescription)")
//        return false
//    }
//
//    // Release the authorization
//    AuthorizationFree(authRef!, [])
//    return true
//}
//
