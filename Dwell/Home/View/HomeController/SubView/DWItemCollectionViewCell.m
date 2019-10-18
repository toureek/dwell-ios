//
//  DWItemCollectionViewCell.m
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWItemCollectionViewCell.h"
#import "DWDisplayModel.h"

NSString *const kDWItemCollectionViewCell = @"kDWItemCollectionViewCell";

@implementation DWItemCollectionViewCell {
    UIImageView *_itemImageView;
    UILabel *_itemLable;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpItemCell];
    }
    return self;
}

- (void)setUpItemCell {
    self.userInteractionEnabled = self.contentView.userInteractionEnabled = YES;
    [self addItemImageView];
    [self addItemLable];
}

- (void)addItemImageView {
    _itemImageView = [[UIImageView alloc] init];
    _itemImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_itemImageView];
}

- (void)addItemLable {
    _itemLable = [[UILabel alloc] init];
    _itemLable.textAlignment = NSTextAlignmentCenter;
    _itemLable.numberOfLines = 1;
    _itemLable.font = [UIFont systemFontOfSize:12];
    [_itemLable sizeToFit];    // iOS9 font-size changed in character-space 
    [self.contentView addSubview:_itemLable];
}

- (void)updateConstraints {
    [self setUpItemImageViewLayout];
    [self setUpItemLabelLayout];
    
    [super updateConstraints];
}

- (void)setUpItemImageViewLayout {
    CGFloat size = floor((UIScreen.mainScreen.bounds.size.width/5.0)) / 2.0;
    [_itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(size, size));
        make.centerX.equalTo(self.contentView);
    }];
}

- (void)setUpItemLabelLayout {
    __block CGFloat bottomPadding = IS_IPHONE_4_OR_LESS ? -kLeftRightFitPadding : -kLeftRightBoldPadding;
    [_itemLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(bottomPadding);
    }];
}

- (void)refresh {
    if (_item) {
        [_itemImageView sd_setImageWithURL:[NSURL URLWithString:_item.imgUrl]
                          placeholderImage:[UIColor dw_ImageFactoryWithColor:[UIColor clearColor]]];
        _itemLable.text = _item.title ? : @"";
    }
    [self setNeedsUpdateConstraints];
}

@end
