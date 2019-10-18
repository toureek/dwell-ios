//
//  DWHouseItemContentCell.h
//  Dwell
//
//  Created by toureek on 10/16/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kDWHouseItemContentCellTag;
extern NSString *const kDWHouseItemOutterCellTag;

typedef NS_ENUM(NSInteger, DWHouseItemContentType) {
    DWHouseItemContentTypeDefault = 0,      //  empty-cell
    DWHouseItemContentTypeUsed = 1,
    DWHouseItemContentTypeNew = 2,
    DWHouseItemContentTypeRent = 3,
    DWHouseItemContentTypeOverseas = 4,
};

@protocol DWHouseItemContentCellDelegate <NSObject>
@optional
- (void)triggerToResponseAfterInteractiveButtonClickedAt:(NSInteger)index;
- (void)triggerToControllerResponseAfterInteractiveButtonClickedAt:(NSInteger)index;
@end

@class DWHomeItemInfo;
@interface DWHouseItemContentCell : UITableViewCell

@property (nonatomic, strong) DWHomeItemInfo *item;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL reusedFromController;
@property (nonatomic, weak) id<DWHouseItemContentCellDelegate> delegate;
@property (nonatomic, assign) DWHouseItemContentType type;

+ (CGFloat)heightInType:(DWHouseItemContentType)type;
- (void)refresh;

@end
