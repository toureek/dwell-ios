//
//  DWImageNewsTableViewCell.m
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWImageNewsTableViewCell.h"
#import "DWRichContentItemView.h"

NSString *const kDWImageNewsTableViewCellTag = @"kDWImageNewsTableViewCellTag";

@interface DWImageNewsTableViewCell () <DWRichContentItemViewDelegate>
@end

@implementation DWImageNewsTableViewCell {
    NSMutableArray *_imageViewsArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageViewsArray = [[NSMutableArray alloc] initWithCapacity:6];
    }
    return self;
}

+ (CGFloat)height {
    CGFloat width = (SCREEN_WIDTH-(kLeftRightBoldPadding+kLeftRightThinPadding)*2)/3.0f;
    return width*2 + kLeftRightThinPadding;
}

- (void)refresh {
    if (_dataArray) {
        if (_imageViewsArray.count == 0) {
            for (int i = 0; i < _dataArray.count; i++) {
                NSDictionary *dict = _dataArray[i];
                NSString *key = [dict.allKeys firstObject];
                CGRect frame = [DWRichContentItemData imagePictureInfoFrame:key];
                DWRichContentItemView *itemView = [[DWRichContentItemView alloc] initWithFrame:frame richContentItemViewStyle:DWRichContentItemStyleTitleSubTitleWithBackgroundImgInfo];
                itemView.delegate = self;
                itemView.tag = itemView.itemViewIndex = i;
                [itemView refreshContent:dict.allValues.firstObject];
                [self.contentView addSubview:itemView];
                [_imageViewsArray addObject:itemView];
            }
        } else {
            // do nothing...
        }
    } else {
        // do nothing...
    }
}

#pragma mark - DWRichContentItemViewDelegate
- (void)triggerToResponseAfterItemViewTappedAtIndex:(NSInteger)index {
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterImageNewsTappedAt:)]) {
        [_delegate triggerToResponseAfterImageNewsTappedAt:index];
    }
}

@end
