//
//  BXGUserInputTextField.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/14.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BXGUserInputTextFieldType) {
    BXGUserInputTextFieldTypePhone,
    BXGUserInputTextFieldTypeNormal,
    BXGUserInputTextFieldTypePassWord,
    BXGUserInputTextFieldTypeVCode,
    BXGUserInputTextFieldTypeImageVCode,
};

@interface BXGUserNormalTextField : UIView
@property (nonatomic, copy) NSString *tagName;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) UIKeyboardType keyBoardType;
@property (nonatomic, assign) BXGUserInputTextFieldType *type;
@property (nonatomic, assign) BOOL enable;
- (void)installUI;

- (BOOL)becomeFirstResponder;

- (BOOL)resignFirstResponder;

@end
