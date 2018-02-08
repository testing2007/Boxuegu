//
//  BXGReportTypeModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGReportTypeModel : BXGBaseModel
// @property (nonatomic, strong)
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSNumber *idx;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *name;
@end
