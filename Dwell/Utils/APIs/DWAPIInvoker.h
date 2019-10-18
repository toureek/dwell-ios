//
//  DWAPIInvoker.h
//  Dwell
//
//  Created by toureek on 10/17/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DWResponseInfo.h"

extern NSString *const kDWHomeFetchConfigs;
extern NSString *const kDWHomeFetchRecommends;

@interface DWAPIInvoker : NSObject
+ (NSString *)baseURL;
+ (NSMutableDictionary *)baseParameter;

- (NSString *)requestURL:(NSString *)requestURL;
- (NSMutableDictionary *)baseParameter;
@end



@interface DWHomeAPIInvoker : NSObject
- (void)fetchHomeConfigs;
- (void)fetchHomeRecommends;
@end
