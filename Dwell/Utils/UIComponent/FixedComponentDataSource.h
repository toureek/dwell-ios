//
//  FixedComponentDataSource.h
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kTabBarItemIconNameSuffix;

@interface FixedComponentDataSource : NSObject

+ (NSArray *)fetchTabBarItemIconNames;
+ (NSArray *)fetchTabBarItemTextNames;


// FakeDataBuilder:

+ (NSArray *)buildFakeHotSearchTags;
+ (NSArray *)buildFakeHotSearchTagsAgain;

+ (NSArray *)buildFakeHotSearchTagsForNew;

@end
