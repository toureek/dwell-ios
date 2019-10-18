//
//  DWHomeNaviTitleBarView.m
//  Dwell
//
//  Created by toureek on 10/18/19.
//  Copyright © 2019 toureek.it. All rights reserved.
//

#import "DWHomeNaviTitleBarView.h"
#import "UIButton+Utils.h"

@implementation DWHomeNaviTitleBarView {
    UIImageView *_imageView;
    UIButton *_button;
    UIButton *_selectedButton;
}

- (instancetype)initWithFrame:(CGRect)frame type:(DWNaviTitleBarType)type {
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        [self setUpViewWithType:type];
    }
    return self;
}

- (void)setUpViewWithType:(DWNaviTitleBarType)type {
    if (type == DWNaviTitleBarTypeDisplayOnly) {
        [self addImageViewAndLayout];
    } else if (type == DWNaviTitleBarTypeSelectWithInput) {
        [self setUpBorderStyle];
        [self addButtonViewAndLayout];
        [self addTextfieldAndLayout];
    }
}

- (void)setUpBorderStyle {
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowOpacity = 0.1f;
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [UIColor dw_ColorWithHexString:@"#CCCCCC"].CGColor;
    self.layer.cornerRadius = 3.0f;
}

- (void)addImageViewAndLayout {
    _imageView = [[UIImageView alloc] init];
    _imageView.image = [UIImage imageNamed:@"searchView"];
    _imageView.contentMode = UIViewContentModeScaleToFill;
    _imageView.userInteractionEnabled = YES;
    _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _imageView.layer.shadowOpacity = 0.1f;
    _imageView.layer.shadowOffset = CGSizeZero;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(didSearchBarImageClicked:)];
    [_imageView addGestureRecognizer:tap];
    [self addSubview:_imageView];
    
    [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(3, 0, 3, 0));
    }];
}

- (void)addButtonViewAndLayout {
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.backgroundColor = [UIColor whiteColor];
    _button.frame = CGRectMake(0, 3, 110, 38);
    _button.titleLabel.font = [UIFont systemFontOfSize:16];
    [_button setTitle:@"二手房▾ |  " forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor dw_TitleTextColor] forState:UIControlStateNormal];
    [_button setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(didSelectedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    [_button setButtonType:DWButtonAlignTypeLeft];
    [self bringSubviewToFront:_button];
}

- (void)addTextfieldAndLayout {
    _textfield = [[UITextField alloc] init];
    _textfield.frame = CGRectMake(115, 3, self.bounds.size.width-115, 38);
    _textfield.delegate = self;
    _textfield.placeholder = @"你想住在哪？";
    _textfield.font = [UIFont systemFontOfSize:16];
    _textfield.textColor = [UIColor dw_PlaceholderTextColor];
    _textfield.userInteractionEnabled = NO;
    _textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textfield.returnKeyType = UIReturnKeySearch;
    [_textfield addTarget:self action:@selector(didTextFiledDidChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_textfield];
    [self bringSubviewToFront:_textfield];
}

- (void)refresh {
    if (_type == DWNaviTitleBarTypeSelectWithInput) {
        [_button setTitle:_selectedText ? [NSString stringWithFormat:@"%@▾ |  ", _selectedText] : @""
                 forState:UIControlStateNormal];
        _textfield.placeholder = _inputPlaceholder ? : @"";
    }
}

- (void)activeTextField {
    _textfield.userInteractionEnabled = YES;
    [_textfield becomeFirstResponder];
}

#pragma mark - SEL
- (void)didSearchBarImageClicked:(UITapGestureRecognizer *)tapper {
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterSearchButtonClicked)]) {
        [_delegate triggerToResponseAfterSearchButtonClicked];
    }
}

- (void)didSelectedButtonClicked:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterSelectedButtonClicked)]) {
        [_delegate triggerToResponseAfterSelectedButtonClicked];
    }
}

- (void)didTextFiledDidChanged:(UITextField *)textfield {
    if (textfield.text.length == 0 || [textfield.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseWhenTextFieldChanged:)]) {
        [_delegate triggerToResponseWhenTextFieldChanged:textfield.text];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterTextFieldFinishInput:)]) {
        [_delegate triggerToResponseAfterTextFieldFinishInput:textField.text];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseWhenTextFieldBecomeFirstResponder)]) {
        [_delegate triggerToResponseWhenTextFieldBecomeFirstResponder];
    }
    return YES;
}

@end
