//
//  BXGOrderBindCouponViewModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/27.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderBindCouponViewModel.h"

@implementation BXGOrderBindCouponViewModel
- (void)performBindCouponWithSerialNo:(NSString *)serialNo
                          andCourseId:(NSString*)courseId
                          andFinished:(void(^)(BOOL succeed, NSString *couponId, NSNumber *isCouver, NSString *msg))finished {
    
    [self.networkTool requestBindCouponWithSerialNo:serialNo
                                        andCourseId:courseId
                                        andFinished:^(id  _Nullable responseObject) {
        [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
            switch (status) {
                case BXGNetworkResultStatusSucceed:{
                    NSNumber *coupondId = nil;
                    NSNumber *isCouver = nil;
                    if([result isKindOfClass:[NSDictionary class]] &&
                       [result[@"couponId"] isKindOfClass:[NSNumber class]] &&
                       [result[@"isCouver"] isKindOfClass:[NSNumber class]]) {
                        coupondId = result[@"couponId"];
                        isCouver = result[@"isCouver"];
                    }
                    if(isCouver && !isCouver.boolValue) {
                        finished(true,nil, isCouver, @"兑换成功,此优惠券不适用于本课程");
                    } else {
                        // couponId
                        finished(true,coupondId.stringValue, nil, @"兑换成功");
                    }
                    return;
                }break;
                case BXGNetworkResultStatusFailed: {
                    finished(false,nil, nil, message);
                    return;
                    break;
                }
                case BXGNetworkResultStatusExpired: {
                    finished(true,nil, nil, kBXGToastNoNetworkError);
                    break;
                }
                case BXGNetworkResultStatusParserError: {
                    finished(true,nil, nil, kBXGToastNoNetworkError);
                    break;
                }
            }
        }];
        
    } andFailed:^(NSError * _Nonnull error) {
        finished(false,nil, nil, kBXGToastNoNetworkError);
    }];
}
@end
