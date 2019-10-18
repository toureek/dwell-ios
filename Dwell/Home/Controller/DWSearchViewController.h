//
//  DWSearchViewController.h
//  Dwell
//
//  Created by toureek on 10/18/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWViewController.h"

extern NSString *const kDWSearchCellTypeUsed;
extern NSString *const kDWSearchCellTypeNew;
extern NSString *const kDWSearchCellTypeRent;

@class DWDisplayHomeAPI;
@interface DWSearchViewController : DWViewController
@property (nonatomic, strong) DWDisplayHomeAPI *recommendModel;
@end
