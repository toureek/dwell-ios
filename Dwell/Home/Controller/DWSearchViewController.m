//
//  DWSearchViewController.m
//  Dwell
//
//  Created by toureek on 10/18/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWSearchViewController.h"
#import "DWHomeNaviTitleBarView.h"
#import "DWItemPickerView.h"
#import "DWSearchViewCell.h"
#import "FixedComponentDataSource.h"
#import "DWSearchResultEmptyCell.h"
#import "UIButton+Utils.h"
#import "DWDisplayModel.h"

NSString *const kDWSearchCellTypeUsed = @"kDWSearchCellTypeUsed";
NSString *const kDWSearchCellTypeNew = @"kDWSearchCellTypeNew";
NSString *const kDWSearchCellTypeRent = @"kDWSearchCellTypeRent";
static NSString *const kDWSearchHistoryViewCellNewTag = @"kDWSearchHistoryViewCellNewTag";
static NSString *const kDWSearchHistoryViewCellRentTag = @"kDWSearchHistoryViewCellRentTag";

@interface DWSearchViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,
DWHomeNaviTitleBarDelegate, DWItemPickerViewDelegate, DWSearchViewCellDelegate>
@property (nonatomic, strong) DWHomeNaviTitleBarView *searchBarView;
@property (nonatomic, strong) DWItemPickerView *pickerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;               // as footer in new-type
@property (nonatomic, strong) UIButton *clearButtonForNew;      // subview in footerView
@property (nonatomic, strong) UIView *headerView;               // as header in rent-type
@property (nonatomic, strong) UILabel *titleLabel;              // subview in headerView
@property (nonatomic, strong) UIButton *cleanButtonForRent;     // subview in headerView

@property (nonatomic, strong) NSMutableArray *fakeDataSourceA;
@property (nonatomic, strong) NSMutableArray *historySearchInputList;
@property (nonatomic, strong) NSMutableArray *searchResultList;
@property (nonatomic, assign) DWSearchCellType currentSelectedSearchType;
@property (nonatomic, assign) BOOL isDisplaySearchResult;
@end

@implementation DWSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentSelectedSearchType = DWSearchCellTypeUsed;
    [self buildFakeDataSource];
    [self setUpNaviationBarStyle];
    [self activeSearchBarTextFieldForFirstTime];
    [self initTableViewAndLayout];
    [_tableView reloadData];
}

- (void)buildFakeDataSource {
    _isDisplaySearchResult = NO;
    _fakeDataSourceA = [[FixedComponentDataSource buildFakeHotSearchTags] mutableCopy];
    _historySearchInputList = [NSMutableArray arrayWithCapacity:4];
    _historySearchInputList = [[[NSUserDefaults standardUserDefaults] objectForKey:kDWSearchCellTypeUsed] mutableCopy];
}

- (void)initTableViewAndLayout {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(didViewTapped)];
    [tap setCancelsTouchesInView:NO];
    [_tableView addGestureRecognizer:tap];
    _tableView.cellLayoutMarginsFollowReadableWidth = NO;
    [_tableView registerClass:DWSearchViewCell.class forCellReuseIdentifier:kDWSearchViewCellTag];
    [_tableView registerClass:DWSearchResultEmptyCell.class forCellReuseIdentifier:kDWSearchResultEmptyCellTag];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.estimatedRowHeight = _tableView.estimatedSectionHeaderHeight = _tableView.estimatedSectionFooterHeight = 0;
    }
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setUpNaviationBarStyle {
    [self.navigationController.navigationItem setHidesBackButton:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
    [self setUpPopBackOnRightBarButtonItem];
    [self setUpNavigationBarContentView];
}

- (void)activeSearchBarTextFieldForFirstTime {
    double delayInSeconds = 0.5;
    __weak typeof(self) weakSelf = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.searchBarView activeTextField];
    });
}

- (void)setUpPopBackOnRightBarButtonItem {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 32, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor dw_TitleTextColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didNaviBarRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setUpNavigationBarContentView {
    self.navigationController.navigationBar.clipsToBounds = YES;
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH-kLeftRightBoldPadding-60, 44);
    _searchBarView = [[DWHomeNaviTitleBarView alloc] initWithFrame:frame type:DWNaviTitleBarTypeSelectWithInput];
    _searchBarView.delegate = self;
    self.navigationItem.titleView = _searchBarView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_searchBarView.textfield resignFirstResponder];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];    
    [self saveHistory];
}

- (void)popUpPickerView {
    if (!_pickerView) {
        _pickerView = [[DWItemPickerView alloc] initWithFrame:CGRectMake(20, 64, 100, 130)];
        _pickerView.itemArray = @[@"二手房", @"新房", @"租房"];
        _pickerView.selectedIndex = 0;
        _pickerView.delegate = self;
        [_pickerView refresh];
        [self.view addSubview:_pickerView];
        _pickerView.hidden = YES;
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.15 animations:^{
        weakSelf.pickerView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            weakSelf.pickerView.alpha = 1;
            weakSelf.pickerView.hidden = NO;
            weakSelf.pickerView.frame = CGRectMake(20, 0, 100, 130);
            [weakSelf.view bringSubviewToFront:weakSelf.pickerView];
        }
    }];
}

- (void)dismissPickerView {
    _pickerView.hidden = YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isDisplaySearchResult) {
        return 1;
    }
    return (_currentSelectedSearchType != DWSearchCellTypeNew) ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isDisplaySearchResult) {
        return _searchResultList.count > 0 ? _searchResultList.count : 1;
    }

    if (_currentSelectedSearchType == DWSearchCellTypeUsed) {
        return _historySearchInputList.count > 0 ? 2 : 1;
    } else if (_currentSelectedSearchType == DWSearchCellTypeNew) {
        return section == 0 ? 1 : ((_historySearchInputList.count > 0) ? _historySearchInputList.count+1 : 0);
    } else {
        return _historySearchInputList.count == 0 ? 1 : _historySearchInputList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isDisplaySearchResult) {
        return nil;
    } else {
        if ((_currentSelectedSearchType != DWSearchCellTypeRent) && indexPath.section == 0) {
            DWSearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDWSearchViewCellTag forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.tagButtonArray = indexPath.row == 0 ? _fakeDataSourceA : _historySearchInputList;
            cell.controlButtonTitle = indexPath.row == 0 ? @"刷新" : @"清空";
            cell.searchTitle = indexPath.row == 0 ? @"热门搜索" : @"历史搜索";
            cell.type = _currentSelectedSearchType;
            cell.cellIndex = indexPath.row;
            cell.delegate = self;
            [cell refresh];
            return cell;
        } else if ((_currentSelectedSearchType == DWSearchCellTypeNew) && indexPath.section == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDWSearchHistoryViewCellNewTag];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                              reuseIdentifier:kDWSearchHistoryViewCellNewTag];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setBackgroundImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(didDeleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = indexPath.row;
                button.frame = CGRectMake(0, 0, 17, 17);
                cell.accessoryView = indexPath.row == 0 ? [UIView new] : button;
            }
            cell.textLabel.text = indexPath.row == 0 ? @"历史搜索" : _historySearchInputList[indexPath.row-1];
            cell.imageView.image = [UIImage imageNamed:indexPath.row == 0 ? @"" : @"checked"];
            cell.textLabel.font = [UIFont systemFontOfSize:indexPath.row == 0 ? 12 : 16];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            if (_historySearchInputList.count == 0) {
                DWSearchResultEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:kDWSearchResultEmptyCellTag
                                                                                forIndexPath:indexPath];
                cell.imageName = @"section-1";
                cell.emptyDataMessage = @"暂无搜索历史";
                [cell refresh];
                return cell;
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDWSearchHistoryViewCellRentTag];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                  reuseIdentifier:kDWSearchHistoryViewCellRentTag];
                }
                cell.textLabel.text = _historySearchInputList[indexPath.row];
                cell.detailTextLabel.text = @"不限";
                return cell;
            }
        }
    }
}

- (void)didDeleteButtonClicked:(UIButton *)button {
    NSInteger index = button.tag - 1;  // button-tag 对应到historySearchList中的index  都大于1，所以减去1即historySearchList的索引
    [_historySearchInputList removeObjectAtIndex:index];
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ((_currentSelectedSearchType == DWSearchCellTypeRent) && _historySearchInputList.count > 0) {
        if (!_headerView) {
            _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
            _headerView.backgroundColor = [UIColor whiteColor];
        }
        
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] init];
            _titleLabel.font = [UIFont systemFontOfSize:12];
            _titleLabel.textColor = [UIColor dw_SubTitleTextColor];
            _titleLabel.text = @"历史";
            [_headerView addSubview:_titleLabel];
            _titleLabel.frame = CGRectMake(15, 10, 100, 20);
        }
        
        if (!_cleanButtonForRent) {
            _cleanButtonForRent = [UIButton buttonWithType:UIButtonTypeCustom];
            [_cleanButtonForRent setTitle:@"删除历史" forState:UIControlStateNormal];
            [_cleanButtonForRent addLeftImage:[UIImage imageNamed:@"checked"] offset:5];
            [_cleanButtonForRent addTarget:self
                                    action:@selector(didCleanButtonClickedForRent:)
                          forControlEvents:UIControlEventTouchUpInside];
            _cleanButtonForRent.titleLabel.font = [UIFont systemFontOfSize:12];
            [_cleanButtonForRent setTitleColor:[UIColor dw_SubTitleTextColor] forState:UIControlStateNormal];
            [_headerView addSubview:_cleanButtonForRent];
            _cleanButtonForRent.frame = CGRectMake(SCREEN_WIDTH-15-80, 5, 80, 30);
        }
        
        return _headerView;
    }
    return [UIView new];
}

- (void)didCleanButtonClickedForRent:(UIButton *)button {
    [self clearAllSearchHistory];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ((_currentSelectedSearchType == DWSearchCellTypeNew) && (_historySearchInputList.count > 0) && section == 1) {
        if (!_footerView) {
            _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        }
        if (!_clearButtonForNew) {
            _clearButtonForNew = [UIButton buttonWithType:UIButtonTypeCustom];
            [_clearButtonForNew setTitle:@"清空历史记录" forState:UIControlStateNormal];
            _clearButtonForNew.titleLabel.font = [UIFont systemFontOfSize:12];
            [_clearButtonForNew setTitleColor:[UIColor dw_SubTitleTextColor] forState:UIControlStateNormal];
            [_clearButtonForNew addTarget:self
                                   action:@selector(didClearSearchHistoryButtonClickedForNew:)
                         forControlEvents:UIControlEventTouchUpInside];
            _clearButtonForNew.frame = _footerView.bounds;
            [_footerView addSubview:_clearButtonForNew];
        }
        return _footerView;
    }
    return [UIView new];
}

- (void)didClearSearchHistoryButtonClickedForNew:(UIButton *)button {
    [self clearAllSearchHistory];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ((_currentSelectedSearchType == DWSearchCellTypeRent) && _historySearchInputList.count > 0) {
        return 40.0f;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_currentSelectedSearchType != DWSearchCellTypeNew) {
        return CGFLOAT_MIN;
    }
    return section == 0 ? kLeftRightFitPadding : 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((_currentSelectedSearchType != DWSearchCellTypeRent) && indexPath.section == 0) {
        return [DWSearchViewCell height:indexPath.row == 0 ? _fakeDataSourceA : _historySearchInputList
                             atRowIndex:indexPath.row];
    } else if ((_currentSelectedSearchType == DWSearchCellTypeNew) && indexPath.section == 1) {
        return 44.0f;
    } else {
        return _historySearchInputList.count == 0 ? self.view.bounds.size.height : 50.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self dismissPickerView];
}

#pragma mark - DWSearchViewCellDelegate
- (void)triggerToResponseAfterControlButtonClickedAt:(NSInteger)index {
    if (index == 0) {
        [self updateHotSearchSection_0];
    } else {
        [self clearAllSearchHistory];
    }
}

- (void)clearAllSearchHistory {
    [_historySearchInputList removeAllObjects];
    [_tableView reloadData];
}

- (void)updateHotSearchSection_0 {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {  // Background Thread
        [weakSelf refreshNewHotSearchTags];
        dispatch_async(dispatch_get_main_queue(), ^(void) {  // Run UI Updates
            NSIndexPath *idx = [NSIndexPath indexPathForRow:0 inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idx, nil]
                                      withRowAnimation:UITableViewRowAnimationNone];
        });
    });
}

- (void)refreshNewHotSearchTags {
    NSArray *array = [FixedComponentDataSource buildFakeHotSearchTags];
    if ([_fakeDataSourceA isEqual:array]) {
        _fakeDataSourceA = [[FixedComponentDataSource buildFakeHotSearchTagsAgain] mutableCopy];
    } else {
        _fakeDataSourceA = [[FixedComponentDataSource buildFakeHotSearchTags] mutableCopy];
    }
}

- (void)triggerToResponseAfterHotTagsClickedAtViewIndex:(NSInteger)viewIndex itemIndex:(NSInteger)index {
    // 去结果页面
}

#pragma mark - SELs
- (void)didViewTapped {
    [self dismissPickerView];
}

- (void)didNaviBarRightButtonClicked:(UIButton *)button {
    [self dismissPickerView];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - DWHomeNaviTitleBarDelegate
- (void)triggerToResponseAfterSelectedButtonClicked {
    [_searchBarView.textfield resignFirstResponder];
    if (!_pickerView || _pickerView.isHidden) {
        [self popUpPickerView];
    } else {
        [self dismissPickerView];
    }
}

- (void)triggerToResponseWhenTextFieldChanged:(NSString *)inputText {
    [self dismissPickerView];
    if (!inputText || inputText.length < 1) {
        _isDisplaySearchResult = NO;
        _searchResultList = [NSMutableArray arrayWithCapacity:4];
        [_tableView reloadData];
        return;
    }
    
    _isDisplaySearchResult = YES;
//    [self filterSearchingResultList:(NSString *)keyWords];   // TODO:
    [_tableView reloadData];
}

- (void)filterSearchingResultList:(NSString *)keyWords {
    
}

- (void)triggerToResponseWhenTextFieldBecomeFirstResponder {
    [self dismissPickerView];
}

- (void)triggerToResponseAfterTextFieldFinishInput:(NSString *)inputText {
    [self dismissPickerView];
    [_searchBarView.textfield resignFirstResponder];
    if (!inputText || inputText.length < 1)    return;
    
    if (_historySearchInputList.count == 4) {
        [_historySearchInputList removeLastObject];
        [_historySearchInputList insertObject:inputText atIndex:0];
    } else {
        [_historySearchInputList insertObject:inputText atIndex:0];
    }
    [_tableView reloadData];
}

#pragma mark - DWItemPickerViewDelegate
- (void)triggerToResponseAfterItemSelectedAt:(NSInteger)index {
    if (_pickerView.selectedIndex == index) {
        [self dismissPickerView];
        return;
    }
    
    [self rebuildTableViewDataSource:index];
    double delayInSeconds = 0.15;
    __weak typeof(self) weakSelf = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [weakSelf.tableView reloadData];
    });
}

- (void)rebuildTableViewDataSource:(NSInteger)index {
    [self switchPickerViewAtIndex:index];
    [self switchSearchBarViewAtIndex:index];
    [self switchHotSearchViewAtIndex:index];
    [self cachedSearchHistoryLocally:index];
}

- (void)switchPickerViewAtIndex:(NSInteger)index {
    _pickerView.selectedIndex = index;
    [_pickerView refresh];
    [self dismissPickerView];
}

- (void)switchSearchBarViewAtIndex:(NSInteger)index {
    NSString *selectedText = [@[@"二手房", @"新 房", @"租 房"] objectAtIndex:index];
    _searchBarView.selectedText = selectedText;
    if (index == DWSearchCellTypeUsed) {
        _searchBarView.inputPlaceholder = @"你想住在哪？";
    } else if (index == DWSearchCellTypeNew) {
        _searchBarView.inputPlaceholder = @"请输入楼盘名或区域";
    } else {
        _searchBarView.inputPlaceholder = @"请输入小区名称";
    }
    [_searchBarView refresh];
}

- (void)switchHotSearchViewAtIndex:(NSInteger)index {
    if (index == DWSearchCellTypeUsed) {
        _fakeDataSourceA = [[FixedComponentDataSource buildFakeHotSearchTags] mutableCopy];
    } else if (index == DWSearchCellTypeNew) {
        _fakeDataSourceA = [[FixedComponentDataSource buildFakeHotSearchTagsForNew] mutableCopy];
    } else {
        // do nothing...
    }
}

- (void)cachedSearchHistoryLocally:(NSInteger)index {
    if (_currentSelectedSearchType == index) {
        return;
    }
    
    [self saveHistory];
    _currentSelectedSearchType = index;
    [self fetchHistory];
}

- (void)saveHistory {
    NSArray *toBeSavedArray = (_historySearchInputList.count > 0) ? [_historySearchInputList copy] : @[];
    NSString *saveIdentifierKey = [self fetchUserDefaultKey:_currentSelectedSearchType];
    [[NSUserDefaults standardUserDefaults] setObject:toBeSavedArray forKey:saveIdentifierKey];
}

- (void)fetchHistory {
    NSString *fetchIdentifierKey = [self fetchUserDefaultKey:_currentSelectedSearchType];
    NSArray *fetchHistoryList = [[NSUserDefaults standardUserDefaults] objectForKey:fetchIdentifierKey];
    _historySearchInputList = !fetchHistoryList ? [NSMutableArray arrayWithCapacity:4] : [fetchHistoryList mutableCopy];
}

- (NSString *)fetchUserDefaultKey:(NSInteger)index {
    NSString *identifierKey = @"";
    if (index == DWSearchCellTypeUsed) {
        identifierKey = kDWSearchCellTypeUsed;
    } else if (index == DWSearchCellTypeNew) {
        identifierKey = kDWSearchCellTypeNew;
    } else if (index == DWSearchCellTypeRent) {
        identifierKey = kDWSearchCellTypeRent;
    } else {
        // do nothing...
    }
    return identifierKey;
}

- (void)dealloc {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _searchBarView.delegate = nil;
    _pickerView.delegate = nil;
}

@end
