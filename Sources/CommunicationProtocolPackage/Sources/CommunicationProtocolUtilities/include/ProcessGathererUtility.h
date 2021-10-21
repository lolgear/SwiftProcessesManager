//
//  ProcessGathererUtility.h
//  CommunicationProtocolSDK
//
//  Created by Dmitry Lobanov on 12.06.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface ProcessGathererUtilityObjectProcess : NSObject
@property (nonatomic, nonnull, readonly) NSNumber *pid;
@property (nonatomic, nonnull, readonly) NSString *name;
@property (nonatomic, nonnull, readonly) NSString *owner;
@end

@interface ProcessGathererUtility : NSObject
@property (nonatomic, readonly, nullable, class) NSArray <ProcessGathererUtilityObjectProcess *> *allProcesses;
+ (BOOL)isProcessRunningWithExecutableName:(NSString *)executableName processes:(NSArray *)processes;
+ (BOOL)isProcessRunningWithExecutableName:(NSString *)executableName;
@end

// WARNING. Exposing internal property.
@interface NSXPCConnection (AuditToken)

// Apple uses this property internally to verify XPC connections.
// There is no safe pulicly available alternative (check by client pid, for example, is racy)
@property (nonatomic, readonly) audit_token_t auditToken;

@end

NS_ASSUME_NONNULL_END
