//
//  BXGCourseInfoOutlineViewModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
@class BXGCourseInfoChapterModel;
@interface BXGCourseInfoOutlineViewModel : BXGBaseViewModel
- (instancetype)initWithCourseId:(NSString *)courseId;
@property (nonatomic, strong) NSString *courseId;
- (void)loadCourseInfoOutlineWithFinishedBlock:(void(^)(NSMutableArray<BXGCourseInfoChapterModel*>*chapterModels)) finishedBlock;
@end
