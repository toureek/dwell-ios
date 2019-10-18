//
//  UIButton+Utils.m
//  Dwell
//
//  Created by toureek on 10/16/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "UIButton+Utils.h"
#import "UIColor+Dwell.h"
#import <objc/runtime.h>

static NSString *const UIBUTTON_CLICKED_EDGE_INSETS = @"HitTestEdgeInsets";

@implementation UIButton (Utils)

- (UIEdgeInsets)hitEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &UIBUTTON_CLICKED_EDGE_INSETS);
    if (value) {
        UIEdgeInsets edgeInsets;
        [value getValue:&edgeInsets];
        return edgeInsets;
    }
    return UIEdgeInsetsZero;
}

- (void)setHitEdgeInsets:(UIEdgeInsets)hitEdgeInsets {
    NSValue *value = [NSValue value:&hitEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &UIBUTTON_CLICKED_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(self.hitEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}


- (void)setButtonType:(DWButtonAlignType)type {
    [self layoutIfNeeded];
    
    CGRect titleFrame = self.titleLabel.frame;
    CGRect imageFrame = self.imageView.frame;
    CGFloat space = titleFrame.origin.x - imageFrame.origin.x - imageFrame.size.width;
    
    if (type == DWButtonAlignTypeLeft) {
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleFrame.size.width+space, 0, -(titleFrame.size.width+space))];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -(titleFrame.origin.x-imageFrame.origin.x), 0, titleFrame.origin.x-imageFrame.origin.x)];
    } else if(type == DWButtonAlignTypeBottom) {
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, titleFrame.size.height+space, -(titleFrame.size.width))];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(imageFrame.size.height+space, -(imageFrame.size.width), 0, 0)];
    }
}

- (void)addLeftImage:(UIImage *)image offset:(CGFloat)offset {
    [self setImage:image forState:UIControlStateNormal];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.imageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:0].active = YES;
    [self.imageView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:offset].active = YES;
}

- (void)removeLeftImage {
    [self setImage:nil forState:UIControlStateNormal];
}

- (void)addDefaultBorderLine {
    self.layer.borderColor = [UIColor dw_SeperatorLineColor].CGColor;
    self.layer.borderWidth = 0.5;
}

- (void)removeDefaultBorderLine {
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 0;
}


@end
