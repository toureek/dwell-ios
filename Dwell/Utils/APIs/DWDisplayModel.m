//
//  DWDisplayModel.m
//  Dwell
//
//  Created by toureek on 10/17/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWDisplayModel.h"
#import "DWRichContentItemData.h"

@implementation DWDisplayModel
- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    return self ? : nil;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *modifiedDictionaryValue = [[super dictionaryValue] mutableCopy];
    for (NSString *originalKey in [super dictionaryValue]) {
        if ([self valueForKey:originalKey] == nil) {
            [modifiedDictionaryValue removeObjectForKey:originalKey];
        }
    }
    return [modifiedDictionaryValue copy];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"identifier" : @"id", @"itemKey" : @"itemKey", @"eleid" : @"eleid"};
}
@end



@implementation DWDisplayHomeAPI
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"searchBarPlaceholder": @"searchBarPlaceholder",  // Home-api
             @"moduleList"          : @"moduleList",
             @"secondHand"          : @"secondHand",            // Recommend-api
             @"rent"                : @"rent",
             @"newhouse"            : @"newhouse",
             @"oversea"             : @"oversea"};
}

+ (NSValueTransformer *)moduleListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:DWHomeContentList.class];
}

+ (NSValueTransformer *)secondHandJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:DWHomeItemInfo.class];
}

+ (NSValueTransformer *)rentJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:DWHomeItemInfo.class];
}

+ (NSValueTransformer *)newhouseJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:DWHomeItemInfo.class];
}

+ (NSValueTransformer *)overseaJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:DWHomeItemInfo.class];
}

// data for ViewModel
- (NSArray *)sectionHeaderIndexTitlesForConfigs {
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:_moduleList.count];
    for (NSInteger index = 0; index < _moduleList.count; index++) {
        DWHomeContentList *content = _moduleList[index];
        NSString *title = content.title ? : @"";
        [titleArray addObject:title];
        
        if (index == 1) {
            NSMutableArray *section_1_dataList = [NSMutableArray arrayWithCapacity:2];
            [section_1_dataList addObject:content.helpFindHouse];
            [section_1_dataList addObject:content.myHouse];
            _section_1_data = nil;
            _section_1_data = [section_1_dataList copy];
        } else if (index == 2) {
            NSMutableArray *menuList = [NSMutableArray arrayWithCapacity:content.list.count];
            NSMutableArray *itemList = [NSMutableArray arrayWithCapacity:content.list.count];
            for (DWHomeSectionsInfo *item in content.list) {
                [menuList addObject:item.title ? : @""];
                NSMutableArray *arrayList = [NSMutableArray arrayWithCapacity:item.list.count];
                for (DWHomeSectionsInfo *obj in item.list) {
                    DWRichContentItemData *data = [obj transformListItemIntoRichContentItemInSectionTwo];
                    [arrayList addObject:data];
                }
                [itemList addObject:[arrayList copy]];
            }
            _section_2_data = nil;
            _section_2_data = @[[menuList copy], [itemList copy]];
        } else if (index == 3) {
            NSMutableArray *arrayList = [NSMutableArray arrayWithCapacity:content.list.count];
            for (DWHomeSectionsInfo *obj in content.list) {
                DWRichContentItemData *data = [obj transformListItemIntoRichContentItemInSectionThree];
                [arrayList addObject:data];
            }
            _section_3_data = [arrayList copy];
        } else if (index == 4) {
            NSMutableArray *arrayList = [NSMutableArray arrayWithCapacity:content.list.count];
            for (DWHomeSectionsInfo *obj in content.list) {
                DWRichContentItemData *data = [obj transformListItemIntoRichContentItemInSectionFour];
                [arrayList addObject:@{[obj.position buildUpPostionKey] : data}];
            }
            _section_4_data = [arrayList copy];
        } else if (index == 5) {
            NSMutableArray *arrayList = [NSMutableArray arrayWithCapacity:content.list.count];
            for (DWHomeSectionsInfo *obj in content.list) {
                [arrayList addObject:@{obj.actionUrl ? : @"" : obj.imgUrl ? : @""}];
            }
            _section_5_data = [arrayList copy];
        } else if (index == 6) {
            NSMutableArray *arrayList = [NSMutableArray arrayWithCapacity:content.list.count];
            for (DWHomeSectionsInfo *obj in content.contentList) {
                DWRichContentItemData *data = [obj transformListItemIntoRichContentItemInSection6_7_8];
                [arrayList addObject:data];
            }
            _section_6_data = @[[arrayList copy],
                                [content.recommendList copy],
                                @{content.moreText ? : @"" : content.moreUrl ? : @""}];
        } else if (index == 7) {
            NSMutableArray *arrayList = [NSMutableArray arrayWithCapacity:content.list.count];
            for (DWHomeSectionsInfo *obj in content.contentList) {
                DWRichContentItemData *data = [obj transformListItemIntoRichContentItemInSection6_7_8];
                [arrayList addObject:data];
            }
            _section_7_data = @[[arrayList copy],
                                [content.recommendList copy],
                                @{content.moreText ? : @"" : content.moreUrl ? : @""}];
        } else if (index == 8) {
            NSMutableArray *arrayList = [NSMutableArray arrayWithCapacity:content.list.count];
            for (DWHomeSectionsInfo *obj in content.contentList) {
                DWRichContentItemData *data = [obj transformListItemIntoRichContentItemInSection6_7_8];
                [arrayList addObject:data];
            }
            _section_8_data = @[[arrayList copy],
                                [content.recommendList copy],
                                @{content.moreText ? : @"" : content.moreUrl ? : @""}];
        } else {
            // do nothing...
        }
    }
    return [titleArray copy];
}
@end



@implementation DWHomeContentList
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"list"           :          @"list"           ,
             @"helpFindHouse"  :          @"helpFindHouse"  ,
             @"myHouse"        :          @"myHouse"        ,
             @"cutTime"        :          @"cutTime"        ,
             @"title"          :          @"title"          ,
             @"contentList"    :          @"contentList"    ,
             @"recommendList"  :          @"recommendList"  ,
             @"waitingList"    :          @"waitingList"    ,
             @"moreText"       :          @"moreText"       ,
             @"moreUrl"        :          @"moreUrl"};
}

+ (NSValueTransformer *)helpFindHouseJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:DWHomeSectionsInfo.class];
}

+ (NSValueTransformer *)myHouseJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:DWHomeSectionsInfo.class];
}

+ (NSValueTransformer *)listJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:DWHomeSectionsInfo.class];
}

+ (NSValueTransformer *)contentListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:DWHomeSectionsInfo.class];
}

+ (NSValueTransformer *)recommendListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:DWHomeItemInfo.class];
}

+ (NSValueTransformer *)waitingListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:DWHomeItemInfo.class];
}
@end



@implementation DWHomeSectionsInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"title"             :      @"title"       ,
             @"imgUrl"            :      @"imgUrl"      ,
             @"actionUrl"         :      @"actionUrl"   ,
             @"buttonText"        :      @"buttonText"  ,
             @"contentTitle"      :      @"contentTitle",
             @"contentDesc"       :      @"contentDesc" ,
             @"buttonName"        :      @"buttonName"  ,
             @"describe"          :      @"describe"    ,
             @"list"              :      @"list"        ,
             @"subtitle"          :      @"subtitle"    ,
             @"titleColor"        :      @"titleColor"  ,
             @"position"          :      @"position"    ,
             @"type"              :      @"type"};
}

+ (NSValueTransformer *)listJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:DWHomeSectionsInfo.class];
}

+ (NSValueTransformer *)positionJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:DWItemPosition.class];
}

- (DWRichContentItemData *)transformListItemIntoRichContentItemInSectionTwo {    
    DWRichContentItemData *item = [[DWRichContentItemData alloc] initDWRichContentItemDataWithStyle:DWRichContentItemStyleColorfulTitleWithSubtitle
                                                                                           colorHEX:[NSString stringWithFormat:@"#%@", _titleColor ? : @"CCCCCC"]
                                                                                          colorText:_title ? : @""
                                                                                     titleLableText:_subtitle ? : @""
                                                                                  subtitleLabelText:_describe ? : @""
                                                                                  iconImageNameText:@""
                                                                                      actionUrlText:_actionUrl ? : @""];
    return item;
}

- (DWRichContentItemData *)transformListItemIntoRichContentItemInSectionThree {
    DWRichContentItemData *item = [[DWRichContentItemData alloc] initDWRichContentItemDataWithStyle:DWRichContentItemStyleTitleSubTitleWithRightBottomIcon
                                                                                           colorHEX:@""
                                                                                          colorText:@""
                                                                                     titleLableText:_title ? : @""
                                                                                  subtitleLabelText:_subtitle ? : @""
                                                                                  iconImageNameText:_imgUrl ? : @""
                                                                                      actionUrlText:_actionUrl ? : @""];
    return item;
}

- (DWRichContentItemData *)transformListItemIntoRichContentItemInSectionFour {
    DWRichContentItemData *item = [[DWRichContentItemData alloc] initDWRichContentItemDataWithStyle:DWRichContentItemStyleTitleSubTitleWithBackgroundImgInfo
                                                                                           colorHEX:@""
                                                                                          colorText:@""
                                                                                     titleLableText:_title ? : @""
                                                                                  subtitleLabelText:_subtitle ? : @""
                                                                                  iconImageNameText:_imgUrl ? : @""
                                                                                      actionUrlText:_actionUrl ? : @""];
    return item;
}

- (DWRichContentItemData *)transformListItemIntoRichContentItemInSection6_7_8 {
    DWRichContentItemData *item = [[DWRichContentItemData alloc] initDWRichContentItemDataWithStyle:DWRichContentItemStyleTitleSubTitleWithBackgroundImgAD
                                                                                           colorHEX:@""
                                                                                          colorText:@""
                                                                                     titleLableText:_title ? : @""
                                                                                  subtitleLabelText:_subtitle ? : @""
                                                                                  iconImageNameText:_imgUrl ? : @""
                                                                                      actionUrlText:_actionUrl ? : @""];
    return item;
}

- (BOOL)isOpenWebView {
    return [_actionUrl hasPrefix:@"http"];
}
@end



@implementation DWItemPosition
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"top" : @"top", @"bottom" : @"bottom"};
}

- (NSString *)buildUpPostionKey {
    return [NSString stringWithFormat:@"%@-%@", _top ? : @"", _bottom ? : @""];
}
@end



@implementation DWHomeItemInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"houseCode"               :     @"houseCode"          ,
             @"title"                   :     @"title"              ,
             @"desc"                    :     @"desc"               ,
             @"colorTags"               :     @"colorTags"          ,
             @"priceStr"                :     @"priceStr"           ,
             @"priceUnit"               :     @"priceUnit"          ,
             @"unitPriceStr"            :     @"unitPriceStr"       ,
             @"coverPic"                :     @"coverPic"           ,
             @"negFeedBack"             :     @"negFeedBack"        ,
             @"projectDesc"             :     @"projectDesc"        ,
             @"houseType"               :     @"houseType"          ,
             @"bizcircleName"           :     @"bizcircleName"      ,
             @"district"                :     @"district"           ,
             @"showPrice"               :     @"showPrice"          ,
             @"showPriceUnit"           :     @"showPriceUnit"      ,
             @"resblockFrameArea"       :     @"resblockFrameArea"  ,
             @"houseTitle"              :     @"houseTitle"         ,
             @"houseTags"               :     @"houseTags"          ,
             @"rentPriceListing"        :     @"rentPriceListing"   ,
             @"rentPriceUnit"           :     @"rentPriceUnit"      ,
             @"imgUrl"                  :     @"imgUrl"             ,
             @"tags"                    :     @"tags"               ,
             @"priceRMB"                :     @"priceRMB"           ,
             @"price"                   :     @"price"              ,
             @"actionUrl"               :     @"actionUrl"};
}

+ (NSValueTransformer *)colorTagsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:DWColorTagsAndFeedback.class];
}

+ (NSValueTransformer *)negFeedBackJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:DWColorTagsAndFeedback.class];
}

+ (NSValueTransformer *)houseTagsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:DWColorTagsAndFeedback.class];
}

+ (NSValueTransformer *)tagsJSONTransformer {  // [@"", @"", @"", ...]  NSString-Type-object
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSMutableArray * array = [NSMutableArray array];
        for (NSString *tag in value) {
            [array addObject:tag];
        }
        return array;
    }];
}

- (NSString *)priceTextForUsed {
    return [NSString stringWithFormat:@"%@%@", _priceStr ? : @"", _priceUnit ? : @""];
}

- (NSString *)subsubtitleTextForNew {
    return [NSString stringWithFormat:@"%@%@%@", _houseType ? : @"", _bizcircleName ? : @"", _district ? : @""];
}

- (NSString *)priceTextForNew {
    return [NSString stringWithFormat:@"%@%@", _showPrice ? : @"", _showPriceUnit ? : @""];
}

- (NSString *)priceTextForRent {
    return [NSString stringWithFormat:@"%@%@", _rentPriceListing ? : @"", _rentPriceUnit ? : @""];
}

@end



@implementation DWColorTagsAndFeedback
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"desc"     : @"desc",
             @"color"    : @"color",
             @"bgColor"  : @"bgColor",
             @"boldFont" : @"boldFont",
             @"key"      : @"key",
             @"colorBg"  : @"colorBg",
             @"colorTxt" : @"colorTxt",
             @"name"     : @"name",
             @"fbKey"    : @"fbKey",
             @"fbTitle"  : @"fbTitle",
             @"fbIconUrl": @"fbIconUrl"};
}

- (BOOL)isBoldFont {
    return [_boldFont isEqualToString:@"1"];
}
@end

