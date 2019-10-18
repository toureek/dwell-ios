//
//  DWImagePromotionViewCell.h
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kDWImagePromotionViewCellTag;
extern CGFloat const kDWImagePromotionCellHeight;

@protocol DWImagePromotionCellDelegate <NSObject>
@optional
- (void)triggerToResponseAfterPromoteADTappedAt:(NSInteger)index;
@end

@interface DWImagePromotionViewCell : UITableViewCell

@property (nonatomic, weak) id<DWImagePromotionCellDelegate> delegate;

- (void)refresh:(NSArray *)dataArray;

@end
