//
//  DWUsedInteractiveView.m
//  Dwell
//
//  Created by toureek on 10/18/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWUsedInteractiveView.h"
#import "DWDisplayModel.h"

@implementation DWUsedInteractiveView {
    NSArray *_buttonArrays;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.7f;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
    CGFloat width = (SCREEN_WIDTH-30*2-kLeftRightBoldPadding/2)/2;
    
    CGRect frameA = CGRectMake(30, kLeftRightBoldPadding, width, kLeftRightBoldPadding*2);
    CGRect frameB = CGRectMake(30+width+kLeftRightBoldPadding, kLeftRightBoldPadding, width, kLeftRightBoldPadding*2);
    CGRect frameC = CGRectMake(30, self.bounds.size.height-kLeftRightBoldPadding*3, width, kLeftRightBoldPadding*2);
    CGRect frameD = CGRectMake(30+width+kLeftRightBoldPadding, self.bounds.size.height-kLeftRightBoldPadding*3, width, kLeftRightBoldPadding*2);
    _frameArrays = @[[NSValue valueWithCGRect:frameA], [NSValue valueWithCGRect:frameB],
                     [NSValue valueWithCGRect:frameC], [NSValue valueWithCGRect:frameD]];
    
    for (int i = 0; i < _frameArrays.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor redColor];
        button.frame = CGRectMake(0, 0, 60, 18);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:@" " forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(didInteractiveButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor dw_TitleTextColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = kLeftRightBoldPadding;
        button.layer.masksToBounds = YES;
        button.alpha = 1;
        button.tag = i;
        [array addObject:button];
        [self addSubview:button];
    }
    _buttonArrays = [array copy];
}

- (void)showInteractiveView {
    if (_actionArray && _actionArray.count > 0) {
        for (int i = 0; i < _actionArray.count; i++) {
            DWColorTagsAndFeedback *item = _actionArray[i];
            UIButton *button = _buttonArrays[i];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button sd_setImageWithURL:[NSURL URLWithString:item.fbIconUrl ? : @""] forState:UIControlStateNormal];
            [button setTitle:item.fbTitle ? : @"" forState:UIControlStateNormal];
            button.frame = [_frameArrays[i] CGRectValue];
            [self bringSubviewToFront:button];
        }
    }
}

- (void)dismissInteractiveView {
    self.hidden = YES;
}

#pragma mark - SEL
- (void)didInteractiveButtonClicked:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToRepsonseAfterButtonClickedAtButtonIndex:atCellIndex:)]) {
        [_delegate triggerToRepsonseAfterButtonClickedAtButtonIndex:button.tag atCellIndex:_cellIndex];
    }
}

@end
