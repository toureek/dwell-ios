//
//  DWItemPickerView.h
//  Dwell
//
//  Created by toureek on 10/18/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWItemPickerViewDelegate <NSObject>
@optional
- (void)triggerToResponseAfterItemSelectedAt:(NSInteger)index;
@end

@interface DWItemPickerView : UIView

@property (nonatomic, weak) id<DWItemPickerViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) NSArray *itemArray;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)refresh;
@end
