//
//  DWSquareBannerViewCell.m
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWSquareBannerViewCell.h"
#import "DWRichContentItemView.h"
#import "DWRichContentItemData.h"
#import "UIView+Utils.h"
#import "DWDisplayModel.h"

NSString *const kDWSquareBannerViewCellTag = @"kDWSquareBannerViewCellTag";

@interface DWSquareBannerViewCell () <DWRichContentItemViewDelegate>

@property (nonatomic, strong) NSTimer *bannerTimer;
@property (nonatomic, strong) UIStackView *menuStackView;
@property (nonatomic, strong) UIStackView *contentStackView;

@end

@implementation DWSquareBannerViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addStackViews];
    }
    return self;
}

+ (CGFloat)height {
    return 130.0f;
}

- (void)addStackViews {
    CGRect defaultMenuStackViewFrame = CGRectMake(0, 0, (70+kLeftRightThinPadding)*3, kLeftRightFitPadding + 25);
    _menuStackView = [[UIStackView alloc] initWithFrame:defaultMenuStackViewFrame];
    CGRect contentStackViewFrame = CGRectMake(0, 0, SCREEN_WIDTH-kLeftRightFitPadding*2, 100);
    _contentStackView = [[UIStackView alloc] initWithFrame:contentStackViewFrame];

    _menuStackView.axis = _contentStackView.axis = UILayoutConstraintAxisHorizontal;
    _menuStackView.spacing = _contentStackView.spacing = kLeftRightThinPadding;
    _menuStackView.alignment = _contentStackView.alignment = UIStackViewAlignmentCenter;
    _menuStackView.distribution = _contentStackView.distribution = UIStackViewDistributionFillEqually;
    [self.contentView addSubview:_menuStackView];
    [self.contentView addSubview:_contentStackView];
    
    
    for (int index = 0; index < 3; index++) {  // menuStackView
        UIButton *button = [DWUIComponentFactory buildButtonWithTitle:@"    "
                                                      backgroundImage:nil
                                                                 font:[UIFont boldSystemFontOfSize:12.0f]
                                                               target:self
                                                               action:@selector(didMenuButtonClicked:)];
        button.tag = index;
        [button setTitleColor:[UIColor dw_TitleTextColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.layer.borderWidth = 0.5f;
        button.layer.borderColor = [UIColor dw_SeperatorLineColor].CGColor;
        button.selected = index == 0;
        button.adjustsImageWhenHighlighted = NO;
        [button setBackgroundColor:button.isSelected ? [UIColor redColor] : [UIColor whiteColor]];
        [_menuStackView addArrangedSubview:button];
        
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@25);
        }];
        
        
        DWRichContentItemView *itemView = [[DWRichContentItemView alloc] initWithFrame:CGRectZero
                                                              richContentItemViewStyle:DWRichContentItemStyleColorfulTitleWithSubtitle];
        itemView.backgroundColor = [UIColor dw_ColorWithHexString:@"#E1E1E1"];
        itemView.itemViewIndex = index;
        itemView.delegate = self;
        [_contentStackView addArrangedSubview:itemView];
        
        [itemView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@70);
        }];
    }
}

- (void)updateConstraints {
    [self addStackViewAutoLayout];
    
    [super updateConstraints];
}

- (void)addStackViewAutoLayout {
    NSInteger titleTotalCount = (_dataArray && _dataArray.count > 0) ? ((NSArray *)[_dataArray firstObject]).count : 0;
    CGFloat stackViewWidth = (SCREEN_WIDTH-kLeftRightBoldPadding*2 - (70+kLeftRightThinPadding)*titleTotalCount);
    CGFloat rightOffsetPadding = kLeftRightBoldPadding + stackViewWidth;
    __block CGFloat finalPadding = rightOffsetPadding > 300 ? kLeftRightBoldPadding : rightOffsetPadding;
    [_menuStackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kLeftRightThinPadding);
        make.left.equalTo(self.contentView).offset(kLeftRightBoldPadding);
        make.right.equalTo(self.contentView).offset(-finalPadding);
        make.height.equalTo(@(kLeftRightFitPadding + 25));
    }];
    
    [_contentStackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuStackView.mas_bottom).offset(kLeftRightThinPadding);
        make.left.equalTo(self).offset(kLeftRightBoldPadding);
        make.right.equalTo(self).offset(-kLeftRightBoldPadding);
        make.bottom.equalTo(self).offset(-kLeftRightThinPadding);
    }];
    
}

- (void)refresh {
    if (_dataArray && _dataArray.count > 0) {
        NSArray *titleArray = [_dataArray firstObject];
        for (int i = 0; i < titleArray.count; i++) {
            UIButton *button = _menuStackView.arrangedSubviews[i];
            button.selected = self.currentMenuIndex == button.tag;
            [button setBackgroundColor:button.isSelected ? [UIColor redColor] : [UIColor whiteColor]];
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
        }
        NSArray *contentList = [[_dataArray lastObject] objectAtIndex:_currentMenuIndex];
        for (int i = 0; i < contentList.count; i++) {
            DWRichContentItemData *object = contentList[i];
            DWRichContentItemView *itemView = [_contentStackView.arrangedSubviews objectAtIndex:i];
            [itemView refreshContent:object];
        }
        [self initBannerTimer];
    } else {
        // do nothing...
    }
    
    if (_triggerTimer) {
        [self restartCycleBanner];
    } else {
        // do nothing...
    }
    
    [self setNeedsUpdateConstraints];
}

- (void)initBannerTimer {
    if (!_bannerTimer) {
        self.bannerTimer = [NSTimer timerWithTimeInterval:5.0f
                                                   target:self
                                                 selector:@selector(clockTimerTickAction)
                                                 userInfo:nil
                                                  repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.bannerTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)restartCycleBanner {
    if (_bannerTimer) {
        [self removeTimer];
    }
    [self initBannerTimer];
}

- (void)removeTimer {
    [_bannerTimer invalidate];
    _bannerTimer = nil;
}

#pragma mark - SELs
- (void)clockTimerTickAction {
    NSArray *array = [_dataArray firstObject];
    _currentMenuIndex = (_currentMenuIndex == array.count - 1) ? 0 : _currentMenuIndex + 1;
    [self removeTimer];
    [self switchNextMenuIndexView:NO];
}

- (void)didMenuButtonClicked:(UIButton *)button {
    [self removeTimer];
    _currentMenuIndex = button.tag;
    [self switchNextMenuIndexView:YES];
}

- (void)switchNextMenuIndexView:(BOOL)isTapped {
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterClickedMenuAt:isTapped:)]) {
        [_delegate triggerToResponseAfterClickedMenuAt:_currentMenuIndex isTapped:isTapped];
    }
}

#pragma mark - DWRichContentItemViewDelegate
- (void)triggerToResponseAfterItemViewTappedAtIndex:(NSInteger)index {
    NSLog(@"%ld", index);
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterClickedAt:itemIndex:)]) {
        [_delegate triggerToResponseAfterClickedAt:_currentMenuIndex itemIndex:index];
    }
}

- (void)dealloc {
    [_bannerTimer invalidate];
    _bannerTimer = nil;
}

@end
