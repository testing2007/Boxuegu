//
//  BXGCourseTable.m
//  Boxuegu
//
//  Created by apple on 2017/6/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseTable.h"
#import "BXGDatabase.h"
#import "BXGCourseModel.h"

@interface BXGCourseTable()
@end

@implementation BXGCourseTable

+(BOOL)createTable
{
//#pragma mark - 下载课时
//    @property (nonatomic, assign) NSUInteger total_download_count;//总下载课时,也就是视频数
//    @property (nonatomic, strong) NSString* total_download_size;  //总下载容量
    BOOL bResult = YES;
    bResult = [BXGDATABASE executeUpdate:@"CREATE TABLE if not exists courseTable(\
               course_id text NOT NULL PRIMARY KEY, \
               course_name text, \
               smallimg_path text,\
               learnd_sum text, \
               teacher_name text, \
               course_length text, \
               type integer, \
               learnd_count text);"];
    return bResult;
}

-(BOOL)addOneRecord:(BXGCourseModel*)model
{
    BOOL bResult = YES;
    bResult = [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"insert or replace into courseTable(\
                                          course_id, \
                                          course_name, \
                                          smallimg_path,\
                                          learnd_sum, \
                                          teacher_name, \
                                          course_length, \
                                          type, \
                                          learnd_count)values('%@', '%@', '%@', '%@', '%@', '%@', %ld, '%@');", model.course_id, model.course_name, model.smallimg_path, model.learnd_sum, model.teacher_name, model.course_length, model.type.integerValue, model.learnd_count]];
    if(!bResult)
    {
        NSLog(@"courseTable the error code=%d, the error reason=%@", [BXGDATABASE lastErrorCode], [BXGDATABASE lastErrorMessage]);
    }
    return bResult;
}

-(BOOL)updateOneRecordWithNewData:(BXGCourseModel*)model
{
    BOOL bResult = YES;
    bResult = [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"update courseTable set \
                                          course_id='%@', \
                                          course_name='%@', \
                                          smallimg_path='%@',\
                                          learnd_sum='%@', \
                                          teacher_name='%@', \
                                          course_length='%@', \
                                          type=%ld, \
                                          learnd_count='%@',\
                                          where course_id='%@');", model.course_id, model.course_name, model.smallimg_path, model.learnd_sum, model.teacher_name, model.course_length, (long)model.type.integerValue, model.learnd_count, model.course_id]];
    return bResult;
}

-(BOOL)deleteOneRecordWithCourseId:(NSString*)courseId
{
    BOOL bResult = YES;
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"delete from courseTable where course_id='%@';", courseId]];
    return bResult;
}

-(BOOL)deleteAllRecords
{
    BOOL bResult = YES;
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"delete from courseTable;"]];
    return bResult;
}

-(BXGCourseModel*)searchCourseInfoWithCourseId:(NSString*)courseId
{
    BXGCourseModel *model = [BXGCourseModel new];
    NSString* sqlStatement = [NSString stringWithFormat:@"select * from courseTable where course_id='%@';", courseId];
    FMResultSet *resultSet = [BXGDATABASE executeQuery:sqlStatement];
    if([resultSet next]) {
        model.course_id = [resultSet stringForColumn:@"course_id"];
        model.course_name = [resultSet stringForColumn:@"course_name"];
        model.smallimg_path = [resultSet stringForColumn:@"smallimg_path"];
        model.learnd_sum = [resultSet stringForColumn:@"learnd_sum"];
        model.teacher_name = [resultSet stringForColumn:@"teacher_name"];
        model.course_length = [resultSet stringForColumn:@"course_length"];
        model.type = [resultSet objectForColumnName:@"type"];
        model.learnd_count = [resultSet stringForColumn:@"learnd_count"];
//        model.total_download_count = [resultSet unsignedLongLongIntForColumn:@"total_download_count"];
//        model.total_download_size = [resultSet stringForColumn:@"total_download_size"];
    }
    return model;
}

-(NSDictionary*)searchAllCourseInfo
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    NSString* sqlStatement = [NSString stringWithFormat:@"select * from courseTable;"];
    FMResultSet *resultSet = [BXGDATABASE executeQuery:sqlStatement];
    if([resultSet next]) {
        NSString *course_id = [resultSet stringForColumn:@"course_id"];
        BXGCourseModel *model = [self searchCourseInfoWithCourseId:course_id];
        [dict setObject:model forKey:course_id];
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end
