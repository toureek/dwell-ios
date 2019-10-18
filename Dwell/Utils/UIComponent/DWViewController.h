//
//  DWViewController.h
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_8 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_8P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)
#define IS_IPHONE_XS_MAX (IS_IPHONE && SCEEN_MAX_LENGTH == 896.0)

// ref to https://stackoverflow.com/questions/3339722/how-to-check-ios-version
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

extern NSString *const kDWInitPageCode;
extern CGFloat const kLeftRightThinPadding;
extern CGFloat const kLeftRightFitPadding;
extern CGFloat const kLeftRightBoldPadding;

typedef NS_ENUM(NSInteger, ControllerTransitionStyle) {
    ControllerTransitionStyleDefault = 0,
    ControllerTransitionStylePush = 1,
    ControllerTransitionStylePresent = 2,
};

@interface DWViewController : UIViewController

@property (nonatomic, copy) NSString *pageCode;  // 用于后期做日志打点记录

- (void)switchToWebView:(NSString *)url
            newPageCode:(NSString *)newPageCode
           newPageTitle:(NSString *)title
        transitionStyle:(ControllerTransitionStyle)style;

@end
