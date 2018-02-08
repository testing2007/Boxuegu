//
//  BXGCourseInfoLecturerView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGCourseInfoVC.h"

@class BXGCourseLecturerModel;
@interface BXGCourseInfoLecturerView : UIView
@property (nonatomic, strong) NSArray<BXGCourseLecturerModel *> *lecturerModels;
@property (nonatomic, weak) id<BXGCourseInfoFoldable> foldDelegate;
@end
