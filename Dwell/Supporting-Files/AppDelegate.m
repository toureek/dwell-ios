//
//  AppDelegate.m
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "AppDelegate.h"
#import "DWMainTabBarViewController.h"
#import "DWSearchViewController.h"

static CGFloat const kNavigationBarTitleOffsetPaddingOnIOS11 = -200.0f;
static CGFloat const kNavigationBarTitleOffsetPaddingLessThanIOS11 = -64.0f;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setUpFrameworkForInterface];
    [self showMainPage];
    [self buildFakeDataLocally];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setUpFrameworkForInterface {
    [self setupUIWindow];
    [self customUINavigationBarStyle];
}

- (void)setupUIWindow {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
}

- (void)customUINavigationBarStyle {
    NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:18],
                                 NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    if (@available(iOS 11, *)) {  // TODO: Need a back-icon for popIndicatorIcon
        UIImage *backButtonImage = [[UIImage imageNamed:@"mm_pop_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [[UINavigationBar appearance] setBackIndicatorImage:backButtonImage];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backButtonImage];
        [UIBarButtonItem.appearance setBackButtonTitlePositionAdjustment:UIOffsetMake(kNavigationBarTitleOffsetPaddingOnIOS11, 0)
                                                           forBarMetrics:UIBarMetricsDefault];
    } else {
        [UIBarButtonItem.appearance setBackButtonTitlePositionAdjustment:UIOffsetMake(0, kNavigationBarTitleOffsetPaddingLessThanIOS11)
                                                           forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)showMainPage {
    _mainTab = [[DWMainTabBarViewController alloc] init];
    _mainTab.view.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = _mainTab;
}

- (void)buildFakeDataLocally {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDWSearchCellTypeRent];
    NSArray *defaultHistoryList = @[@"111", @"111111", @"111111111"];    
    [[NSUserDefaults standardUserDefaults] setObject:defaultHistoryList forKey:kDWSearchCellTypeUsed];
    [[NSUserDefaults standardUserDefaults] setObject:@[@"一", @"二"] forKey:kDWSearchCellTypeNew];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
