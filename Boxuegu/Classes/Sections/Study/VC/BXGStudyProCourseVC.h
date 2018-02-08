//
//  BXGStudyRootController.h
//  Boxuegu
//
//  Created by HM on 2017/4/12.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGBaseViewController.h"

#import "BXGStudyViewModel.h"
#import "BXGProCoursePlanViewModel.h"

// 1.1.1
@interface BXGStudyProCourseVC : BXGBaseRootVC
- (instancetype)initWithCourseDetailViewModel:(BXGProCoursePlanViewModel *)viewModel;

@property (nonatomic, strong) BXGProCoursePlanViewModel *viewModel;

@end
