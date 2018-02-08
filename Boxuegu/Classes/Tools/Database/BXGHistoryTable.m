//
//  BXGHistoryTable.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGHistoryTable.h"
#import "BXGDatabase.h"
//@property (nonatomic, strong) NSString *course_id;
//@property (nonatomic, strong) NSString *zhang_id;
//@property (nonatomic, strong) NSString *dian_id;
//@property (nonatomic, strong) NSString *video_id;
//@property (nonatomic, assign) float seek_time;
@implementation BXGHistoryTable
+(BOOL)createTable
{
    BOOL bResult = YES;
    
    // type
    
    // course_type
    bResult = [BXGDATABASE executeUpdate:@"CREATE TABLE if not exists historyTable(\
               course_id text NOT NULL, \
               course_name text, \
               zhang_id text NOT NULL, \
               jie_id text NOT NULL, \
               dian_id text,\
               video_id text, \
               video_name text, \
               create_time double, \
               smallimgPath text, \
               per double, \
               course_type text, \
               primary key(course_id, jie_id, video_id) \
               );"];
    return bResult;
}

-(BOOL)addOneRecord:(BXGHistoryModel*)model
{
    BOOL bResult = YES;
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"insert or replace into historyTable(\
                                           course_id, \
                                           course_name, \
                                           zhang_id, \
                                           jie_id, \
                                           dian_id, \
                                           video_id, \
                                           video_name, \
                                           per, \
                                           smallimgPath, \
                                           create_time, \
                                           course_type)values('%@', '%@', '%@', '%@', '%@', '%@', '%@', %f, '%@', %f, %@);",
                                           model.course_id,
                                           model.course_name,
                                           model.zhang_id,
                                           model.jie_id,
                                           model.dian_id,
                                           model.video_id,
                                           model.video_name,
                                           model.per,
                                           model.smallimgPath,
                                           model.create_time,
                                           model.course_type]];
    if(!bResult)
    {
        NSLog(@"historyTable the error code=%d, the error reason=%@", [BXGDATABASE lastErrorCode], [BXGDATABASE lastErrorMessage]);
    }
    
    
    return bResult;
}

-(BOOL)deleteAllRecords
{
    BOOL bResult = YES;
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"delete from historyTable;"]];
    return bResult;
}

- (BXGHistoryModel *)searchHistoryWithCourseId:(NSString *)courseId andZhangId:(NSString *)zhangId; {

    BXGHistoryModel *model;
    NSString* sqlStatement = [NSString stringWithFormat:@"select * from historyTable where zhang_id='%@' and course_id='%@';", zhangId,courseId];
    FMResultSet *resultSet = [BXGDATABASE executeQuery:sqlStatement];
    if ([resultSet next]) {
        
        model = [BXGHistoryModel new];
        model.course_id = [resultSet stringForColumn:@"course_id"];
        model.course_name = [resultSet stringForColumn:@"course_name"];
        
        
        model.zhang_id = [resultSet stringForColumn:@"zhang_id"];
        model.dian_id = [resultSet stringForColumn:@"dian_id"];
        
        model.video_id = [resultSet stringForColumn:@"video_id"];
        
        model.video_name = [resultSet stringForColumn:@"video_name"];
        model.per = [resultSet doubleForColumn:@"per"];
        model.create_time = [resultSet doubleForColumn:@"create_time"];
        model.smallimgPath = [resultSet stringForColumn:@"smallimgPath"];
        model.course_type  = [resultSet stringForColumn:@"course_type"];
    }

    return model;
}

- (BXGHistoryModel *)searchLastHistory {

    NSString* sqlStatement = [NSString stringWithFormat:@"select * from historyTable order by create_time desc limit 1;"];
    FMResultSet *resultSet = [BXGDATABASE executeQuery:sqlStatement];
    
    BXGHistoryModel *model;
    
    if ([resultSet next]) {
        
        model = [BXGHistoryModel new];
        model.course_id = [resultSet stringForColumn:@"course_id"];
        model.course_name = [resultSet stringForColumn:@"course_name"];
        
        model.zhang_id = [resultSet stringForColumn:@"zhang_id"];
        model.jie_id = [resultSet stringForColumn:@"jie_id"];
        model.dian_id = [resultSet stringForColumn:@"dian_id"];
        
        model.video_id = [resultSet stringForColumn:@"video_id"];
        
        model.video_name = [resultSet stringForColumn:@"video_name"];
        model.smallimgPath = [resultSet stringForColumn:@"smallimgPath"];
        model.per = [resultSet doubleForColumn:@"per"];
        model.create_time = [resultSet doubleForColumn:@"create_time"];
        model.course_type  = [resultSet stringForColumn:@"course_type"];
    }
    
    return model;
}
- (BXGHistoryModel *)searchHistoryWithCourseId:(NSString *)courseId andJieId:(NSString *)jieId; {
    BXGHistoryModel *model;
    NSString* sqlStatement = [NSString stringWithFormat:@"select * from historyTable where jie_id='%@' and course_id='%@' order by create_time desc limit 1;", jieId,courseId];
    FMResultSet *resultSet = [BXGDATABASE executeQuery:sqlStatement];
    if ([resultSet next]) {
        
        model = [BXGHistoryModel new];
        model.course_id = [resultSet stringForColumn:@"course_id"];
        model.course_name = [resultSet stringForColumn:@"course_name"];
        
        
        model.zhang_id = [resultSet stringForColumn:@"zhang_id"];
        model.jie_id = [resultSet stringForColumn:@"jie_id"];
        model.dian_id = [resultSet stringForColumn:@"dian_id"];
        model.video_id = [resultSet stringForColumn:@"video_id"];
        model.video_name = [resultSet stringForColumn:@"video_name"];
        model.per = [resultSet doubleForColumn:@"per"];
        model.create_time = [resultSet doubleForColumn:@"create_time"];
        model.smallimgPath = [resultSet stringForColumn:@"smallimgPath"];
        model.course_type  = [resultSet stringForColumn:@"course_type"];
    }
    
    return model;

}
- (BXGHistoryModel *)searchLastHistoryWithCourseId:(NSString *)courseId {
    
    BXGHistoryModel *model;
    NSString* sqlStatement = [NSString stringWithFormat:@"select * from historyTable where course_id='%@' order by create_time desc;",courseId];
    FMResultSet *resultSet = [BXGDATABASE executeQuery:sqlStatement];
    if ([resultSet next]) {
        
        model = [BXGHistoryModel new];
        model.course_id = [resultSet stringForColumn:@"course_id"];
        model.course_name = [resultSet stringForColumn:@"course_name"];
        
        
        model.zhang_id = [resultSet stringForColumn:@"zhang_id"];
        model.jie_id = [resultSet stringForColumn:@"jie_id"];
        model.dian_id = [resultSet stringForColumn:@"dian_id"];
        
        model.video_id = [resultSet stringForColumn:@"video_id"];
        
        model.video_name = [resultSet stringForColumn:@"video_name"];
        model.smallimgPath = [resultSet stringForColumn:@"smallimgPath"];
        model.per = [resultSet doubleForColumn:@"per"];
        model.create_time = [resultSet doubleForColumn:@"create_time"];
        model.course_type  = [resultSet stringForColumn:@"course_type"];
    }
    
    return model;
}

- (NSArray <BXGHistoryModel *> *)searchGroupLastHistory;{
    
    BXGHistoryModel *model;
    NSMutableArray *array = [NSMutableArray new];
    NSString* sqlStatement = [NSString stringWithFormat:@"select * ,MAX(create_time) from historyTable group by course_id order by create_time desc;"];
    FMResultSet *resultSet = [BXGDATABASE executeQuery:sqlStatement];
    while ([resultSet next]) {
        
        model = [BXGHistoryModel new];
        model.course_id = [resultSet stringForColumn:@"course_id"];
        model.course_name = [resultSet stringForColumn:@"course_name"];
        
        
        model.zhang_id = [resultSet stringForColumn:@"zhang_id"];
        model.jie_id = [resultSet stringForColumn:@"jie_id"];
        model.dian_id = [resultSet stringForColumn:@"dian_id"];
        
        model.video_id = [resultSet stringForColumn:@"video_id"];
        
        model.video_name = [resultSet stringForColumn:@"video_name"];
        model.smallimgPath = [resultSet stringForColumn:@"smallimgPath"];
        model.per = [resultSet doubleForColumn:@"per"];
        model.create_time = [resultSet doubleForColumn:@"create_time"];
        model.course_type  = [resultSet stringForColumn:@"course_type"];
        [array addObject:model];
    }
    
    return array;
}

- (double)seekPercentWithCourseId:(NSString *)courseId andVideoId:(NSString *)videoId; {

    double seekPercent = 0;
    NSString * sqlStatement = [NSString stringWithFormat:@"select * from historyTable where course_id='%@' and video_id='%@';",courseId,videoId];
    FMResultSet *resultSet = [BXGDATABASE executeQuery:sqlStatement];
    
    while ([resultSet next]) {
    
        BXGHistoryModel *model;
        model = [BXGHistoryModel new];
        model.course_id = [resultSet stringForColumn:@"course_id"];
        model.course_name = [resultSet stringForColumn:@"course_name"];
        
        
        model.zhang_id = [resultSet stringForColumn:@"zhang_id"];
        model.jie_id = [resultSet stringForColumn:@"jie_id"];
        model.dian_id = [resultSet stringForColumn:@"dian_id"];
        
        model.video_id = [resultSet stringForColumn:@"video_id"];
        
        model.video_name = [resultSet stringForColumn:@"video_name"];
        model.smallimgPath = [resultSet stringForColumn:@"smallimgPath"];
        model.per = [resultSet doubleForColumn:@"per"];
        model.create_time = [resultSet doubleForColumn:@"create_time"];
        model.course_type  = [resultSet stringForColumn:@"course_type"];
        seekPercent = model.per;
    }
    
    return seekPercent;
}

- (BOOL)autoClearData {

    BOOL bResult = YES;
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"DELETE from historyTable WHERE video_id in (select video_id from historyTable ORDER BY create_time desc limit 20,5);"]];
    return bResult;
}

@end
