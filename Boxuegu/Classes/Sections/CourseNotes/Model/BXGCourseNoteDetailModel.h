//
//  BXGCourseNoteDetailModel.h
//  Boxuegu
//
//  Created by apple on 2017/8/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGCourseNoteDetailModel : BXGBaseModel

@property(nonatomic, strong) NSString *idx;
@property(nonatomic, strong) NSString *course_id;
@property(nonatomic, strong) NSString *video_id;
@property(nonatomic, strong) NSString *chapter_id;
@property(nonatomic, strong) NSString *user_id;
@property(nonatomic, strong) NSString *user_name;
@property(nonatomic, strong) NSString *small_head_photo;
@property(nonatomic, strong) NSString *grade_id;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSNumber *praise_sum;//点赞数目
@property(nonatomic, strong) NSString *is_share;
@property(nonatomic, strong) NSNumber *comment_sum;//评论数
@property(nonatomic, strong) NSString *create_time;
@property(nonatomic, strong) NSString *create_person;
@property(nonatomic, strong) NSNumber *praise;
@property(nonatomic, strong) NSNumber *collect;
@property(nonatomic, strong) NSNumber *deleteButton;

@end
