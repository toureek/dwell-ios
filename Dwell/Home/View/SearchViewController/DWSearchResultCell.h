//
//  DWSearchResultCell.h
//  Dwell
//
//  Created by toureek on 10/18/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWSearchViewCell.h"

@interface DWSearchResultCell : UITableViewCell

@property (nonatomic, assign) DWSearchCellType type;

- (void)refresh;

@end

