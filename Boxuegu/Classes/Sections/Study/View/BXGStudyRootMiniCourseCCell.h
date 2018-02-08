//
//  BXGStudyRootMiniCourseCCell.h
//  Boxuegu
//
//  Created by HM on 2017/6/13.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGCourseModel.h"
#import "BXGCourseDetailViewModel.h"
@interface BXGStudyRootMiniCourseCCell : UICollectionViewCell
@property (nonatomic, strong) BXGCourseDetailViewModel *courseDetailViewModel;

@property (nonatomic, strong) BXGCourseModel *model;
@end
