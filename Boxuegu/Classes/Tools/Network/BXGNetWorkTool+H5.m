//
//  BXGNetWorkTool+H5.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGNetWorkTool+H5.h"

@implementation BXGNetWorkTool (H5)

#pragma mark - H5

/// 获取服务协议URL /Views/h5/bxg_agreement.html
- (NSURL* _Nullable)h5ForAgreement{
    NSString *urlString = [MainBaseUrlString stringByAppendingString:@"Views/h5/bxg_agreement.html"];
    return [NSURL URLWithString:urlString];
}

/// 获取关于URL: /Views/h5/bxgabout.html
- (NSURL* _Nullable)h5ForAppAbout{
    NSString *urlString = [MainBaseUrlString stringByAppendingString:@"Views/h5/bxgabout.html"];
    return [NSURL URLWithString:urlString];
}

/// 课程详情 URL：/Views/h5/courseDetails.html
- (NSURL* _Nullable)h5ForCourseDetailsWithCourseId:(NSString * _Nullable)courseId {
    NSString *urlString = [NSString stringWithFormat:@"%@%@?course_id=%@",MainBaseUrlString,@"Views/h5/courseDetails.html",courseId];
    return [NSURL URLWithString:urlString];
}

/// 课程Q&A URL：/Views/h5/Q&A.html
- (NSURL* _Nullable)h5ForCourseQAWithCourseId:(NSString * _Nullable)courseId; {
    NSString *urlString = [NSString stringWithFormat:@"%@%@?course_id=%@",MainBaseUrlString,@"Views/h5/Q&A.html",courseId];
    return [NSURL URLWithString:urlString];
}

/// 支付协议页面 URL：/Views/h5/paymentAgreement.html
- (NSURL* _Nullable)h5ForPaymentAgreement {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",MainBaseUrlString,@"/Views/h5/paymentAgreement.html"];
    return [NSURL URLWithString:urlString];
}

/// 优惠券说明页面 URL：/Views/h5/useProtocol.html
- (NSURL* _Nullable)h5ForCouponuseProtocol {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",MainBaseUrlString,@"/Views/h5/useProtocol.html"];
    return [NSURL URLWithString:urlString];
}

@end
