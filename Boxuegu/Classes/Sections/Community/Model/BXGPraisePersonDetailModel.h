//
//  BXGPraisePersonDetailModel.h
//  Boxuegu
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@class BXGCommunityUserModel;
@interface BXGPraisePersonDetailModel : BXGBaseModel

@property(nonatomic, strong) NSNumber *currentPage; //currentPage (integer, optional): 当前页数 ,
@property(nonatomic, assign) BOOL firstPage; //firstPage (boolean, optional): 当前页是否是第一页 ,
@property(nonatomic, strong) NSArray<BXGCommunityUserModel*> *items; //items (Array[Comment], optional): 数据结果集合 ,
@property(nonatomic, assign) BOOL lastPage; //lastPage (boolean, optional): 当前页是否是最后一页 ,
@property(nonatomic, strong) NSNumber *nextPage; //nextPage (integer, optional): 当前页数下一页 ,
@property(nonatomic, strong) NSNumber *offset; //offset (integer, optional): 当前页第一条记录在总结果集中的位置，序号从0开始 ,
@property(nonatomic, strong) NSNumber *pageSize; //pageSize (integer, optional): 每页记录个数 ,
@property(nonatomic, strong) NSNumber *prevPage; //prevPage (integer, optional): 当前页数前一页 ,
@property(nonatomic, strong) NSNumber *totalCount; //totalCount (integer, optional): 总记录数 ,
@property(nonatomic, strong) NSNumber *totalPageCount; //totalPageCount (integer, optional): 总页数


@end
