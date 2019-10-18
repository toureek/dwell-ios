//
//  DWItemPickerView.m
//  Dwell
//
//  Created by toureek on 10/18/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWItemPickerView.h"

@implementation DWItemPickerView {
    UIStackView *_stackView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor blueColor].CGColor;
    self.layer.borderWidth = 0.5f;
    self.layer.cornerRadius = 4.0f;
    
    _stackView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, 100, self.bounds.size.height)];
    _stackView.axis = UILayoutConstraintAxisVertical;
    _stackView.spacing = CGFLOAT_MIN;
    _stackView.alignment = UIStackViewAlignmentCenter;
    _stackView.distribution = UIStackViewDistributionFill;
    [self addSubview:_stackView];
}

- (void)refresh {
    if (_itemArray && _itemArray.count > 0) {
        if (_stackView.arrangedSubviews.count == 0) {
            NSInteger totalLineCount = _itemArray.count - 1;
            for (int i = 0, j = 0; i < _itemArray.count; i++, j++) {
                NSString *buttonTitle = _itemArray[i];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = i;
                button.titleLabel.font = [UIFont systemFontOfSize:16];
                [button setTitle:buttonTitle forState:UIControlStateNormal];
                UIColor *textColor = (_selectedIndex == i) ? [UIColor blueColor] : [UIColor dw_TitleTextColor];
                [button setTitleColor:textColor forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor whiteColor]];
                button.selected = YES;
                [button addTarget:self
                           action:@selector(didItemButtonClicked:)
                 forControlEvents:UIControlEventTouchUpInside];
                [_stackView addArrangedSubview:button];
                
                [button mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@43);
                }];
                
                if (j < totalLineCount) {
                    UILabel *label = [[UILabel alloc] init];
                    label.backgroundColor = [UIColor dw_SeperatorLineColor];
                    [_stackView addArrangedSubview:label];
                    
                    [label mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(70, 0.5));
                    }];
                 }
                
            }
        } else {
            for (int i = 0, j = 0; i < _stackView.arrangedSubviews.count; i++) {
                UIView *subView = _stackView.arrangedSubviews[i];
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *button = (UIButton *)subView;
                    UIColor *textColor = (_selectedIndex == j) ? [UIColor blueColor] : [UIColor dw_TitleTextColor];
                    [button setTitleColor:textColor forState:UIControlStateNormal];
                    j++;
                }
            }
        }
    }
}

#pragma mark - SEL
- (void)didItemButtonClicked:(UIButton *)button {
    NSLog(@"%ld", button.tag);
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterItemSelectedAt:)]) {
        [_delegate triggerToResponseAfterItemSelectedAt:button.tag];
    }
}

@end
