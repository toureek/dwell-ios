//
//  DWMainTabBarViewController.m
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWMainTabBarViewController.h"
#import "FixedComponentDataSource.h"
#import "DWHomeViewController.h"
#import "DWNewsViewController.h"
#import "DWMeViewController.h"

static NSUInteger const kTotalTabItemsCount = 1;

@interface DWMainTabBarViewController ()

@end

@implementation DWMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpTabBarContentViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)setUpTabBarContentViewController {
    NSArray *tabBarItemIcons = [FixedComponentDataSource fetchTabBarItemIconNames];
    NSArray *tabBarItemNames = [FixedComponentDataSource fetchTabBarItemTextNames];
    NSMutableArray *contentPages = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < kTotalTabItemsCount; index++) {
        DWViewController *vc;
        if (index == 0) {
            vc = [[DWHomeViewController alloc] init];
        } else if (index == 1) {
            vc = [[DWNewsViewController alloc] init];
        } else if (index == 2) {
            vc = [[DWMeViewController alloc] init];
        } else {
            // do nothing...
        }
        UINavigationController *navigationContent = [self setUpTabBarItemStyleForContentView:vc
                                                                                   iconsName:tabBarItemIcons[index]
                                                                                       title:tabBarItemNames[index]
                                                                                     atIndex:index];
        if (navigationContent) {
            [contentPages addObject:navigationContent];
        }
    }
    [self setViewControllers:[contentPages copy]];
}

- (UINavigationController *)setUpTabBarItemStyleForContentView:(UIViewController *)vc
                                                     iconsName:(NSString *)imageName
                                                         title:(NSString *)title
                                                       atIndex:(NSUInteger)index {
    if (!vc)    return nil;
    
    UIImage *iconImage = [UIImage imageNamed:imageName];
    UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:kTabBarItemIconNameSuffix, imageName]];
    
    UIImage *img = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImg = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *tabItem = [[UITabBarItem alloc] initWithTitle:title
                                                          image:img
                                                  selectedImage:selectedImg];
    
    UIColor *foregroundColor = [UIColor blueColor];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:foregroundColor, NSForegroundColorAttributeName, nil];
    [tabItem setTitleTextAttributes:dic forState:UIControlStateSelected];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    navigationController.tabBarItem = tabItem;
    
    return navigationController;
}

@end
