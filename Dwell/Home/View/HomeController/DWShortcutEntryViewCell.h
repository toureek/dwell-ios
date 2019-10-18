//
//  DWShortcutEntryViewCell.h
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kDWShortcutEntryViewCellTag;

@protocol DWShortcutEntryViewCellDelegate <NSObject>
@optional
- (void)triggerToResponseAfterTopButtonClickedAtIndex:(NSInteger)index;
- (void)triggerToResponseAfterContentTappedAtIndex:(NSInteger)index;
@end

@interface DWShortcutEntryViewCell : UITableViewCell

@property (nonatomic, copy) NSArray *itemArray;
@property (nonatomic, assign) NSInteger currentIndicatorIndex;
@property (nonatomic, weak) id<DWShortcutEntryViewCellDelegate> delegate;

- (void)refresh;
+ (CGFloat)height;

@end
