//
//  BXGConstruePlanMonthItemModel.h
//  Boxuegu
//
//  Created by wurenying on 2018/1/10.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGConstruePlanMonthItemModel : BXGBaseModel
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *hasPlan;
@end
