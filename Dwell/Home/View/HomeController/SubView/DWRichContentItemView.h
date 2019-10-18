//
//  DWRichContentItemView.h
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWRichContentItemData.h"

@protocol DWRichContentItemViewDelegate <NSObject>
@optional
- (void)triggerToResponseAfterItemViewTappedAtIndex:(NSInteger)index;
@end

@interface DWRichContentItemView : UIView

- (instancetype)initWithFrame:(CGRect)frame richContentItemViewStyle:(DWRichContentItemStyle)style;

@property (nonatomic, weak) id<DWRichContentItemViewDelegate> delegate;
@property (nonatomic, assign) DWRichContentItemStyle style;
@property (nonatomic, assign) NSInteger itemViewIndex;
@property (nonatomic, strong) UILabel *colorLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *iconImageBackgroundView;

- (void)refreshContent:(DWRichContentItemData *)data;

@end
