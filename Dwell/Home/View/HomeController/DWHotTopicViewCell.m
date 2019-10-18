//
//  DWHotTopicViewCell.m
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWHotTopicViewCell.h"
#import "DWRichContentItemData.h"
#import "DWRichContentItemView.h"

NSString *const kDWHotTopicViewCellTag = @"kDWHotTopicViewCellTag";
CGFloat const kDWHotTopicViewCellHeight = 70.0f;

@interface DWHotTopicViewCell () <DWRichContentItemViewDelegate>

@end

@implementation DWHotTopicViewCell {
    UIStackView *_stackView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _stackView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-kLeftRightBoldPadding*2, 70)];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.spacing = kLeftRightThinPadding;
        _stackView.alignment = UIStackViewAlignmentCenter;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        [self.contentView addSubview:_stackView];
    }
    return self;
}

- (void)updateConstraints {
    [_stackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, kLeftRightBoldPadding, 0, kLeftRightBoldPadding));
    }];
    
    [super updateConstraints];
}

- (void)refresh {
    if (_array && _array.count > 0) {
        if (_stackView.arrangedSubviews.count == 0) {
            CGRect frame = CGRectMake(0, 0, (SCREEN_WIDTH-(kLeftRightBoldPadding+kLeftRightFitPadding)*2)/3, 70);
            for (int i = 0; i < _array.count; i++) {
                DWRichContentItemView *itemView = [[DWRichContentItemView alloc] initWithFrame:frame richContentItemViewStyle:DWRichContentItemStyleTitleSubTitleWithRightBottomIcon];
                itemView.itemViewIndex = i;
                itemView.delegate = self;
                itemView.layer.borderColor = [UIColor redColor].CGColor;
                itemView.layer.borderWidth = 1;
                [_stackView addArrangedSubview:itemView];
                
                [itemView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@70);
                }];
            }
            [self displayDatasource];
        } else {
            // Don't even refresh here.   [self displayDatasource];
        }
    } else {
        // do nothing...
    }

    [self setNeedsUpdateConstraints];
}

- (void)displayDatasource {
    for (int i = 0; i < _array.count; i++) {
        DWRichContentItemData *data = _array[i];
        DWRichContentItemView *itemView = [_stackView.arrangedSubviews objectAtIndex:i];
        [itemView refreshContent:data];
    }
}

#pragma mark - DWRichContentItemViewDelegate
- (void)triggerToResponseAfterItemViewTappedAtIndex:(NSInteger)index {
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterItemClickedAt:)]) {
        [_delegate triggerToResponseAfterItemClickedAt:index];
    }
}


@end
