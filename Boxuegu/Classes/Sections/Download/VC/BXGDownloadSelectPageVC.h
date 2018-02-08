//
//  BXGDownloadSelectPageVC.h
//  Boxuegu
//
//  Created by apple on 2017/6/16.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGBaseViewController.h"

@class BXGCourseModel;
@class BXGCourseOutlinePointModel;

@interface BXGDownloadSelectPageVC : BXGBaseRootVC

-(void)enterDownloadSelectPageWithCourseModel:(BXGCourseModel*)courseModel
                                   pointModel:(BXGCourseOutlinePointModel*)pointModel;

@end
