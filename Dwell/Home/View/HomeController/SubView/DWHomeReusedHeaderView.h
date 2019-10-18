//
//  DWHomeReusedHeaderView.h
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kDWHomeReusedHeaderViewTag;
extern NSString *const kDWHomeReusedHeaderViewMenuTag;
extern CGFloat const kDWHomeReusedHeaderNormalHeight;
extern CGFloat const kDWHomeReusedFooterButtomViewHeight;

@protocol DWHomeReusedHeaderViewDelegate <NSObject>
@optional
- (void)triggerToResponseAfterMenuFilterClickedAt:(NSInteger)index;
- (void)triggerToResponseAfterFooterButtonClickedAt:(NSInteger)sectionIndex;
@end

@interface DWHomeReusedHeaderView : UITableViewHeaderFooterView

@property (nonatomic, assign) BOOL asFooterView;
@property (nonatomic, assign) NSInteger sectionIndex;
@property (nonatomic, copy) NSString *buttonTitleText;

@property (nonatomic, assign) BOOL existFilterButton;
@property (nonatomic, copy) NSArray *filterMenuArray;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, weak) id<DWHomeReusedHeaderViewDelegate> delegate;
@property (nonatomic, strong) UILabel *groupHeaderLabel;

- (void)refresh;

@end
