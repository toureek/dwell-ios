//
//  DWHomeNaviTitleBarView.h
//  Dwell
//
//  Created by toureek on 10/18/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWHomeNaviTitleBarDelegate <NSObject>
@optional
- (void)triggerToResponseAfterSearchButtonClicked;
- (void)triggerToResponseAfterSelectedButtonClicked;
- (void)triggerToResponseWhenTextFieldBecomeFirstResponder;
- (void)triggerToResponseWhenTextFieldChanged:(NSString *)inputText;
- (void)triggerToResponseAfterTextFieldFinishInput:(NSString *)inputText;
@end

typedef NS_ENUM(NSInteger, DWNaviTitleBarType) {
    DWNaviTitleBarTypeDisplayOnly = 0,          //  home-controller
    DWNaviTitleBarTypeInputOnly = 1,            //
    DWNaviTitleBarTypeSelectWithInput = 2,      //  search-controller
};

@interface DWHomeNaviTitleBarView : UIView <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textfield;

@property (nonatomic, copy) NSString *selectedText;
@property (nonatomic, copy) NSString *inputPlaceholder;
@property (nonatomic, weak) id<DWHomeNaviTitleBarDelegate> delegate;
@property (nonatomic, assign) DWNaviTitleBarType type;

- (instancetype)initWithFrame:(CGRect)frame type:(DWNaviTitleBarType)type;
- (void)activeTextField;
- (void)refresh;

@end

