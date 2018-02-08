//
//  BXGVideoTable.h
//  Boxuegu
//
//  Created by apple on 2017/6/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGCourseOutlineVideoModel.h"

@interface BXGVideoTable : NSObject

+(BOOL)createTable;

-(BOOL)addOneRecord:(BXGCourseOutlineVideoModel*)model withPointIdx:(NSString*)point_idx;
-(BOOL)updateOneRecordWithNewData:(BXGCourseOutlineVideoModel*)model withVideoIdx:(NSString*)videoIdx;
-(BOOL)deleteOneRecordWithVideoIdx:(NSString*)videoIdx;
-(BOOL)deleteAllRecords;
-(BXGCourseOutlineVideoModel*)searchVideoWithVideoIdx:(NSString*)videoIdx;
-(BXGCourseOutlineVideoModel*)searchVideoWithVideoIdx:(NSString*)videoIdx andPointIdx:(NSString*)pointIdx;
-(NSArray<BXGCourseOutlineVideoModel*>*)searchVideoWithPointIdx:(NSString*)pointIdx;

@end
