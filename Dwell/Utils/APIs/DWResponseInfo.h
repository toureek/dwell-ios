//
//  DWResponseInfo.h
//  Dwell
//
//  Created by toureek on 10/17/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const DWNFetchHomeConfig;
extern NSString *const DWKFetchHomeConfig;

extern NSString *const DWNFetchHomeRecommends;
extern NSString *const DWKFetchHomeRecommends;

@interface DWResponseErrorInfo : NSObject
@property (nonatomic, copy) NSString *errorCode;
@property (nonatomic, copy) NSString *error;

- (instancetype)initWithCode:(NSString *)errorCode msg:(NSString *)error;
+ (DWResponseErrorInfo *)emptyDataResponse;
+ (DWResponseErrorInfo *)errorDataResponse;
+ (DWResponseErrorInfo *)errorNetworkingResponse;
- (BOOL)isHttpOK;

@end



@class DWResponseErrorInfo;
@interface DWResponseInfo : NSObject
@property (nonatomic, strong) DWResponseErrorInfo *responseStatus;
@end



@class DWDisplayHomeAPI;
@interface DWHomeConfigResponse : DWResponseInfo
@property (nonatomic, strong) DWDisplayHomeAPI *configModel;
@end


@class DWDisplayHomeAPI;
@interface DWHomeRecommendsResponse : DWResponseInfo
@property (nonatomic, strong) DWDisplayHomeAPI *recommendModel;
@end
