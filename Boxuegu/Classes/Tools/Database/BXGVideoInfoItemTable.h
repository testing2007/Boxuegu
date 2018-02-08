//
//  BXGVideoIntoItemTable.h
//  FFDBPrj
//
//  Created by apple on 17/6/12.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BXGVideoInfoItem;
@interface BXGVideoInfoItemTable : NSObject

+(BOOL)createTable;

-(BOOL)addOneRecord:(BXGVideoInfoItem*)model withVideoIdx:(NSString*)videoIdx;
-(BOOL)updateOneRecordWithNewData:(BXGVideoInfoItem*)model withVideoIdx:(NSString*)videoIdx;
-(BOOL)deleteOneRecordWithVideoIdx:(NSString*)videoIdx;
-(BOOL)deleteAllRecords;
-(BXGVideoInfoItem*)searchVideoInfoWithVideoIdx:(NSString*)videoIdx;

@end
