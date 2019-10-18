//
//  DWRichContentItemData.m
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWRichContentItemData.h"
#import "DWResponseInfo.h"
#import "DWDisplayModel.h"

@implementation DWRichContentItemData

- (instancetype)init {
    self = [super init];
    if (self) {
        _sectionTotalCount = 0;
    }
    return self;
}

- (instancetype)initDWRichContentItemDataWithStyle:(DWRichContentItemStyle)style {
    self = [super init];
    if (self) {
        self.style = style;
    }
    return self;
}

- (instancetype)initDWRichContentItemDataWithStyle:(DWRichContentItemStyle)style
                                          colorHEX:(NSString *)colorHEXText
                                         colorText:(NSString *)colorText
                                    titleLableText:(NSString *)titleText
                                 subtitleLabelText:(NSString *)subtitleText
                                 iconImageNameText:(NSString *)iconImgName
                                     actionUrlText:(NSString *)actionUrl {
    self = [super init];
    if (self) {
        self.style = style;
        self.colorHEXText = colorHEXText ? : @"";
        self.colorLabelText = colorText ? : @"";
        self.titleLabelText = titleText ? : @"";
        self.subtitleLabelText = subtitleText ? : @"";
        self.iconImageBackgroundImgName = iconImgName ? : @"";
        self.actionUrl = actionUrl ? : @"";
    }
    return self;
}

- (void)buildUpDataSourceForHomeConfigs:(DWHomeConfigResponse *)info {
    if (!info)    return;
    
    _sectionTotalCount = info.configModel.moduleList.count;
    _secitonHeaderTitles = [info.configModel sectionHeaderIndexTitlesForConfigs];
    _sectionArray_0 = [info.configModel.moduleList.firstObject list];
    _sectionArray_1 = info.configModel.section_1_data;
    _sectionArray_2 = info.configModel.section_2_data;
    _sectionArray_3 = info.configModel.section_3_data;
    _sectionArray_4 = info.configModel.section_4_data;
    _sectionArray_5 = info.configModel.section_5_data;
    _sectionArray_6 = info.configModel.section_6_data;
    _sectionArray_7 = info.configModel.section_7_data;
    _sectionArray_8 = info.configModel.section_8_data;
}

- (void)buildUpSectionHeadersAfterFetchedRecmdList {
    if (_sectionTotalCount == 9)    _sectionTotalCount = 10;
    
    NSMutableArray *array = [_secitonHeaderTitles mutableCopy];
    [array addObject:(_secitonHeaderTitles.count == 9) ? @"精选推荐" : @""];
    _secitonHeaderTitles = [array copy];
}

- (void)buildUpDataSourceForHomeRecommendList:(DWHomeRecommendsResponse *)recommendsInfo type:(NSInteger)type {
    if (!recommendsInfo)    return;
    
//    DWHouseItemContentTypeUsed = 1,
//    DWHouseItemContentTypeNew = 2,
//    DWHouseItemContentTypeRent = 3,
//    DWHouseItemContentTypeOverseas = 4,
    if (type == 1) {
        _sectionArray_9 = recommendsInfo.recommendModel.secondHand;
    } else if (type == 2) {
        _sectionArray_9 = recommendsInfo.recommendModel.newhouse;
    } else if (type == 3) {
        _sectionArray_9 = recommendsInfo.recommendModel.rent;
    } else if (type == 4) {
        _sectionArray_9 = recommendsInfo.recommendModel.oversea;
    } else {
        // do nothing...
    }
}

- (NSString *)recommendListBottomButtonTitle:(NSInteger)type {
    if (type == 1) {
        return @"查看全部二手房";
    } else if (type == 2) {
        return @"查看全部新房";
    } else if (type == 3) {
        return @"查看全部租房";
    } else if (type == 4) {
        return @"查看全部海外房源";
    } else {
        return @"";
    }
}

+ (CGRect)imagePictureInfoFrame:(NSString *)layout {
    if (!layout || layout.length == 0 || layout.length != 3)    return CGRectZero;
    
    CGFloat unitWidth = (SCREEN_WIDTH-(kLeftRightBoldPadding+kLeftRightThinPadding)*2)/3.0f;
    NSArray *array = [layout componentsSeparatedByString:@"-"];
    NSInteger top = [[array firstObject] integerValue];
    NSInteger bottom = [[array lastObject] integerValue];
    if (bottom < top)    return CGRectZero;
    
    CGFloat originX = 0;
    if (top%3 == 0 ) {
        originX = kLeftRightBoldPadding;
    } else if (top%3 == 1) {
        originX = kLeftRightBoldPadding + unitWidth + kLeftRightThinPadding;
    } else if (top%3 == 2) {
        originX = kLeftRightBoldPadding + (unitWidth + kLeftRightThinPadding)*2;
    } else {
        originX = 0;
    }
    
    CGFloat originY = (bottom > 2) ? unitWidth+kLeftRightThinPadding : 0;
    if (top != bottom && top%3 == bottom%3)    originY = 0;

    CGFloat width = 0;
    CGFloat height = 0;
    if (top == bottom) {
        width = height = unitWidth;
    } else if (top%3 == bottom%3) {
        width = unitWidth;
        height = unitWidth*2 + kLeftRightThinPadding;
    } else if (bottom%3 - top%3 == 1) {
        width = unitWidth*2 + kLeftRightThinPadding;
        height = bottom < 3 ? unitWidth : unitWidth*2 + kLeftRightThinPadding;
    } else if (bottom%3 - top%3 == 2) {
        width = unitWidth*3 + 2*kLeftRightThinPadding;
        height = bottom < 3 ? unitWidth : unitWidth*2 + kLeftRightThinPadding;
    } else {
        width = height = unitWidth;
    }
    return CGRectMake(originX, originY, width, height);
}

- (NSArray *)buildUpDataSourceForSection:(NSInteger)section {
    if (section == 6) {
        return _sectionArray_6;
    } else if (section == 7) {
        return _sectionArray_7;
    } else if (section == 8) {
        return _sectionArray_8;
    } else if (section == 9) {
        return _sectionArray_9;
    } else {
        return nil;
    }
}

- (BOOL)isOpenHttp {
    return [_actionUrl hasPrefix:@"http"];
}

@end
