//
//  UIButton+Utils.h
//  Dwell
//
//  Created by toureek on 10/16/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DWButtonAlignType) {
    DWButtonAlignTypeLeft = 0,    // 标题在左边
    DWButtonAlignTypeBottom = 1,
};

@interface UIButton (Utils)

@property (nonatomic, assign) UIEdgeInsets hitEdgeInsets;

- (void)setButtonType:(DWButtonAlignType)type;

- (void)addLeftImage:(UIImage *)image offset:(CGFloat)offset;
- (void)removeLeftImage;

- (void)addDefaultBorderLine;
- (void)removeDefaultBorderLine;

@end
