//
//  BXGCourseStudentCriticizedView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGCourseInfoVC.h"

@class BXGCourseDetailCriticizedViewModel;

@interface BXGCourseStudentCriticizedView : UIView
@property (nonatomic, weak) id<BXGCourseInfoFoldable> foldDelegate;
- (instancetype)initWithViewModel:(BXGCourseDetailCriticizedViewModel *)viewModel;
@property (nonatomic, assign) BOOL headerReflashEnabled;
@property (nonatomic, assign) BOOL footerReflashEnabled;
@property (nonatomic, strong) NSString *courseId;
@end
