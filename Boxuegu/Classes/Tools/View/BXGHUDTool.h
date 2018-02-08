//
//  BXGHUDTool.h
//  Boxuegu
//
//  Created by RW on 2017/4/19.
//  Copyright © 2017年 itcast. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface BXGHUDTool : NSObject

+ (instancetype)share;
// window
- (void)showHUDWithString:(NSString *)str;
- (void)showHUDWithString:(NSString *)str View:(UIView *)view;
// window
- (void)showLoadingHUDWithString:(NSString *)str;
- (void)showLoadingHUDWithString:(NSString *)str andView:(UIView *)view;
- (void)closeHUD;
@end
