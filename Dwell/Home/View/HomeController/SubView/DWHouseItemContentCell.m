//
//  DWHouseItemContentCell.m
//  Dwell
//
//  Created by toureek on 10/16/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWHouseItemContentCell.h"
#import "UIButton+Utils.h"
#import "DWDisplayModel.h"

NSString *const kDWHouseItemContentCellTag = @"kDWHouseItemContentCellTag";
NSString *const kDWHouseItemOutterCellTag = @"kDWHouseItemOutterCellTag";
static CGFloat const kDWHouseItemImgWidthHeightRate = 1.288f;
static NSInteger const kMaxTagCount = 7;

@interface DWHouseItemContentCell ()
@property (nonatomic, assign) CGFloat itemImageViewWidth;         // imageView-width
@property (nonatomic, strong) UIImageView *itemImageView;         // image
@property (nonatomic, strong) UILabel *itemTitleLabel;            // title
@property (nonatomic, strong) UILabel *itemSubtitleLabel;         // subtitle
@property (nonatomic, strong) UIStackView *itemStackView;         // tags
@property (nonatomic, strong) UILabel *itemPriceInfoLabel;        // price
@property (nonatomic, strong) UILabel *itemDescInfoLabel;         // desc
@property (nonatomic, strong) UILabel *bottomLineLabel;           // bottomline
@property (nonatomic, strong) UILabel *itemSubSubtitleLabel;      // only-show when (type == new || (type == used && custom-info)
@property (nonatomic, strong) UIButton *itemFeedbackButton;       // only-show when type == used
@end

@implementation DWHouseItemContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _itemImageViewWidth = (SCREEN_WIDTH-(kLeftRightBoldPadding+kLeftRightThinPadding)*2)/3.0f - kLeftRightFitPadding;
        [self setUpViews];
    }
    return self;
}

+ (CGFloat)heightInType:(DWHouseItemContentType)type {
    CGFloat padding = (type == DWHouseItemContentTypeNew) ? 50.0f : 30.0f;
    CGFloat scalePoint = (type == DWHouseItemContentTypeNew && (IS_IPHONE_4_OR_LESS || IS_IPHONE_5)) ? 1.0f : 1.288f;
    CGFloat height = (((SCREEN_WIDTH-(kLeftRightBoldPadding+kLeftRightThinPadding)*2.0f)/3.0f-kLeftRightFitPadding)/scalePoint+padding);
    return height;
}

- (void)setUpViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addItemImageView];               // ImageView
    [self addTitleAndSubtitleLabels];      // First Line (Title) + Second Line (Subtitle)
    [self addStackView];                   // Third Line (Tags)
    [self addPriceAndDescLabels];          // Fourth Line (Price + Desc)
    [self addBottomLineLabel];
    
    [self addDynamicContentFeedbackButton];
    [self addDynamicContentSubsubtitleLabel];
}

- (void)addItemImageView {
    _itemImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_itemImageView];
}

- (void)addTitleAndSubtitleLabels {
    _itemTitleLabel = [DWUIComponentFactory buildLabelWithTextColor:[UIColor dw_TitleTextColor]
                                                               font:[UIFont boldSystemFontOfSize:16]];
    [self.contentView addSubview:_itemTitleLabel];
    
    _itemSubtitleLabel = [DWUIComponentFactory buildLabelWithTextColor:[UIColor dw_TitleTextColor]
                                                                  font:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:_itemSubtitleLabel];
}

- (void)addStackView {
    CGFloat stackViewWidth = SCREEN_WIDTH-kLeftRightBoldPadding*2-_itemImageViewWidth-kLeftRightFitPadding;
    _itemStackView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, stackViewWidth, kLeftRightFitPadding)];
    _itemStackView.axis = UILayoutConstraintAxisHorizontal;
    _itemStackView.spacing = kLeftRightThinPadding;
    _itemStackView.distribution = UIStackViewDistributionFillProportionally;
    _itemStackView.alignment = UIStackViewAlignmentBottom;
    [self.contentView addSubview:_itemStackView];
    
    for (int i = 0; i < kMaxTagCount; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:9];
        label.numberOfLines = 1;
        label.layer.borderColor = [UIColor blueColor].CGColor;
        label.layer.borderWidth = 0.5f;
        label.text = @" ";
        [label sizeToFit];
        [_itemStackView addArrangedSubview:label];
        
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(10.0f));
        }];
    }
}

- (void)addPriceAndDescLabels {
    UIFont *font = [UIFont systemFontOfSize:(IS_IPHONE_4_OR_LESS || IS_IPHONE_5) ? 14 : 16];
    _itemPriceInfoLabel = [DWUIComponentFactory buildLabelWithTextColor:[UIColor redColor] font:font];
    [self.contentView addSubview:_itemPriceInfoLabel];
    
    _itemDescInfoLabel = [DWUIComponentFactory buildLabelWithTextColor:[UIColor dw_SeperatorLineColor]
                                                                  font:[UIFont systemFontOfSize:12]];
    _itemDescInfoLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_itemDescInfoLabel];
}

- (void)addBottomLineLabel {
    _bottomLineLabel = [[UILabel alloc] init];
    _bottomLineLabel.backgroundColor = [UIColor dw_SeperatorLineColor];
    [self.contentView addSubview:_bottomLineLabel];
}

#pragma mark - dynamic-content
- (void)addDynamicContentFeedbackButton {
    _itemFeedbackButton = [DWUIComponentFactory buildButtonWithTitle:@"..."
                                                     backgroundImage:@""
                                                                font:nil
                                                              target:self
                                                              action:@selector(didFeedbackButtonClicked:)];
    UIEdgeInsets insets = UIEdgeInsetsMake(-kLeftRightBoldPadding, -kLeftRightBoldPadding, -kLeftRightBoldPadding, -kLeftRightBoldPadding);
    _itemFeedbackButton.hitEdgeInsets = insets;
    _itemFeedbackButton.highlighted = NO;
    [_itemFeedbackButton setTitle:@"..." forState:UIControlStateNormal];
    [_itemFeedbackButton setTitleColor:[UIColor dw_SubTitleTextColor] forState:UIControlStateNormal];
    [self.contentView addSubview:_itemFeedbackButton];
    _itemFeedbackButton.hidden = YES;
}

- (void)addDynamicContentSubsubtitleLabel {
    _itemSubSubtitleLabel = [DWUIComponentFactory buildLabelWithTextColor:[UIColor dw_SeperatorLineColor]
                                                                     font:[UIFont systemFontOfSize:8]];
    [self.contentView addSubview:_itemSubSubtitleLabel];
    _itemSubSubtitleLabel.hidden = YES;
}

- (void)updateConstraints {
    [self addItemImageViewAutoLayout];
    [self addTitleAndSubtitleLabelsAutoLayout];
    [self addDynamicContentSubsubtitleLabelLayout];
    [self addStackViewAutoLayout];
    [self addPriceAndDescLabelsAutoLayout];
    [self addDynamicContentFeedbackButtonLayout];
    [self addBottomLineLabelLayout];
    
    [super updateConstraints];
}

- (void)addItemImageViewAutoLayout {
    BOOL isTypeNew = ((IS_IPHONE_4_OR_LESS || IS_IPHONE_5) && _type == DWHouseItemContentTypeNew);
    __block CGFloat height = isTypeNew ? self.itemImageViewWidth : self.itemImageViewWidth/kDWHouseItemImgWidthHeightRate;
    __weak typeof(self) weakSelf = self;
    [_itemImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(weakSelf.itemImageViewWidth, height));
        make.top.equalTo(weakSelf.contentView).offset(kLeftRightBoldPadding);
        make.left.equalTo(weakSelf.contentView).offset(kLeftRightBoldPadding);
    }];
}

- (void)addTitleAndSubtitleLabelsAutoLayout {
    __weak typeof(self) weakSelf = self;
    [_itemTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@17);
        make.top.equalTo(weakSelf.itemImageView);
        make.left.equalTo(weakSelf.itemImageView.mas_right).offset(kLeftRightFitPadding);
        make.right.equalTo(weakSelf.contentView).offset(-kLeftRightBoldPadding);
    }];
    
    __block CGFloat padding = _type == DWHouseItemContentTypeNew ? kLeftRightFitPadding : kLeftRightThinPadding;
    __block CGFloat topPadding = (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) ? 2.0f : padding;
    [_itemSubtitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.itemTitleLabel.mas_bottom).offset(topPadding);
        make.left.and.right.equalTo(weakSelf.itemTitleLabel);
    }];
}

- (void)addStackViewAutoLayout {  // colorTags标签
    __weak typeof(self) weakSelf = self;
    __block CGFloat stackViewMaxWidth = SCREEN_WIDTH-kLeftRightBoldPadding-_itemImageViewWidth-kLeftRightFitPadding;
    if (_type == DWHouseItemContentTypeNew) {  // 在subsubtitleLable下面
        [_itemStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.itemSubSubtitleLabel.mas_bottom).offset(kLeftRightFitPadding);
            make.left.equalTo(weakSelf.itemImageView.mas_right).offset(kLeftRightFitPadding);
            make.size.mas_equalTo(CGSizeMake(stackViewMaxWidth, 11.0f));
        }];
    } else if (_type == DWHouseItemContentTypeUsed || _type == DWHouseItemContentTypeRent || _type == DWHouseItemContentTypeOverseas) {
        __block CGFloat topPadding = (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) ? 2.0f : kLeftRightFitPadding;
        [_itemStackView mas_remakeConstraints:^(MASConstraintMaker *make) {  // 在subtitleLabel下面
            make.top.equalTo(weakSelf.itemSubtitleLabel.mas_bottom).offset(topPadding);
            make.left.equalTo(weakSelf.itemImageView.mas_right).offset(kLeftRightFitPadding);
            make.size.mas_equalTo(CGSizeMake(stackViewMaxWidth, 11.0f));
        }];
    } else {
        [_itemStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.itemSubSubtitleLabel.mas_bottom).offset(kLeftRightFitPadding);
            make.left.equalTo(weakSelf.itemImageView.mas_right).offset(kLeftRightFitPadding);
            make.size.mas_equalTo(CGSizeMake(stackViewMaxWidth, kLeftRightFitPadding));
        }];
    }
}

- (void)addPriceAndDescLabelsAutoLayout {
    __weak typeof(self) weakSelf = self;
    if (_type == DWHouseItemContentTypeNew) {
        __block CGFloat scalePoint = (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) ? 1.1f : 0.88f;
        __block CGFloat topPadding = IS_IPHONE_8 ? kLeftRightThinPadding : kLeftRightFitPadding;
        [_itemPriceInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.itemStackView.mas_bottom).offset(topPadding);
            make.left.equalTo(weakSelf.itemImageView.mas_right).offset(kLeftRightFitPadding);
            make.size.mas_equalTo(CGSizeMake(weakSelf.itemImageViewWidth*scalePoint, 16.0f));
        }];
    } else if (_type == DWHouseItemContentTypeRent) {
        __block CGFloat scalePoint = (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) ? 1.15f : 1.0f;
        [_itemPriceInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.itemImageView.mas_right).offset(kLeftRightFitPadding);
            make.bottom.equalTo(weakSelf.itemImageView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(weakSelf.itemImageViewWidth*scalePoint, 16.0f));
        }];
    } else if (_type == DWHouseItemContentTypeUsed) {
        __block CGFloat width = (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) ? self.itemImageViewWidth/2.0f + kLeftRightBoldPadding : self.itemImageViewWidth/2.0f;
        CGFloat iPhone8_TopPadding = (IS_IPHONE_8 ? kLeftRightThinPadding : kLeftRightFitPadding);
        __block CGFloat topPadding = (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) ? 0.5f : iPhone8_TopPadding;
        [_itemPriceInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.itemStackView.mas_bottom).offset(topPadding);
            make.left.equalTo(weakSelf.itemImageView.mas_right).offset(kLeftRightFitPadding);
            make.size.mas_equalTo(CGSizeMake(width, 16.0f));
        }];
    } else {
        __block CGFloat scalePoint = (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) ? 1.3f : 1.25f;
        [_itemPriceInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.itemImageView.mas_right).offset(kLeftRightFitPadding);
            make.size.mas_equalTo(CGSizeMake(weakSelf.itemImageViewWidth*scalePoint, 16.0f));
            make.bottom.equalTo(weakSelf.itemImageView.mas_bottom);
        }];
    }
    
    [_itemDescInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.itemPriceInfoLabel.mas_right);
        make.bottom.equalTo(weakSelf.itemPriceInfoLabel);
    }];
}

- (void)addBottomLineLabelLayout {
    __weak typeof(self) weakSelf = self;
    [_bottomLineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.bottom.equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-kLeftRightBoldPadding*2.0f, 0.5f));
    }];
}

#pragma mark - Dynamic-content-rendering
- (void)addDynamicContentSubsubtitleLabelLayout {
    if (_type == DWHouseItemContentTypeNew) {
        __weak typeof(self) weakSelf = self;
        [_itemSubSubtitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.itemSubtitleLabel.mas_bottom).offset(kLeftRightFitPadding);
            make.left.and.right.equalTo(weakSelf.itemTitleLabel);
            make.height.equalTo(@(12.0f));
        }];
    } else {
        //  do nothing...
    }
}

- (void)addDynamicContentFeedbackButtonLayout {
    if (_type == DWHouseItemContentTypeUsed) {
        __weak typeof(self) weakSelf = self;
        [_itemFeedbackButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.itemPriceInfoLabel);
            make.right.equalTo(weakSelf.contentView).offset(-kLeftRightBoldPadding);
            make.size.mas_equalTo(CGSizeMake(16.0f, 16.0f));
        }];
    } else {
        //  do nothing...
    }
}

- (void)refresh {
    _itemSubSubtitleLabel.hidden = (_type != DWHouseItemContentTypeNew);
    _itemFeedbackButton.hidden = (_type != DWHouseItemContentTypeUsed);
    
    if (_item && _type == DWHouseItemContentTypeUsed) {
        [_itemImageView sd_setImageWithURL:[NSURL URLWithString:_item.coverPic ? : @""]
                          placeholderImage:[UIColor dw_ImageFactoryWithColor:[UIColor dw_SeperatorLineColor]]];
        _itemTitleLabel.font = [UIFont boldSystemFontOfSize:16];
        _itemTitleLabel.text = _item.title ? : @"";
        _itemSubtitleLabel.text = _item.desc ? : @"";
        
        for (int i = 0; i < _itemStackView.arrangedSubviews.count; i++) {
            UILabel *label = [_itemStackView.arrangedSubviews objectAtIndex:i];
            if (i < _item.colorTags.count) {
                DWColorTagsAndFeedback *color = [_item.colorTags objectAtIndex:i];
                label.text = color.desc;
                label.textColor = [UIColor dw_ColorWithHexString:[NSString stringWithFormat:@"#%@", color.color]];
                label.backgroundColor = !color.bgColor ? [UIColor clearColor] : [UIColor dw_ColorWithHexString:[NSString stringWithFormat:@"#%@", color.bgColor]];
                label.font = [color isBoldFont] ? [UIFont boldSystemFontOfSize:9] : [UIFont systemFontOfSize:9];
                label.layer.borderColor = [UIColor blueColor].CGColor;
            } else {
                label.text = @"    ";
                label.layer.borderColor = [UIColor clearColor].CGColor;
                label.backgroundColor = label.textColor = [UIColor clearColor];
            }
        }
        
        _itemPriceInfoLabel.text = [_item priceTextForUsed];
        _itemDescInfoLabel.text = _item.unitPriceStr ? : @"";
        
        _itemFeedbackButton.hidden = !_reusedFromController;
        [self.contentView bringSubviewToFront:_itemFeedbackButton];
        
    } else if (_item && _type == DWHouseItemContentTypeNew) {
        [_itemImageView sd_setImageWithURL:[NSURL URLWithString:_item.coverPic ? : @""]
                          placeholderImage:[UIColor dw_ImageFactoryWithColor:[UIColor dw_SeperatorLineColor]]];
        _itemTitleLabel.font = [UIFont boldSystemFontOfSize:16];
        _itemTitleLabel.text = _item.title ? : @"";
        _itemSubtitleLabel.text = _item.projectDesc ? : @"";
        _itemSubSubtitleLabel.text = [_item subsubtitleTextForNew];
        _itemSubtitleLabel.font = _itemSubSubtitleLabel.font = [UIFont systemFontOfSize:12];
        
        for (int i = 0; i < _itemStackView.arrangedSubviews.count; i++) {
            UILabel *label = [_itemStackView.arrangedSubviews objectAtIndex:i];
            if (i < _item.colorTags.count) {
                DWColorTagsAndFeedback *color = [_item.colorTags objectAtIndex:i];
                label.text = color.desc;
                label.textColor = [UIColor dw_ColorWithHexString:[NSString stringWithFormat:@"#%@", color.color]];
                label.backgroundColor = [UIColor whiteColor];
                label.layer.borderColor = [UIColor blueColor].CGColor;
            } else {
                label.text = @"    ";
                label.layer.borderColor = [UIColor clearColor].CGColor;
                label.textColor = label.backgroundColor = [UIColor clearColor];
            }
        }
        
        _itemPriceInfoLabel.text = [_item priceTextForNew];
        _itemDescInfoLabel.text = _item.resblockFrameArea ? : @"";
        
    } else if (_item && _type == DWHouseItemContentTypeRent) {
        [_itemImageView sd_setImageWithURL:[NSURL URLWithString:_item.coverPic ? : @""]
                          placeholderImage:[UIColor dw_ImageFactoryWithColor:[UIColor dw_SeperatorLineColor]]];
        _itemTitleLabel.font = [UIFont boldSystemFontOfSize:16];
        _itemTitleLabel.text = _item.houseTitle ? : @"";
        _itemSubtitleLabel.text = _item.desc ? : @"";
        _itemSubtitleLabel.font = [UIFont systemFontOfSize:12];
        
        for (int i = 0; i < _itemStackView.arrangedSubviews.count; i++) {
            UILabel *label = [_itemStackView.arrangedSubviews objectAtIndex:i];
            if (i < _item.houseTags.count) {
                DWColorTagsAndFeedback *color = [_item.houseTags objectAtIndex:i];
                label.text = color.name;
                label.layer.borderColor = [UIColor blueColor].CGColor;
                label.textColor = [UIColor dw_ColorWithHexString:[NSString stringWithFormat:@"#%@", color.colorTxt ? : @""]];
                label.backgroundColor = [UIColor dw_ColorWithHexString:[NSString stringWithFormat:@"#%@", color.colorBg ? : @""]];
            } else {
                label.text = @"    ";
                label.layer.borderColor = [UIColor clearColor].CGColor;
                label.textColor = label.backgroundColor = [UIColor clearColor];
            }
        }
        
        _itemPriceInfoLabel.text = [_item priceTextForRent];
        _itemPriceInfoLabel.textColor = [UIColor redColor];
        _itemDescInfoLabel.text = @"  ";
        
    } else if (_item && _type == DWHouseItemContentTypeOverseas) {
        [_itemImageView sd_setImageWithURL:[NSURL URLWithString:_item.imgUrl ? : @""]
                          placeholderImage:[UIColor dw_ImageFactoryWithColor:[UIColor dw_SeperatorLineColor]]];
        _itemTitleLabel.font = [UIFont boldSystemFontOfSize:16];
        _itemTitleLabel.text = _item.title ? : @"";
        _itemSubtitleLabel.text = _item.desc ? : @"";
        _itemSubtitleLabel.font = [UIFont systemFontOfSize:12];
        
        for (int i = 0; i < _itemStackView.arrangedSubviews.count; i++) {
            UILabel *label = [_itemStackView.arrangedSubviews objectAtIndex:i];
            if (i < _item.tags.count) {
                NSString *tagText = [_item.tags objectAtIndex:i];
                label.text = tagText ? : @"";
                label.layer.borderColor = [UIColor blueColor].CGColor;
                label.textColor = [UIColor blueColor];
                label.backgroundColor = [UIColor whiteColor];
            } else {
                label.text = @"    ";
                label.layer.borderColor = [UIColor whiteColor].CGColor;
                label.textColor = label.backgroundColor = [UIColor whiteColor];
            }
        }
        
        _itemPriceInfoLabel.text = _item.priceRMB ? : @" ";
        _itemPriceInfoLabel.textColor = [UIColor redColor];
        _itemDescInfoLabel.text = _item.price ? : @" ";
        
    } else {
        [_itemImageView sd_setImageWithURL:[NSURL URLWithString:@""]
                          placeholderImage:[UIColor dw_ImageFactoryWithColor:[UIColor dw_SeperatorLineColor]]];
        _itemSubSubtitleLabel.text = _itemDescInfoLabel.text = _itemPriceInfoLabel.text = _itemSubtitleLabel.text = _itemTitleLabel.text = @" ";
        for (int i = 0; i < _itemStackView.arrangedSubviews.count; i++) {
            UILabel *label = [_itemStackView.arrangedSubviews objectAtIndex:i];
            label.text = @"    ";
            label.layer.borderColor = [UIColor whiteColor].CGColor;
            label.backgroundColor = label.textColor = [UIColor clearColor];
        }
    }
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - SEL
- (void)didFeedbackButtonClicked:(id)sender {
    if (!_reusedFromController) {
        if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterInteractiveButtonClickedAt:)]) {
            [_delegate triggerToResponseAfterInteractiveButtonClickedAt:_index];
        }
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(triggerToControllerResponseAfterInteractiveButtonClickedAt:)]) {
            [_delegate triggerToControllerResponseAfterInteractiveButtonClickedAt:_index];
        }
    }
}

@end
