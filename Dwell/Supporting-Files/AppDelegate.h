//
//  AppDelegate.h
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DWMainTabBarViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DWMainTabBarViewController *mainTab;

- (void)showMainPage;

@end

