//
//  DWViewController.m
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWViewController.h"
#import "DWWebKitViewController.h"

NSString *const kDWInitPageCode = @"init_base_code";
CGFloat const kLeftRightThinPadding = 5.0f;
CGFloat const kLeftRightFitPadding = 10.0f;
CGFloat const kLeftRightBoldPadding = 15.0f;

@interface DWViewController ()

@end

@implementation DWViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {    // 配置view的可视区域 减少离屏渲染
    [super viewDidLoad];
    
    self.pageCode = kDWInitPageCode;
    self.edgesForExtendedLayout = UIRectEdgeNone;  // 导航条半透明效果时 按需修改Edge距离即可
    if (@available(iOS 11.0, *)) {
        // do nothing...
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    self.view.backgroundColor = [UIColor whiteColor];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - Public methods
- (void)switchToWebView:(NSString *)url
            newPageCode:(NSString *)newPageCode
           newPageTitle:(NSString *)title
        transitionStyle:(ControllerTransitionStyle)style {
    if (!url || url.length == 0 ) {
        [self.view makeToast:@"请求路径异常 请检查请求路径是否正确"];
        return;
    }
    
    DWWebKitViewController *vc = [[DWWebKitViewController alloc] init];
    vc.urlPath = url ? : @"";
    vc.title = title ? : @"";
    vc.pageCode = newPageCode ? : @"";
    if (style == ControllerTransitionStylePush || style == ControllerTransitionStyleDefault) {
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        __block NSString *text = [vc.title copy];
        [self presentViewController:vc animated:YES completion:^{
            NSLog(@"进入%@页面", text);
        }];
    }
}

@end
