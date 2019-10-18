//
//  DWRichContentItemData.h
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DWRichContentItemStyle) {
    DWRichContentItemStyleDefault = 0,      //  empty-view
    DWRichContentItemStyleColorfulTitleWithSubtitle = 1,
    DWRichContentItemStyleTitleSubTitleWithRightBottomIcon = 2,
    DWRichContentItemStyleTitleSubTitleWithBackgroundImgInfo = 3,
    DWRichContentItemStyleTitleSubTitleWithBackgroundImgAD = 4,
    DWRichContentItemStyleBackgroundImageViewOnly = 5,
};

@class DWHomeConfigResponse;
@class DWHomeRecommendsResponse;
@interface DWRichContentItemData : NSObject

@property (nonatomic, copy) NSString *actionUrl;
@property (nonatomic, copy) NSString *colorHEXText;
@property (nonatomic, copy) NSString *colorLabelText;
@property (nonatomic, copy) NSString *titleLabelText;
@property (nonatomic, copy) NSString *subtitleLabelText;
@property (nonatomic, copy) NSString *iconImageBackgroundImgName;
@property (nonatomic, assign) DWRichContentItemStyle style;

// datasource
@property (nonatomic, assign) NSInteger sectionTotalCount;
@property (nonatomic, copy) NSArray *secitonHeaderTitles;
@property (nonatomic, copy) NSArray *sectionArray_0;
@property (nonatomic, copy) NSArray *sectionArray_1;
@property (nonatomic, copy) NSArray *sectionArray_2;
@property (nonatomic, copy) NSArray *sectionArray_3;
@property (nonatomic, copy) NSArray *sectionArray_4;
@property (nonatomic, copy) NSArray *sectionArray_5;

@property (nonatomic, copy) NSArray *sectionArray_6;
@property (nonatomic, copy) NSArray *sectionArray_7;
@property (nonatomic, copy) NSArray *sectionArray_8;
@property (nonatomic, copy) NSArray *sectionArray_9;

- (instancetype)initDWRichContentItemDataWithStyle:(DWRichContentItemStyle)style;
- (instancetype)initDWRichContentItemDataWithStyle:(DWRichContentItemStyle)style
                                          colorHEX:(NSString *)colorHEXText
                                         colorText:(NSString *)colorText
                                    titleLableText:(NSString *)titleText
                                 subtitleLabelText:(NSString *)subtitleText
                                 iconImageNameText:(NSString *)iconImgName
                                     actionUrlText:(NSString *)actionUrl;

- (NSArray *)buildUpDataSourceForSection:(NSInteger)section;
- (void)buildUpDataSourceForHomeConfigs:(DWHomeConfigResponse *)info;

- (void)buildUpDataSourceForHomeRecommendList:(DWHomeRecommendsResponse *)recommendsInfo type:(NSInteger)type;
- (void)buildUpSectionHeadersAfterFetchedRecmdList;
- (NSString *)recommendListBottomButtonTitle:(NSInteger)type;

+ (CGRect)imagePictureInfoFrame:(NSString *)layout;
- (BOOL)isOpenHttp;
@end
