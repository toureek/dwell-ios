//
//  DWWebKitViewController.m
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWWebKitViewController.h"
#import <WebKit/WebKit.h>

@interface DWWebKitViewController ()

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation DWWebKitViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startLoadingWebPage];
}

- (void)startLoadingWebPage {
    _webView = [[WKWebView alloc] init];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_urlPath]];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    [_webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

@end
