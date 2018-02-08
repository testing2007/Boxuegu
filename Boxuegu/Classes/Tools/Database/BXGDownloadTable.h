//
//  BXGDownloadVideoInfoTable.h
//  FFDBPrj
//
//  Created by apple on 17/6/12.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB/FMDB.h"

@class BXGDownloadModel;
@class BXGCourseModel;
@class BXGCourseOutlinePointModel;
@class BXGDownloadedRenderModel;

@interface BXGDownloadTable : NSObject

+(BOOL)createTable;

//-(BOOL)addDownloadingOneRecord:(BXGDownloadModel*)model;
//添加记录
-(BOOL)addDownloadOneRecord:(BXGDownloadModel*)model;

-(NSDictionary*)searchAllDownloaded;
-(NSDictionary*)searchAllDownloading;
//-(NSDictionary*)searchAllDownloaded;
//查询课程下所有已下载的视频文件
-(NSDictionary*)searchAllDownloadedOrderByCourseId;

//对于正在下载删除操作
//正在下载: 删除单个视频
-(BOOL)deleteDownloadingVideo:(BXGDownloadModel*)downloadModel;
//正在下载: 删除多个视频
-(BOOL)deleteDownloadingVideos:(NSArray<BXGDownloadModel*>*)arrDownloadModel;
//正在下载: 删除所有
-(BOOL)deleteAllDownloadingVideos;

//对于已完成下载删除操作
//删除单个课程下单个/多个视频
-(BOOL)deleteDownloadedVideosUnderOneCourse:(BXGDownloadedRenderModel*)courseRenderModel;
//删除多个课程下单个/多个视频
-(BOOL)deleteDownloadedVideosUnderMultiCourse:(NSArray<BXGDownloadedRenderModel*>*)arrCourseRenderModel;
//对于已完成通过选择已下载课程->单个视频: 通过vidioIdx删除记录, 只删除downloadTable/videoInfo/videoInfoItem表中的记录,不涉及 courseTable/pointTable/videoTable表
-(BOOL)deleteDownloadedOneRecordWithVideoIdx:(NSString*)videoIdx;

////删除课程下多个视频
//-(BOOL)deleteDownloadedCourse:(NSString*)courseId
//               withPointModel:(BXGCourseOutlinePointModel*)pointModel;



//-(BOOL)deleteDownloadedOneRecordWithVideoIdx:(NSString*)videoIdx
//                                withCourseId:(NSString*)courseId
//                              withPointModel:(BXGCourseOutlinePointModel*)pointModel;
//-(BOOL)deleteDownloadedOneRecord:(BXGDownloadedModel*)model;
//
//-(BOOL)deleteAllDownloadingRecords;
//-(BOOL)deleteAllDownloadedRecords;
//
//-(BOOL)updateOneRecordWithNewData:(BXGDownloadModel*)model;



@end
