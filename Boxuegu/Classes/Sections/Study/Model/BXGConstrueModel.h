//
//  BXGConstrueModel.h
//  Boxuegu
//
//  Created by HM on 2017/4/26.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 学习中心 - 串讲信息卡模型
 */
@interface BXGConstrueModel : BXGBaseModel

@property (nonatomic, strong) NSString *idx;
@property (nonatomic, strong) NSString *chuanjiang_end_time;
@property (nonatomic, strong) NSString *chuanjiang_mode;
@property (nonatomic, strong) NSString *chuanjiang_start_time;
@property (nonatomic, strong) NSString *chuanjiang_lecturer_id;
@property (nonatomic, strong) NSString *chuanjiang_room_link;
@property (nonatomic, strong) NSString *plan_date;
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *chuanjiang_room_id;
@property (nonatomic, strong) NSString *chuanjiang_name;
@property (nonatomic, strong) NSString *teacher_name;
@property (nonatomic, strong) NSString *chuanjiang_has;
@property (nonatomic, strong) NSString *chuanjiang_duration;
@end
