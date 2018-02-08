//
//  BXGOrderPayResultViewModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/11/11.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
#import "BXGOrderHelper.h"

@interface BXGOrderPayResultViewModel : BXGBaseViewModel
- (instancetype)initWithOrderNo:(NSString *)orderNo andPayType:(NSString*)type;
- (instancetype)initWithPayFailedMsg:(NSString *)msg;

@property (nonatomic, readonly ,assign) BOOL isFaild;
@property (nonatomic, readonly, copy) NSString * faildMsg;
- (void)loadOrderPayResultWithFinishBlock:(void (^)(BOOL bSuccess, BXGOrderPayResultModel *resultModel,NSString *msg))finishedBlock;
@end
