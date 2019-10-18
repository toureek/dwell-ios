//
//  FixedComponentDataSource.m
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "FixedComponentDataSource.h"

static NSString *kTabBarItemIconIndex_0 = @"home";
static NSString *kTabBarItemNameIndex_0 = @"首页";
static NSString *kTabBarItemIconIndex_1 = @"news";
static NSString *kTabBarItemNameIndex_1 = @"看点";
static NSString *kTabBarItemIconIndex_2 = @"me";
static NSString *kTabBarItemNameIndex_2 = @"我的";
NSString *const kTabBarItemIconNameSuffix = @"_selected";

@implementation FixedComponentDataSource

+ (NSArray *)fetchTabBarItemIconNames {
    return @[kTabBarItemIconIndex_0, kTabBarItemIconIndex_1, kTabBarItemIconIndex_2];
}

+ (NSArray *)fetchTabBarItemTextNames {
    return @[kTabBarItemNameIndex_0, kTabBarItemNameIndex_1, kTabBarItemNameIndex_2];
}


// Fake:

+ (NSArray *)buildFakeHotSearchTags {
    return @[@[@"恒大ABC", @"万科", @"碧桂园", @"金地"], @[@"华远", @"绿地", @"华润"]];
}

+ (NSArray *)buildFakeHotSearchTagsAgain {
    return @[@[@"恒大ABC", @"万科QAZ", @"碧桂园1573", @"金地广厦"], @[@"华远广场", @"绿地都市", @"华润万家", @"首开国风美唐"]];
}

+ (NSArray *)buildFakeHotSearchTagsForNew {
    return @[@[@"保利地产", @"招商营盘", @"建业城市", @"宝钢地产"], @[@"望京soho", @"曼哈顿花园", @"中银国际"]];
}

@end
