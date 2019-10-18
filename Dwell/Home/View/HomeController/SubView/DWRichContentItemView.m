//
//  DWRichContentItemView.m
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWRichContentItemView.h"

@implementation DWRichContentItemView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initContentViewWithStyle:DWRichContentItemStyleDefault];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame richContentItemViewStyle:(DWRichContentItemStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        self.style = style;
        [self initContentViewWithStyle:style];
    }
    return self;
}

- (void)initContentViewWithStyle:(DWRichContentItemStyle)style {
    if (style == DWRichContentItemStyleDefault)    return;
    
    if (style == DWRichContentItemStyleColorfulTitleWithSubtitle) {
        [self initColorLabel];
        [self initTitleAndSubtitleLabels];
    } else if (style == DWRichContentItemStyleTitleSubTitleWithRightBottomIcon) {
        [self initTitleAndSubtitleLabels];
        [self initImageView];
    } else if (style == DWRichContentItemStyleTitleSubTitleWithBackgroundImgInfo ||
               style == DWRichContentItemStyleTitleSubTitleWithBackgroundImgAD) {
        [self initTitleAndSubtitleLabels];
        [self initImageView];
        _titleLabel.textColor = _subtitleLabel.textColor = [UIColor whiteColor];
    } else if (style == DWRichContentItemStyleBackgroundImageViewOnly) {
        [self initImageView];
    } else {
        // To-be-continued new styles in future.
    }
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(didCurrentContentItemViewTapped)];
    [self addGestureRecognizer:tapGesture];
}

- (void)initColorLabel {
    _colorLabel = [DWUIComponentFactory buildLabelWithTextColor:nil
                                                           font:[UIFont boldSystemFontOfSize:10]
                                                backgroundColor:nil
                                                  textAlignment:NSTextAlignmentLeft
                                                  numberOfLines:1];
    [self addSubview:_colorLabel];
}

- (void)initTitleAndSubtitleLabels {
    _titleLabel = [DWUIComponentFactory buildLabelWithTextColor:[UIColor dw_TitleTextColor]
                                                           font:[UIFont boldSystemFontOfSize:16]
                                                backgroundColor:nil
                                                  textAlignment:NSTextAlignmentLeft
                                                  numberOfLines:1];
    [self addSubview:_titleLabel];
    
    _subtitleLabel = [DWUIComponentFactory buildLabelWithTextColor:[UIColor dw_TitleTextColor]
                                                              font:[UIFont systemFontOfSize:10]
                                                   backgroundColor:nil
                                                     textAlignment:NSTextAlignmentLeft
                                                     numberOfLines:1];
    [self addSubview:_subtitleLabel];
}

- (void)initImageView {
    _iconImageBackgroundView = [[UIImageView alloc] init];
    _iconImageBackgroundView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_iconImageBackgroundView];
}

- (void)refreshContent:(DWRichContentItemData *)data {
    if (!data)    return;
    
    if (_style == DWRichContentItemStyleDefault) {
        // do nothing for it is an empty view
    } else if (_style == DWRichContentItemStyleColorfulTitleWithSubtitle) {
        BOOL existNoData = (!(data.colorHEXText) || [data.colorHEXText length] < 1);
        _colorLabel.textColor = existNoData ? [UIColor clearColor] : [UIColor dw_ColorWithHexString:data.colorHEXText];
        _colorLabel.text = data.colorLabelText ? : @"";
        _titleLabel.text = data.titleLabelText ? : @"";
        _subtitleLabel.text = data.subtitleLabelText ? : @"";
    } else if (_style == DWRichContentItemStyleTitleSubTitleWithRightBottomIcon) {
        _titleLabel.text = data.titleLabelText ? : @"";
        _subtitleLabel.text = data.subtitleLabelText ? : @"";
        UIImage *image = [UIImage imageNamed:data.iconImageBackgroundImgName];
        if (image) {
            _iconImageBackgroundView.image = image;
        } else {
            [_iconImageBackgroundView sd_setImageWithURL:[NSURL URLWithString:data.iconImageBackgroundImgName ? : @""]
                                        placeholderImage:[UIColor dw_ImageFactoryWithColor:[UIColor clearColor]]];
        }
        [self bringSubviewToFront:self.iconImageBackgroundView];
    } else if (_style == DWRichContentItemStyleTitleSubTitleWithBackgroundImgInfo) {
        [_iconImageBackgroundView sd_setImageWithURL:[NSURL URLWithString:data.iconImageBackgroundImgName ? : @""]
                                    placeholderImage:[UIColor dw_ImageFactoryWithColor:[UIColor grayColor]]];
        
        _titleLabel.text = data.titleLabelText ? : @"";
        _subtitleLabel.text = data.subtitleLabelText ? : @"";
        _titleLabel.textColor = _subtitleLabel.textColor = [UIColor dw_ColorWithHexString:@"#D0D0F0"];
        [self bringSubviewToFront:_titleLabel];
        [self bringSubviewToFront:_subtitleLabel];
    } else if (_style == DWRichContentItemStyleTitleSubTitleWithBackgroundImgAD) {
        _iconImageBackgroundView.contentMode = UIViewContentModeScaleToFill;
        [_iconImageBackgroundView sd_setImageWithURL:[NSURL URLWithString:data.iconImageBackgroundImgName ? : @""]
                                    placeholderImage:[UIColor dw_ImageFactoryWithColor:[UIColor grayColor]]];
        
        _titleLabel.text = data.titleLabelText ? : @"";
        _titleLabel.textColor = [UIColor whiteColor];
        _subtitleLabel.text = data.subtitleLabelText ? : @"";
        _subtitleLabel.textColor = [UIColor dw_ColorWithHexString:@"#F0F0F0"];
        [self bringSubviewToFront:_titleLabel];
        [self bringSubviewToFront:_subtitleLabel];
    } else if (_style == DWRichContentItemStyleBackgroundImageViewOnly) {
        [self addBackgroundImageViewAutoLayout];
    } else {
        // To-be-continued new styles in future.
    }
    
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    if (_style == DWRichContentItemStyleDefault) {
        // do nothing for it is an empty view
    } else if (_style == DWRichContentItemStyleColorfulTitleWithSubtitle) {
        [_colorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@12);
            make.left.and.top.equalTo(self).offset(kLeftRightFitPadding);
            make.right.lessThanOrEqualTo(self).offset(-kLeftRightFitPadding);
        }];
        
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@18);
            make.centerY.equalTo(self);
            make.left.and.right.equalTo(self.colorLabel);
        }];
        
        [_subtitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@12);
            make.left.and.right.equalTo(self.colorLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(kLeftRightThinPadding);
        }];
    } else if (_style == DWRichContentItemStyleTitleSubTitleWithRightBottomIcon) {
        CGFloat width = floor(ceil((SCREEN_WIDTH-(kLeftRightFitPadding+kLeftRightThinPadding)*2)/3.0));
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@18);
            make.top.equalTo(self).offset(kLeftRightFitPadding*2);
            make.left.equalTo(self).offset(kLeftRightFitPadding);
            make.right.equalTo(self).offset(-kLeftRightFitPadding);
        }];
        
        [_iconImageBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width/4.0, width/4.0));
            make.right.and.bottom.equalTo(self);
        }];
        
        [_subtitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@12);
            make.left.and.equalTo(self.titleLabel);
            make.right.lessThanOrEqualTo(self.iconImageBackgroundView.mas_left);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(kLeftRightThinPadding);
        }];
    } else if (_style == DWRichContentItemStyleTitleSubTitleWithBackgroundImgInfo) {
        [self addBackgroundImageViewAutoLayout];
        
        [_subtitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@12);
            make.left.equalTo(self).offset(kLeftRightFitPadding);
            make.right.equalTo(self).offset(-kLeftRightFitPadding);
            make.bottom.equalTo(self).offset(-kLeftRightFitPadding);
        }];
        
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.subtitleLabel.mas_top).offset(-kLeftRightThinPadding);
            make.left.and.right.equalTo(self.subtitleLabel);
            make.height.equalTo(@18);
        }];
    } else if (_style == DWRichContentItemStyleTitleSubTitleWithBackgroundImgAD) {
        [self addBackgroundImageViewAutoLayout];

        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@18);
            make.top.equalTo(self).offset(kLeftRightFitPadding);
            make.left.equalTo(self).offset(kLeftRightFitPadding);
            make.right.equalTo(self).offset(-kLeftRightFitPadding);
        }];
        
        [self addWhiteColorSubtitleLabelAutoLayout];
    } else if (_style == DWRichContentItemStyleBackgroundImageViewOnly) {
        [self addBackgroundImageViewAutoLayout];
    } else {
        // To-be-continued new styles in future.
    }
    
    [super updateConstraints];
}

- (void)addBackgroundImageViewAutoLayout {
    [_iconImageBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)addWhiteColorSubtitleLabelAutoLayout {
    [_subtitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@12);
        make.left.and.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kLeftRightThinPadding);
    }];
}

#pragma mark - SEL
- (void)didCurrentContentItemViewTapped {
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterItemViewTappedAtIndex:)]) {
        [_delegate triggerToResponseAfterItemViewTappedAtIndex:_itemViewIndex];
    }
}

@end
