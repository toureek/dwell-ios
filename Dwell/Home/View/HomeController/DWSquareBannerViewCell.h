//
//  DWSquareBannerViewCell.h
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DWRichContentItemData;
@class DWRichContentItemView;

extern NSString *const kDWSquareBannerViewCellTag;

@protocol DWSquareBannerViewCellDelegate <NSObject>
@optional
- (void)triggerToResponseAfterClickedMenuAt:(NSInteger)menuIndex isTapped:(BOOL)isTapped;
- (void)triggerToResponseAfterClickedAt:(NSInteger)menuIndex itemIndex:(NSInteger)itemIndex;
@end

@class DWHomeSectionsInfo;
@interface DWSquareBannerViewCell : UITableViewCell

@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, assign) BOOL triggerTimer;
@property (nonatomic, assign) NSInteger currentMenuIndex;
@property (nonatomic, weak) id<DWSquareBannerViewCellDelegate> delegate;

- (void)refresh;
+ (CGFloat)height;

@end
