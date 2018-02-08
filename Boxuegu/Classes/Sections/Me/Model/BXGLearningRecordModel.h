//
//  BXGLearningRecordModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/8.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"
#import "BXGCourseModel.h"
#import "BXGCourseOutlineSectionModel.h"

@interface BXGLearningRecordModel : BXGBaseModel
- (BXGCourseModel *)generateCourseModel;
- (BXGCourseOutlineSectionModel *)generateSectionModel;

@property (nonatomic, strong) NSString *idx;
@property (nonatomic, strong) NSString *video_name;
@property (nonatomic, strong) NSString *video_id;
@property (nonatomic, strong) NSString *course_name;
@property (nonatomic, strong) NSString *smallimgPath;
@property (nonatomic, strong) NSString *point_id;
@property (nonatomic, strong) NSString *last_learn_time;
@property (nonatomic, strong) NSString *section_id;
@property (nonatomic, strong) NSString *course_id;
@property (nonatomic, strong) NSString *courseType;
@end
//id = 2c9081915c63dda7015c6d573e33026e,
//video_name = 00-回顾,
//video_id = 2c9081915c63dda7015c6d573e33026e,
//course_name = 测试数据0527,
//smallimgPath = http://attachment-center.boxuegu.com:58000/data/picture/online/2017/06/15/22/98d03e3c792e45c4a3eb6418bc26a6c9.jpg,
//point_id = 2c9081915c63dda7015c6d573e1d01e0,
//videoForChapter = <null>,
//learnedLength = <null>,
//courseLength = <null>,
//last_learn_time = 2017-06-16 18:08:30,
//section_id = 2c9081915c63dda7015c6d573e1d01e0,
//chapterLength = <null>,
//course_id = 340,
//courseType = 1
