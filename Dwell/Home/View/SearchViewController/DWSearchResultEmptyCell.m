//
//  DWSearchResultEmptyCell.m
//  Dwell
//
//  Created by toureek on 10/18/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWSearchResultEmptyCell.h"

NSString *const kDWSearchResultEmptyCellTag = @"kDWSearchResultEmptyCellTag";

@implementation DWSearchResultEmptyCell {
    UIImageView *_emptyImageView;
    UILabel *_emptyMessageLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    _emptyImageView = [[UIImageView alloc] init];
    _emptyImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_emptyImageView];
    
    _emptyMessageLabel = [[UILabel alloc] init];
    _emptyMessageLabel.textColor = [UIColor dw_TitleTextColor];
    _emptyMessageLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_emptyMessageLabel];
}

- (void)updateConstraints {
    [_emptyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-30);
    }];
    
    [_emptyMessageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_centerY);
    }];
    
    [super updateConstraints];
}

- (void)refresh {
    _emptyImageView.image = [UIImage imageNamed:_imageName ? : @""];
    _emptyMessageLabel.text = _emptyDataMessage ? : @"";
    
    [self setNeedsUpdateConstraints];
}

@end
