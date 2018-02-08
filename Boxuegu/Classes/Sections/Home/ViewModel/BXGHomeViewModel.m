//
//  BXGHomeViewModel.m
//  Boxuegu
//
//  Created by apple on 2017/10/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGHomeViewModel.h"
#import "BXGHomeCourseListModel.h"
#import "BXGHomeCourseModel.h"
#import "BXGMicroFilterModel.h"
#import "BXGBannerModel.h"

#define kPageSize  10

@implementation BXGHomeViewModel

- (instancetype)init {
    self = [super init];
    if(self){
        _currentPage = 0;
        _bHaveMoreData = YES;
    }
    return self;
}

- (void)loadCourseInfoFinished:(void(^)(BOOL bSuccess, BXGHomeCourseListModel *courseListModel))finishedBlock {
    [self.networkTool requestCourseListInfoFinish :^(id  _Nullable responseObject) {
         [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
             switch (status) {
                 case BXGNetworkResultStatusSucceed:{
                     BXGHomeCourseListModel *model = [BXGHomeCourseListModel yy_modelWithDictionary:result];
                     return finishedBlock(YES, model);
                 }
                     break;
                 case BXGNetworkResultStatusFailed:
                     
                     break;
                 case BXGNetworkResultStatusExpired:
                     
                     break;
                 case BXGNetworkResultStatusParserError:
                     break;
             }
             return finishedBlock(NO, nil);
         }];
     } Failed:^(NSError * _Nonnull error) {
         finishedBlock(NO, nil);
     }];
}

- (void)loadMoreCareerCourseFinished:(void(^)(BOOL bSuccess, NSArray<BXGHomeCourseModel*> *arrCourseModel))finishedBlock {
    [self.networkTool requestMoreCareerCourseFinish:^(id _Nullable responseObject) {
         [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
             switch (status) {
                 case BXGNetworkResultStatusSucceed:{
                     if([result isKindOfClass:[NSArray class]]) {
                         NSMutableArray *arrResult = [NSMutableArray new];
                         for (NSDictionary *dictItem in result) {
                             BXGHomeCourseModel *modelItem = [BXGHomeCourseModel yy_modelWithDictionary:dictItem];
                             [arrResult addObject:modelItem];
                         }
                         return finishedBlock(YES, arrResult);
                     }
                 }
                     break;
                 case BXGNetworkResultStatusFailed:
                     
                     break;
                 case BXGNetworkResultStatusExpired:
                     
                     break;
                 case BXGNetworkResultStatusParserError:
                     break;
             }
             return finishedBlock(NO, nil);
         }];
     } Failed:^(NSError * _Nonnull error) {
         finishedBlock(NO, nil);
     }];
}

- (void)loadFilterCourseInfoWithCourseType:(NSNumber *)courseType
                              andMicroType:(NSNumber *)microType
                            andFinishBlock:(void(^)(BOOL bSuccess, BXGMicroFilterModel *model))finishedBlock {
    [self.networkTool requestFilterCourseInfoWithCourseType:courseType andMicroType:microType andFinished:^(id  _Nullable responseObject) {
        [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
            switch (status) {
                case BXGNetworkResultStatusSucceed:{
                    if([result isKindOfClass:[NSDictionary class]]) {
                        BXGMicroFilterModel *model = [BXGMicroFilterModel yy_modelWithDictionary:result];
                        return finishedBlock(YES, model);
                    }
                }
                    break;
                case BXGNetworkResultStatusFailed:
                    
                    break;
                case BXGNetworkResultStatusExpired:
                    
                    break;
                case BXGNetworkResultStatusParserError:
                    break;
            }
            return finishedBlock(NO, nil);
        }];
    } Failed:^(NSError * _Nonnull error) {
        finishedBlock(NO, nil);
    }];
}

//directionId    string    否    学科方向
//subjectId    string    否    学科
//tagId    string    否    分类
//orderType    string    否    排序方式:0-综合 1-最新 2-最热
//courseLevel    string    否    课程等级:0-基础 1-进阶 2-提高
//contentType    string    否    课程内容:0-全部 1-知识点精讲 2-项目实战
//isFree    number    否    是否免费：0-精品微课 1-免费微课
//pageNo    number    否    当前页(默认为1)
//pageSize    number    否    每页显示的条数(默认为15)
- (void)loadFilterCourseInfoWithRefresh:(BOOL)bRefresh
                         andDirectionId:(NSNumber *)directionId
                           andSubjectId:(NSNumber *)subjectId
                               andTagId:(NSNumber *)tagId
                           andOrderType:(NSNumber *)orderType
                         andCourseLevel:(NSNumber *)courseLevel
                         andContentType:(NSNumber *)contentType
                                 isFree:(NSNumber *)bFree
                         andFinishBlock:(void(^)(BOOL bSuccess, NSError *error))finishedBlock {

    if(bRefresh)
    {
        _currentPage = 0;
        _bHaveMoreData = YES;
        _arrMicroFilterData = [NSArray new];
    }
    if(!_bHaveMoreData)
    {
        return  finishedBlock(NO, nil);
    }
    _currentPage = self.arrMicroFilterData!=nil ? (self.arrMicroFilterData.count/kPageSize)+1 : 1;
    
    __weak typeof (self) weakSelf = self;
    [self.networkTool requestFilterCourseInfoWithDirectionId:directionId
                                                andSubjectId:subjectId
                                                    andTagId:tagId
                                                andOrderType:orderType
                                              andCourseLevel:courseLevel
                                              andContentType:contentType
                                                      isFree:bFree
                                                      pageNo:[NSNumber numberWithInteger:_currentPage]
                                                    pageSize:[NSNumber numberWithInteger:kPageSize]
                                                 andFinished:^(id  _Nullable responseObject) {
        [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
            switch (status) {
                case BXGNetworkResultStatusSucceed:{
                    if([result isKindOfClass:[NSArray class]]) {
                        NSMutableArray *arrResult = [[NSMutableArray alloc] initWithArray:weakSelf.arrMicroFilterData];
                        for(NSDictionary *dictItem in result) {
                            BXGHomeCourseModel *model = [BXGHomeCourseModel yy_modelWithDictionary:dictItem];
                            [arrResult addObject:model];
                        }
                        
                        if(((NSArray*)result).count<kPageSize)
                        {
                            _bHaveMoreData = NO;
                        }
                        
                        weakSelf.arrMicroFilterData = arrResult;
                        
                        return finishedBlock(YES, nil);
                    }
                }
                    break;
                case BXGNetworkResultStatusFailed:
                    break;
                case BXGNetworkResultStatusExpired:
                    break;
                case BXGNetworkResultStatusParserError:
                    break;
            }
            return finishedBlock(NO, nil);
        }];
    } Failed:^(NSError * _Nonnull error) {
        finishedBlock(NO, error);
    }];
}

- (void)loadBannerFinished:(void (^)(BOOL bSuccess, NSArray<BXGBannerModel*> *arrBannerModel))finishedBlock {
    [self.networkTool requestBannerFinished:^(id  _Nullable responseObject) {
        [BXGNetworkParser communityNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
            switch (status) {
                case BXGNetworkResultStatusSucceed:{
                    if([result isKindOfClass:[NSArray class]]) {
                        NSMutableArray *arrTemp = [NSMutableArray new];
                        for(NSDictionary *dictItem in result) {
                            BXGBannerModel *model = [BXGBannerModel yy_modelWithDictionary:dictItem];
                            [arrTemp addObject:model];
                        }
                        NSArray *arrRet = [NSArray arrayWithArray:arrTemp];
                        return finishedBlock(YES, arrRet);
                    }
                }
                    break;
                case BXGNetworkResultStatusFailed:
                    
                    break;
                case BXGNetworkResultStatusExpired:
                    
                    break;
                case BXGNetworkResultStatusParserError:
                    break;
            }
            return finishedBlock(NO, nil);
        }];
        
    } andFailed:^(NSError * _Nonnull error) {
        finishedBlock(NO, nil);
    }];
}

@end
