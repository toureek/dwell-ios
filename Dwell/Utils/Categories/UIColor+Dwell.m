//
//  UIColor+Dwell.m
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "UIColor+Dwell.h"

@implementation UIColor (Dwell)

+ (UIColor *)dw_ColorWithHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue  = [self colorComponentFrom:colorString start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red   = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue  = [self colorComponentFrom:colorString start:6 length:2];
            break;
        default:
            [NSException raise:@"Invalid color value"
                        format:@"Color value %@ is invalid.  It should be a hex value of the form #RRGGBB, or #AARRGGBB", hexString];
            break;
    }

//    if (@available(iOS 10.0, *)) {
//        return [UIColor colorWithDisplayP3Red:red green:green blue:blue alpha:alpha];  // sRGB-Color
//    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];           // RGB-Color
}

+ (UIImage *)dw_ImageFactoryWithColor:(UIColor *)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *subString = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? subString : [NSString stringWithFormat:@"%@%@", subString, subString];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}


+ (UIColor *)dw_TitleTextColor {
    return [self dw_ColorWithHexString:@"#333333"];
}

+ (UIColor *)dw_SubTitleTextColor {
    return [self dw_ColorWithHexString:@"#666666"];
}

+ (UIColor *)dw_PlaceholderTextColor {
    return [self dw_ColorWithHexString:@"#999999"];
}

+ (UIColor *)dw_SeperatorLineColor {
    return [self dw_ColorWithHexString:@"#CCCCCC"];
}


// 大图缩小为显示尺寸的图, iOS Image/IO BestPractise in WWDC 2018
+ (UIImage *)dw_DownsampleImageAt:(NSURL *)imageURL to:(CGSize)pointSize scale:(CGFloat)scale {
    NSDictionary *imageSourceOptions = @{(__bridge NSString *)kCGImageSourceShouldCache: @NO};  // original img doesn't need to be decoded
    CGImageSourceRef imageSource =
    CGImageSourceCreateWithURL((__bridge CFURLRef)imageURL, (__bridge CFDictionaryRef)imageSourceOptions);
    
    // downsampling
    CGFloat maxDimensionInPixels = MAX(pointSize.width, pointSize.height) * scale;
    NSDictionary *downsampleOptions =
    @{
      (__bridge NSString *)kCGImageSourceCreateThumbnailFromImageAlways: @YES,
      (__bridge NSString *)kCGImageSourceShouldCacheImmediately: @YES,  // doing thumbnail while decoding at the same time
      (__bridge NSString *)kCGImageSourceCreateThumbnailWithTransform: @YES,
      (__bridge NSString *)kCGImageSourceThumbnailMaxPixelSize: @(maxDimensionInPixels)
      };
    CGImageRef downsampledImage =
    CGImageSourceCreateThumbnailAtIndex(imageSource, 0, (__bridge CFDictionaryRef)downsampleOptions);
    UIImage *image = [[UIImage alloc] initWithCGImage:downsampledImage];
    CGImageRelease(downsampledImage);
    CFRelease(imageSource);
    return image;
}

@end
