//
//  BXGOrderBindCouponViewModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/27.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"

@interface BXGOrderBindCouponViewModel : BXGBaseViewModel
- (void)performBindCouponWithSerialNo:(NSString *)serialNo
                          andCourseId:(NSString*)courseId
                          andFinished:(void(^)(BOOL succeed,NSString *couponId, NSNumber *isCouver, NSString *msg))finished;
@end
