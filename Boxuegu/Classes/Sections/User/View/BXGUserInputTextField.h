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

@interface BXGUserInputTextField : UIView
@property (nonatomic, copy) NSString *tagName;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) UIKeyboardType keyBoardType;
@property (nonatomic, assign) BXGUserInputTextFieldType *type;
- (void)installUI;
@end
