//
//  UIView+Utils.m
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

- (void)dw_AddCornerRadius:(CGFloat)radius size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(cxt, [UIColor whiteColor].CGColor);
    CGContextSetStrokeColorWithColor(cxt, [UIColor dw_SeperatorLineColor].CGColor);
    
    CGContextMoveToPoint(cxt, size.width, size.height-radius);
    CGContextAddArcToPoint(cxt, size.width, size.height, size.width-radius, size.height, radius);  //right-bottom
    CGContextAddArcToPoint(cxt, 0, size.height, 0, size.height-radius, radius);  //left-bottom
    CGContextAddArcToPoint(cxt, 0, 0, radius, 0, radius);  //left-top
    CGContextAddArcToPoint(cxt, size.width, 0, size.width, radius, radius);  //right-top
    CGContextClosePath(cxt);
    CGContextDrawPath(cxt, kCGPathFillStroke);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [imageView setImage:image];
    [self insertSubview:imageView atIndex:0];
}

@end
