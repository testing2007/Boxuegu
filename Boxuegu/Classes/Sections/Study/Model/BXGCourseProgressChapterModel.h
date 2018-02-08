//
//  BXGCourseProgressChapterModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/26.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGCourseProgressChapterModel : BXGBaseModel

@property (nonatomic, strong) NSString *chapterId;
@property (nonatomic, strong) NSString *chapterName;
@property (nonatomic, strong) NSNumber *videoCount;
@property (nonatomic, strong) NSNumber *learnedVideoCount;
@property (nonatomic, strong) NSNumber *unStudyCount;
@property (nonatomic, strong) NSString *isExitLearned;
@end
