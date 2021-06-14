//
//  NewAuthorizationService.m
//  SwiftProcessesManager
//
//  Created by Dmitry Lobanov on 13.06.2021.
//

#import "NewAuthorizationService.h"
@import ServiceManagement;

@implementation NewAuthorizationService

+ (BOOL)authorizeLabel:(NSString *)label {
    NSError *error;
    __auto_type result = [self blessHelperWithLabel:label withAuthRef:[self createAuthRef] error:&error];
    if (!result) {
        NSLog(@"error: %@", error);
    }
    return result;
}

+ (AuthorizationRef)createAuthRef {
    AuthorizationRef authRef = NULL;
    AuthorizationItem authItem = { kSMRightBlessPrivilegedHelper, 0, NULL, 0 };
    AuthorizationRights authRights = { 1, &authItem };
    AuthorizationFlags flags = kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed | kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights;

    OSStatus status = AuthorizationCreate(&authRights, kAuthorizationEmptyEnvironment, flags, &authRef);
    if (status != errAuthorizationSuccess) {
        NSLog(@"Failed to create AuthorizationRef, return code %i", status);
    }

    return authRef;
}

+ (BOOL)blessHelperWithLabel:(NSString *)label withAuthRef:(AuthorizationRef)authRef error:(NSError **)error {
    CFErrorRef err;
    BOOL result = SMJobBless(kSMDomainSystemLaunchd, (__bridge CFStringRef)label, authRef, &err);
    *error = (__bridge NSError *)err;

    return result;
}
@end
