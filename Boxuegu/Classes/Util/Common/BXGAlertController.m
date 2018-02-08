//
//  BXGConfirmAlertController.m
//  Boxuegu
//
//  Created by HM on 2017/4/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGAlertController.h"

@interface BXGAlertController ()

@end

@implementation BXGAlertController

+ (instancetype)confirmWithTitle:(NSString *) title message:(NSString *) message handler:(void (^)())handler{

    BXGAlertController* instance = [BXGAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    
    UIAlertAction *accept = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:handler];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [instance addAction:accept];
    [instance addAction:cancle];
    return instance;
}

+ (instancetype)confirmWithTitle:(NSString *) title message:(NSString *) message confirmHandler:(void (^)())confirmHandler cancleHandler:(void (^)())cancleHandler{
    
    BXGAlertController* instance = [BXGAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *accept = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:confirmHandler];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancleHandler];
    [instance addAction:accept];
    [instance addAction:cancle];
    return instance;
}

+ (instancetype)confirmWithTitle:(NSString *) title
                         message:(NSString *) message
                 andConfirmTitle:(NSString*)confirmTitle
                  confirmHandler:(void (^)())confirmHandler
                   cancleHandler:(void (^)())cancleHandler{
    
    BXGAlertController* instance = [BXGAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *accept = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:confirmHandler];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancleHandler];
    [instance addAction:accept];
    [instance addAction:cancle];
    return instance;
}

+ (instancetype)confirmWithTitle:(NSString *) title
                         message:(NSString *) message
                 andConfirmTitle:(NSString*)confirmTitle
                  andCancelTitle:(NSString*)cancelTitle
                  confirmHandler:(void (^)())confirmHandler
                   cancleHandler:(void (^)())cancleHandler {
    
    BXGAlertController* instance = [BXGAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *accept = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:confirmHandler];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:cancleHandler];
    [instance addAction:accept];
    [instance addAction:cancle];
    return instance;
}

+ (instancetype)tipWithTitle:(NSString *) title message:(NSString *) message confirmHandler:(void (^)())confirmHandler {
    
    BXGAlertController* instance = [BXGAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *accept = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:confirmHandler];
    [instance addAction:accept];
    return instance;
}

+ (instancetype)authorityWithTitle:(NSString *) title message:(NSString *) message confirmHandler:(void (^)())confirmHandler cancleHandler:(void (^)())cancleHandler; {

    BXGAlertController* instance = [BXGAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *setting = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:confirmHandler];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancleHandler];
    [instance addAction:cancle];
    [instance addAction:setting];
    
    return instance;
}

+ (instancetype)locationAuthorityWithconfirmHandler:(void (^)())confirmHandler cancleHandler:(void (^)())cancleHandler; {

    BXGAlertController *instance = [BXGAlertController authorityWithTitle:@"已为\"博学谷\"关闭定位服务" message:@"您可以在\"设置\"中为此应用打开定位服务" confirmHandler:^{
        
            NSString *version = [UIDevice currentDevice].systemVersion;
            if (version.doubleValue > 10.0) { // iOS系统版本 >= 10.0
        
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
            
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                        
                    }];
                }
                
            } else{ //iOS系统版本 < 8.0
        
                
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }
    } cancleHandler:^{
        
    }];
    
    return instance;
}

@end
