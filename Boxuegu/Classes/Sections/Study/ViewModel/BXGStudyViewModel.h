//
//  BXGStudyViewModel.h
//  Boxuegu
//
//  Created by RW on 2017/4/12.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGBaseViewModel.h"
#import "BXGCourseModel.h"

@interface BXGStudyViewModel : BXGBaseViewModel

+ (instancetype _Nullable )share;

// - (void)loadAppCourceIsUpdate:(BOOL)isUpdate andFinished:(void(^_Nullable)(BOOL succeed, NSString * _Nullable message))finishedBlock;

@property (nonatomic, strong) NSArray<BXGCourseModel *> * _Nullable proCourseModelArray;
@property (nonatomic, strong) NSArray<BXGCourseModel *> * _Nullable miniCourseModelArray;

- (void)requestReLoginFinished:(void(^ _Nullable)(BOOL success))finishedBlock;
- (void)requestUpdateOfflineStudyStatusWithFinished:(void(^ _Nullable)(BOOL success))finishedBlock;
- (void)loadLastLearnHistoryWithFinished:(void(^ _Nullable)(id _Nullable model))finishedBlock;

/// 加载学习中心所有课程数据
- (void)loadAppCourseFinished:(void(^_Nullable)(BOOL succeed,
                                                NSArray * _Nullable procourseModelArray,
                                                NSArray * _Nullable minicourseModelArray,
                                                NSString * _Nullable message))finishedBlock;
@end
