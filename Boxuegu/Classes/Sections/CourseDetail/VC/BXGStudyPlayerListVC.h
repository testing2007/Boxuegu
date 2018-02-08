//
//  BXGStudyPlayerListTableViewController.h
//  Boxuegu
//
//  Created by Renying Wu on 2017/4/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGBaseViewController.h"
#import "BXGCourseDetailViewModel.h"


#import "BXGCourseOutlinePointModel.h"

@interface BXGStudyPlayerListVC : UIViewController
@property(nonatomic, strong) BXGCourseDetailViewModel *courseDetailViewModel;
@property (nonatomic, copy) void(^playBlock)(BXGCourseOutlinePointModel *pointModel,BXGCourseOutlineVideoModel *videoModel);
@property (nonatomic, copy) BXGCourseOutlineVideoModel *(^playVideoBlock)(BXGCourseOutlineVideoModel *videoModel);


- (void)updateCurrentVideoModel:(BXGCourseOutlineVideoModel *)videoModel;
- (void)searchVideoModel:(BXGCourseOutlineVideoModel *)videoModel;
- (void)scrollToModel:(id)model;
@end
