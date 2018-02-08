//
//  BXGPostTopicModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGPostTopicModel : BXGBaseModel
@property (nonatomic, strong) NSNumber *basicId;
@property (nonatomic, strong) NSString *createPerson;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSNumber *idx;
@property (nonatomic, strong) NSNumber *isDelete;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *sort;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSString *updatePerson;
@property (nonatomic, strong) NSString *updateTime;
@end
