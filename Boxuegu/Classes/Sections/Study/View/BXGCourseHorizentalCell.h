//
//  BXGStudyTableViewCell.h
//  Boxuegu
//
//  Created by RW on 2017/4/12.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BXGCourseModel.h"
#import "BXGHistoryModel.h"
#import "BXGLearningRecordModel.h"
#import "BXGCourseNoteModel.h"

@interface BXGCourseHorizentalCell : UITableViewCell

@property (nonatomic, strong) BXGCourseModel *model;
@property (nonatomic, strong) BXGHistoryModel *historyModel;
@property (nonatomic, strong) BXGLearningRecordModel *recordModel;
@property (nonatomic, strong) BXGCourseNoteModel *courseNoteModel;

@property (nonatomic, assign) BOOL isPurchase;
@property (nonatomic, copy) void(^clickAddBtnBlock)(BXGCourseModel *model);
@end
