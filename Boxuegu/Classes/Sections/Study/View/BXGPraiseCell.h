//
//  BXGPraiseCell.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/21.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGStudentCriticizeItemModel.h"
@class BXGCourseLecturerModel;
@interface BXGPraiseCell : UITableViewCell
@property (nonatomic, strong) BXGStudentCriticizeItemModel *model;
@property (nonatomic, strong) BXGCourseLecturerModel *lecturerModel;
@end
