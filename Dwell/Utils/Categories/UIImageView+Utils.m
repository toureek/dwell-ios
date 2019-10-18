//
//  UIImageView+Utils.m
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "UIImageView+Utils.h"
#import "UIImage+Utils.h"

@implementation UIImageView (Utils)

- (void)dw_ImageAddCornerRadius:(CGFloat)radius size:(CGSize)size {
    if (self.image) {
        self.image = [self.image dw_ImageAddCornerRadius:radius size:size];
    }
    return;
}

@end
