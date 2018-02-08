//
//  BXGUserPasswordTextField.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGUserPasswordTextField : UIView
@property (nonatomic, copy) NSString *tagName;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) UIKeyboardType keyBoardType;
//@property (nonatomic, assign) BXGUserInputTextFieldType *type;
- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;
@end
