//
//  DWShortcutEntryViewCell.m
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWShortcutEntryViewCell.h"
#import "UIView+Utils.h"
#import "DWDisplayModel.h"

NSString *const kDWShortcutEntryViewCellTag = @"kDWShortcutEntryViewCellTag";
static CGFloat const kShortcutTopButtonSizeWidth = 90.0f;
static CGFloat const kShortcutTopButtonSizeHeight = 50.0f;
static CGFloat const kShortcutIndicatorWidth = 60.0f;
static CGFloat const kShortcutBottomLineOffsetHeight = 40.0f;

@interface DWShortcutEntryViewCell ()

@property (nonatomic, strong) UIView *paperView;
@property (nonatomic, strong) UIButton *searchHouseButton;
@property (nonatomic, strong) UIButton *myHouseButton;
@property (nonatomic, strong) UILabel *selectedIndicatorLine;
@property (nonatomic, strong) UILabel *topSplitorLineLabel;
@property (nonatomic, strong) UILabel *textTitleLabel;
@property (nonatomic, strong) UILabel *textSubtitleLabel;
@property (nonatomic, strong) UILabel *bottomSplitorLineLabel;
@property (nonatomic, strong) UILabel *shortcutInfoLabel;
@property (nonatomic, strong) UIImageView *infoImageView;
@property (nonatomic, strong) UIView *coverTappedView;

@end

@implementation DWShortcutEntryViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpViews];
    }
    return self;
}

+ (CGFloat)height {
    return 3*floor(UIScreen.mainScreen.bounds.size.width/5.0);
}

- (void)setUpViews {
    [self addPaperViewWithShadowStyle];
    [self addSearchHouseButtonView];
    [self addMyHouseButtonView];
    [self addIndicatorView];
    [self addTopSplitorLineLabels];
    [self addTextTitleLabelsView];
    [self addInfoImageView];
    [self addCoverTappedView];
}

- (void)addPaperViewWithShadowStyle {
    _paperView = [[UIView alloc] init];
    CGFloat height = 3*floor(ceil(UIScreen.mainScreen.bounds.size.width/5.0)) - kLeftRightFitPadding*2;
    [_paperView dw_AddCornerRadius:10.0f size:CGSizeMake(SCREEN_WIDTH-kLeftRightBoldPadding*2, height)];
    [self.contentView addSubview:_paperView];
}

- (void)addSearchHouseButtonView {
    _searchHouseButton = [DWUIComponentFactory buildButtonWithTitle:@"帮我找房"
                                                    backgroundImage:@""
                                                               font:nil
                                                             target:self
                                                             action:@selector(didTopButtonClicked:)];
    [_searchHouseButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_searchHouseButton setTitleColor:[UIColor dw_PlaceholderTextColor] forState:UIControlStateNormal];
    _searchHouseButton.selected = YES;
    [self.paperView addSubview:_searchHouseButton];
}

- (void)addMyHouseButtonView {
    _myHouseButton = [DWUIComponentFactory buildButtonWithTitle:@"我的房子"
                                                backgroundImage:@""
                                                           font:nil
                                                         target:self
                                                         action:@selector(didTopButtonClicked:)];
    [_myHouseButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_myHouseButton setTitleColor:[UIColor dw_PlaceholderTextColor] forState:UIControlStateNormal];
    [self.paperView addSubview:_myHouseButton];
}

- (void)addIndicatorView {
    _selectedIndicatorLine = [[UILabel alloc] init];
    _selectedIndicatorLine.backgroundColor = [UIColor dw_SeperatorLineColor];
    [self.paperView addSubview:_selectedIndicatorLine];
}

- (void)addTopSplitorLineLabels {
    _topSplitorLineLabel = [[UILabel alloc] init];
    _bottomSplitorLineLabel = [[UILabel alloc] init];
    _topSplitorLineLabel.backgroundColor = _bottomSplitorLineLabel.backgroundColor = [UIColor dw_SeperatorLineColor];
    [self.paperView addSubview:_topSplitorLineLabel];
    [self.paperView addSubview:_bottomSplitorLineLabel];
}

- (void)addTextTitleLabelsView {
    BOOL displayScale = IS_IPHONE_4_OR_LESS || IS_IPHONE_5;
    _textTitleLabel = [DWUIComponentFactory buildLabelWithTextColor:[UIColor dw_TitleTextColor]
                                                               font:[UIFont boldSystemFontOfSize:displayScale ? 14 : 16]
                                                    backgroundColor:nil
                                                      textAlignment:NSTextAlignmentLeft
                                                      numberOfLines:0];
    [self.paperView addSubview:_textTitleLabel];
    
    _textSubtitleLabel = [DWUIComponentFactory buildLabelWithTextColor:[UIColor dw_TitleTextColor]
                                                                  font:[UIFont systemFontOfSize:displayScale ? 12 : 14]
                                                       backgroundColor:nil
                                                         textAlignment:NSTextAlignmentLeft
                                                         numberOfLines:0];
    [self.paperView addSubview:_textSubtitleLabel];
    
    _shortcutInfoLabel = [DWUIComponentFactory buildLabelWithTextColor:[UIColor blueColor]
                                                                  font:[UIFont systemFontOfSize:16]
                                                       backgroundColor:[UIColor clearColor]
                                                         textAlignment:NSTextAlignmentCenter
                                                         numberOfLines:0];
    [self.paperView addSubview:_shortcutInfoLabel];
}

- (void)addInfoImageView {
    _infoImageView = [[UIImageView alloc] init];
    _infoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.paperView addSubview:_infoImageView];
}

- (void)addCoverTappedView {
    _coverTappedView = [[UIView alloc] init];
    _coverTappedView.backgroundColor = [UIColor clearColor];
    _coverTappedView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(didCoverViewTapped)];
    [_coverTappedView addGestureRecognizer:gesture];
    [self.paperView addSubview:_coverTappedView];
}

- (void)updateConstraints {
    [self addPaperViewAutoLayout];
    [self addSearchButtonAutoLayout];
    [self addMyHouseButtonAutoLayout];
    [self addTopLineAutoLayout];
    [self addDynamicComponentAutoLayou];
    [self addCoverTappedViewAutoLayout];
    
    [super updateConstraints];
}

- (void)addPaperViewAutoLayout {
    UIEdgeInsets insets = UIEdgeInsetsMake(kLeftRightFitPadding, kLeftRightBoldPadding, kLeftRightFitPadding, kLeftRightBoldPadding);
    [_paperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(insets);
    }];
}

- (void)addSearchButtonAutoLayout {
    [_searchHouseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self.paperView);
        make.size.mas_equalTo(CGSizeMake(kShortcutTopButtonSizeWidth, kShortcutTopButtonSizeHeight));
    }];
}

- (void)addMyHouseButtonAutoLayout {
    [_myHouseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paperView);
        make.left.equalTo(self.searchHouseButton.mas_right);
        make.size.equalTo(self.searchHouseButton);
    }];
}

- (void)addCoverTappedViewAutoLayout {
    [_coverTappedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topSplitorLineLabel.mas_bottom);
        make.left.right.and.bottom.equalTo(self.paperView);
    }];
}

- (void)addDynamicComponentAutoLayou {
    CGFloat leftRightPadding = (SCREEN_WIDTH - kLeftRightBoldPadding*2)/4.0;

    if (_currentIndicatorIndex == 0) {
        [_selectedIndicatorLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.searchHouseButton);
            make.centerX.equalTo(self.searchHouseButton);
            make.size.mas_equalTo(CGSizeMake(kShortcutIndicatorWidth, 2));
        }];
        
        [_textTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.selectedIndicatorLine.mas_bottom).offset(kLeftRightFitPadding*2);
            make.left.equalTo(self.paperView).offset(kLeftRightBoldPadding);
            make.right.lessThanOrEqualTo(self.paperView).offset(-leftRightPadding);
        }];
        
        _bottomSplitorLineLabel.hidden = _shortcutInfoLabel.hidden = NO;
        [_textSubtitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textTitleLabel.mas_bottom).offset(kLeftRightFitPadding);
            make.left.and.right.equalTo(self.textTitleLabel);
        }];
        
        [_bottomSplitorLineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.paperView).offset(-kShortcutBottomLineOffsetHeight);
            make.left.and.right.equalTo(self.paperView);
            make.height.equalTo(@0.5);
        }];
        
        [_shortcutInfoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.paperView);
            make.bottom.equalTo(self.paperView).offset(-kLeftRightFitPadding);
        }];
        
        [_infoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.paperView);
            make.top.equalTo(self.topSplitorLineLabel.mas_bottom);
            make.bottom.equalTo(self.bottomSplitorLineLabel.mas_top);
            make.left.equalTo(self.paperView.mas_right).offset(-leftRightPadding);
        }];
    } else {
        [_selectedIndicatorLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.myHouseButton);
            make.centerX.equalTo(self.myHouseButton);
            make.size.mas_equalTo(CGSizeMake(kShortcutIndicatorWidth, 2));
        }];
        
        [_textTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.paperView.mas_centerY);
            make.left.equalTo(self.paperView).offset(kLeftRightBoldPadding*2);
            make.right.lessThanOrEqualTo(self.paperView).offset(-leftRightPadding);
        }];
        
        [_textSubtitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textTitleLabel.mas_bottom).offset(kLeftRightFitPadding);
            make.left.and.right.equalTo(self.textTitleLabel);
        }];
        
        _bottomSplitorLineLabel.hidden = _shortcutInfoLabel.hidden = YES;
        
        [_infoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topSplitorLineLabel.mas_bottom);
            make.bottom.and.right.equalTo(self.paperView);
            make.left.equalTo(self.paperView.mas_right).offset(-leftRightPadding);
        }];
    }
}

- (void)addTopLineAutoLayout {
    [_topSplitorLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paperView).offset(kShortcutTopButtonSizeHeight);
        make.left.and.right.equalTo(self.paperView);
        make.height.equalTo(@(0.5));
    }];
}

- (void)refresh {
    if (_itemArray && _itemArray.count > 0) {
        DWHomeSectionsInfo *first = [_itemArray firstObject];
        DWHomeSectionsInfo *last = [_itemArray lastObject];
        [_searchHouseButton setTitle:first.title forState:UIControlStateNormal];
        [_myHouseButton setTitle:last.title forState:UIControlStateNormal];
        _searchHouseButton.selected = _currentIndicatorIndex == 0;
        _myHouseButton.selected = _currentIndicatorIndex == 1;
        _textTitleLabel.text = _currentIndicatorIndex == 0 ? (first.contentTitle ? : @"") : (last.describe ? : @"");
        _textSubtitleLabel.text = _currentIndicatorIndex == 0 ? (first.contentDesc ? : @"") : (last.buttonName ? : @"");
        _textSubtitleLabel.textColor = _currentIndicatorIndex == 0 ? [UIColor dw_TitleTextColor] : [UIColor blueColor];
        _shortcutInfoLabel.text = _currentIndicatorIndex == 0 ? (first.buttonText ? : @"") : @"";
        [_infoImageView sd_setImageWithURL:[NSURL URLWithString:first.imgUrl ? : @""]
                          placeholderImage:[UIImage imageNamed:@"section-1"]];
    } else {
        // do nothing...
    }
    
    [self setNeedsUpdateConstraints];
    [self.paperView bringSubviewToFront:_selectedIndicatorLine];
    [self.paperView bringSubviewToFront:_coverTappedView];
}

#pragma mark - ButtonClicked
- (void)didTopButtonClicked:(UIButton *)sender {
    if (sender == _searchHouseButton) {
        if (_currentIndicatorIndex == 0)    return;
        _currentIndicatorIndex = 0;
    } else if (sender == _myHouseButton) {
        if (_currentIndicatorIndex == 1)    return;
        _currentIndicatorIndex = 1;
    } else {
        // do nothing...
    }
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterTopButtonClickedAtIndex:)]) {
        [_delegate triggerToResponseAfterTopButtonClickedAtIndex:_currentIndicatorIndex];
    }
}

- (void)didCoverViewTapped {
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterContentTappedAtIndex:)]) {
        [_delegate triggerToResponseAfterContentTappedAtIndex:_currentIndicatorIndex];
    }
}

@end
