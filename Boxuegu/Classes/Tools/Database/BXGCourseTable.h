//
//  BXGCourseTable.h
//  Boxuegu
//
//  Created by apple on 2017/6/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 注意课程表是只有当视频下载完成以后,才会记录信息
 //*/
@class BXGCourseModel;
@interface BXGCourseTable : NSObject

+(BOOL)createTable;

-(BOOL)addOneRecord:(BXGCourseModel*)model;
-(BOOL)updateOneRecordWithNewData:(BXGCourseModel*)model;
-(BOOL)deleteOneRecordWithCourseId:(NSString*)courseId;
-(BOOL)deleteAllRecords;
-(BXGCourseModel*)searchCourseInfoWithCourseId:(NSString*)courseId;
-(NSDictionary*)searchAllCourseInfo;

@end
