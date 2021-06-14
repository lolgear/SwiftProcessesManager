//
//  AuthorizationTools.m
//  CommunicationProtocolSDK
//
//  Created by Dmitry Lobanov on 14.06.2021.
//

#import "AuthorizationTools.h"

@implementation AuthorizationTools
+ (NSData *)externalDataFromAuthorization:(AuthorizationRef)authorization {
    AuthorizationExternalForm externalForm;
    OSStatus error = AuthorizationMakeExternalForm(authorization, &externalForm);
    
    if (error == errAuthorizationSuccess) {
         return [[NSData alloc] initWithBytes:&externalForm length:sizeof(externalForm)];
    }
    
    return nil;
}
@end

static NSString *kAuthorizationRightsCommands_AttachToEndpoint = @"AuthorizationRightsCommands_AttachToEndpoint";
static NSString *kAuthorizationRightsCommands_AskUpdates = @"AuthorizationRightsCommands_AskUpdates";
static NSString *kAuthorizationRightsCommands_AskUpdatesWithReply = @"AuthorizationRightsCommands_AskUpdatesWithReply";
static NSString *kAuthorizationRightsCommands_KillProcess = @"AuthorizationRightsCommands_KillProcess";
static NSString *kAuthorizationRightsCommands_ReceiveUpdates = @"kAuthorizationRightsCommands_ReceiveUpdates";

@implementation AuthorizationRightsCommands
+ (NSString *)attachToEndpoint { return kAuthorizationRightsCommands_AttachToEndpoint;}
+ (NSString *)askUpdates { return kAuthorizationRightsCommands_AskUpdates; }
+ (NSString *)askUpdatesWithReply { return kAuthorizationRightsCommands_AskUpdatesWithReply; }
+ (NSString *)killProcess { return kAuthorizationRightsCommands_KillProcess; }
+ (NSString *)receiveUpdates { return kAuthorizationRightsCommands_ReceiveUpdates; }
@end

static NSString *kAuthorizationRightsNames_AttachToEndpoint = @"org.opensource.SwiftProcessesManager.attachToEndpoint";
static NSString *kAuthorizationRightsNames_AskUpdates = @"org.opensource.SwiftProcessesManagerLaunchAgent.askUpdates";
static NSString *kAuthorizationRightsNames_AskUpdatesWithReply = @"org.opensource.SwiftProcessesManagerLaunchAgent.askUpdatesWithReply";
static NSString *kAuthorizationRightsNames_KillProcess = @"org.opensource.SwiftProcessesManagerLaunchAgent.killProcess";
static NSString *kAuthorizationRightsNames_ReceiveUpdates = @"org.opensource.SwiftProcessesManager.ReceiveUpdates";

@interface AuthorizationRightsNames : NSObject
+ (NSString *)attachToEndpoint;
+ (NSString *)askUpdates;
+ (NSString *)askUpdatesWithReply;
+ (NSString *)killProcess;
+ (NSString *)receiveUpdates;
@end

@implementation AuthorizationRightsNames
+ (NSString *)attachToEndpoint { return kAuthorizationRightsNames_AttachToEndpoint; }
+ (NSString *)askUpdates { return kAuthorizationRightsNames_AskUpdates; }
+ (NSString *)askUpdatesWithReply { return kAuthorizationRightsNames_AskUpdatesWithReply; }
+ (NSString *)killProcess { return kAuthorizationRightsNames_KillProcess; }
+ (NSString *)receiveUpdates { return kAuthorizationRightsNames_ReceiveUpdates; }
@end

static NSString * kCommandKeyAuthRightName    = @"authRightName";
static NSString * kCommandKeyAuthRightDefault = @"authRightDefault";
static NSString * kCommandKeyAuthRightDesc    = @"authRightDescription";

@implementation AuthorizationRegistry

+ (NSDictionary *)commandInfo
{
    static dispatch_once_t sOnceToken;
    static NSDictionary *  sCommandInfo;
    
    dispatch_once(&sOnceToken, ^{
        sCommandInfo = @{
            AuthorizationRightsCommands.attachToEndpoint : @{
                kCommandKeyAuthRightName    : AuthorizationRightsNames.attachToEndpoint,
                kCommandKeyAuthRightDefault : @kAuthorizationRuleClassAllow,
                kCommandKeyAuthRightDesc    : NSLocalizedString(
                    @"Swift Processes Manager LaunchAgent is trying to attach back to main app",
                    @"prompt shown when user is required to authorize this action"
                )
            },
            AuthorizationRightsNames.askUpdates : @{
                kCommandKeyAuthRightName    : AuthorizationRightsNames.askUpdates,
                kCommandKeyAuthRightDefault : @kAuthorizationRuleClassAllow,
                kCommandKeyAuthRightDesc    : NSLocalizedString(
                    @"Swift Processes Manager is trying to ask updates and get processes list",
                    @"prompt shown when user is required to authorize to obtain processes list"
                )
            },
            AuthorizationRightsCommands.askUpdatesWithReply : @{
                kCommandKeyAuthRightName    : AuthorizationRightsNames.askUpdatesWithReply,
                kCommandKeyAuthRightDefault : @kAuthorizationRuleClassAllow,
                kCommandKeyAuthRightDesc    : NSLocalizedString(
                    @"Swift Processes Manager is trying to ask updates and get processes list",
                    @"prompt shown when user is required to authorize to obtain processes list"
                )
            },
            AuthorizationRightsCommands.killProcess : @{
                kCommandKeyAuthRightName    : AuthorizationRightsNames.killProcess,
                kCommandKeyAuthRightDefault : @kAuthorizationRuleClassAllow,
                kCommandKeyAuthRightDesc    : NSLocalizedString(
                    @"Swift Processes Manager is trying to terminate a process",
                    @"prompt shown when user is required to authorize to terminate a process"
                )
            },
            AuthorizationRightsCommands.receiveUpdates : @{
                kCommandKeyAuthRightName    : AuthorizationRightsNames.receiveUpdates,
                kCommandKeyAuthRightDefault : @kAuthorizationRuleClassAllow,
                kCommandKeyAuthRightDesc    : NSLocalizedString(
                    @"Swift Processes Manager is trying to ask updates and get processes list",
                    @"prompt shown when user is required to authorize to obtain processes list"
                )
            },
        };
    });
    return sCommandInfo;
}

+ (NSString *)authorizationRightForCommandString:(NSString *)string {
    return [self commandInfo][string][kCommandKeyAuthRightName];
}

+ (void)enumerateRightsUsingBlock:(void (^)(NSString * authRightName, id authRightDefault, NSString * authRightDesc))block {
    [self.commandInfo enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        #pragma unused(key)
        #pragma unused(stop)
        NSDictionary *  commandDict;
        NSString *      authRightName;
        id              authRightDefault;
        NSString *      authRightDesc;
        
        // If any of the following asserts fire it's likely that you've got a bug
        // in sCommandInfo.
        
        commandDict = (NSDictionary *) obj;
        assert([commandDict isKindOfClass:[NSDictionary class]]);

        authRightName = [commandDict objectForKey:kCommandKeyAuthRightName];
        assert([authRightName isKindOfClass:[NSString class]]);

        authRightDefault = [commandDict objectForKey:kCommandKeyAuthRightDefault];
        assert(authRightDefault != nil);

        authRightDesc = [commandDict objectForKey:kCommandKeyAuthRightDesc];
        assert([authRightDesc isKindOfClass:[NSString class]]);

        block(authRightName, authRightDefault, authRightDesc);
    }];
}

+ (void)setupAuthorizationRights:(AuthorizationRef)authRef {
    assert(authRef != NULL);
    [self enumerateRightsUsingBlock:^(NSString * authRightName, id authRightDefault, NSString * authRightDesc) {
        OSStatus    blockErr;
        
        // First get the right.  If we get back errAuthorizationDenied that means there's
        // no current definition, so we add our default one.
        
        blockErr = AuthorizationRightGet([authRightName UTF8String], NULL);
        if (blockErr == errAuthorizationDenied) {
            blockErr = AuthorizationRightSet(
                authRef,                                    // authRef
                [authRightName UTF8String],                 // rightName
                (__bridge CFTypeRef) authRightDefault,      // rightDefinition
                (__bridge CFStringRef) authRightDesc,       // descriptionKey
                NULL,                                       // bundle (NULL implies main bundle)
                CFSTR("Common")                             // localeTableName
            );
            assert(blockErr == errAuthorizationSuccess);
        } else {
            // A right already exists (err == noErr) or any other error occurs, we
            // assume that it has been set up in advance by the system administrator or
            // this is the second time we've run.  Either way, there's nothing more for
            // us to do.
        }
    }];
}

@end

@implementation AuthorizationVerifier
// Check that the client denoted by authData is allowed to run the specified command.
// authData is expected to be an NSData with an AuthorizationExternalForm embedded inside.
+ (NSError *)checkAuthorization:(NSData *)authData authorizationRightName:(NSString *)name {
    NSError *                   error;
    OSStatus                    err;
    OSStatus                    junk;
    AuthorizationRef            authRef;
    
    assert(name != nil);
    
    authRef = NULL;
    
    // First check that authData looks reasonable.
    
    error = nil;
    if ( (authData == nil) || ([authData length] != sizeof(AuthorizationExternalForm)) ) {
        error = [NSError errorWithDomain:NSOSStatusErrorDomain code:paramErr userInfo:nil];
    }
    
    // Create an authorization ref from that the external form data contained within.
    
    if (error == nil) {
        err = AuthorizationCreateFromExternalForm([authData bytes], &authRef);
        
        // Authorize the right associated with the command.
        
        if (err == errAuthorizationSuccess) {
            AuthorizationItem   oneRight = { NULL, 0, NULL, 0 };
            AuthorizationRights rights   = { 1, &oneRight };
            
            oneRight.name = name.UTF8String;
            assert(oneRight.name != NULL);
            
            err = AuthorizationCopyRights(
                                          authRef,
                                          &rights,
                                          NULL,
                                          kAuthorizationFlagExtendRights | kAuthorizationFlagInteractionAllowed,
                                          NULL
                                          );
        }
        if (err != errAuthorizationSuccess) {
            error = [NSError errorWithDomain:NSOSStatusErrorDomain code:err userInfo:nil];
        }
    }
    
    if (authRef != NULL) {
        junk = AuthorizationFree(authRef, 0);
        assert(junk == errAuthorizationSuccess);
    }
    
    return error;
}

+ (NSError *)checkAuthorization:(NSData *)authData command:(NSString *)command {
    assert(command != nil);
    __auto_type authorizationRightName = [AuthorizationRegistry authorizationRightForCommandString:command];
    return [self checkAuthorization:authData authorizationRightName:authorizationRightName];
}
@end
