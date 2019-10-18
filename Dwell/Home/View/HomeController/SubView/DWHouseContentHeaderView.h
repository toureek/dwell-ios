//
//  DWHouseContentHeaderView.h
//  Dwell
//
//  Created by toureek on 10/16/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kDWHouseContentHeaderViewTag;
extern CGFloat const kDWHouseContentHeaderViewHeight;

@protocol DWHouseContentHeaderDelegate <NSObject>
@optional
- (void)triggerToResponseAfterHeaderViewItemClickedAt:(NSInteger)index atSectionIndex:(NSInteger)sectinIndex;
@end

@interface DWHouseContentHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<DWHouseContentHeaderDelegate> delegate;
@property (nonatomic, assign) NSInteger sectionIndex;
- (void)refresh:(NSArray *)dataArray;

@end
