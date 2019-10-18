//
//  DWUsedInteractiveView.h
//  Dwell
//
//  Created by toureek on 10/18/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DWColorTagsAndFeedback;
@protocol DWUsedInteractiveViewDelegate <NSObject>
@optional
- (void)triggerToRepsonseAfterButtonClickedAtButtonIndex:(NSInteger)index atCellIndex:(NSInteger)cellIndex;
@end

@interface DWUsedInteractiveView : UIView

@property (nonatomic, weak) id<DWUsedInteractiveViewDelegate> delegate;
@property (nonatomic, assign) NSInteger cellIndex;
@property (nonatomic, copy) NSArray *actionArray;
@property (nonatomic, copy) NSArray *frameArrays;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)showInteractiveView;
- (void)dismissInteractiveView;

@end
