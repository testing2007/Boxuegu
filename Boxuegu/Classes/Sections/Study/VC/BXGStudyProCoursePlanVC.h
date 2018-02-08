//
//  BXGStudyProfessionalCourseController.h
//  Boxuegu
//
//  Created by HM on 2017/4/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGStudyBaseCourseVC.h"
//#import "BXGCourseDetailViewModel.h"

#import "BXGProCoursePlanViewModel.h"

@interface BXGStudyProCoursePlanVC : BXGStudyBaseCourseVC
@property (nonatomic, weak) BXGProCoursePlanViewModel *viewModel;
@property (nonatomic, strong) NSArray *dateArray;
- (void)updateLayout;
@end
