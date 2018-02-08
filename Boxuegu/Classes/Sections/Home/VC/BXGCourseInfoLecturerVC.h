//
//  BXGCourseInfoLecturerVC.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewController.h"
#import "BXGCourseInfoVC.h"

@class BXGCourseLecturerModel;

/**
 讲师列表 (可替换成View)
 */
@class BXGCourseInfoLecturerViewModel;
@interface BXGCourseInfoLecturerVC : BXGBaseViewController
@property (nonatomic, strong) NSArray<BXGCourseLecturerModel *> *lecturerModels;
@property (nonatomic, weak) id<BXGCourseInfoFoldable> foldDelegate;
- (instancetype)initWithViewModel:(BXGCourseInfoLecturerViewModel *)viewModel;
@end
