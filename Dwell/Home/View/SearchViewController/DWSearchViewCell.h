//
//  DWSearchViewCell.h
//  Dwell
//
//  Created by toureek on 10/18/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kDWSearchViewCellTag;

typedef NS_ENUM(NSInteger, DWSearchCellType) {
    DWSearchCellTypeUsed = 0,
    DWSearchCellTypeNew = 1,
    DWSearchCellTypeRent = 2,
};

@protocol DWSearchViewCellDelegate <NSObject>
@optional
- (void)triggerToResponseAfterControlButtonClickedAt:(NSInteger)index;
- (void)triggerToResponseAfterHotTagsClickedAtViewIndex:(NSInteger)viewIndex itemIndex:(NSInteger)index;
@end

@class DWSearchHistoryView;
@interface DWSearchViewCell : UITableViewCell

@property (nonatomic, assign) DWSearchCellType type;

@property (nonatomic, weak) id<DWSearchViewCellDelegate> delegate;
@property (nonatomic, assign) NSInteger cellIndex;
@property (nonatomic, copy) NSString *searchTitle;
@property (nonatomic, copy) NSString *controlButtonTitle;

@property (nonatomic, copy) NSArray *tagButtonArray;   // if- (cellIndex==0) @[@[], @[]];  (cellIndex == 1) @[@"", @""]

+ (CGFloat)height:(NSArray *)tagButtonArray atRowIndex:(NSInteger)index;
- (void)refresh;

@end

