//
//  BXGResourceManager.h
//  Demo
//
//  Created by apple on 17/6/7.
//  Copyright © 2017年 com.bokecc.www. All rights reserved.
//

#import <Foundation/Foundation.h>

#define OUT

@class BXGVideoInfo;
@class BXGDownloadBaseModel;
@class BXGDownloadModel;
@class BXGDownloadedModel;
@class BXGDownloadedRenderModel;

typedef NS_ENUM(NSInteger, DownloadQuality)
{
    DownloadQuality_General=0,//清晰
    DownloadQuality_High      //高清
};

@interface BXGResourceManager : NSObject

+(instancetype)shareInstance;
-(void)addLoginRegisterNotification;

-(void)initialDowloadInfo;

@property (strong, nonatomic, readonly) NSMutableDictionary *dictDownloaded;
@property (strong, nonatomic, readonly) NSMutableDictionary *dictDownloading;
@property (strong, nonatomic, readonly) NSMutableDictionary *dictDownloadedRender;

@property (nonatomic, strong, readonly) NSString *userDirectory;
@property (nonatomic, strong, readonly) NSString *downloadDirectory;
@property (nonatomic, strong, readonly) NSString *documentDirectory;

@property (nonatomic, assign, readonly) CGFloat totalSizeInBytes;
@property (nonatomic, assign, readonly) CGFloat freeSizeInBytes;

-(NSString*)downloadDBPath;
//-(NSString*)downloadFileNameByVideoIdx:(NSString*)videoId;
//-(NSString*)downloadFilePathByVideoIdx:(NSString*)videoId;
-(NSString*)downloadFileNameByDownloadModel:(BXGDownloadBaseModel*)baseModel;
-(NSString*)downloadFilePathByDownloadModel:(BXGDownloadBaseModel*)baseModel;
-(NSString*)parseDownloadFileSuffixNameByDownloadURL:(NSString*)downloadURL;

//判断下载的文件是否在本地已存在
-(BOOL)isDownloadFileExistInLocalByVideoIdx:(NSString*)videoIdx withReturnLocalPath:(NSString**)returnLocalPath;

//添加一个下载
-(void)addDownloadingItem:(BXGDownloadModel*)item;
//-(void)updateDownloadingItem:(BXGDownloadModel*)item;
//正在下载页面: 删除一个下载
-(void)removeDownloadingItem:(BXGDownloadModel*)item;
//下载完成调用
-(void)downloadedItem:(BXGDownloadModel*)item;

//从内存中删除正在下载信息
-(void)removeDownloadingItemFromMemory:(BXGDownloadModel*)item;

//记录所有正在下载的信息
//-(void)recordAllDownloadingInfo;

//已完成下载页面 删除操作
//删除单个课程下单个/多个/所有课程
-(void)removeDownloadedCourse:(BXGDownloadedRenderModel*)model;
//删除多个课程下单个/多个/所有课程
-(void)removeDownloadedCourses:(NSArray<BXGDownloadedRenderModel*>*)models;
//已下载课程->子视频项目删除
-(void)removeDownloadedVideoIdx:(NSString*)videoIdx;

//-(BXGDownloadModel*)existDowloadItem:(NSString*)videoId;
-(NSArray<BXGDownloadModel*>*)getAllRunningDownloadVideos;
//检测指定视频是否在下载列表中, 有则返回, 否则返回nil.
-(BXGDownloadModel*)existDownloadingItem:(NSString*)videoIdx;
//检测指定视频是否在下载列表/已下载列表中. 有则返回, 否则返回nil
-(BXGDownloadModel*)existDowloadItem:(NSString*)videoIdx;
//检测是否有等待的下载项, 有则返回,否则返回nil.
-(BXGDownloadModel*)checkNextReadyingDownloadModel;

//检测已下载资源是否存在, 如果不存在, 返回nil; 否则, 返回对应下载模型以及如果不传nil返回存放的本地路径
-(BXGDownloadModel*)existDownloadedItem:(NSString*)videoIdx withReturnLocalPath:(NSString**)returnLocalPath;

//清空userDirectory
-(void)clearUserDirectory;
-(BOOL)isExistDownloadRunnningItem;

-(NSString*)totalSizeInString;
-(NSString*)freeSizeInString;
-(NSString*)bytesToString:(CGFloat)bytes;

//更新已下载渲染信息
-(void)updateDownloadedRenderInfo;

//监测是否点下面的所有视频已下载
-(BOOL)isAllVideoDownloadedUnderPointMode:(BXGCourseOutlinePointModel*)pointModel;

-(NSString*)appVersion;


@end

////添加记录
//-(BOOL)addDownloadedOneRecord:(BXGDownloadedModel*)model;
//
//-(NSDictionary*)searchAllDownloading;
////-(NSDictionary*)searchAllDownloaded;
////查询课程下所有已下载的视频文件
//-(NSDictionary*)searchAllDownloadedOrderByCourseId;
//
////对于正在下载删除操作
////正在下载: 删除单个视频
//-(BOOL)deleteDownloadingVideo:(BXGDownloadedModel*)downloadModel;
////正在下载: 删除多个视频
//-(BOOL)deleteDownloadingVideos:(NSArray<BXGDownloadedModel*>*)arrDownloadModel;
////正在下载: 删除所有
//-(BOOL)deleteAllDownloadingVideos;
//
////对于已完成下载删除操作
////删除单个课程下单个/多个视频
//-(BOOL)deleteDownloadedVideosUnderOneCourse:(BXGDownloadedRenderModel*)courseRenderModel;
////删除多个课程下单个/多个视频
//-(BOOL)deleteDownloadedVideosUnderMultiCourse:(NSArray<BXGDownloadedRenderModel*>*)arrCourseRenderModel;
////对于已完成通过选择已下载课程->单个视频: 通过vidioIdx删除记录, 只删除downloadTable/videoInfo/videoInfoItem表中的记录,不涉及 courseTable/pointTable/videoTable表
//-(BOOL)deleteDownloadingOneRecordWithVideoIdx:(NSString*)videoIdx;
