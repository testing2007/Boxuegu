//
//  BXGCourseProgressInfoModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/26.
//  Copyright © 2017年 itcast. All rights reserved.
//

//#import "BXGBaseModel.h"


#import "BXGCourseProgressChapterModel.h"

@interface BXGCourseProgressInfoModel : BXGBaseModel

@property (nonatomic, strong) NSString *course_id;
@property (nonatomic, strong) NSString *course_name;
@property (nonatomic, strong) NSString *descriptionX;
@property (nonatomic, strong) NSString *course_length;
@property (nonatomic, strong) NSString *course_type;
@property (nonatomic, strong) NSString *learnd_count;
@property (nonatomic, strong) NSString *course_count;
@property (nonatomic, strong) NSString *learndVideo;
@property (nonatomic, strong) NSString *unStudy;
@property (nonatomic, strong) NSString *studentCount;
@property (nonatomic, strong) NSString *studentRanking;
@property (nonatomic, strong) NSString *barrierCount;
@property (nonatomic, strong) NSString *passBarrier;
@property (nonatomic, strong) NSString *chapterCount;
@property (nonatomic, strong) NSArray<BXGCourseProgressChapterModel *> *chapterList;
@end
