//
//  BXGHistoryTable.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGHistoryModel.h"

@interface BXGHistoryTable : NSObject
+(BOOL)createTable;

-(BOOL)addOneRecord:(BXGHistoryModel*)model;

-(BOOL)deleteAllRecords;

- (BXGHistoryModel *)searchHistoryWithCourseId:(NSString *)courseId andZhangId:(NSString *)zhangId;

- (BXGHistoryModel *)searchHistoryWithCourseId:(NSString *)courseId andJieId:(NSString *)jieId;

- (BXGHistoryModel *)searchLastHistory;

- (BXGHistoryModel *)searchLastHistoryWithCourseId:(NSString *)courseId;

- (NSArray <BXGHistoryModel *> *)searchGroupLastHistory;

- (double)seekPercentWithCourseId:(NSString *)courseId andVideoId:(NSString *)videoId;
- (BOOL)autoClearData;
@end
