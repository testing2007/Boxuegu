//
//  BXGDownloadTable.h
//  FFDBPrj
//
//  Created by apple on 17/6/12.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "BXGDownloadTable.h"
#import "BXGDownloadModel.h"
#import "BXGCourseModel.h"
#import "BXGVideoInfoTable.h"
#import "BXGDatabase.h"
#import "BXGCourseTable.h"
#import "BXGPointTable.h"
#import "BXGVideoTable.h"

@interface BXGDownloadTable()
@property(nonatomic, strong) BXGVideoInfoTable *videoInfoTable;
@property(nonatomic, strong) BXGPointTable *pointTable;
@property(nonatomic, strong) BXGCourseTable *courseTable;
@property(nonatomic, strong) BXGVideoTable *videoTable;
@end

@implementation BXGDownloadTable

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _videoInfoTable = [BXGVideoInfoTable new];
        _pointTable = [BXGPointTable new];
        _courseTable = [BXGCourseTable new];
        _videoTable = [BXGVideoTable new];
    }
    return self;
}

+(BOOL)createTable
{
    BOOL bResult = YES;
    bResult = [[BXGDatabase shareInstance].db executeUpdate:@"CREATE TABLE if not exists downloadVideoInfo(\
                   videoIdx text NOT NULL PRIMARY KEY, \
                   videoId text,\
                   videoName text, \
                   courseId text,\
                   pointId text,\
                   downloadQualityDefinition integer,\
                   downloadQualityDesp text, \
                   downloadUrl text, \
                   downloadLocalFileName text, \
                   state integer, \
                   totalBytesWritten double, \
                   totalBytesExpectedToWrite double, \
                   progress double);"];
    return bResult;
}

-(BOOL)addDownloadBaseModel:(BXGDownloadBaseModel*)model
{
    BOOL bResult = YES;
    bResult = [_videoInfoTable addOneRecord:model.videoInfo withVideoIdx:model.videoModel.idx];
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"insert or replace into downloadVideoInfo(\
                                       videoIdx,\
                                       videoId,\
                                       videoName, \
                                       courseId,\
                                       pointId, \
                                       downloadQualityDefinition, \
                                       downloadQualityDesp, \
                                       downloadUrl, \
                                       downloadLocalFileName, \
                                       state, \
                                       totalBytesWritten, \
                                       totalBytesExpectedToWrite, \
                                       progress) \
                                       values('%@', '%@', '%@', '%@', '%@', \
                                       %ld, \
                                       '%@', \
                                       '%@', \
                                       '%@', \
                                       %ld,\
                                       %lld,\
                                       %lld,\
                                       %f);",
                                       model.videoModel.idx,
                                       model.videoModel.video_id,
                                       model.videoModel.name,
                                       model.courseId,
                                       model.pointId,
                                       model.downloadQualityDefinition,
                                       model.downloadQualityDesp,
                                       model.downloadUrl,
                                       model.downloadLocalFileName,
                                       (long)model.state,
                                       model.totalBytesWritten,
                                       model.totalBytesExpectedToWrite,
                                       model.progress]];
    if(bResult)
    {
        NSLog(@"success to add one record");
    }
    else
    {
        NSLog(@"fail to add one record, the code=%d, the reason=%@", [BXGDATABASE lastErrorCode], [BXGDATABASE lastErrorMessage]);
    }
    return bResult;
}

-(BOOL)addDownloadOneRecord:(BXGDownloadModel*)model
{
    BOOL bResult = YES;
    bResult = [self addDownloadBaseModel:model.downloadBaseModel];
    bResult &= [_courseTable addOneRecord:model.course];
    bResult &= [_pointTable addOneRecord:model.point];
    if(bResult)
    {
        NSLog(@"success to add one record");
    }
    else
    {
        NSLog(@"fail to add one record, the code=%d, the reason=%@", [BXGDATABASE lastErrorCode], [BXGDATABASE lastErrorMessage]);
    }
    return bResult;
}

-(NSDictionary*)searchAllDownloading
{
    NSString* sql = @"select * from downloadVideoInfo where state!=4;";
    NSMutableDictionary* dict = [NSMutableDictionary new];
    FMResultSet *resultSet = [BXGDATABASE executeQuery:sql];
    while ([resultSet next]) {
        BXGDownloadModel* model = [BXGDownloadModel new];
        [self fillOutDownloadBaseModel:model.downloadBaseModel withResultSet:resultSet];
        model.course = [_courseTable searchCourseInfoWithCourseId:model.downloadBaseModel.courseId];
        model.point = [_pointTable searchVideoInfoWithPointId:model.downloadBaseModel.pointId];
        [dict setObject:model forKey:model.downloadBaseModel.videoModel.idx];
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}

-(NSDictionary*)searchAllDownloaded
{
    NSString* sql = @"select * from downloadVideoInfo where state==4;";
    NSMutableDictionary* dict = [NSMutableDictionary new];
    FMResultSet *resultSet = [BXGDATABASE executeQuery:sql];
    while ([resultSet next]) {
        BXGDownloadModel* model = [BXGDownloadModel new];
        [self fillOutDownloadBaseModel:model.downloadBaseModel withResultSet:resultSet];
        model.course = [_courseTable searchCourseInfoWithCourseId:model.downloadBaseModel.courseId];
        model.point = [_pointTable searchVideoInfoWithPointId:model.downloadBaseModel.pointId];
        [dict setObject:model forKey:model.downloadBaseModel.videoModel.idx];
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}

-(NSDictionary*)searchAllDownloadedOrderByCourseId
{
    //返回 NSDictionary<key=courseId, value=BXGDownloadedRenderModel>
    NSString* sql = [NSString stringWithFormat:@"select * from downloadVideoInfo where state==4 order by courseId;"];
    NSMutableDictionary* dict = [NSMutableDictionary new];
    FMResultSet *resultSet = [BXGDATABASE executeQuery:sql];
    NSString* preCourseId = @"";
    BXGDownloadedRenderModel* model;
    NSString *curCourseId=nil;
    
    NSMutableArray *arrPreVideoModel = [NSMutableArray new];
//    BXGCourseOutlinePointModel *preCoursePointModel = nil;
    while ([resultSet next]) {
        curCourseId = [resultSet stringForColumn:@"courseId"];
        if([preCourseId isEqualToString:@""] || ![preCourseId isEqualToString:curCourseId])
        {
            if(![preCourseId isEqualToString:curCourseId] && ![preCourseId isEqualToString:@""])
            {
                BXGDownloadedRenderModel *preModel = [dict objectForKey:preCourseId];
                [self fillOutDownloadedVideosAllPointModelUnderCourse:preModel.arrPointModel
                                         withAllVideoModelUnderCourse:arrPreVideoModel];
                [arrPreVideoModel removeAllObjects];
            }
            preCourseId = curCourseId;
            model = [BXGDownloadedRenderModel new];
            [dict setObject:model forKey:curCourseId];
        }
        model.courseModel = [_courseTable searchCourseInfoWithCourseId:curCourseId];
        
        BXGDownloadBaseModel* downloadmodel = [self fillOutDownloadBaseModel:nil withResultSet:resultSet];
        [model.arrDownloadModel addObject:downloadmodel];
        
        BXGCourseOutlinePointModel* pointModel = [_pointTable searchVideoInfoWithPointId:downloadmodel.pointId];
        pointModel.videos = nil;
        BOOL bExist=NO;
        for (BXGCourseOutlinePointModel *item in model.arrPointModel)
        {
            if([item.idx isEqualToString:pointModel.idx])
            {
                bExist=YES;
                break;
            }
        }
        if(!bExist)
        {
//            preCoursePointModel = pointModel;
            [model.arrPointModel addObject:pointModel];
        }
        if(downloadmodel.videoModel.idx && pointModel.idx)
        {
            BXGCourseOutlineVideoModel *videoModel = [_videoTable searchVideoWithVideoIdx:downloadmodel.videoModel.idx andPointIdx:pointModel.idx];
            videoModel.superPointModel = [BXGCourseOutlinePointModel new];
            videoModel.superPointModel.idx = pointModel.idx;
            [arrPreVideoModel addObject:videoModel];
        }
    }
    if(curCourseId && ![curCourseId isEqualToString:@""])
    {
        BXGDownloadedRenderModel *curModel = [dict objectForKey:curCourseId];
        [self fillOutDownloadedVideosAllPointModelUnderCourse:curModel.arrPointModel
                                 withAllVideoModelUnderCourse:arrPreVideoModel];
        [arrPreVideoModel removeAllObjects];
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}

-(void)fillOutDownloadedVideosAllPointModelUnderCourse:(NSMutableArray<BXGCourseOutlinePointModel*>*)arrPointModel
                          withAllVideoModelUnderCourse:(NSArray<BXGCourseOutlineVideoModel*>*)arrVideoModel
{
    NSMutableArray *arrVideosUnderPointModel = [NSMutableArray new];
    for(BXGCourseOutlinePointModel* pointItem in arrPointModel)
    {
        for(BXGCourseOutlineVideoModel* videoItem in arrVideoModel)
        {
            if([pointItem.idx isEqualToString:videoItem.superPointModel.idx])
            {
                [arrVideosUnderPointModel addObject:videoItem];
            }
        }
        if(arrVideosUnderPointModel && arrVideosUnderPointModel.count>0)
        {
            [arrVideosUnderPointModel sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return ((BXGCourseOutlineVideoModel*)obj1).sort >  ((BXGCourseOutlineVideoModel*)obj2).sort;
            }];
            pointItem.videos = [NSArray arrayWithArray:arrVideosUnderPointModel];
            [arrVideosUnderPointModel removeAllObjects];
        }
    }
    if(arrPointModel && arrPointModel.count>0)
    {
        [arrPointModel sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return ((BXGCourseOutlinePointModel*)obj1).sort >  ((BXGCourseOutlinePointModel*)obj2).sort;
        }];
    }
}

-(BXGDownloadBaseModel*)fillOutDownloadBaseModel:(BXGDownloadBaseModel*)downloadBaseModel withResultSet:(FMResultSet*)resultSet
{
    NSAssert(resultSet!=nil, @"fillOutDownloadBaseModel the resultset is nil");
    if(downloadBaseModel==nil)
    {
        downloadBaseModel = [BXGDownloadBaseModel new];
    }
    downloadBaseModel.videoModel.idx = [resultSet stringForColumn:@"videoIdx"];
    downloadBaseModel.videoModel.video_id = [resultSet stringForColumn:@"videoId"];
    downloadBaseModel.videoModel.name = [resultSet stringForColumn:@"videoName"];
    downloadBaseModel.courseId = [resultSet stringForColumn:@"courseId"];
    downloadBaseModel.pointId = [resultSet stringForColumn:@"pointId"];
    downloadBaseModel.videoInfo = [_videoInfoTable searchVideoInfoWithVideoIdx:downloadBaseModel.videoModel.idx];
    downloadBaseModel.downloadQualityDefinition = [resultSet intForColumn:@"downloadQualityDefinition"];
    downloadBaseModel.downloadQualityDesp = [resultSet stringForColumn:@"downloadQualityDesp"];
    downloadBaseModel.downloadUrl = [resultSet stringForColumn:@"downloadUrl"];
    downloadBaseModel.downloadLocalFileName = [resultSet stringForColumn:@"downloadLocalFileName"];
    //todo 其实最好不要在这里面修改,应该在查询外面修改
    DWDownloadState dwState = (DWDownloadState)[resultSet intForColumn:@"state"];
    if(dwState!=DWDownloadStateFailed || dwState!=DWDownloadStateCompleted)
    {
        dwState = DWDownloadStateNone;
    }
    downloadBaseModel.state = dwState;
    downloadBaseModel.resumeBytesWritten = 0;
    downloadBaseModel.bytesWritten = 0;
    downloadBaseModel.totalBytesWritten = [resultSet longLongIntForColumn:@"totalBytesWritten"];
    downloadBaseModel.totalBytesExpectedToWrite = [resultSet longLongIntForColumn:@"totalBytesExpectedToWrite"];
    downloadBaseModel.progress = [resultSet doubleForColumn:@"progress"];
    downloadBaseModel.speed = 0.f;
    downloadBaseModel.remainingTime = 0.f;
    
    return downloadBaseModel;
}

-(BOOL)deleteDownloadingOneRecordWithVideoIdx:(NSString*)videoIdx
{
    BOOL bResult = YES;
    bResult = [_videoInfoTable deleteOneRecordWithVideoIdx:videoIdx];
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"delete from downloadVideoInfo where videoIdx='%@';", videoIdx]];
    if(bResult)
    {
        NSLog(@"success to delete record, condition=%@", videoIdx);
    }
    else
    {
        NSLog(@"fail to delete record, condition=%@, the code=%d, reason=%@", videoIdx, [BXGDATABASE lastErrorCode], [BXGDATABASE lastErrorMessage]);
    }
    return bResult;
}


//对于正在下载删除操作
//正在下载: 删除单个视频
-(BOOL)deleteDownloadingVideo:(BXGDownloadModel*)downloadModel
{
    BOOL bResult = YES;
    bResult = [self deleteDownloadedOneRecordWithVideoIdx:downloadModel.downloadBaseModel.videoModel.idx];
    return bResult;
}

//正在下载: 删除多个视频
-(BOOL)deleteDownloadingVideos:(NSArray<BXGDownloadModel*>*)arrDownloadModel
{
    BOOL bResult = YES;
    for (BXGDownloadModel* downloadModelItem in arrDownloadModel)
    {
        bResult &= [self deleteDownloadingVideo:downloadModelItem];
    }
    return bResult;
}

////正在下载: 删除所有
//-(BOOL)deleteAllDownloadingVideos
//{
//    BOOL bResult = YES;
//    return bResult;
//}

//删除单个课程下单个/多个视频
-(BOOL)deleteDownloadedVideosUnderOneCourse:(BXGDownloadedRenderModel*)courseRenderModel
{
    if(courseRenderModel==nil || courseRenderModel.arrPointModel==nil)
    {
        NSLog(@"fail to deleteDownloadedVideosUnderOneCourse, 参数错误");
        return NO;
    }
    BOOL bResult = YES;
    //在删除pointTable之前会先会去删除videoTable信息, --- 不能删除 pointTable, courseTable, 因为他们存在一对多的情况.
//    for(BXGCourseOutlinePointModel* item in courseRenderModel.arrPointModel)
//    {
//        NSMutableArray* arrVideoIdx = [NSMutableArray new];
//        for(BXGCourseOutlineVideoModel* videoModelItem in item.videos)
//        {
//            [arrVideoIdx addObject:videoModelItem.idx];
//        }
//        bResult &= [_pointTable deleteOneRecordWithPointId:item.idx withArrDownloadedVideoIdx:arrVideoIdx];
//    }
    //删除下载信息表的相关内容
    for(BXGDownloadBaseModel* model in courseRenderModel.arrDownloadModel)
    {
        NSString* videoIdx = model.videoModel.idx;
        bResult = [self deleteDownloadedOneRecordWithVideoIdx:videoIdx];
    }
    return bResult;
}

//删除多个课程下单个/多个视频
-(BOOL)deleteDownloadedVideosUnderMultiCourse:(NSArray<BXGDownloadedRenderModel*>*)arrCourseRenderModel
{
    BOOL bResult = YES;
    for(BXGDownloadedRenderModel* downloadedRenderModel in arrCourseRenderModel)
    {
        bResult &= [self deleteDownloadedVideosUnderOneCourse:downloadedRenderModel];
    }
    if(!bResult)
    {
        NSLog(@"fail to execute deleteDownloadedVideosUnderMultiCourse");
    }
    return bResult;
}


//-(BOOL)deleteDownloadedOneRecord:(BXGDownloadedModel*)model
//{
//    return [self deleteDownloadedOneRecordWithVideoIdx:model.downloadBaseModel.videoModel.idx
//                                          withCourseId:model.downloadBaseModel.courseId
//                                        withPointModel:model.point];
//}

-(BOOL)deleteDownloadedOneRecordWithVideoIdx:(NSString*)videoIdx
{
    BOOL bResult = YES;
    bResult = [_videoInfoTable deleteOneRecordWithVideoIdx:videoIdx];
    bResult &= [_videoTable deleteOneRecordWithVideoIdx:videoIdx];
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"delete from downloadVideoInfo where videoIdx='%@';", videoIdx]];
    if(bResult)
    {
        NSLog(@"success to delete record, condition=%@", videoIdx);
    }
    else
    {
        NSLog(@"fail to delete record, condition=%@, the code=%d, reason=%@", videoIdx, [BXGDATABASE lastErrorCode], [BXGDATABASE lastErrorMessage]);
    }
    return bResult;
}
////////////////////////////////////////////////////////////////////////////////
/*
-(BOOL)deleteDownloadedOneRecordWithVideoIdx:(NSString*)videoIdx
                                withCourseId:(NSString*)courseId
                              withPointModel:(BXGCourseOutlinePointModel*)pointModel
{
    BOOL bResult = NO;
    if(videoIdx==nil || [videoIdx isEqualToString:@""] || courseId==nil || [courseId isEqualToString:@""] || pointModel==nil)
    {
        NSLog(@"fail to execute [deleteDownloadedOneRecordWithVideoIdx:(NSString*)videoIdx withCourseId:(NSString*)courseId withPointModel:(BXGCourseOutlinePointModel*)pointModel] fuction");
        return bResult;
    }
    bResult = [_courseTable deleteOneRecordWithCourseId:courseId];
    NSMutableArray* arrVideoIdx = [NSMutableArray new];
    for (BXGCourseOutlineVideoModel* videoModelItem in pointModel.videos) {
        [arrVideoIdx addObject:videoModelItem.idx];
    }
    if(arrVideoIdx.count>0)
    {
        bResult &= [_pointTable deleteOneRecordWithPointId:pointModel.idx withArrDownloadedVideoIdx:arrVideoIdx];
    }
    bResult &= [self deleteDownloadingOneRecordWithVideoIdx:videoIdx];
    if(bResult)
    {
        NSLog(@"deleteDownloadedOneRecordWithVideoIdx success to delete record, condition=%@, courseId=%@", videoIdx, courseId);
    }
    else
    {
        NSLog(@"deleteDownloadedOneRecordWithVideoIdx fail to delete record, condition=%@, courseId=%@, the code=%d, reason=%@", videoIdx, courseId, [BXGDATABASE lastErrorCode], [BXGDATABASE lastErrorMessage]);
    }
    return bResult;
}

-(BOOL)deleteAllDownloadingRecords
{
    BOOL bResult = YES;
    bResult = [_videoInfoTable deleteAllRecords];
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"delete from downloadVideoInfo;"]];
    if(bResult)
    {
        NSLog(@"success to delete all record");
    }
    else
    {
        NSLog(@"fail to delete all record, the code=%d, reason=%@", [BXGDATABASE lastErrorCode], [BXGDATABASE lastErrorMessage]);
    }
    return bResult;
}

-(BOOL)deleteAllDownloadedRecords
{
    BOOL bResult = YES;
    bResult = [_courseTable deleteAllRecords];
    bResult &= [_pointTable deleteAllRecords];
    bResult &= [self deleteAllDownloadingRecords];
    if(bResult)
    {
        NSLog(@"deleteAllDownloadedRecords success to delete all record");
    }
    else
    {
        NSLog(@"deleteAllDownloadedRecords fail to delete all record, the code=%d, reason=%@", [BXGDATABASE lastErrorCode], [BXGDATABASE lastErrorMessage]);
    }
    return bResult;
}

-(BOOL)updateOneRecordWithNewData:(BXGDownloadModel*)model
{
    BOOL bResult = YES;
    bResult = [_videoInfoTable updateOneRecordWithNewData:model.videoInfo withVideoIdx:model.videoModel.idx];
    bResult &= [BXGDATABASE executeUpdate:[NSString stringWithFormat:@"update downloadVideoInfo set\
                                       videoIdx='%@',\
                                       videoId='%@',\
                                       videoName='%@',\
                                       courseId='%@',\
                                       pointId='%@', \
                                       downloadQualityDefinition=%ld, \
                                       downloadQualityDesp='%@', \
                                       downloadUrl='%@', \
                                       downloadLocalFileName='%@', \
                                       state=%ld, \
                                       totalBytesWritten=%lld, \
                                       totalBytesExpectedToWrite=%lld, \
                                       progress=%f \
                                       where videoId='%@';",
                                       model.videoModel.idx,
                                       model.videoModel.video_id,
                                       model.videoModel.name,
                                       model.courseId,
                                       model.pointId,
                                       model.downloadQualityDefinition,
                                       model.downloadQualityDesp,
                                       model.downloadUrl,
                                       model.downloadLocalFileName,
                                       (long)model.state,
                                       model.totalBytesWritten,
                                       model.totalBytesExpectedToWrite,
                                       model.progress,
                                       model.videoModel.idx]];
    if(bResult)
    {
        NSLog(@"success to update one record");
    }
    else
    {
        NSLog(@"fail to add one record, the code=%d, reason=%@", [BXGDATABASE lastErrorCode], [BXGDATABASE lastErrorMessage]);
    }
    return bResult;
}
//*/

//-(NSDictionary*)searchAllDownloading
//{
//    NSString* sql = @"select * from downloadVideoInfo where state!=4;";
//    NSMutableDictionary* dict = [NSMutableDictionary new];
//    FMResultSet *resultSet = [BXGDATABASE executeQuery:sql];
//    while ([resultSet next]) {
//        BXGDownloadModel* model = [BXGDownloadModel new];
//        model.videoModel.idx = [resultSet stringForColumn:@"videoIdx"];
//        model.videoModel.video_id = [resultSet stringForColumn:@"videoId"];
//        model.videoModel.name = [resultSet stringForColumn:@"videoName"];
//        model.courseId = [resultSet stringForColumn:@"courseId"];
//        model.pointId = [resultSet stringForColumn:@"pointId"];
//        model.videoInfo = [_videoInfoTable searchVideoInfoWithVideoIdx:model.videoModel.idx];
//        model.downloadQualityDefinition = [resultSet intForColumn:@"downloadQualityDefinition"];
//        model.downloadQualityDesp = [resultSet stringForColumn:@"downloadQualityDesp"];
//        model.downloadUrl = [resultSet stringForColumn:@"downloadUrl"];
//        model.downloadLocalFileName = [resultSet stringForColumn:@"downloadLocalFileName"];
//        model.state = (DWDownloadState)[resultSet intForColumn:@"state"];
//        model.resumeBytesWritten = 0;
//        model.bytesWritten = 0;
//        model.totalBytesWritten = [resultSet longLongIntForColumn:@"totalBytesWritten"];
//        model.totalBytesExpectedToWrite = [resultSet longLongIntForColumn:@"totalBytesExpectedToWrite"];
//        model.progress = [resultSet doubleForColumn:@"progress"];
//        model.speed = 0.f;
//        model.remainingTime = 0.f;
//        [dict setObject:model forKey:model.videoModel.idx];
//    }
//    return [NSDictionary dictionaryWithDictionary:dict];
//}

@end
