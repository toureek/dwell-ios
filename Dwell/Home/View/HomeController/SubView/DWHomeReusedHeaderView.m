//
//  DWHomeReusedHeaderView.m
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWHomeReusedHeaderView.h"

NSString *const kDWHomeReusedHeaderViewTag = @"kDWHomeReusedHeaderViewTag";
NSString *const kDWHomeReusedHeaderViewMenuTag = @"kDWHomeReusedHeaderViewMenuTag";
CGFloat const kDWHomeReusedHeaderNormalHeight = 50.0f;
CGFloat const kDWHomeReusedFooterButtomViewHeight = 60.0f;
static NSInteger const kDefaultFilterMenuCount = 4;

@interface DWHomeReusedHeaderView ()

@property (nonatomic, strong) UIStackView *filterMenuStackView;
@property (nonatomic, strong) UIButton *footerButton;

@end

@implementation DWHomeReusedHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpInitiationViews];
    }
    return self;
}

- (void)setUpInitiationViews {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addGroupHeaderLabel];
    [self addFilterMenuStackView];
    self.filterMenuStackView.hidden = YES;
    [self addFooterButtonView];
    self.footerButton.hidden = YES;
}

- (void)addGroupHeaderLabel {
    self.groupHeaderLabel = [DWUIComponentFactory buildLabelWithTextColor:[UIColor dw_TitleTextColor]
                                                                     font:[UIFont boldSystemFontOfSize:20]];
    [self.contentView addSubview:_groupHeaderLabel];
}

- (void)addFilterMenuStackView {
    if (!_filterMenuStackView) {
        CGFloat width = (SCREEN_WIDTH-kLeftRightBoldPadding*2)/2;
        CGRect frame = CGRectMake(SCREEN_WIDTH/2, kDWHomeReusedHeaderNormalHeight/2, width, kDWHomeReusedHeaderNormalHeight/2);
        _filterMenuStackView = [[UIStackView alloc] initWithFrame:frame];
        _filterMenuStackView.axis = UILayoutConstraintAxisHorizontal;
        _filterMenuStackView.spacing = kLeftRightThinPadding;
        _filterMenuStackView.alignment = UIStackViewAlignmentBottom;
        _filterMenuStackView.distribution = UIStackViewDistributionFillEqually;
        [self.contentView addSubview:_filterMenuStackView];
    }
    
    for (int index = 0; index < kDefaultFilterMenuCount; index++) {
        UIFont *font = [UIFont boldSystemFontOfSize:(IS_IPHONE_4_OR_LESS || IS_IPHONE_5) ? 9 : 12.0f];
        UIButton *button = [DWUIComponentFactory buildButtonWithTitle:@"   "
                                                      backgroundImage:nil
                                                                 font:font
                                                               target:self
                                                               action:@selector(didMenuButtonClicked:)];
        button.tag = index;
        [button setTitleColor:[UIColor dw_SeperatorLineColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        button.layer.borderWidth = 0.5f;
        button.layer.borderColor = [UIColor dw_SeperatorLineColor].CGColor;
        button.selected = (index == _currentIndex);
        button.adjustsImageWhenHighlighted = NO;
        [_filterMenuStackView addArrangedSubview:button];
        
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(kDWHomeReusedHeaderNormalHeight/2));
        }];
    }
}

- (void)addFooterButtonView {
    _footerButton = [DWUIComponentFactory buildButtonWithTitle:@"  "
                                               backgroundImage:@""
                                                          font:nil
                                                        target:self
                                                        action:@selector(didFooterButtonClicked:)];
    [_footerButton setHighlighted:NO];
    [_footerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_footerButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    UIImage *image = [UIColor dw_ImageFactoryWithColor:[UIColor dw_ColorWithHexString:@"#F4F8FE"]];
    [_footerButton setBackgroundImage:image forState:UIControlStateNormal];
    [_footerButton setBackgroundImage:image forState:UIControlStateSelected];
    [self.contentView addSubview:_footerButton];
    [self.contentView bringSubviewToFront:_footerButton];
}

- (void)updateConstraints {
    [self addGroupHeaderLabelLayout];
    [self addStackViewLayout];
    [self addFooterButtonLayout];
    
    [super updateConstraints];
}

- (void)addGroupHeaderLabelLayout {
    CGFloat width = (SCREEN_WIDTH-kLeftRightBoldPadding)/2.0;
    [_groupHeaderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(kLeftRightBoldPadding);
        make.size.mas_equalTo(CGSizeMake(width, 25));
    }];
}

- (void)addStackViewLayout {
    CGFloat width = (SCREEN_WIDTH-kLeftRightBoldPadding*2)/2;
    [_filterMenuStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(width, kDWHomeReusedHeaderNormalHeight/2));
    }];
}

- (void)addFooterButtonLayout {
    CGFloat width = SCREEN_WIDTH-kLeftRightBoldPadding*2;
    [_footerButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(width, kLeftRightBoldPadding*2));
    }];
}

- (void)refresh {
    if (_asFooterView) {
        _groupHeaderLabel.hidden = _filterMenuStackView.hidden = YES;
        _footerButton.hidden = NO;
        [_footerButton setTitle:_buttonTitleText ? : @"" forState:UIControlStateNormal];
    } else {
        _groupHeaderLabel.hidden = NO;
        _footerButton.hidden = YES;
        if (_existFilterButton && (_filterMenuArray && _filterMenuArray.count > 0)) {
            _filterMenuStackView.hidden = NO;
            for (int index = 0; index < _filterMenuArray.count; index++) {
                UIButton *button = [_filterMenuStackView.arrangedSubviews objectAtIndex:index];
                button.selected = (index == _currentIndex);
                [button setTitle:_filterMenuArray[index] forState:UIControlStateNormal];
            }
        } else {
            _filterMenuStackView.hidden = YES;
        }
    }
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - SEL
- (void)didFooterButtonClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterFooterButtonClickedAt:)]) {
        [_delegate triggerToResponseAfterFooterButtonClickedAt:_sectionIndex];
    }
}

- (void)didMenuButtonClicked:(UIButton *)button {
    NSLog(@"button.tag : %ld", button.tag);
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterMenuFilterClickedAt:)]) {
        [_delegate triggerToResponseAfterMenuFilterClickedAt:button.tag];
    }
}

@end
