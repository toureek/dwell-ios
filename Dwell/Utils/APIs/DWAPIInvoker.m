//
//  DWAPIInvoker.m
//  Dwell
//
//  Created by toureek on 10/17/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWAPIInvoker.h"
#import "DWDisplayModel.h"
#import "DWResponseInfo.h"

#import <AFNetworking.h>
#import <Mantle.h>

static NSString *const kDWBaseURL = @"https://5a317c7c-a6ce-4664-a832-4772145337d0.mock.pstmn.io/";

NSString *const kDWHomeFetchConfigs = @"config";
NSString *const kDWHomeFetchRecommends = @"recommends";


@implementation DWAPIInvoker
- (NSString *)requestURL:(NSString *)requestURL {
    NSLog(@"%@", [NSString stringWithFormat:@"%@%@", [DWAPIInvoker baseURL], requestURL ? : @""]);
    return [NSString stringWithFormat:@"%@%@", [DWAPIInvoker baseURL], requestURL ? : @""];
}

+ (NSString *)baseURL {
    return [NSString stringWithFormat:@"%@", kDWBaseURL];
}

+ (NSMutableDictionary *)baseParameter {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 自定义获取用户设备信息 device_id carrierName os_version app_version timestamps
    return parameters;
}

- (NSMutableDictionary *)baseParameter {
    return [DWAPIInvoker baseParameter];
}

- (NSTimeInterval)currentTimestamp {
    return [[NSDate date] timeIntervalSince1970];
}
@end



@interface DWHomeAPIInvoker ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation DWHomeAPIInvoker
- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _manager;
}

- (void)fetchHomeConfigs {
    [self.manager GET:[NSString stringWithFormat:@"%@%@", kDWBaseURL, kDWHomeFetchConfigs]
      parameters:nil progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             DWHomeConfigResponse *info = [[DWHomeConfigResponse alloc] init];
             if (!responseObject) {
                 info.responseStatus = [DWResponseErrorInfo emptyDataResponse];
                 [[NSNotificationCenter defaultCenter] postNotificationName:DWNFetchHomeConfig
                                                                     object:nil
                                                                   userInfo:@{DWKFetchHomeConfig : info}];
                 return;
             }
             
             if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
                 NSDictionary *dict;     NSError *error = nil;
                 dict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
                 if (!dict) {  // 数据解析失败 并通知到notificationHandler Toast弹出提示 （客户端处理的问题）
                     return;
                 }
                 
                 info.responseStatus = [[DWResponseErrorInfo alloc] initWithCode:dict[@"errno"] ? : @"0"
                                                                             msg:dict[@"error"] ? : @""];
                 DWDisplayHomeAPI *home = [MTLJSONAdapter modelOfClass:DWDisplayHomeAPI.class
                                                    fromJSONDictionary:dict[@"data"]
                                                                 error:nil];
                 info.configModel = home;
                 [[NSNotificationCenter defaultCenter] postNotificationName:DWNFetchHomeConfig
                                                                     object:nil
                                                                   userInfo:@{DWKFetchHomeConfig : info}];
             }
         }
         failure:^(NSURLSessionTask *operation, NSError *error) {
             DWHomeConfigResponse *info = [[DWHomeConfigResponse alloc] init];
             info.responseStatus = [DWResponseErrorInfo errorNetworkingResponse];
             [[NSNotificationCenter defaultCenter] postNotificationName:DWNFetchHomeConfig
                                                                 object:nil
                                                               userInfo:@{DWKFetchHomeConfig : info}];
    }];
}

- (void)fetchHomeRecommends {
    [self.manager GET:[NSString stringWithFormat:@"%@%@", kDWBaseURL, kDWHomeFetchRecommends]
      parameters:nil progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             DWHomeRecommendsResponse *info = [[DWHomeRecommendsResponse alloc] init];
             if (!responseObject) {
                 info.responseStatus = [DWResponseErrorInfo emptyDataResponse];
                 [[NSNotificationCenter defaultCenter] postNotificationName:DWNFetchHomeRecommends
                                                                     object:nil
                                                                   userInfo:@{DWKFetchHomeRecommends : info}];
                 return;
             }

             if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
                 NSDictionary *dict;     NSError *error = nil;
                 dict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
                 if (!dict) {
                     return;  // 数据解析失败 并通知到notificationHandler Toast弹出提示 （客户端处理的问题）
                 }
                 
                 info.responseStatus = [[DWResponseErrorInfo alloc] initWithCode:dict[@"errno"] ? : @"0"
                                                                             msg:dict[@"error"] ? : @""];
                 DWDisplayHomeAPI *home = [MTLJSONAdapter modelOfClass:DWDisplayHomeAPI.class
                                                    fromJSONDictionary:dict[@"data"]
                                                                 error:nil];
                 info.recommendModel = home;
                 [[NSNotificationCenter defaultCenter] postNotificationName:DWNFetchHomeRecommends
                                                                     object:nil
                                                                   userInfo:@{DWKFetchHomeRecommends : info}];
             }
         }
         failure:^(NSURLSessionTask *operation, NSError *error) {
             DWHomeRecommendsResponse *info = [[DWHomeRecommendsResponse alloc] init];
             info.responseStatus = [DWResponseErrorInfo errorNetworkingResponse];
             [[NSNotificationCenter defaultCenter] postNotificationName:DWNFetchHomeRecommends
                                                                 object:nil
                                                               userInfo:@{DWKFetchHomeRecommends : info}];
         }];
}

@end
