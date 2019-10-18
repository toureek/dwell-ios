//
//  DWHouseContentHeaderView.m
//  Dwell
//
//  Created by toureek on 10/16/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWHouseContentHeaderView.h"
#import "DWRichContentItemView.h"
#import "DWRichContentItemData.h"

NSString *const kDWHouseContentHeaderViewTag = @"kDWHouseContentHeaderViewTag";
CGFloat const kDWHouseContentHeaderViewHeight = 60.0f;

@interface DWHouseContentHeaderView () <DWRichContentItemViewDelegate>
@end

@implementation DWHouseContentHeaderView {
    UIStackView *_stackView;
    UILabel *_bottomLineLabel;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH-kLeftRightBoldPadding*2, kDWHouseContentHeaderViewHeight-0.5);
    _stackView = [[UIStackView alloc] initWithFrame:frame];
    _stackView.axis = UILayoutConstraintAxisHorizontal;
    _stackView.spacing = kLeftRightThinPadding;
    _stackView.alignment = UIStackViewAlignmentCenter;
    _stackView.distribution = UIStackViewDistributionFillEqually;
    [self.contentView addSubview:_stackView];
    
    _bottomLineLabel = [[UILabel alloc] init];
    _bottomLineLabel.backgroundColor = [UIColor dw_SeperatorLineColor];
    [self.contentView addSubview:_bottomLineLabel];
}

- (void)updateConstraints {
    UIEdgeInsets insets = UIEdgeInsetsMake(0, kLeftRightBoldPadding, 0.5, kLeftRightBoldPadding);
    [_stackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(insets);
    }];
    
    [_bottomLineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(kLeftRightBoldPadding);
        make.right.equalTo(self.contentView).offset(kLeftRightBoldPadding);
    }];
    
    [super updateConstraints];
}

- (void)refresh:(NSArray *)dataArray {
    if (dataArray && dataArray.count > 0) {
        if (_stackView.arrangedSubviews.count == 0) {
            NSInteger totalCount = dataArray.count;
            for (int i = 0; i < totalCount; i++) {
                DWRichContentItemData *data = dataArray[i];
                DWRichContentItemView *itemView = [[DWRichContentItemView alloc] initWithFrame:CGRectZero richContentItemViewStyle:DWRichContentItemStyleTitleSubTitleWithBackgroundImgAD];
                itemView.delegate = self;
                itemView.tag = itemView.itemViewIndex = i;
                itemView.layer.borderWidth = 1;
                itemView.layer.borderColor = [UIColor blueColor].CGColor;
                [itemView refreshContent:data];
                [_stackView addArrangedSubview:itemView];
                
                [itemView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(kDWHouseContentHeaderViewHeight-0.5));
                }];
            }
        } else {
            // do nothing...
        }
    } else {
        // do nothing...
    }
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - DWRichContentItemViewDelegate
- (void)triggerToResponseAfterItemViewTappedAtIndex:(NSInteger)index {
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterHeaderViewItemClickedAt:atSectionIndex:)]) {
        [_delegate triggerToResponseAfterHeaderViewItemClickedAt:index atSectionIndex:_sectionIndex];
    }
}

@end
