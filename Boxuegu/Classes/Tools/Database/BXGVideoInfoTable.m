//
//  BXGVideoInfoTable.m
//  FFDBPrj
//
//  Created by apple on 17/6/12.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "BXGVideoInfoTable.h"
#import "BXGDatabase.h"
#import "BXGVideoInfo.h"
#import "BXGVideoInfoItem.h"
#import "BXGVideoInfoItemTable.h"

@interface BXGVideoInfoTable()
@property(nonatomic, strong) BXGVideoInfoItemTable* videoInfoItemTable;
@end

@implementation BXGVideoInfoTable

-(instancetype)init{
    self = [super init];
    if(self)
    {
        _videoInfoItemTable = [BXGVideoInfoItemTable new];
    }
    return self;
}

+(BOOL)createTable
{
    BOOL bResult = YES;
    bResult = [BXGDATABASE executeUpdate:@"CREATE TABLE if not exists videoInfoTable(\
               videoIdx text NOT NULL PRIMARY KEY, \
               defaultDefinition integer, \
               status integer,\
               statusInfo text, \
               token text);"];
    return bResult;
}

-(BOOL)addOneRecord:(BXGVideoInfo*)model withVideoIdx:(NSString*)videoIdx
{
    BOOL bResult = YES;
    for(BXGVideoInfoItem *item in model.definitions)
    {
        bResult &= [_videoInfoItemTable addOneRecord:item withVideoIdx:videoIdx];
        
    }
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"insert or replace into videoInfoTable(\
                videoIdx, \
                defaultDefinition, \
                status, \
                statusInfo, \
                token)values('%@', %ld, '%ld', '%@', '%@');", videoIdx, (long)model.defaultDefinition, (long)model.status, model.statusInfo, model.token]];
    if(bResult)
    {
        NSLog(@"BXGVideoInfoTable the error code=%d, the error reason=%@", [BXGDATABASE lastErrorCode], [BXGDATABASE lastErrorMessage]);
    }
    return bResult;
}

-(BOOL)updateOneRecordWithNewData:(BXGVideoInfo*)model withVideoIdx:(NSString*)videoIdx
{
    BOOL bResult = YES;
    for(BXGVideoInfoItem *item in model.definitions)
    {
        bResult &= [_videoInfoItemTable updateOneRecordWithNewData:item withVideoIdx:videoIdx ];
        
    }
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"update videoInfoTable set \
                videoIdx='%@', \
                                           defaultDefinition=%ld, \
                                           status=%ld,\
                                           statusInfo='%@', \
                                           token='%@');", videoIdx, (long)model.defaultDefinition, (long)model.status, model.statusInfo, model.token]];
    return bResult;
}

-(BOOL)deleteOneRecordWithVideoIdx:(NSString*)videoIdx
{
    BOOL bResult = YES;
    bResult = [_videoInfoItemTable deleteOneRecordWithVideoIdx:videoIdx];
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"delete from videoInfoTable where videoIdx='%@';", videoIdx]];
    return bResult;
}

-(BOOL)deleteAllRecords
{
    BOOL bResult = YES;
    bResult = [_videoInfoItemTable deleteAllRecords];
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"delete from videoInfoTable;"]];
    return bResult;
}

-(BXGVideoInfo*)searchVideoInfoWithVideoIdx:(NSString*)videoIdx
{
    BXGVideoInfo* info = [BXGVideoInfo new];
    NSString* sqlStatement = [NSString stringWithFormat:@"select * from videoInfoTable where videoIdx='%@';", videoIdx];
    
    FMResultSet *resultSet = [BXGDATABASE executeQuery:sqlStatement];
    NSMutableArray* arrVideoInfoItems = [NSMutableArray new];
        while ([resultSet next]) {
            info.defaultDefinition = [resultSet intForColumn:@"defaultDefinition"];
            BXGVideoInfoItem* videoInfoItem = [_videoInfoItemTable searchVideoInfoWithVideoIdx:videoIdx];
            [arrVideoInfoItems addObject:videoInfoItem];
            info.status = [resultSet intForColumn:@"status"];
            info.statusInfo = [resultSet stringForColumn:@"statusInfo"];
            info.token = [resultSet stringForColumn:@"token"];
        }
    info.definitions = [NSArray arrayWithArray:arrVideoInfoItems];
    return info;
}

@end
