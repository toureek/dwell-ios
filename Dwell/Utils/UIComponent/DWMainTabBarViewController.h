//
//  DWMainTabBarViewController.h
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWMainTabBarViewController : UITabBarController

// 使用public property是为了方便自定义推送的点击业务处理: 无论当前在什么页面，通过navigation都能找到。(iOS的页面，是个栈结构)
@property (nonatomic, strong) UINavigationController *homeNavigation;
@property (nonatomic, strong) UINavigationController *newsNavigation;
@property (nonatomic, strong) UINavigationController *meNavigation;

@end
