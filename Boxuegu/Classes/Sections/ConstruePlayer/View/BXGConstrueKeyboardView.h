//
//  BXGConstrueKeyboardView.h
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/12.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGConstrueKeyboardView : UIView
@property (nonatomic, strong) UITextField *textView;
@property (nonatomic, copy) void(^sendMessageBlock)(NSString *msg);
@end
