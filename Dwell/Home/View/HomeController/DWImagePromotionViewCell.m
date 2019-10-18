//
//  DWImagePromotionViewCell.m
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWImagePromotionViewCell.h"

NSString *const kDWImagePromotionViewCellTag = @"kDWImagePromotionViewCellTag";
CGFloat const kDWImagePromotionCellHeight = 70.0f;

@implementation DWImagePromotionViewCell {
    UIStackView *_stackView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    _stackView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-kLeftRightBoldPadding*2, 70)];
    _stackView.axis = UILayoutConstraintAxisHorizontal;
    _stackView.spacing = kLeftRightThinPadding;
    _stackView.alignment = UIStackViewAlignmentCenter;
    _stackView.distribution = UIStackViewDistributionFillEqually;
    [self.contentView addSubview:_stackView];
}

- (void)updateConstraints {
    [_stackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, kLeftRightBoldPadding, 0, kLeftRightBoldPadding));
    }];
    
    [super updateConstraints];
}

- (void)refresh:(NSArray *)dataArray {
    if (dataArray && dataArray.count > 0) {
        if (_stackView.arrangedSubviews.count == 0) {
            NSInteger totalCount = dataArray.count;
            for (int i = 0; i < totalCount; i++) {
                NSDictionary *dict = dataArray[i];
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.userInteractionEnabled = YES;
                imageView.tag = i;
                UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(didPromotionADClicked:)];
                [imageView addGestureRecognizer:tapper];
                [imageView sd_setImageWithURL:[NSURL URLWithString:dict.allValues.firstObject ? : @""]
                             placeholderImage:[UIColor dw_ImageFactoryWithColor:[UIColor clearColor]]];
                [_stackView addArrangedSubview:imageView];
                
                [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(kDWImagePromotionCellHeight));
                }];
            }
        }
    } else {
        // Do nothing...
    }
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - SEL
- (void)didPromotionADClicked:(UITapGestureRecognizer *)tapper {
    UIImageView *imageView = (UIImageView *)[tapper view];
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterPromoteADTappedAt:)]) {
        [_delegate triggerToResponseAfterPromoteADTappedAt:imageView.tag];
    }
}

@end
