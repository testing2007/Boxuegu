//
//  BXGNetWorkTool+H5.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGNetWorkTool.h"

@interface BXGNetWorkTool (H5)

#pragma mark - H5

/// 获取服务协议URL /Views/h5/bxg_agreement.html
- (NSURL* _Nullable)h5ForAgreement;

/// 获取关于URL: /Views/h5/bxgabout.html
- (NSURL* _Nullable)h5ForAppAbout;

/// 课程详情URL：/Views/h5/courseDetails.html
- (NSURL* _Nullable)h5ForCourseDetailsWithCourseId:(NSString * _Nullable)courseId;

/// 课程评价：/Views/h5/Q&A.html
- (NSURL* _Nullable)h5ForCourseQAWithCourseId:(NSString * _Nullable)courseId;

/// 支付协议页面 URL：/Views/h5/paymentAgreement.html
- (NSURL* _Nullable)h5ForPaymentAgreement;

/// 优惠券说明页面 URL：/Views/h5/useProtocol.html
- (NSURL* _Nullable)h5ForCouponuseProtocol;

@end
