//
//  BXGPointTable.h
//  Boxuegu
//
//  Created by apple on 2017/6/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGCourseOutlinePointModel.h"

@interface BXGPointTable : NSObject

+(BOOL)createTable;

-(BOOL)addOneRecord:(BXGCourseOutlinePointModel*)model;
-(BOOL)updateOneRecordWithNewData:(BXGCourseOutlinePointModel*)model;
-(BOOL)deleteOneRecordWithPointId:(NSString*)pointId withArrDownloadedVideoIdx:(NSArray*)arrVideoIdx;
-(BOOL)deleteAllRecords;
-(BXGCourseOutlinePointModel*)searchVideoInfoWithPointId:(NSString*)pointId;

@end
