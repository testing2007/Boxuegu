//
//  BXGSearchViewModel.m
//  Boxuegu
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGSearchViewModel.h"
#import "BXGSearchCourseModel.h"
#import "BXGSearchHotKeywordModel.h"

#define kBXGSearchPageSize 10

@interface BXGSearchViewModel()
@property (nonatomic, strong) BXGSearchCourseModel* courseModel;
@property (nonatomic, assign) NSInteger currentSearchCoursePageIndex;
@property (nonatomic, strong) NSArray<BXGSearchHotKeywordModel*> *arrSearchHotKeywordModel;
@end

@implementation BXGSearchViewModel


- (instancetype)init {
    self = [super init];
    if(self) {
        _haveMoreCourseModelData = YES;
        _courseModel = nil;
        _currentSearchCoursePageIndex = 1;
        _arrSearchHotKeywordModel = [NSMutableArray new];
    }
    return self;
}

- (void)loadRequestSearchCourseListByRefresh:(BOOL)bRefresh
                                  andKeyword:(NSString *_Nullable)keyword
                              andFinishBlock:(void (^)(BOOL bSuccess, NSString *errorMessage, BXGSearchCourseModel* courseModel))finishBlock {
    if(keyword==nil || keyword.length==0) {
        finishBlock(NO, @"查询关键字为空", nil);
        return ;
    }
    if(finishBlock==nil) {
        return ;
    }
    
    if(bRefresh) {
        _currentSearchCoursePageIndex = 1;
        _haveMoreCourseModelData = YES;
        _courseModel = [BXGSearchCourseModel new];
    }
        
    if(!_haveMoreCourseModelData) {
        finishBlock(YES, @"成功", _courseModel);
        return ;
    }
    
    __weak typeof(self) weakSelf = self;
    [[BXGNetWorkTool sharedTool] appRequestSearchCourseListByKeyword:keyword
                                                          PageNumber:[NSString stringWithFormat:@"%ld", (long)_currentSearchCoursePageIndex]
                                                            PageSize:[NSString stringWithFormat:@"%d", kBXGSearchPageSize]
                                                            Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        if(status==200) {
            if([result isKindOfClass:[NSDictionary class]]) {
                BXGSearchCourseModel *courseModel = [BXGSearchCourseModel yy_modelWithDictionary:result];
                weakSelf.courseModel.totalCount = courseModel.totalCount;
                [weakSelf.courseModel.items addObjectsFromArray:courseModel.items];
                _currentSearchCoursePageIndex++;
                if(courseModel.items.count<kBXGSearchPageSize) {
                    weakSelf.haveMoreCourseModelData = NO;
                }
                finishBlock(YES, @"成功", weakSelf.courseModel);
            } else {
                finishBlock(NO, @"失败", nil);
            }
        } else {
            finishBlock(NO, @"失败", nil);
        }
    }];
}

- (void)loadRequestSearchHotKeywordWithFinishBlock:(void (^)(BOOL bSuccess, NSString *errorMessage, NSArray<BXGSearchHotKeywordModel*>* arrCourseList))finishBlock {
    if(finishBlock==nil) {
        return ;
    }
    
    [[BXGNetWorkTool sharedTool] appRequestSearchHotKeywordWithFinished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        if(status==200) {
            if([result isKindOfClass:[NSArray class]]) {
                NSMutableArray *arrTemp = [NSMutableArray new];
                for(NSDictionary *dictItem in result) {
                    BXGSearchHotKeywordModel *model = [BXGSearchHotKeywordModel yy_modelWithDictionary:dictItem];
                    [arrTemp addObject:model];
                }
                NSArray *arrRet = [NSArray arrayWithArray:arrTemp];
                return finishBlock(YES, @"成功", arrRet);
            } else {
                finishBlock(NO, @"失败", nil);
            }
        } else {
            finishBlock(NO, @"失败", nil);
        }
    }];
}


@end
