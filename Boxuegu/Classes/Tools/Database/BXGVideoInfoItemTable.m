//
//  BXGVideoIntoItemTable.m
//  FFDBPrj
//
//  Created by apple on 17/6/12.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "BXGVideoInfoItemTable.h"
#import "BXGDatabase.h"
#import "BXGVideoInfoItem.h"

@implementation BXGVideoInfoItemTable

+(BOOL)createTable
{
    BOOL bResult = YES;
    bResult = [BXGDATABASE executeUpdate:@"CREATE TABLE if not exists videoInfoItemTable(\
               videoIdx text, \
               definition integer, \
               desp text,\
               playurl text, \
               PRIMARY KEY(videoIdx, definition));"];
    return bResult;
}

-(BOOL)addOneRecord:(BXGVideoInfoItem*)model withVideoIdx:(NSString*)videoIdx
{
    BOOL bResult = YES;
    bResult = [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"insert or replace into videoInfoItemTable(\
                videoIdx, \
                definition, \
                desp, \
                playurl)values('%@', %ld, '%@', '%@');", videoIdx, (long)model.definition, model.desp, model.playurl]];
    if(!bResult)
    {
        NSLog(@"BXGVideoInfoItemTable the error code=%d, the error reason=%@", [BXGDATABASE lastErrorCode], [BXGDATABASE lastErrorMessage]);
    }
    return bResult;
}

-(BOOL)updateOneRecordWithNewData:(BXGVideoInfoItem*)model withVideoIdx:(NSString*)videoIdx
{
    BOOL bResult = YES;
    bResult = [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"update videoInfoItemTable set \
                videoIdx='%@', \
                                          definition=%ld, \
                                          desp='%@', \
                                          playurl='%@');", videoIdx, (long)model.definition, model.desp, model.playurl]];
    return bResult;
}

-(BOOL)deleteOneRecordWithVideoIdx:(NSString*)videoIdx
{
    BOOL bResult = YES;
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"delete from videoInfoItemTable where videoIdx='%@';", videoIdx]];
    return bResult;
}

-(BOOL)deleteAllRecords
{
    BOOL bResult = YES;
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"delete from videoInfoItemTable;"]];
    return bResult;
}

-(BXGVideoInfoItem*)searchVideoInfoWithVideoIdx:(NSString*)videoIdx
{
    BXGVideoInfoItem* info = [BXGVideoInfoItem new];
    NSString* sqlStatement = [NSString stringWithFormat:@"select * from videoInfoItemTable where videoIdx='%@';", videoIdx];
    FMResultSet *resultSet = [BXGDATABASE executeQuery:sqlStatement];
    while ([resultSet next]) {
        info.definition = [resultSet intForColumn:@"definition"];
        info.desp = [resultSet stringForColumn:@"desp"];
        info.playurl = [resultSet stringForColumn:@"playurl"];
    }
    return info;
}
@end
