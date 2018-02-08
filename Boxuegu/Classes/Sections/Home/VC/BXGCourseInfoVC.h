//
//  BXGCourseInfoVC.h
//  Boxuegu
//
//  Created by RW on 2017/10/10.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewController.h"
#import "BXGHome.h"
#import "BXGHomeCourseModel.h"
#import "BXGCourseInfoViewModel.h"

//@class BXGCourseInfoViewModel;
@protocol BXGCourseInfoFoldable
- (void)checkFoldWithScrollView:(UIScrollView *)scrollView;
@end

@interface BXGCourseInfoVC : BXGBaseRootVC <BXGCourseInfoFoldable>
- (instancetype)initWithViewModel:(BXGCourseInfoViewModel *)viewModel;
@end
