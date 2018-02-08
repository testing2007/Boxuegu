//
//  BXGStudentCriticizeItemModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGStudentCriticizeItemModel : BXGBaseModel

@property (nonatomic, strong) NSString *criticizeId;
@property (nonatomic, strong) NSString *createPerson;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *chapterId;
@property (nonatomic, strong) NSString *videoId;
@property (nonatomic, strong) NSString *starLevel;
@property (nonatomic, strong) NSString *praiseSum;
@property (nonatomic, strong) NSString *praiseLoginNames;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *isPraise;
@property (nonatomic, strong) NSString *smallPhoto;
@property (nonatomic, strong) NSString *courseId;
@property (nonatomic, strong) NSString *response;
@property (nonatomic, strong) NSString *response_time;
@property (nonatomic, strong) NSString *videoName;
@end
