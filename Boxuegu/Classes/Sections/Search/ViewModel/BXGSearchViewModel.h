//
//  BXGSearchViewModel.h
//  Boxuegu
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
#import "BXGSearchCourseModel.h"
#import "BXGSearchHotKeywordModel.h"

@interface BXGSearchViewModel : BXGBaseViewModel

///搜索课程列表
- (void)loadRequestSearchCourseListByRefresh:(BOOL)bRefresh
                                  andKeyword:(NSString *_Nullable)keyword
                              andFinishBlock:(void (^)(BOOL bSuccess, NSString *errorMessage, BXGSearchCourseModel* courseModel))finishBlock;

///热门搜索关键字
- (void)loadRequestSearchHotKeywordWithFinishBlock:(void (^)(BOOL bSuccess, NSString *errorMessage, NSArray<BXGSearchHotKeywordModel*>* arrCourseList))finishBlock;

@property (nonatomic, assign) BOOL haveMoreCourseModelData;

@end
