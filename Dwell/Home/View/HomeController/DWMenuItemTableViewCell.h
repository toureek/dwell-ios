//
//  DWMenuItemTableViewCell.h
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kDWMenuItemTableViewCellTag;

@protocol DWMenuItemTableViewCellDelegate <NSObject>
@optional
- (void)triggerToResponseAfterItemClickedAtIndex:(NSUInteger)index;
@end

@interface DWMenuItemTableViewCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id<DWMenuItemTableViewCellDelegate> delegate;
@property (nonatomic, copy) NSArray *menuList;

- (void)refresh;
+ (CGFloat)height:(NSInteger)itemCount;

@end
