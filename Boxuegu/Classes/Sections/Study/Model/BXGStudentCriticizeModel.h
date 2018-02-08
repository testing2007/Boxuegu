//
//  BXGStudentCriticizeModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"
#import "BXGStudentCriticizeItemModel.h"

@interface BXGStudentCriticizeModel : BXGBaseModel

@property (nonatomic, strong) NSString *totalCount;
@property (nonatomic, strong) NSString *totalPageCount;
@property (nonatomic, strong) NSString *pageSize;
@property (nonatomic, strong) NSString *currentPage;
@property (nonatomic, strong) NSArray<BXGStudentCriticizeItemModel *> *items;

@end
