//
//  BXGConfirmAlertController.h
//  Boxuegu
//
//  Created by HM on 2017/4/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGAlertController : UIAlertController
+ (instancetype)confirmWithTitle:(NSString *) title message:(NSString *) message handler:(void (^)())handler;
+ (instancetype)confirmWithTitle:(NSString *) title message:(NSString *) message confirmHandler:(void (^)())confirmHandler cancleHandler:(void (^)())cancleHandler;

+ (instancetype)confirmWithTitle:(NSString *) title
                         message:(NSString *) message
                 andConfirmTitle:(NSString*)confirmTitle
                  confirmHandler:(void (^)())confirmHandler
                   cancleHandler:(void (^)())cancleHandler;

+ (instancetype)confirmWithTitle:(NSString *) title
                         message:(NSString *) message
                 andConfirmTitle:(NSString*)confirmTitle
                  andCancelTitle:(NSString*)cancelTitle
                  confirmHandler:(void (^)())confirmHandler
                   cancleHandler:(void (^)())cancleHandler;
    
+ (instancetype)tipWithTitle:(NSString *) title message:(NSString *) message confirmHandler:(void (^)())confirmHandler;

+ (instancetype)authorityWithTitle:(NSString *) title message:(NSString *) message confirmHandler:(void (^)())confirmHandler cancleHandler:(void (^)())cancleHandler;

+ (instancetype)locationAuthorityWithconfirmHandler:(void (^)())confirmHandler cancleHandler:(void (^)())cancleHandler;
@end
