//
//  AuthorizationTools.h
//  CommunicationProtocolSDK
//
//  Created by Dmitry Lobanov on 14.06.2021.
//

#import <Foundation/Foundation.h>
@import ServiceManagement;

NS_ASSUME_NONNULL_BEGIN

@interface AuthorizationTools : NSObject
+ (nullable NSData *)externalDataFromAuthorization:(AuthorizationRef)authorization;
@end

@interface AuthorizationRightsCommands : NSObject
@property (copy, nonatomic, readonly, class) NSString *attachToEndpoint;
@property (copy, nonatomic, readonly, class) NSString *askUpdates;
@property (copy, nonatomic, readonly, class) NSString *askUpdatesWithReply;
@property (copy, nonatomic, readonly, class) NSString *killProcess;
@property (copy, nonatomic, readonly, class) NSString *receiveUpdates;
@end

@interface AuthorizationRegistry : NSObject
+ (void)setupAuthorizationRights:(AuthorizationRef)authRef;
@end

@interface AuthorizationVerifier : NSObject
+ (nullable NSError *)checkAuthorization:(nullable NSData *)authData command:(nullable NSString *)command;
@end

NS_ASSUME_NONNULL_END
