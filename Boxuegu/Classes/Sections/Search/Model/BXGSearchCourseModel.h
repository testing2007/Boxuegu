//
//  BXGSearchCourseModel.h
//  Boxuegu
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"
#import "BXGHomeCourseModel.h"

@interface BXGSearchCourseModel : BXGBaseModel

@property (nonatomic, strong) NSString *totalCount;
@property (nonatomic, strong) NSMutableArray<BXGHomeCourseModel *> *items;

@end
