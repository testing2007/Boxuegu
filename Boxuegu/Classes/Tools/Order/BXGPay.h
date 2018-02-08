//
//  BXGPay.h
//  Boxuegu
//
//  Created by apple on 2017/11/13.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BXGOrderPayResultViewModel;
@class BXGOrderPayResultVC;
@class BXGOrderPayBaseModel;
@class BXGOrderPayFreeModel;
@class BXGOrderPayWechatModel;

typedef NS_ENUM(NSUInteger, BXGOrderStatusType) {
    BXGSaveOrderStatusTypeNetworkError,
    BXGSaveOrderStatusTypeOperationError,
    BXGSaveOrderStatusTypeServerError,
    BXGSaveOrderStatusTypeFreeCourse,
    BXGSaveOrderStatusTypePayCourse,
};

@protocol BXGPay <NSObject>

//- (void)translatePayUIWithOrderStatusType:(BXGOrderStatusType)status
//                               andMessage:(NSString *)msg
//                              andPayModel:(BXGOrderPayBaseModel*)payModel
//                               andPayType:(NSString*)payType;

-(void)orderFinishPayCallbackWithSerialNo:(NSString*)serialNo andPayType:(NSString*)payType;


@end
