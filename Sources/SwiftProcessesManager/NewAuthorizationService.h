//
//  NewAuthorizationService.h
//  SwiftProcessesManager
//
//  Created by Dmitry Lobanov on 13.06.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewAuthorizationService : NSObject
+ (BOOL)authorizeLabel:(NSString *)label;
@end

NS_ASSUME_NONNULL_END
