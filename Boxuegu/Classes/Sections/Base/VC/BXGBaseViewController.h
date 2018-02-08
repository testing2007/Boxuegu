//
//  BXGBaseViewController.h
//  Boxuegu
//
//  Created by HM on 2017/5/16.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGMainTabBarController.h"
#import "BXGPay.h"

@class BXGOrderPayBaseModel;
@interface BXGBaseViewController : UIViewController
- (BXGMainTabBarController *)mainViewController;
@property (nonatomic, copy) NSString *pageName;
@property (nonatomic, assign) CGFloat topOffset;
@property (nonatomic, assign) CGFloat bottomOffset;
-(BOOL)isNeedPresentLoginBlock:(void (^)())completion;
// 头部偏移量
// 底部偏移量


////订单处理
//- (void)translatePayUIWithOrderStatusType:(BXGOrderStatusType)status
//                               andMessage:(NSString *)msg
//                              andPayModel:(BXGOrderPayBaseModel*)payModel
//                               andPayType:(NSString*)payType;
//-(void)doOrderSearchWithOrderSeialNo:(NSString*)orderSerialNo andPayType:(NSString*)payType;

@end
