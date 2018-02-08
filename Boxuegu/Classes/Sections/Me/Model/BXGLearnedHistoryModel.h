//
//  BXGLearnedRecordModel.h
//  Boxuegu
//
//  Created by RW on 2017/6/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGLearnedHistoryModel : BXGBaseModel

@property(nonatomic, strong) NSString *idx;
@property(nonatomic, strong) NSString *video_id;
@property(nonatomic, strong) NSString *course_id;
@property(nonatomic, strong) NSString *point_id;
@property(nonatomic, strong) NSString *section_id;
@property(nonatomic, strong) NSString *video_name;
@property(nonatomic, strong) NSString *last_learn_time;

@end
