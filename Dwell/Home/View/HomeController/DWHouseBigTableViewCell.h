//
//  DWHouseBigTableViewCell.h
//  Dwell
//
//  Created by toureek on 10/16/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWHouseItemContentCell.h"

extern NSString *const kDWHouseBigTableViewCellTag;

@protocol DWHouseBigTableViewDelegate <NSObject>
@optional
- (void)triggerToResponseAfterHeaderClickedAt:(NSInteger)index atSectionIndex:(NSInteger)sectionIndex;
- (void)triggerToResponseAfterItemClickedAt:(NSInteger)index atSectionIndex:(NSInteger)sectionIndex;
- (void)triggerToResponseAfterFooterButtonClickedAt:(NSInteger)sectionIndex;
@end

@class DWHomeItemInfo;
@interface DWHouseBigTableViewCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<DWHouseBigTableViewDelegate> delegate;
@property (nonatomic, assign) DWHouseItemContentType type;
@property (nonatomic, assign) NSInteger sectionIndex;
@property (nonatomic, copy) NSArray *dataArray;

+ (CGFloat)height:(NSArray *)dataArray type:(DWHouseItemContentType)type;
- (void)refresh;

@end
