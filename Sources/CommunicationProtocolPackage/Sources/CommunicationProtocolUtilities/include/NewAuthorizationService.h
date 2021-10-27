//
//  NewAuthorizationService.h
//  SwiftProcessesManager
//
//  Created by Dmitry Lobanov on 13.06.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewAuthorizationService : NSObject
+ (BOOL)authorizeLabel:(NSString *)label reference:(AuthorizationRef)reference;
+ (nullable AuthorizationRef)obtainAuthorizationForPriviledgedHelper;
+ (nullable AuthorizationRef)obtainDefaultAuthorization;
+ (nullable AuthorizationRef)obtainAuthorizationToExecute;
@end

NS_ASSUME_NONNULL_END
