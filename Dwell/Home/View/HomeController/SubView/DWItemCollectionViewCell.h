//
//  DWItemCollectionViewCell.h
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kDWItemCollectionViewCell;

@class DWHomeSectionsInfo;
@interface DWItemCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) DWHomeSectionsInfo *item;
@property (nonatomic, assign) NSInteger index;

- (void)refresh;

@end
