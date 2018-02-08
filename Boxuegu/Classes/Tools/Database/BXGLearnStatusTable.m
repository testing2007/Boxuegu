//
//  BXGLearnStatusTable.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/8.
//  Copyright © 2017年 itcast. All rights reserved.
//
//@property (nonatomic, strong) NSString *video_id;
//@property (nonatomic, strong) NSString *studyStatus;
//@property (nonatomic, strong) NSString *last_learn_time;
//@property (nonatomic, strong) NSString *user_id;
//@property (nonatomic, strong) NSString *course_id;
#import "BXGLearnStatusTable.h"
#import "BXGDatabase.h"

@implementation BXGLearnStatusTable
+ (BOOL)createTable; {

    
    NSString *sql = @"create table if not exists BXGLearnStatusTable(\
    video_id text not null primary key,\
    learn_status text,\
    last_learn_time text,\
    course_id text);";
    
    BOOL bResult = false;
    bResult = [BXGDATABASE executeUpdate:sql];
    return bResult;
}

- (BOOL)addOneRecord:(BXGLearnStatusModel *)model; {

    NSString *sql = [NSString stringWithFormat:@"insert or replace into BXGLearnStatusTable(\
                                               video_id,\
                                               learn_status,\
                                               last_learn_time,\
                     course_id)\
                    values ('%@','%@','%@','%@')",model.video_id,model.studyStatus,model.last_learn_time, model.course_id];
    
    BOOL bResult = false;
    bResult = [BXGDATABASE executeUpdate:sql];
    return bResult;
}

- (BOOL)updateOneRecord:(BXGLearnStatusModel *)model; {

    NSString *sql = [NSString stringWithFormat:@"update BXGLearnStatusTable\
                    set learn_status = case when learn_status == '1' then '1' else '%@' end,last_learn_time = '%@'\
                     ,course_id = '%@'\
                     where video_id == '%@'",model.studyStatus, model.last_learn_time, model.course_id, model.video_id];
    
    BOOL bResult = false;
    bResult = [BXGDATABASE executeUpdate:sql];
    return bResult;
}
- (BOOL)deleteOneRecord:(NSString *)idx; {

    NSString *sql = [NSString stringWithFormat:@"delete from BXGLearnStatusTable\
                     where video_id == '%@'",idx];
    
    BOOL bResult = false;
    bResult = [BXGDATABASE executeUpdate:sql];
    return bResult;
}

- (BOOL)existRecord:(NSString *)idx; {

    NSString *sql = [NSString stringWithFormat:@"select *from BXGLearnStatusTable\
                     where video_id='%@'",idx];
    
    FMResultSet *resultSet = [BXGDATABASE executeQuery:sql];
    while ([resultSet next]) {
        return true;
    }
    return false;
}

- (NSArray<BXGLearnStatusModel *> *)searchAllRecord; {

    NSString *sql = [NSString stringWithFormat:@"select *from BXGLearnStatusTable"];
    
    FMResultSet *resultSet = [BXGDATABASE executeQuery:sql];
    NSMutableArray *array = [NSMutableArray new];
    
    while ([resultSet next]) {
        
        BXGLearnStatusModel *model = [BXGLearnStatusModel new];
        model.video_id = [resultSet stringForColumn:@"video_id"];
        model.studyStatus  = [resultSet stringForColumn:@"learn_status"];
        model.last_learn_time = [resultSet stringForColumn:@"last_learn_time"];
        // model.user_id = [resultSet stringForColumn:@"user_id"];
        model.course_id = [resultSet stringForColumn:@"course_id"];
        [array addObject:model];
    }
    return array;
}

- (BOOL)deleteAllRecord; {

    NSString *sql = [NSString stringWithFormat:@"delete from BXGLearnStatusTable"];
    
    BOOL bResult = false;
    bResult = [BXGDATABASE executeUpdate:sql];
    return bResult;
}
@end
