//
//  DWHomeViewController.m
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWHomeViewController.h"
#import "DWMenuItemTableViewCell.h"
#import "DWShortcutEntryViewCell.h"
#import "DWSquareBannerViewCell.h"
#import "DWWebKitViewController.h"
#import "DWRichContentItemData.h"
#import "DWHomeReusedHeaderView.h"
#import "DWHotTopicViewCell.h"
#import "DWImageNewsTableViewCell.h"
#import "DWImagePromotionViewCell.h"
#import "DWHouseBigTableViewCell.h"
#import "DWHouseItemContentCell.h"
#import "DWAPIInvoker.h"
#import "DWResponseInfo.h"
#import "DWDisplayModel.h"
#import "DWUsedInteractiveView.h"
#import "DWHomeNaviTitleBarView.h"
#import "DWSearchViewController.h"
#import <MJRefresh.h>

@interface DWHomeViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate,
DWMenuItemTableViewCellDelegate, DWShortcutEntryViewCellDelegate, DWSquareBannerViewCellDelegate, DWHotTopicViewCellDelegate,
DWImageNewsCellDelegate, DWImagePromotionCellDelegate, DWHouseBigTableViewDelegate, DWHouseItemContentCellDelegate,
DWHomeReusedHeaderViewDelegate, DWUsedInteractiveViewDelegate, DWHomeNaviTitleBarDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DWRichContentItemData *datasource;
@property (nonatomic, strong) DWHomeRecommendsResponse *infoList;
  // (_currentSelectedMenuIndex = _currentSelectedMenuType - 1)
@property (nonatomic, assign) DWHouseItemContentType currentSelectedMenuType;
@property (nonatomic, strong) UIButton *naviBarRightButton;
@end

@implementation DWHomeViewController {
    NSInteger _currentIndicatorIndex;
    NSInteger _currentCycledMenuIndex;
    BOOL _isTimerTriggered;
    DWHomeConfigResponse *_infoHome;
    DWUsedInteractiveView *_feedbackView;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = NO;
        [self addNotificationHandlers];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageCode = @"Home_Page";
    _isTimerTriggered = NO;
    _datasource = [[DWRichContentItemData alloc] init];
    _currentIndicatorIndex = _currentCycledMenuIndex = 0;
    _currentSelectedMenuType = DWHouseItemContentTypeUsed;
    [self initNavigationBarStyle];
    [self invokeNetworkingForDataSource];
    [self initTableViewAndSetupLayout];
}

- (void)initNavigationBarStyle {
    [self setUpNavigationBarContentView];
    [self setUpCityLocationConfig];
}

- (void)setUpNavigationBarContentView {
    self.navigationController.navigationBar.clipsToBounds = YES;
    CGRect frame = CGRectMake(kLeftRightBoldPadding, 0, SCREEN_WIDTH-kLeftRightBoldPadding-80, 44);
    DWHomeNaviTitleBarView *searchBarView = [[DWHomeNaviTitleBarView alloc] initWithFrame:frame
                                                                                     type:DWNaviTitleBarTypeDisplayOnly];
    searchBarView.delegate = self;
    CGRect naviBarFrame = self.navigationController.navigationBar.frame;
    NSLog(@"%lf, %lf", naviBarFrame.origin.x, naviBarFrame.origin.y);
    NSLog(@"%lf, %lf", naviBarFrame.size.width, naviBarFrame.size.height);
    self.navigationItem.titleView = searchBarView;
}

- (void)setUpCityLocationConfig {
    _naviBarRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _naviBarRightButton.frame = CGRectMake(0, 0, 60, 18);
    _naviBarRightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_naviBarRightButton setTitle:@"全国" forState:UIControlStateNormal];
    [_naviBarRightButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    [_naviBarRightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_naviBarRightButton addTarget:self action:@selector(didNaviBarRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_naviBarRightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)initTableViewAndSetupLayout {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(didTableViewTapped:)];
    tap.delegate = self;
    [tap setCancelsTouchesInView:NO];
    [_tableView addGestureRecognizer:tap];
    _tableView.cellLayoutMarginsFollowReadableWidth = NO;
    [_tableView registerClass:[DWMenuItemTableViewCell class] forCellReuseIdentifier:kDWMenuItemTableViewCellTag];
    [_tableView registerClass:[DWShortcutEntryViewCell class] forCellReuseIdentifier:kDWShortcutEntryViewCellTag];
    [_tableView registerClass:[DWSquareBannerViewCell class] forCellReuseIdentifier:kDWSquareBannerViewCellTag];
    [_tableView registerClass:[DWHomeReusedHeaderView class] forHeaderFooterViewReuseIdentifier:kDWHomeReusedHeaderViewTag];
    [_tableView registerClass:[DWHomeReusedHeaderView class] forHeaderFooterViewReuseIdentifier:kDWHomeReusedHeaderViewMenuTag];
    [_tableView registerClass:[DWHotTopicViewCell class] forCellReuseIdentifier:kDWHotTopicViewCellTag];
    [_tableView registerClass:[DWImageNewsTableViewCell class] forCellReuseIdentifier:kDWImageNewsTableViewCellTag];
    [_tableView registerClass:[DWImagePromotionViewCell class] forCellReuseIdentifier:kDWImagePromotionViewCellTag];
    [_tableView registerClass:[DWHouseBigTableViewCell class] forCellReuseIdentifier:kDWHouseBigTableViewCellTag];
    [_tableView registerClass:[DWHouseItemContentCell class] forCellReuseIdentifier:kDWHouseItemOutterCellTag];
    [self addPullToRefreshView];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedRowHeight = _tableView.estimatedSectionHeaderHeight = _tableView.estimatedSectionFooterHeight = 0;
    }
    [self.view addSubview:_tableView];

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Pull-To-Refresh
- (void)addPullToRefreshView {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(loadNewData:)];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    _tableView.mj_header = header;
}

- (void)loadNewData:(id)sender {
    [_tableView.mj_header beginRefreshing];
    [self invokeNetworkingForDataSource];
}

- (void)invokeNetworkingForDataSource {
    DWHomeAPIInvoker *apiInvoker = [[DWHomeAPIInvoker alloc] init];
    [apiInvoker fetchHomeConfigs];
    [apiInvoker fetchHomeRecommends];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;   // remove seperate-line of tableview
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self dismissInteractiveView];
    _tableView.userInteractionEnabled = YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self dismissInteractiveView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _datasource.sectionTotalCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 9 ? _datasource.sectionArray_9.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DWMenuItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDWMenuItemTableViewCellTag
                                                                        forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.menuList = _datasource.sectionArray_0;
        cell.delegate = self;
        [cell refresh];
        return cell;
    } else if (indexPath.section == 1) {
        DWShortcutEntryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDWShortcutEntryViewCellTag
                                                                        forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.currentIndicatorIndex = _currentIndicatorIndex;
        cell.itemArray = _datasource.sectionArray_1;
        cell.delegate = self;
        [cell refresh];
        return cell;
    } else if (indexPath.section == 2) {
        DWSquareBannerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDWSquareBannerViewCellTag
                                                                       forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.currentMenuIndex = _currentCycledMenuIndex;
        cell.dataArray = _datasource.sectionArray_2;
        cell.triggerTimer = _isTimerTriggered;
        cell.delegate = self;
        [cell refresh];
        return cell;
    } else if (indexPath.section == 3) {
        DWHotTopicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDWHotTopicViewCellTag
                                                                   forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.array = _datasource.sectionArray_3;
        cell.delegate = self;
        [cell refresh];
        return cell;
    } else if (indexPath.section == 4) {
        DWImageNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDWImageNewsTableViewCellTag
                                                                   forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataArray = _datasource.sectionArray_4;
        cell.delegate = self;
        [cell refresh];
        return cell;
    } else if (indexPath.section == 5) {
        DWImagePromotionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDWImagePromotionViewCellTag
                                                                         forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell refresh:_datasource.sectionArray_5];
        return cell;
    } else if (indexPath.section < 9) {
        DWHouseBigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDWHouseBigTableViewCellTag
                                                                        forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataArray = [_datasource buildUpDataSourceForSection:indexPath.section];
        cell.type = [self reuseDWHouseBigTableViewCellType:indexPath.section];
        cell.sectionIndex = indexPath.section;
        cell.delegate = self;
        [cell refresh];
        return cell;
    } else {  // Recommand-Cells (Used-New-Rent-Overseas)
        DWHouseItemContentCell *cell = [tableView dequeueReusableCellWithIdentifier:kDWHouseItemOutterCellTag
                                                                       forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.item = _datasource.sectionArray_9[indexPath.row];
        cell.type = _currentSelectedMenuType;
        cell.reusedFromController = YES;
        cell.index = indexPath.row;
        cell.delegate = self;
        [cell refresh];
        return cell;
    }
}

- (DWHouseItemContentType)reuseDWHouseBigTableViewCellType:(NSInteger)sectionIndex {
    if (sectionIndex == 6) {
        return DWHouseItemContentTypeUsed;
    } else if (sectionIndex == 7) {
        return DWHouseItemContentTypeNew;
    } else if (sectionIndex == 8) {
        return DWHouseItemContentTypeRent;
    } else {
        return DWHouseItemContentTypeDefault;
    }
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section > 2 && section < 9) {
        DWHomeReusedHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kDWHomeReusedHeaderViewTag];
        header.groupHeaderLabel.text = _datasource.secitonHeaderTitles[section];
        header.asFooterView = header.existFilterButton = NO;
        [header refresh];
        return header;
    } else if (section == 9) {
        DWHomeReusedHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kDWHomeReusedHeaderViewMenuTag];
        header.groupHeaderLabel.text = _datasource.secitonHeaderTitles[section];
        header.filterMenuArray = @[@"二手房", @"新房", @"租房", @"海外"];
        header.currentIndex = _currentSelectedMenuType - 1;
        header.existFilterButton = YES;
        header.asFooterView = NO;
        header.delegate = self;
        [header refresh];
        return header;
    } else {
        return [UIView new];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 9) {
        DWHomeReusedHeaderView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kDWHomeReusedHeaderViewTag];
        footer.buttonTitleText = [_datasource recommendListBottomButtonTitle:_currentSelectedMenuType];
        footer.asFooterView = YES;
        footer.delegate = self;
        [footer refresh];
        return footer;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > 2 && section < 9) {
        return kDWHomeReusedHeaderNormalHeight;
    } else if (section == 9) {
        return kDWHomeReusedHeaderNormalHeight;
    } else {
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 9 ? kDWHomeReusedFooterButtomViewHeight : CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [DWMenuItemTableViewCell height:_datasource.sectionArray_0.count];
    } else if (indexPath.section == 1) {
        return [DWShortcutEntryViewCell height];
    } else if (indexPath.section == 2) {
        return [DWSquareBannerViewCell height];
    } else if (indexPath.section == 3) {
        return kDWHotTopicViewCellHeight;
    } else if (indexPath.section == 4) {
        return [DWImageNewsTableViewCell height];
    } else if (indexPath.section == 5) {
        return kDWImagePromotionCellHeight;
    } else if (indexPath.section < 9) {
        NSArray *array = [_datasource buildUpDataSourceForSection:indexPath.section];
        NSArray *itemList = [array objectAtIndex:1];
        DWHouseItemContentType type = [self reuseDWHouseBigTableViewCellType:indexPath.section];
        return [DWHouseBigTableViewCell height:itemList type:type];
    } else {
        return [DWHouseItemContentCell heightInType:_currentSelectedMenuType];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SEL
- (void)didTableViewTapped:(UITapGestureRecognizer *)gesture {
    UIView *view = [gesture view];
    if ([view isKindOfClass:[UITableView class]]) {
        [self dismissInteractiveView];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"]) {
        return NO; // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    }
    return  YES;
}

#pragma mark - DWMenuItemTableViewCellDelegate
- (void)triggerToResponseAfterItemClickedAtIndex:(NSUInteger)index {
    _tableView.userInteractionEnabled = YES;
    NSLog(@"%lu", (unsigned long)index);
    DWHomeSectionsInfo *item = _datasource.sectionArray_0[index];
    if ([item isOpenWebView]) {  // 海外-商业办公-房贷计算-搬家保洁
        [self switchToWebView:item.actionUrl
                  newPageCode:item.title
                 newPageTitle:item.title
              transitionStyle:ControllerTransitionStylePush];
    } else {
        [self.view makeToast:@"暂时不支持点击 请见谅..."];
    }
}

#pragma mark - DWShortcutEntryViewCellDelegate
- (void)triggerToResponseAfterTopButtonClickedAtIndex:(NSInteger)index {
    if (index == -1)    return;
    
    _currentIndicatorIndex = index;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)triggerToResponseAfterContentTappedAtIndex:(NSInteger)index {
    NSString *content = index == 0 ? @"帮我选房" : @"我的房子";
    NSLog(@"%@", content);
    [self switchToWebView:@"http://www.265.com"
              newPageCode:@"www.265.com"
             newPageTitle:content
          transitionStyle:ControllerTransitionStylePush];
}

#pragma mark - DWSquareBannerViewCellDelegate
- (void)triggerToResponseAfterClickedMenuAt:(NSInteger)menuIndex isTapped:(BOOL)isTapped {
    _isTimerTriggered = isTapped;
    _currentCycledMenuIndex = menuIndex;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)triggerToResponseAfterClickedAt:(NSInteger)menuIndex itemIndex:(NSInteger)itemIndex {
    NSLog(@"%ld  +++++++  %ld", menuIndex, itemIndex);
    NSArray *contentList = [[_datasource.sectionArray_2 lastObject] objectAtIndex:menuIndex];
    DWRichContentItemData *object = contentList[itemIndex];
    if (![object isOpenHttp]) {
        [self.view makeToast:@"该页面数据出现异常 请稍后再试"];
        return;
    }
    [self goToNextPage:object];
}

- (void)goToNextPage:(DWRichContentItemData *)object {
    [self switchToWebView:object.actionUrl
              newPageCode:object.actionUrl
             newPageTitle:object.titleLabelText
          transitionStyle:ControllerTransitionStylePush];
}

#pragma mark - DWHotTopicViewCellDelegate
- (void)triggerToResponseAfterItemClickedAt:(NSInteger)index {
    NSLog(@"%ld", index);
    DWRichContentItemData *object = _datasource.sectionArray_3[index];
    if (![object isOpenHttp]) {
        [self.view makeToast:@"该页面数据出现异常 请稍后再试"];
        return;
    }
    [self goToNextPage:object];
}

#pragma mark - DWImageNewsCellDelegate
- (void)triggerToResponseAfterImageNewsTappedAt:(NSInteger)index {
    NSLog(@"%ld", index);
    DWHomeContentList *content = [_infoHome.configModel.moduleList objectAtIndex:4];
    DWHomeSectionsInfo *item = [content.list objectAtIndex:index];
    if (![item isOpenWebView]) {
        [self.view makeToast:@"该页面数据出现异常 请稍后再试"];
        return;
    }
    [self switchToNextPage:item];
}

- (void)switchToNextPage:(DWHomeSectionsInfo *)item {
    [self switchToWebView:item.actionUrl
              newPageCode:item.title
             newPageTitle:item.title
          transitionStyle:ControllerTransitionStylePush];
}

#pragma mark - DWImagePromotionCellDelegate
- (void)triggerToResponseAfterPromoteADTappedAt:(NSInteger)index {
    NSLog(@"%ld", index);
    DWHomeContentList *content = [_infoHome.configModel.moduleList objectAtIndex:5];
    DWHomeSectionsInfo *item = [content.list objectAtIndex:index];
    if (![item isOpenWebView]) {
        [self.view makeToast:@"该页面数据出现异常 请稍后再试"];
        return;
    }
    [self switchToNextPage:item];
}

#pragma mark - DWHouseBigTableViewDelegate
- (void)triggerToResponseAfterHeaderClickedAt:(NSInteger)index atSectionIndex:(NSInteger)sectionIndex {
    NSLog(@"%ld-%ld", sectionIndex, index);
    NSArray *array = [[_datasource buildUpDataSourceForSection:sectionIndex] firstObject];
    DWRichContentItemData *data = array[index];
    if (![data isOpenHttp]) {
        [self.view makeToast:@"该页面数据出现异常 请稍后再试"];
        return;
    }
    [self goToNextPage:data];
}

- (void)triggerToResponseAfterFooterButtonClickedAt:(NSInteger)sectionIndex {
    [self dismissInteractiveView];
    NSLog(@"Big-TableViewCell-Footer-Button-Clicked-At-SectionIndex: %ld", sectionIndex);
}

#pragma mark - DWHouseItemContentCellDelegate (section-9)
- (void)triggerToControllerResponseAfterInteractiveButtonClickedAt:(NSInteger)index {
    NSLog(@"%ld", index);
    [self dismissInteractiveView];
    DWHouseItemContentCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:9]];
    CGRect pathRect = [cell convertRect:_tableView.bounds toView:self.view];
    NSLog(@"%lf-%lf-%lf-%lf", pathRect.origin.x, pathRect.origin.y, pathRect.size.width, pathRect.size.height);
    CGFloat cellHeight = [DWHouseItemContentCell heightInType:_currentSelectedMenuType];
    CGRect interactiveFrame = CGRectMake(pathRect.origin.x, pathRect.origin.y, SCREEN_WIDTH, cellHeight);
    [self popUpInteractiveView:interactiveFrame atIndex:index];
}

- (void)popUpInteractiveView:(CGRect)frame atIndex:(NSInteger)index {
    _feedbackView = [[DWUsedInteractiveView alloc] initWithFrame:frame];
    DWHomeItemInfo *item = _datasource.sectionArray_9[index];
    _feedbackView.actionArray = item.negFeedBack;
    _feedbackView.cellIndex = index;
    _feedbackView.delegate = self;
    [_feedbackView showInteractiveView];
    [_tableView addSubview:_feedbackView];
    [_tableView bringSubviewToFront:_feedbackView];
}

#pragma mark - DWHomeReusedHeaderViewDelegate PS: 用GCD避免点击太快的时候 数据源构造可能没有点击操作快 会出现nil的情况
- (void)triggerToResponseAfterMenuFilterClickedAt:(NSInteger)index {
    [self dismissInteractiveView];
    _currentSelectedMenuType = index+1;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {  // Background Thread
        [weakSelf.datasource buildUpDataSourceForHomeRecommendList:weakSelf.infoList
                                                              type:weakSelf.currentSelectedMenuType];
        dispatch_async(dispatch_get_main_queue(), ^(void) {  // Run UI Updates
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:9]
                              withRowAnimation:UITableViewRowAnimationNone];
        });
    });
}

#pragma mark - DWUsedInteractiveViewDelegate
- (void)triggerToRepsonseAfterButtonClickedAtButtonIndex:(NSInteger)index atCellIndex:(NSInteger)cellIndex {
    DWHomeItemInfo *object = _datasource.sectionArray_9[cellIndex];
    DWColorTagsAndFeedback *item = object.negFeedBack[index];
    NSLog(@"提交反馈结果: %@", item.fbTitle);
    [self dismissInteractiveView];
}

- (void)dismissInteractiveView {
    if (_feedbackView) {
        [_feedbackView dismissInteractiveView];
        [_feedbackView removeFromSuperview];
    }
}

#pragma mark - DWHomeNaviTitleBarDelegate
- (void)triggerToResponseAfterSearchButtonClicked {
    DWSearchViewController *vc = [[DWSearchViewController alloc] init];
    vc.recommendModel = _infoList.recommendModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - NavigationBar SELs
- (void)didNaviBarRightButtonClicked:(UIButton *)button {
    
}

#pragma mark - NotificationHandlers
- (void)addNotificationHandlers {
    NSArray *notifications = @[DWNFetchHomeConfig, DWNFetchHomeRecommends];
    for (NSString *notificationName in notifications) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveHomeAPINotification:)
                                                     name:notificationName
                                                   object:nil];
    }
}

- (void)didReceiveHomeAPINotification:(NSNotification *)notification {  // 构造完datasource后 再刷新UI
    if (!notification) {
        [_tableView.mj_header endRefreshing];
        [self.view makeToast:@"app内部网络请求异常"];
        return;
    }
    
    if ([notification.name isEqualToString:DWNFetchHomeConfig]) {
        _infoHome = [notification.userInfo objectForKey:DWKFetchHomeConfig];
        [_tableView.mj_header endRefreshing];
        if ([_infoHome.responseStatus isHttpOK]) {
            [_datasource buildUpDataSourceForHomeConfigs:_infoHome];
            [_tableView reloadData];
        } else {
            NSLog(@"%@", _infoHome.responseStatus.error);  // Toast
            [self.view makeToast:_infoHome.responseStatus.error];
        }
    } else if ([notification.name isEqualToString:DWNFetchHomeRecommends]) {
        _infoList = [notification.userInfo objectForKey:DWKFetchHomeRecommends];
        if ([_infoList.responseStatus isHttpOK]) {
            [_datasource buildUpSectionHeadersAfterFetchedRecmdList];
            [_datasource buildUpDataSourceForHomeRecommendList:_infoList type:_currentSelectedMenuType];
            [_tableView reloadData];
        } else {
            NSLog(@"%@", _infoList.responseStatus.error);  // Toast
            [self.view makeToast:_infoHome.responseStatus.error];
        }
    } else {
        [_tableView.mj_header endRefreshing];
    }
}

- (void)dealloc {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
