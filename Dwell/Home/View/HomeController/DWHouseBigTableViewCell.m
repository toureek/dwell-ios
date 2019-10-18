//
//  DWHouseBigTableViewCell.m
//  Dwell
//
//  Created by toureek on 10/16/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWHouseBigTableViewCell.h"
#import "DWHouseContentHeaderView.h"
#import "DWHomeReusedHeaderView.h"
#import "DWDisplayModel.h"

NSString *const kDWHouseBigTableViewCellTag = @"kDWHouseBigTableViewCellTag";

@interface DWHouseBigTableViewCell () <DWHouseContentHeaderDelegate, DWHouseItemContentCellDelegate,
DWHomeReusedHeaderViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation DWHouseBigTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addTableViewWithAutoLayout];
    }
    return self;
}

+ (CGFloat)height:(NSArray *)dataArray type:(DWHouseItemContentType)type {
    CGFloat padding = (type == DWHouseItemContentTypeNew) ? 50 : 30;
    CGFloat headerHeight = kDWHouseContentHeaderViewHeight+kLeftRightFitPadding*2;
    CGFloat cellHeight = (((SCREEN_WIDTH-(kLeftRightBoldPadding+kLeftRightThinPadding)*2)/3.0f-kLeftRightFitPadding)/1.288+padding);
    CGFloat footerHeight = kDWHomeReusedFooterButtomViewHeight;
    return headerHeight + dataArray.count*(cellHeight) + footerHeight;
}

- (void)addTableViewWithAutoLayout {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.cellLayoutMarginsFollowReadableWidth = _tableView.scrollEnabled = NO;
    [_tableView registerClass:[DWHouseItemContentCell class] forCellReuseIdentifier:kDWHouseItemContentCellTag];
    [_tableView registerClass:[DWHouseContentHeaderView class]
forHeaderFooterViewReuseIdentifier:kDWHouseContentHeaderViewTag];
    [_tableView registerClass:[DWHomeReusedHeaderView class]
forHeaderFooterViewReuseIdentifier:kDWHomeReusedHeaderViewTag];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedRowHeight = _tableView.estimatedSectionHeaderHeight = _tableView.estimatedSectionFooterHeight = 0;
    }
    [self.contentView addSubview:_tableView];
    
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;   // remove seperate-line of tableview
}

- (void)refresh {
    if (_dataArray) {
        [_tableView reloadData];
    } else {
        // do nothing...
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)_dataArray[1]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DWHouseItemContentCell *cell = [tableView dequeueReusableCellWithIdentifier:kDWHouseItemContentCellTag
                                                                   forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.item = ((NSArray *)_dataArray[1])[indexPath.row];
    cell.reusedFromController = NO;
    cell.index = indexPath.row;
    cell.delegate = self;
    cell.type = _type;
    [cell refresh];
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DWHouseContentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kDWHouseContentHeaderViewTag];
    header.delegate = self;
    header.sectionIndex = _sectionIndex;
    [header refresh:_dataArray.firstObject];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    DWHomeReusedHeaderView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kDWHomeReusedHeaderViewTag];
    footer.buttonTitleText = ((NSDictionary *)(_dataArray.lastObject)).allKeys.firstObject;
    footer.sectionIndex = _sectionIndex;
    footer.existFilterButton = NO;
    footer.asFooterView = YES;
    footer.delegate = self;
    [footer refresh];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kDWHouseContentHeaderViewHeight + kLeftRightFitPadding*2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kDWHomeReusedFooterButtomViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [DWHouseItemContentCell heightInType:_type];
}

#pragma mark - DWHomeReusedHeaderViewDelegate
- (void)triggerToResponseAfterFooterButtonClickedAt:(NSInteger)sectionIndex {
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterFooterButtonClickedAt:)]) {
        [_delegate triggerToResponseAfterFooterButtonClickedAt:sectionIndex];
    }
}

#pragma mark - DWHouseItemContentCellDelegate
- (void)triggerToResponseAfterInteractiveButtonClickedAt:(NSInteger)index {
    // BigTableViewCell 不实现feedback-action
}

#pragma mark - DWHouseContentHeaderDelegate
- (void)triggerToResponseAfterHeaderViewItemClickedAt:(NSInteger)index atSectionIndex:(NSInteger)sectinIndex {
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterHeaderClickedAt:atSectionIndex:)]) {
        [_delegate triggerToResponseAfterHeaderClickedAt:index atSectionIndex:sectinIndex];
    }
}
@end
