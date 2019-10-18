//
//  DWSearchViewCell.m
//  Dwell
//
//  Created by toureek on 10/18/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWSearchViewCell.h"
#import "UIButton+Utils.h"
#import "DWSearchHistoryView.h"

NSString *const kDWSearchViewCellTag = @"kDWSearchViewCellTag";
static NSInteger kMaxTagCount = 4;

@interface DWSearchViewCell () <DWSearchHistoryViewDelegate>
@property (nonatomic, strong) UILabel *contentTitleLabel;
@property (nonatomic, strong) UIStackView *stackViewA;
@end

@implementation DWSearchViewCell {
    UIButton *_controlButton;
    UIStackView *_stackViewB;
    NSArray *_frameArrays;
    NSArray *_itemViewArrays;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpViews];
    }
    return self;
}

+ (CGFloat)height:(NSArray *)tagButtonArray atRowIndex:(NSInteger)index {
    CGFloat height = 0;
    height += kLeftRightBoldPadding;
    height += 17;

    if (index == 0) {
        height += kLeftRightBoldPadding;
        height += 30;
        height += kLeftRightFitPadding;
        height += 30;
        height += kLeftRightBoldPadding;
        return height;
    }
    
    if (tagButtonArray.count < 3) {
        height += kLeftRightBoldPadding+50;
        height += kLeftRightFitPadding;
        return height;
    }
    
    height += kLeftRightBoldPadding+50;
    height += kLeftRightFitPadding;
    height += 50+kLeftRightFitPadding;
    return height;
}

- (void)setUpViews {
    [self addContentLabel];
    [self addControlButton];
    [self addStackViews];
    
    [self setUpItemsFrameList];
    [self setUpItemsView];
}

- (void)setUpItemsFrameList {
    CGFloat width = (SCREEN_WIDTH-kLeftRightBoldPadding*2-kLeftRightFitPadding)/2;
    CGRect frameA = CGRectMake(15, kLeftRightBoldPadding*2+17, width, 50);
    CGRect frameB = CGRectMake(15+width+kLeftRightFitPadding, kLeftRightBoldPadding*2+17, width, 50);
    CGRect frameC = CGRectMake(15, kLeftRightBoldPadding*2+17+50+kLeftRightFitPadding, width, 50);
    CGRect frameD = CGRectMake(15+width+kLeftRightBoldPadding, kLeftRightBoldPadding*2+17+50+kLeftRightFitPadding, width, 50);
    _frameArrays = @[[NSValue valueWithCGRect:frameA], [NSValue valueWithCGRect:frameB],
                     [NSValue valueWithCGRect:frameC], [NSValue valueWithCGRect:frameD]];
}

- (void)setUpItemsView {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < _frameArrays.count; i++) {
        CGRect frame = [_frameArrays[i] CGRectValue];
        DWSearchHistoryView *itemView = [[DWSearchHistoryView alloc] initWithFrame:frame];
        itemView.itemIndex = i;
        itemView.delegate = self;
        [itemView refresh];
        [array addObject:itemView];
        [self.contentView addSubview:itemView];
        itemView.hidden = YES;
    }
    _itemViewArrays = [array copy];
}


- (void)addContentLabel {
    _contentTitleLabel = [DWUIComponentFactory buildLabelWithTextColor:[UIColor dw_TitleTextColor]
                                                                  font:[UIFont systemFontOfSize:16]];
    [self.contentView addSubview:_contentTitleLabel];
}

- (void)addControlButton {
    _controlButton = [DWUIComponentFactory buildButtonWithTitle:@""
                                                backgroundImage:@""
                                                           font:[UIFont systemFontOfSize:12]
                                                         target:self
                                                         action:@selector(didControlButtonClicked:)];
    [_controlButton setTitleColor:[UIColor dw_PlaceholderTextColor] forState:UIControlStateNormal];
    _controlButton.hitEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    [self.contentView addSubview:_controlButton];
}


- (void)addStackViews {
    _stackViewA = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-kLeftRightBoldPadding*2, 30)];
    _stackViewB = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-kLeftRightBoldPadding*2, 30)];
    _stackViewA.tag = 0;
    _stackViewB.tag = 1;
    _stackViewB.axis = _stackViewA.axis = UILayoutConstraintAxisHorizontal;
    _stackViewB.spacing = _stackViewA.spacing = kLeftRightFitPadding;
    _stackViewB.alignment = _stackViewA.alignment = UIStackViewAlignmentLeading;
    _stackViewB.distribution = _stackViewA.distribution = UIStackViewDistributionFillProportionally;
    [self.contentView addSubview:_stackViewA];
    [self.contentView addSubview:_stackViewB];
    
    [self addTagButtonsToStackView:_stackViewA];
    [self addTagButtonsToStackView:_stackViewB];
}

- (void)addTagButtonsToStackView:(UIStackView *)stackView {
    if (!stackView)    return;
    
    for (int i = 0; i < kMaxTagCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:@" " forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dw_TitleTextColor] forState:UIControlStateNormal];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        button.selected = YES;
        [button addTarget:self
                   action:@selector(didTagButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        [stackView addArrangedSubview:button];
        
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@28);
        }];
    }
}

- (void)updateConstraints {
    [self addTitleLabelLayout];
    [self addControlButtonLayout];
    [self addStackViewsLayout];
    
    [super updateConstraints];
}

- (void)addTitleLabelLayout {
    __block CGFloat width = (SCREEN_WIDTH-kLeftRightBoldPadding*2)/2;
    [_contentTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kLeftRightBoldPadding);
        make.left.equalTo(self.contentView).offset(kLeftRightBoldPadding);
        make.size.mas_equalTo(CGSizeMake(width, 17));
    }];
}

- (void)addControlButtonLayout {
    __weak typeof(self) weakSelf = self;
    [_controlButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-kLeftRightThinPadding);
        make.centerY.equalTo(weakSelf.contentTitleLabel);
        make.size.mas_equalTo(CGSizeMake(30, 18));
    }];
}

- (void)addStackViewsLayout {
    __weak typeof(self) weakSelf = self;
    __block CGFloat width = (SCREEN_WIDTH-kLeftRightBoldPadding*2);
    [_stackViewA mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake(width, 30));
        make.top.equalTo(weakSelf.contentTitleLabel.mas_bottom).offset(kLeftRightBoldPadding);
    }];
    
    [_stackViewB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake(width, 30));
        make.top.equalTo(weakSelf.stackViewA.mas_bottom).offset(kLeftRightFitPadding);
    }];
}

- (void)refresh {
    if (_tagButtonArray && _tagButtonArray.count > 0 && _cellIndex == 0) {
        _stackViewA.hidden = _stackViewB.hidden = NO;
        NSArray *itemsA = [_tagButtonArray firstObject];
        BOOL isUsedType = _type == DWSearchCellTypeUsed;
        for (int i = 0; i < _stackViewA.arrangedSubviews.count; i++) {
            UIButton *button = _stackViewA.arrangedSubviews[i];
            if (i < itemsA.count) {
                button.alpha = 1;
                button.userInteractionEnabled = YES;
                [button setTitle:itemsA[i] forState:UIControlStateNormal];
                if (isUsedType) {
                    [button setBackgroundColor:[UIColor dw_ColorWithHexString:@"#EEEEEE"]];
                    button.titleLabel.font = [UIFont systemFontOfSize:14];
                    button.titleEdgeInsets = button.imageEdgeInsets = UIEdgeInsetsZero;
                    [button removeLeftImage];
                    [button removeDefaultBorderLine];
                } else {
                    button.titleLabel.font = [UIFont systemFontOfSize:11];
                    [button addLeftImage:[UIImage imageNamed:@"checked"] offset:8];
                    [button setBackgroundColor:[UIColor whiteColor]];
                    [button addDefaultBorderLine];
                }
            } else {
                button.alpha = 0;
                button.userInteractionEnabled = NO;
                [button setTitle:@" " forState:UIControlStateNormal];
                button.titleEdgeInsets = button.imageEdgeInsets = UIEdgeInsetsZero;
                if (isUsedType) {
                    button.titleLabel.font = [UIFont systemFontOfSize:14];
                    [button setBackgroundColor:[UIColor dw_ColorWithHexString:@"#EEEEEE"]];
                    [button removeLeftImage];
                } else {
                    [button setBackgroundColor:[UIColor whiteColor]];
                    [button addLeftImage:[UIImage imageNamed:@"checked"] offset:0];
                    button.titleLabel.font = [UIFont systemFontOfSize:11];
                }
            }
        }
        
        NSArray *itemsB = [_tagButtonArray lastObject];
        for (int i = 0; i < _stackViewB.arrangedSubviews.count; i++) {
            UIButton *button = _stackViewB.arrangedSubviews[i];
            CGFloat fontSize = _type == DWSearchCellTypeNew ? 11 : 14;
            button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
            if (i < itemsB.count) {
                button.alpha = 1;
                button.userInteractionEnabled = YES;
                [button setTitle:itemsB[i] forState:UIControlStateNormal];
                if (_type == DWSearchCellTypeUsed) {
                    [button setBackgroundColor:[UIColor dw_ColorWithHexString:@"#EEEEEE"]];
                    [button removeDefaultBorderLine];
                } else {
                    [button setBackgroundColor:[UIColor whiteColor]];
                    [button addDefaultBorderLine];
                }
            } else {
                button.alpha = 0;
                button.userInteractionEnabled = NO;
                [button setTitle:@" " forState:UIControlStateNormal];
            }
        }
        _contentTitleLabel.hidden = NO;
        _controlButton.hidden = (_type != DWSearchCellTypeUsed);
        CGFloat fontSize = (_type == DWSearchCellTypeUsed) ? 16 : 11;
        _contentTitleLabel.font = [UIFont systemFontOfSize:fontSize];
        _contentTitleLabel.text = _searchTitle ? : @"";
        [_controlButton setTitle:_controlButtonTitle forState:UIControlStateNormal];
        
    } else if (_tagButtonArray && _tagButtonArray.count > 0 && _cellIndex == 1) {
        _stackViewA.hidden = _stackViewB.hidden = YES;
        for (int i = 0; i < _itemViewArrays.count; i++) {
            DWSearchHistoryView *view = _itemViewArrays[i];
            if (i < _tagButtonArray.count) {
                view.hidden = NO;
                view.titleText = _tagButtonArray[i];
                [view refresh];
            } else {
                view.hidden = YES;
            }
        }
        _contentTitleLabel.hidden = (_type != DWSearchCellTypeUsed);
        CGFloat fontSize = (_type == DWSearchCellTypeUsed) ? 16 : 10;
        _contentTitleLabel.font = [UIFont systemFontOfSize:fontSize];
        _contentTitleLabel.text = _searchTitle ? : @"";
        [_controlButton setTitle:_controlButtonTitle forState:UIControlStateNormal];

    } else {
        _stackViewA.hidden = _stackViewB.hidden = YES;
        for (DWSearchHistoryView *view in _itemViewArrays) {
            view.hidden = YES;
        }
        _contentTitleLabel.font = [UIFont systemFontOfSize:16];
        _contentTitleLabel.text = @"";
        [_controlButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - SEL
- (void)didControlButtonClicked:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterControlButtonClickedAt:)]) {
        [_delegate triggerToResponseAfterControlButtonClickedAt:_cellIndex];
    }
}

- (void)didTagButtonClicked:(UIButton *)button {
    NSLog(@"%ld", button.tag);
    NSInteger viewIndex = -1;
    UIView *view = [button superview];
    if (view == _stackViewA) {
        viewIndex = 0;
    } else if (view == _stackViewB) {
        viewIndex = 1;
    } else {
        // do nothing...
    }
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterHotTagsClickedAtViewIndex:itemIndex:)]) {
        [_delegate triggerToResponseAfterHotTagsClickedAtViewIndex:viewIndex itemIndex:button.tag];
    }
}

@end
