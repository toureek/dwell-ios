//
//  DWDisplayModel.h
//  Dwell
//
//  Created by toureek on 10/17/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface DWDisplayModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *itemKey;
@property (nonatomic, copy) NSString *eleid;
@end



@class DWHomeContentList;
@class DWHomeItemInfo;
@interface DWDisplayHomeAPI : DWDisplayModel
@property (nonatomic, copy) NSString *searchBarPlaceholder;
@property (nonatomic, copy) NSArray *moduleList;                // Home-api ends
@property (nonatomic, copy) NSArray *secondHand;
@property (nonatomic, copy) NSArray *rent;
@property (nonatomic, copy) NSArray *newhouse;
@property (nonatomic, copy) NSArray *oversea;                   // Recommend-api ends

@property (nonatomic, copy) NSArray *section_1_data;
@property (nonatomic, copy) NSArray *section_2_data;
@property (nonatomic, copy) NSArray *section_3_data;
@property (nonatomic, copy) NSArray *section_4_data;
@property (nonatomic, copy) NSArray *section_5_data;            // @[{actionUrl : imgUrl}, {actionUrl : imgUrl}];
@property (nonatomic, copy) NSArray *section_6_data;
@property (nonatomic, copy) NSArray *section_7_data;
@property (nonatomic, copy) NSArray *section_8_data;
- (NSArray *)sectionHeaderIndexTitlesForConfigs;
@end



@class DWHomeSectionsInfo;
@class DWHomeItemInfo;
@interface DWHomeContentList : DWDisplayModel
@property (nonatomic, copy) NSArray *list;                      // section-0
@property (nonatomic, strong) DWHomeSectionsInfo *helpFindHouse;// 
@property (nonatomic, strong) DWHomeSectionsInfo *myHouse;      // section-1
@property (nonatomic, copy) NSString *cutTime;                  // section-2
@property (nonatomic, copy) NSString *title;                    // section-3-4-5
@property (nonatomic, copy) NSArray *contentList;               // DWHomeSectionsInfo.class
@property (nonatomic, copy) NSArray *recommendList;
@property (nonatomic, copy) NSArray *waitingList;
@property (nonatomic, copy) NSString *moreText;
@property (nonatomic, copy) NSString *moreUrl;                  // section-6-7-8
@end


@class DWItemPosition;
@class DWRichContentItemData;
@interface DWHomeSectionsInfo : DWDisplayModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *actionUrl;
@property (nonatomic, copy) NSString *buttonText;               // section-1-A-only
@property (nonatomic, copy) NSString *contentTitle;             // section-1-A-only
@property (nonatomic, copy) NSString *contentDesc;              // section-1-A-only
@property (nonatomic, copy) NSString *buttonName;               // section-1-B-only
@property (nonatomic, copy) NSString *describe;                 // section-1-B-only
@property (nonatomic, copy) NSArray *list;                      // section-2-only
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *titleColor;               // section-2-color  hex颜色前面需要加#号
@property (nonatomic, copy) DWItemPosition *position;           // section-4-image-top/bottom-indices
@property (nonatomic, copy) NSString *type;  // section-6-7-8's contentList item类型(1 二手 2新房 3 租房 无 海外)

- (DWRichContentItemData *)transformListItemIntoRichContentItemInSectionTwo;
- (DWRichContentItemData *)transformListItemIntoRichContentItemInSectionThree;
- (DWRichContentItemData *)transformListItemIntoRichContentItemInSectionFour;
- (DWRichContentItemData *)transformListItemIntoRichContentItemInSection6_7_8;
- (BOOL)isOpenWebView;
@end



@interface DWItemPosition : DWDisplayModel
@property (nonatomic, copy) NSString *top;
@property (nonatomic, copy) NSString *bottom;

- (NSString *)buildUpPostionKey;
@end



@class DWColorTagsAndFeedback;
@interface DWHomeItemInfo : DWDisplayModel
@property (nonatomic, copy) NSString *houseCode;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSArray *colorTags;
@property (nonatomic, copy) NSString *priceStr;
@property (nonatomic, copy) NSString *priceUnit;
@property (nonatomic, copy) NSString *unitPriceStr;
@property (nonatomic, copy) NSString *coverPic;
@property (nonatomic, copy) NSArray *negFeedBack;               // Used ends
@property (nonatomic, copy) NSString *projectDesc;
@property (nonatomic, copy) NSString *houseType;
@property (nonatomic, copy) NSString *bizcircleName;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *showPrice;
@property (nonatomic, copy) NSString *showPriceUnit;
@property (nonatomic, copy) NSString *resblockFrameArea;        // New ends
@property (nonatomic, copy) NSString *houseTitle;
@property (nonatomic, copy) NSArray *houseTags;
@property (nonatomic, copy) NSString *rentPriceListing;
@property (nonatomic, copy) NSString *rentPriceUnit;            // Rent ends
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSArray *tags;  //[@"", @"", @""]
@property (nonatomic, copy) NSString *priceRMB;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *actionUrl;                // Oversea ends

- (NSString *)priceTextForUsed;
- (NSString *)subsubtitleTextForNew;
- (NSString *)priceTextForNew;
- (NSString *)priceTextForRent;
@end



@interface DWColorTagsAndFeedback : DWDisplayModel
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *bgColor;
@property (nonatomic, copy) NSString *boldFont;                 // used-new ends
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *colorBg;
@property (nonatomic, copy) NSString *colorTxt;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fbKey;
@property (nonatomic, copy) NSString *fbTitle;
@property (nonatomic, copy) NSString *fbIconUrl;

- (BOOL)isBoldFont;
@end


