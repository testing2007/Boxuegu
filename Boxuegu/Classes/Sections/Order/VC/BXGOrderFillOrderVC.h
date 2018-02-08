//
//  BXGOrderFillOrderVC.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/16.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseRootVC.h"
#import "BXGHomeCourseModel.h"

@interface BXGOrderFillOrderVC : BXGBaseRootVC

//需要传递课程id数组
@property(nonatomic, strong) NSArray<NSString*> *arrCourseId;

@end
