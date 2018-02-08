//
//  BXGHistoryModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGCourseModel.h"
#import "BXGCourseOutlineSectionModel.h"

@interface BXGHistoryModel : BXGBaseModel

//video_name = 00-PhotoshopCC 软件卸载、安装、破解,
//video_id = 2c9081915c63dda7015c6d5ce50403cb,
//course_name = 王者荣耀二,
//videoForChapter = <null>,
//user_id = <null>,
//learnedLength = <null>,
//chapter_id = 2c9081915c63dda7015c6d5ce4f80340,
//smallimgPaht = ,
//courseLength = <null>,
//last_learn_time = 2017-07-10 18:01:17,
//chapterLength = <null>,
//course_id = 347

@property (nonatomic, strong) NSString *course_id;
@property (nonatomic, strong) NSString *course_name;
@property (nonatomic, strong) NSString *zhang_id;
@property (nonatomic, strong) NSString *jie_id;
@property (nonatomic, strong) NSString *dian_id;
@property (nonatomic, strong) NSString *video_id;
@property (nonatomic, strong) NSString *cc_video_id;
@property (nonatomic, strong) NSString *video_name;
@property (nonatomic, assign) double seek_time;
@property (nonatomic, assign) double create_time;
@property (nonatomic, strong) NSString *smallimgPath;
@property (nonatomic, assign) double per;
@property (nonatomic, strong) NSString *course_type;
@property (nonatomic, strong) NSString *last_learn_time;

// Extension
- (BXGCourseModel *)generateCourseModel;
- (BXGCourseOutlineSectionModel *)generateSectionModel;
@end
