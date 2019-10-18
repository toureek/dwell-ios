//
//  DWMenuItemTableViewCell.m
//  Dwell
//
//  Created by toureek on 10/15/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWMenuItemTableViewCell.h"
#import "DWItemCollectionViewCell.h"
#import "DWDisplayModel.h"

NSString *const kDWMenuItemTableViewCellTag = @"kDWMenuItemTableViewCellTag";

@implementation DWMenuItemTableViewCell {
    UICollectionView *_collectionView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpCollectionViewWithLayout];
    }
    return self;
}

+ (CGFloat)height:(NSInteger)itemCount {
    CGFloat size = floor(ceil(UIScreen.mainScreen.bounds.size.width/5.0));
    return (itemCount / 5) * size;
}

- (void)setUpCollectionViewWithLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = layout.minimumInteritemSpacing = CGFLOAT_MIN;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.userInteractionEnabled = _collectionView.alwaysBounceVertical = YES;
    _collectionView.scrollEnabled = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[DWItemCollectionViewCell class]
        forCellWithReuseIdentifier:kDWItemCollectionViewCell];
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.contentView addSubview:_collectionView];
}

- (void)refresh {
    if (_menuList) {
        // updateUI...
        [_collectionView reloadData];
    }
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);  // UIEdgeInsetsMake(up, left, bottom, right);
    }];
    
    [super updateConstraints];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat size = floor((UIScreen.mainScreen.bounds.size.width/5.0));
    return CGSizeMake(size, size);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _menuList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DWItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDWItemCollectionViewCell
                                                                               forIndexPath:indexPath];
    cell.item = _menuList[indexPath.row];
    cell.index = indexPath.row;
    [cell refresh];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return _menuList.count > 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterItemClickedAtIndex:)]) {
        [_delegate triggerToResponseAfterItemClickedAtIndex:indexPath.row];
    }
}

@end
