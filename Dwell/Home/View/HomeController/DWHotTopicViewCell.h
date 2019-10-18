//
//  DWHotTopicViewCell.h
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kDWHotTopicViewCellTag;
extern CGFloat const kDWHotTopicViewCellHeight;

@protocol DWHotTopicViewCellDelegate <NSObject>
@optional
- (void)triggerToResponseAfterItemClickedAt:(NSInteger)index;
@end

@interface DWHotTopicViewCell : UITableViewCell

@property (nonatomic, copy) NSArray *array;
@property (nonatomic, weak) id<DWHotTopicViewCellDelegate> delegate;

- (void)refresh;

@end
