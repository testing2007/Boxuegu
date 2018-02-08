//
//  BXGConfirmPopVC.h
//  Boxuegu
//
//  Created by HM on 2017/5/8.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGConfirmPopVC : UIViewController
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) void(^confirmBlock)();
@property (nonatomic, copy) void(^cancleBlock)();
@end
