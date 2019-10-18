//
//  DWUIComponentFactory.h
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWUIComponentFactory : NSObject

+ (UIButton *)buildButtonWithTitle:(NSString *)title
                   backgroundImage:(NSString *)backgroundImage
                              font:(UIFont *)font
                            target:(id)target
                            action:(SEL)action;

+ (UIButton *)buildButtonWithTitle:(NSString *)title
                   backgroundImage:(NSString *)backgroundImage
                    highlightImage:(NSString *)highlightedImage
                              font:(UIFont *)font
                            target:(id)target
                            action:(SEL)action;

+ (UILabel *)buildLabelWithTextColor:(UIColor *)textColor
                                font:(UIFont *)font;

+ (UILabel *)buildLabelWithTextColor:(UIColor *)textColor
                                font:(UIFont *)font
                     backgroundColor:(UIColor *)backgroundColor
                       textAlignment:(NSTextAlignment)textAlignment
                       numberOfLines:(NSInteger)numberOfLines;


+ (UITextField *)buildTextFiledWithPlaceholder:(NSString *)placeholder
                              placeholderColor:(UIColor *)placeholderColor
                                          font:(UIFont *)font
                                     textColor:(UIColor *)textColor
                                 textAlignment:(NSTextAlignment)textAlignment
                                    isPassword:(BOOL)isPassword
                                  keyboardType:(UIKeyboardType)keyboardType;

@end
