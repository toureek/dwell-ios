//
//  DWSearchHistoryView.m
//  Dwell
//
//  Created by toureek on 10/18/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWSearchHistoryView.h"

@implementation DWSearchHistoryView {
    UILabel *_titleLabel;
    UILabel *_subTitleLabel;
    NSArray *_frameArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    [self configEntireView];
    [self addTitleLabel];
    [self addSubtitleLabel];
}

- (void)configEntireView {
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor dw_ColorWithHexString:@"#EEEEEE"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didViewTap)];
    [self addGestureRecognizer:tap];
}

- (void)addTitleLabel {
    _titleLabel = [DWUIComponentFactory buildLabelWithTextColor:[UIColor dw_TitleTextColor]
                                                           font:[UIFont systemFontOfSize:12]];
    [self addSubview:_titleLabel];
}

- (void)addSubtitleLabel {
    _subTitleLabel = [DWUIComponentFactory buildLabelWithTextColor:[UIColor dw_SubTitleTextColor]
                                                              font:[UIFont systemFontOfSize:12]];
    _subTitleLabel.text = @"不限";
    [self addSubview:_subTitleLabel];
}

- (void)updateConstraints {
    [self addTitleLabelLayout];
    [self addSubtitleLabelLayout];
    
    [super updateConstraints];
}

- (void)addTitleLabelLayout {
    __block CGFloat width = self.bounds.size.width-kLeftRightThinPadding*2;
    __weak typeof(self) weakSelf = self;
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, kLeftRightBoldPadding));
        make.bottom.equalTo(weakSelf.mas_centerY);
        make.centerX.equalTo(weakSelf);
    }];
}

- (void)addSubtitleLabelLayout {
    __block CGFloat width = self.bounds.size.width-kLeftRightThinPadding*2;
    __weak typeof(self) weakSelf = self;
    [_subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_centerY);
        make.centerX.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(width, kLeftRightBoldPadding));
    }];
}

- (void)refresh {
    if (_titleText && _titleText.length > 0) {
        _titleLabel.text = _titleText;
    } else {
        _titleLabel.text = @" ";
    }
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - SEL
- (void)didViewTap {
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterItemClickedAt:)]) {
        [_delegate triggerToResponseAfterItemClickedAt:_itemIndex];
    }
}

@end
