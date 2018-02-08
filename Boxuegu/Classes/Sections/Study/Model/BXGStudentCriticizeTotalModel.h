//
//  BXGStudentCriticizeTotalModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"
#import "BXGStudentCriticizeModel.h"

@interface BXGStudentCriticizeTotalModel : BXGBaseModel

@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *totalCount;
@property (nonatomic, strong) NSString *greatCount;
@property (nonatomic, strong) BXGStudentCriticizeModel *criticize;
@end
