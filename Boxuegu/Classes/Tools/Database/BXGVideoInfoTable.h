//
//  BXGVideoInfoTable.h
//  FFDBPrj
//
//  Created by apple on 17/6/12.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BXGVideoInfo;
@interface BXGVideoInfoTable : NSObject

+(BOOL)createTable;

-(BOOL)addOneRecord:(BXGVideoInfo*)model withVideoIdx:(NSString*)videoIdx;
-(BOOL)updateOneRecordWithNewData:(BXGVideoInfo*)model withVideoIdx:(NSString*)videoIdx;
-(BOOL)deleteOneRecordWithVideoIdx:(NSString*)videoIdx;
-(BOOL)deleteAllRecords;
-(BXGVideoInfo*)searchVideoInfoWithVideoIdx:(NSString*)videoId;

@end
