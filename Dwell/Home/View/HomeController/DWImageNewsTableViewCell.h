//
//  DWImageNewsTableViewCell.h
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kDWImageNewsTableViewCellTag;

@protocol DWImageNewsCellDelegate <NSObject>
@optional
- (void)triggerToResponseAfterImageNewsTappedAt:(NSInteger)index;
@end

@interface DWImageNewsTableViewCell : UITableViewCell

@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, weak) id<DWImageNewsCellDelegate> delegate;

+ (CGFloat)height;
- (void)refresh;

@end
