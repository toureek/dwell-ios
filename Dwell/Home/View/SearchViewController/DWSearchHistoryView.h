//
//  DWSearchHistoryView.h
//  Dwell
//
//  Created by toureek 10/18/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWSearchHistoryViewDelegate <NSObject>
@optional
- (void)triggerToResponseAfterItemClickedAt:(NSInteger)index;
@end

@interface DWSearchHistoryView : UIView
@property (nonatomic, weak) id<DWSearchHistoryViewDelegate> delegate;
@property (nonatomic, assign) NSInteger itemIndex;
@property (nonatomic, copy) NSString *titleText;

- (void)refresh;

@end
