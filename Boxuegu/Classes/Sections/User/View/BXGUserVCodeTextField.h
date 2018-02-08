//
//  BXGUserVCodeTextField.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGUserVCodeTextField : UIView
@property (nonatomic, copy) NSString *tagName;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) UIKeyboardType keyBoardType;

- (void)startCount;
- (void)stopCount;
- (void)uninstall;
@property (nonatomic, copy) void(^clickBlock)();

- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;

//@property (nonatomic, assign) UIKeyboardType keyBoardType;
@end