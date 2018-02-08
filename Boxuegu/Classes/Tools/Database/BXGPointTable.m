//
//  BXGPointTable.m
//  Boxuegu
//
//  Created by apple on 2017/6/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPointTable.h"
#import "BXGDatabase.h"
#import "BXGCourseOutlinePointModel.h"
#import "BXGCourseOutlineVideoModel.h"
#import "BXGVideoTable.h"

@interface BXGPointTable()
@property(nonatomic, strong) BXGVideoTable* videoTable;
@end

@implementation BXGPointTable

-(instancetype)init{
    self = [super init];
    if(self)
    {
        _videoTable = [BXGVideoTable new];
    }
    return self;
}

+(BOOL)createTable
{

        BOOL bResult = YES;
        bResult = [BXGDATABASE executeUpdate:@"CREATE TABLE if not exists pointTable(\
                   idx text NOT NULL PRIMARY KEY, \
                   name text, \
                   parent_id text,\
                   lock_status integer, \
                   barrier_status integer, \
                   sort integer);"];
        return bResult;
}

-(BOOL)addOneRecord:(BXGCourseOutlinePointModel*)model
{
        BOOL bResult = YES;
        NSString* point_idx = model.idx;
        for(BXGCourseOutlineVideoModel *item in model.videos)
        {
            bResult &= [_videoTable addOneRecord:item withPointIdx:point_idx];
        }
        bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"insert or replace into pointTable(\
                                               idx, \
                                               name, \
                                               parent_id,\
                                               lock_status, \
                                               barrier_status, \
                                               sort)values('%@', '%@', '%@', %ld, %ld, %ld);", model.idx, model.name, model.parent_id, model.lock_status.integerValue, model.barrier_status.integerValue, model.sort.integerValue]];
    
        if(bResult)
        {
            NSLog(@"pointTable the error code=%d, the error reason=%@", [BXGDATABASE lastErrorCode], [BXGDATABASE lastErrorMessage]);
        }
        return bResult;
}

-(BOOL)updateOneRecordWithNewData:(BXGCourseOutlinePointModel*)model
{
    BOOL bResult = YES;
    for(BXGCourseOutlineVideoModel *item in model.videos)
    {
        bResult &= [_videoTable updateOneRecordWithNewData:item withVideoIdx:item.idx];
    }
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"update pointTable set \
                                          idx='%@', \
                                          name='%@', \
                                          parent_id='%@',\
                                          lock_status=%ld, \
                                          barrier_status=%ld, \
                                          sort=%ld) where idx='%@';", model.idx, model.name, model.parent_id, model.lock_status.integerValue, model.barrier_status.integerValue, model.sort.integerValue, model.idx]];
    return bResult;
}

-(BOOL)deleteOneRecordWithPointId:(NSString*)pointId withArrDownloadedVideoIdx:(NSArray*)arrVideoIdx
{
        BOOL bResult = YES;
        for (NSString* videoIdx in arrVideoIdx) {
            bResult &= [_videoTable deleteOneRecordWithVideoIdx:videoIdx];
        }
        bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"delete from pointTable where idx='%@';", pointId]];
        return bResult;
}

-(BOOL)deleteAllRecords
{
    BOOL bResult = YES;
    bResult = [_videoTable deleteAllRecords];
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"delete from pointTable;"]];
    return bResult;
}

-(BXGCourseOutlinePointModel*)searchVideoInfoWithPointId:(NSString*)pointId
{
    BXGCourseOutlinePointModel *model = [BXGCourseOutlinePointModel new];
    NSString* sqlStatement = [NSString stringWithFormat:@"select * from pointTable where idx='%@';", pointId];
    FMResultSet *resultSet = [BXGDATABASE executeQuery:sqlStatement];
    if ([resultSet next]) {
        model.idx = [resultSet stringForColumn:@"idx"];
        NSArray<BXGCourseOutlineVideoModel*> *arrVideoModel = [_videoTable searchVideoWithPointIdx:model.idx];
        model.videos = arrVideoModel;
        model.name = [resultSet stringForColumn:@"name"];
        model.parent_id = [resultSet stringForColumn:@"parent_id"];
        model.lock_status = [resultSet objectForColumnName:@"lock_status"];
        model.barrier_status = [resultSet objectForColumnName:@"barrier_status"];
        model.sort = [resultSet objectForColumnName:@"sort"];
    }
    return model;
}

@end
