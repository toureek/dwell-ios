//
//  UIColor+Dwell.h
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Dwell)

+ (UIColor *)dw_ColorWithHexString:(NSString *)hexString;
+ (UIImage *)dw_ImageFactoryWithColor:(UIColor *)color;

// App-Colors
+ (UIColor *)dw_TitleTextColor;
+ (UIColor *)dw_SubTitleTextColor;
+ (UIColor *)dw_PlaceholderTextColor;
+ (UIColor *)dw_SeperatorLineColor;

// downsampling for images
+ (UIImage *)dw_DownsampleImageAt:(NSURL *)imageURL to:(CGSize)pointSize scale:(CGFloat)scale;

@end
