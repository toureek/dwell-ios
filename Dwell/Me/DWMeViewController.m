//
//  DWMeViewController.m
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWMeViewController.h"

@interface DWMeViewController ()

@end

@implementation DWMeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
