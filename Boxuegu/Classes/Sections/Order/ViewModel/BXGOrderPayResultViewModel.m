//
//  BXGOrderPayResultViewModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/11/11.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderPayResultViewModel.h"
@interface BXGOrderPayResultViewModel()
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *payType;



@end

@implementation BXGOrderPayResultViewModel

- (instancetype)initWithOrderNo:(NSString *)orderNo andPayType:(NSString*)type; {
    self = [super init];
    if(self) {
        _orderNo = orderNo;
        _payType = type;
    }
    return self;
}

- (instancetype)initWithPayFailedMsg:(NSString *)msg; {
    self = [super init];
    if(self) {
        _isFaild = true;
        _faildMsg = msg;
    }
    return self;
}

- (void)loadOrderPayResultWithFinishBlock:(void (^)(BOOL bSuccess, BXGOrderPayResultModel *resultModel,NSString *msg))finishedBlock  {
 
    if(!(self.orderNo && self.payType)) {
        finishedBlock(false,nil,@"缺少参数");
        return;
    }
    [BXGOrderHelper loadOrderSearchWithOrderNo:self.orderNo andType:self.payType andFinishBlock:^(BOOL bSuccess, BXGOrderPayResultModel *resultModel, NSString *msg) {
        finishedBlock(bSuccess,resultModel,msg);
    }];
}
@end
