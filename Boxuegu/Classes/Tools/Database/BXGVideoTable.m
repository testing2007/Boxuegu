//
//  BXGVideoTable.m
//  Boxuegu
//
//  Created by apple on 2017/6/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGVideoTable.h"
#import "BXGDatabase.h"
#import "BXGCourseOutlineVideoModel.h"

@implementation BXGVideoTable

+(BOOL)createTable
{
    BOOL bResult = YES;
    bResult = [BXGDATABASE executeUpdate:@"CREATE TABLE if not exists videoTable(\
               idx text NOT NULL PRIMARY KEY , \
               video_id text, \
               point_idx text,\
               name text, \
               sort integer);"];
    return bResult;
}

-(BOOL)addOneRecord:(BXGCourseOutlineVideoModel*)model withPointIdx:(NSString*)point_idx
{
    BOOL bResult = YES;
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"insert or replace into videoTable(\
                                           idx, \
                                           video_id,\
                                           point_idx, \
                                           name, \
                                           sort)values('%@', '%@', '%@', '%@', %ld);", model.idx,  model.video_id, point_idx, model.name, model.sort.integerValue]];
    return bResult;
}

-(BOOL)updateOneRecordWithNewData:(BXGCourseOutlineVideoModel*)model withVideoIdx:(NSString*)videoIdx
{
    BOOL bResult = YES;
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"update videoTable set \
                                           idx='%@', \
                                           video_id='%@', \
                                           name='%@', \
                                           sort=%ld) where idx='%@';", model.idx,  model.video_id, model.name, model.sort.integerValue, videoIdx]];
    return bResult;
}

-(BOOL)deleteOneRecordWithVideoIdx:(NSString*)videoIdx
{
    BOOL bResult = YES;
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"delete from videoTable where idx='%@';", videoIdx]];
    return bResult;
}

-(BOOL)deleteAllRecords
{
    BOOL bResult = YES;
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"delete from videoTable;"]];
    return bResult;
}

-(BXGCourseOutlineVideoModel*)searchVideoWithVideoIdx:(NSString*)videoIdx
{
    BXGCourseOutlineVideoModel *model = [BXGCourseOutlineVideoModel new];
    NSString* sqlStatement = [NSString stringWithFormat:@"select * from videoTable where idx='%@';", videoIdx];
    FMResultSet *resultSet = [BXGDATABASE executeQuery:sqlStatement];
    if ([resultSet next]) {
        model.idx = [resultSet stringForColumn:@"idx"];
        model.video_id = [resultSet stringForColumn:@"video_id"];
        model.name = [resultSet stringForColumn:@"name"];
        model.sort = [resultSet objectForColumnName:@"sort"];
    }
    return model;
}

-(BXGCourseOutlineVideoModel*)searchVideoWithVideoIdx:(NSString*)videoIdx andPointIdx:(NSString*)pointIdx
{
    BXGCourseOutlineVideoModel *model = [BXGCourseOutlineVideoModel new];
    NSString* sqlStatement = [NSString stringWithFormat:@"select * from videoTable where idx='%@' and point_idx='%@';", videoIdx, pointIdx];
    FMResultSet *resultSet = [BXGDATABASE executeQuery:sqlStatement];
    if ([resultSet next]) {
        model.idx = [resultSet stringForColumn:@"idx"];
        model.video_id = [resultSet stringForColumn:@"video_id"];
        model.name = [resultSet stringForColumn:@"name"];
        model.sort = [resultSet objectForColumnName:@"sort"];
    }
    return model;
}

-(NSArray<BXGCourseOutlineVideoModel*>*)searchVideoWithPointIdx:(NSString*)pointIdx
{
    NSMutableArray<BXGCourseOutlineVideoModel*> *arrReturn = [NSMutableArray new];
    NSString* sqlStatement = [NSString stringWithFormat:@"select * from videoTable where point_idx='%@';", pointIdx];
    FMResultSet *resultSet = [BXGDATABASE executeQuery:sqlStatement];
    while([resultSet next]) {
        BXGCourseOutlineVideoModel *model = [BXGCourseOutlineVideoModel new];
        model.idx = [resultSet stringForColumn:@"idx"];
        model.video_id = [resultSet stringForColumn:@"video_id"];
        model.name = [resultSet stringForColumn:@"name"];
        model.sort = [resultSet objectForColumnName:@"sort"];
        [arrReturn addObject:model];
    }
    return [NSArray arrayWithArray:arrReturn];
}


@end
