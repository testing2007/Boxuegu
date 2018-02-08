//
//  BXGOrderBindCouponView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGOrderBindCouponView : UIView
- (instancetype)initWithBind:(void(^)(bool success, NSString *msg,NSString *couponId))bindSerialNoBlock
                 andCourseId:(NSString*)courseId;
@property (nonatomic, copy) void(^bindSerialNoBlock)(bool success, NSString *msg, NSString *couponId);
@property (nonatomic, strong) UITextField *inputTF;
@end
