//
//  BXGOrderFreeCoursePopVC.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewController.h"
@class BXGHomeCourseModel;
@interface BXGOrderFreeCoursePopVC : BXGBaseViewController
@property (nonatomic, copy) void(^clickAcceptBtnBlock)();
@property (nonatomic, copy) void(^clickCancleBtnBlock)();
@property (nonatomic, strong) BXGHomeCourseModel *courseModel;
@end
