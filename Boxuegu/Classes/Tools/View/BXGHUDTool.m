//
//  BXGHUDTool.m
//  Boxuegu
//
//  Created by RW on 2017/4/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGHUDTool.h"
#import <MBProgressHUD.h>

@interface BXGHUDTool()

@property (nonatomic, weak) MBProgressHUD *hud;
@property (nonatomic, weak) UIView *hudView; // 当前展示的 自定义View

@end

@implementation BXGHUDTool

static BXGHUDTool *instance;

#pragma mark - Interface

+ (instancetype)share {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BXGHUDTool new];
    });
    return instance;
}

- (void)showHUDWithString:(NSString *)str {
    
    // 关闭上次HUD
    [self closeHUD];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    // Config
    hud.mode = MBProgressHUDModeText;
    hud.margin = 13;
    hud.userInteractionEnabled = true;
    hud.removeFromSuperViewOnHide = true;
    hud.detailsLabelFont = [UIFont bxg_fontMediumWithSize:16];
    hud.detailsLabelColor = [UIColor colorWithHex:0xffffff];
    hud.detailsLabelText = str;
    
    self.hud = hud;
    self.hudView = [UIApplication sharedApplication].keyWindow;

    // 自动关闭
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.2 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    });
}

- (void)showHUDWithString:(NSString *)str View:(UIView *)view{
    
    // 关闭上次HUD
    [self closeHUD];

    // 安全判断
    if(!view){
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.margin = 13;
    hud.detailsLabelFont = [UIFont bxg_fontMediumWithSize:16];;
    hud.detailsLabelText = str;
    
    self.hud = hud;
    self.hudView = view;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.4 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if(self.hud) {
            [MBProgressHUD hideHUDForView:view animated:YES];
        }
    });
}

- (void)showLoadingHUDWithString:(NSString *)str{

    [self closeHUD];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.margin = 13;
    hud.removeFromSuperViewOnHide = true;
    hud.userInteractionEnabled = true;
    hud.labelText = str;
    self.hud = hud;
    self.hudView = [UIApplication sharedApplication].keyWindow;
}

- (void)showLoadingHUDWithString:(NSString *)str andView:(UIView *)view{
    
    [self closeHUD];
    
    if(!view){
        
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.margin = 13;
    hud.removeFromSuperViewOnHide = true;
    hud.userInteractionEnabled = true;
    hud.labelText = str;
    self.hud = hud;
    self.hudView = view;
}

- (void)closeHUD {
    
    Weak(weakSelf);
    
    // 关闭HUD
    if(weakSelf.hud && weakSelf.hudView) {
        
        [MBProgressHUD hideHUDForView:weakSelf.hudView animated:true];
    }
    
    // 释放
    weakSelf.hud = nil;
    weakSelf.hudView = nil;
}
@end
