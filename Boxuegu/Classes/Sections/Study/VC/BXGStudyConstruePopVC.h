//
//  BXGStudyConstrueInfoController.h
//  Boxuegu
//
//  Created by HM on 2017/4/22.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGStudyBaseCourseVC.h"
#import "BXGConstrueModel.h"

@interface BXGStudyConstruePopVC : BXGStudyBaseCourseVC
@property (nonatomic, strong) BXGConstrueModel *model;
@property (nonatomic, copy) void(^toConstrueBlock)(BXGConstrueModel *model) ;
@end
