//
//  DWSearchResultEmptyCell.h
//  Dwell
//
//  Created by toureek on 10/18/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kDWSearchResultEmptyCellTag;

@interface DWSearchResultEmptyCell : UITableViewCell

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *emptyDataMessage;

- (void)refresh;

@end
