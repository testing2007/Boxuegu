//
//  BXGStudyProCoursePlanTableVC.h
//  Boxuegu
//
//  Created by HM on 2017/6/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGBaseViewController.h"
#import "BXGProCoursePlanViewModel.h"
#import "BXGProCourseModel.h"



typedef void(^DidSelectProCoursePlanBlockType)(BXGProCourseModel *model) ;

@interface BXGStudyProCoursePlanTableVC : BXGBaseViewController

- (instancetype)initWithCourseModel:(BXGCourseModel *)courseModel;

@property (nonatomic, strong) BXGProCoursePlanViewModel *viewModel;
@property (nonatomic, strong) NSDate *planDate;
@property (nonatomic, copy) DidSelectProCoursePlanBlockType didSelectProCoursePlanBlock;

// BXGProCourseModel


//NSString *userId = userModel.user_id;
//NSString *courseId = courseModel.course_id;
//NSString *sign = userModel.sign;
@end
