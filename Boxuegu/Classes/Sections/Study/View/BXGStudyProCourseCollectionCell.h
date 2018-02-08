//
//  BXGStudyProCourseCollectionCell.h
//  Boxuegu
//
//  Created by HM on 2017/4/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGProDayPlanModel.h"
#import "BXGProCoursePlanViewModel.h"

typedef void(^DidSelectProCoursePlanBlockType)(BXGProCourseModel *model) ;

@interface BXGStudyProCourseCollectionCell : UICollectionViewCell

@property (nonatomic, strong) NSDate *planDate;
@property (nonatomic, weak) BXGProCoursePlanViewModel *viewModel;
@property (nonatomic, copy) DidSelectProCoursePlanBlockType didSelectProCoursePlanBlock;

@end
