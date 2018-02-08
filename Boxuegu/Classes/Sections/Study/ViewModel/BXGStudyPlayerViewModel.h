//
//  BXGStudyPlayerViewModel.h
//  Boxuegu
//
//  Created by HM on 2017/5/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
// model
#import "BXGCourseOutlineChapterModel.h"

#import "BXGCourseModel.h"

@interface BXGStudyPlayerViewModel : BXGBaseViewModel


/// 课程大纲 缓存数据
@property (atomic, strong) NSMutableDictionary<NSString *, NSArray <BXGCourseOutlineChapterModel *> *> *courseOutlineCacheDict;

@property (atomic, strong) NSArray <BXGCourseOutlineChapterModel *> *courseOutlineModelArray;

// 接口模型
@property (nonatomic, strong) BXGCourseModel *courseModel;

@property (nonatomic, strong) NSString *courseId;
+ (instancetype)share;

// 加载课程大纲

// 选集

- (void)loadCurrentCourseOutLineFinished:(void (^)(id resultObject ,NSString *errorMessage))completedBlock;
@end
