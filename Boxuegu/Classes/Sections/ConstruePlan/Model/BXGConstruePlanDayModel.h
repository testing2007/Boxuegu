//
//  BXGConstruePlanDayModel.h
//  Boxuegu
//
//  Created by wurenying on 2018/1/10.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGConstruePlanDayModel : BXGBaseModel
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *duration; // 100
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime; // "2017-12-29 01:40"
@property (nonatomic, strong) NSString *idx; // 101
@property (nonatomic, strong) NSString *isCallBack; // Y N string
@property (nonatomic, strong) NSString *liveRoom;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *onAir; // Y N string
@property (nonatomic, strong) NSString *subjectId;
@property (nonatomic, strong) NSString *subjectName;
@property (nonatomic, strong) NSString *teacher;
@property (nonatomic, strong) NSString *recommend;

@end
