//
//  DWResponseInfo.m
//  Dwell
//
//  Created by toureek on 10/17/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWResponseInfo.h"
#import "DWDisplayModel.h"

NSString *const DWNFetchHomeConfig = @"DWNFetchHomeConfig";
NSString *const DWKFetchHomeConfig = @"DWKFetchHomeConfig";

NSString *const DWNFetchHomeRecommends = @"DWNFetchHomeRecommends";
NSString *const DWKFetchHomeRecommends = @"DWKFetchHomeRecommends";

static NSString *const kDWDefaultErrorCode = @"-1";
static NSString *const kDWDefaultErrorMsg = @"网络请求异常";

static NSString *const kDWDefaultSuccessErrorCode = @"0";
static NSString *const kDWDefaultEmptyDataMsg = @"本次请求没有响应数据";
static NSString *const kDWDefaultErrorDataMsg = @"本次请求数据异常 请稍后重试";
static NSString *const kDWDefaultErrorNetworkMsg = @"当前网络异常 请稍后重试";

@implementation DWResponseErrorInfo
- (instancetype)initWithCode:(NSString *)errorCode msg:(NSString *)error {
    self = [super init];
    if (self) {
        _errorCode = errorCode;
        _error = error;
    }
    return self;
}

+ (DWResponseErrorInfo *)emptyDataResponse {
    return [[DWResponseErrorInfo alloc] initWithCode:kDWDefaultSuccessErrorCode msg:kDWDefaultEmptyDataMsg];
}

+ (DWResponseErrorInfo *)errorDataResponse {
    return [[DWResponseErrorInfo alloc] initWithCode:kDWDefaultErrorCode msg:kDWDefaultErrorDataMsg];
}

+ (DWResponseErrorInfo *)errorNetworkingResponse {
    return [[DWResponseErrorInfo alloc] initWithCode:kDWDefaultErrorCode msg:kDWDefaultErrorNetworkMsg];
}

- (BOOL)isHttpOK {
    return [_errorCode isEqualToString:kDWDefaultSuccessErrorCode];
}
@end



@implementation DWResponseInfo
- (instancetype)init {
    self = [super init];
    if (self) {
        self.responseStatus = [[DWResponseErrorInfo alloc] initWithCode:kDWDefaultErrorCode msg:kDWDefaultErrorMsg];
    }
    return self;
}
@end




@implementation DWHomeConfigResponse
@end



@implementation DWHomeRecommendsResponse
@end
