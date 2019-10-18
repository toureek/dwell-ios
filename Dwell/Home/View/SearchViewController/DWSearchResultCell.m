//
//  DWSearchResultCell.m
//  Dwell
//
//  Created by toureek on 10/18/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWSearchResultCell.h"

@interface DWSearchResultCell ()
@property (nonatomic, strong) UILabel *leftImageLabel;
@property (nonatomic, strong) UILabel *topTitleLabel;
@property (nonatomic, strong) UILabel *bottomSubTitleLabel;
@property (nonatomic, strong) UILabel *rightDetailLabel;               // used ends

@property (nonatomic, strong) UILabel *tagLabelA;
@property (nonatomic, strong) UILabel *tagLabelB;                      // new ends

@property (nonatomic, strong) UILabel *bottomLineLabel;                // new ends
@end

@implementation DWSearchResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    [self addLeftImageLabel];
    [self addTopTitleLabel];
    [self addBottomSubTitleLabel];
    [self addRightDetailLabel];
    [self addTagLabels];
    [self addBottomLineLabel];
}

- (void)addLeftImageLabel {
    _leftImageLabel = [DWUIComponentFactory buildLabelWithTextColor:[UIColor dw_SubTitleTextColor]
                                                               font:[UIFont systemFontOfSize:10]];
    _leftImageLabel.backgroundColor = [UIColor dw_ColorWithHexString:@"#EEEEEE"];
    [self.contentView addSubview:_leftImageLabel];
}

- (void)addTopTitleLabel {
    _topTitleLabel = [DWUIComponentFactory buildLabelWithTextColor:[UIColor dw_TitleTextColor]
                                                              font:[UIFont systemFontOfSize:16]];
    [self.contentView addSubview:_topTitleLabel];
}

- (void)addBottomSubTitleLabel {
    _bottomSubTitleLabel = [DWUIComponentFactory buildLabelWithTextColor:[UIColor dw_SubTitleTextColor]
                                                                    font:[UIFont systemFontOfSize:10]];
    [self.contentView addSubview:_bottomSubTitleLabel];
}

- (void)addRightDetailLabel {
    _rightDetailLabel = [DWUIComponentFactory buildLabelWithTextColor:[UIColor dw_TitleTextColor]
                                                                 font:[UIFont boldSystemFontOfSize:16]];
    [self.contentView addSubview:_rightDetailLabel];
}

- (void)addTagLabels {
    _tagLabelA = [DWUIComponentFactory buildLabelWithTextColor:[UIColor dw_SubTitleTextColor]
                                                          font:[UIFont systemFontOfSize:8]];
    [self.contentView addSubview:_tagLabelA];
    
    _tagLabelB = [DWUIComponentFactory buildLabelWithTextColor:[UIColor dw_SubTitleTextColor]
                                                          font:[UIFont systemFontOfSize:8]];
    [self.contentView addSubview:_tagLabelB];
}

- (void)addBottomLineLabel {
    _bottomLineLabel = [[UILabel alloc] init];
    _bottomLineLabel.backgroundColor = [UIColor dw_SeperatorLineColor];
    [self.contentView addSubview:_bottomLineLabel];
}

- (void)updateConstraints {
    [self addLeftImageLabelLayout];
    [self addTopTitleLabelLayout];
    [self addBottomSubTitleLabelLayout];
    [self addRightDetailLabelLayout];
    [self addTagLabelsLayout];
    
    [super updateConstraints];
}

- (void)addLeftImageLabelLayout {
    _leftImageLabel.hidden = _type != DWSearchCellTypeUsed;
    __weak typeof(self) weakSelf = self;
    [_leftImageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 20));
        make.centerY.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView).offset(kLeftRightBoldPadding);
    }];
}

- (void)addTopTitleLabelLayout {
    __weak typeof(self) weakSelf = self;
    [_topTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@17);
        make.top.equalTo(weakSelf.contentView).offset(kLeftRightFitPadding);
        make.right.equalTo(weakSelf.contentView).offset(-kLeftRightBoldPadding-50);
        make.left.equalTo(weakSelf.contentView).offset(kLeftRightBoldPadding+40+kLeftRightFitPadding);
    }];
}

- (void)addBottomSubTitleLabelLayout {
    __weak typeof(self) weakSelf = self;
    [_bottomSubTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topTitleLabel.mas_bottom).offset(kLeftRightFitPadding);
        make.left.and.right.equalTo(weakSelf.topTitleLabel);
        make.height.equalTo(@11);
    }];
}

- (void)addRightDetailLabelLayout {
    __weak typeof(self) weakSelf = self;
    [_rightDetailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if (weakSelf.type == DWSearchCellTypeNew) {
            make.centerY.equalTo(weakSelf.bottomSubTitleLabel);
        } else {
            make.centerY.equalTo(weakSelf.contentView);
        }
        make.size.mas_equalTo(CGSizeMake(50, 20));
        make.right.equalTo(weakSelf.contentView).offset(-kLeftRightBoldPadding);
    }];
}

- (void)addTagLabelsLayout {
    __weak typeof(self) weakSelf = self;
    _tagLabelA.hidden = _tagLabelB.hidden = (_type != DWSearchCellTypeNew);
    [_tagLabelB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(19, 9));
        make.centerY.equalTo(weakSelf.topTitleLabel);
        make.right.equalTo(weakSelf.contentView).offset(-kLeftRightBoldPadding);
    }];
    
    [_tagLabelA mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.tagLabelB.mas_left).offset(-2.5);
        make.centerY.equalTo(weakSelf.topTitleLabel);
        make.width.lessThanOrEqualTo(@26);
        make.height.equalTo(@9);
    }];
}

- (void)refresh {
    
    
    
    [self setNeedsUpdateConstraints];
}

@end
