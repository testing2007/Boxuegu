//
//  BXGDownloader.h
//  Demo
//
//  Created by apple on 17/5/31.
//  Copyright © 2017年 com.bokecc.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGDownloadModel.h"
#import "BXGResourceManager.h"
#import "BXGCourseModel.h"
#import "BXGCourseOutlinePointModel.h"
#import "BXGCourseOutlineVideoModel.h"


typedef NS_ENUM(NSInteger, CALL_FROM_PAGE)
{
    CALL_FROM_PAGE_DOWNLOADING_CELL,
    CALL_FROM_PAGE_PLAY_LIST_CELL
};

@class BXGVideoInfo;
@class BXGVideoInfoItem;
@class BXGDownloadDataItem;

@protocol BXGDownloadDelegate <NSObject>

-(void)downloadProgressModel:(BXGDownloadBaseModel*)downloadModel;

@end

@interface BXGDownloader : NSObject

+(instancetype)shareInstance;
//下载指定的videoId数组
-(void)addDownloadCourseModel:(BXGCourseModel*)courseModel
                   pointModel:(BXGCourseOutlinePointModel*)pointModel
              withVideoModels:(NSArray<BXGCourseOutlineVideoModel*>*)arrVideoModel;


typedef void (^NotifyProgressBlock)(BXGDownloadBaseModel*); //block类型定义形式: typedef 返回值 (^BlockType)(参数)
//notifyBlock:(void (^)(BXGDownloadModel*))notifyProgressBlock; //定义形式: (返回值 (^)(参数))参数名称
//下载指定videoId,并立即启动下载
-(void)startDownloadCourseModel:(BXGCourseModel*)courseModel
                     pointModel:(BXGCourseOutlinePointModel*)pointModel
                 withVideoModel:(BXGCourseOutlineVideoModel*)videoModel
                    notifyBlock:(NotifyProgressBlock)notifyProgressBlock;

//查询下载状态
-(DWDownloadState)inquireDownlaodStateByVideoIdx:(NSString*)videoIdx;

//暂停下载之前的videoIds,并立即启动当前视频下载
-(void)pausePreDownloadingVideo;
-(void)pausePreDownloadingVideoAndRunSpecificDownloadModel:(BXGDownloadModel*)downloadModel;
//执行下载 下一个等待下载 的视频
-(void)downloadNextWaitingVideo;

-(void)addObserver:(id<BXGDownloadDelegate>)object withVideoIdxKey:(NSString*)key;
//-(void)removeObserverByVideoIdxkey:(NSString*)key;//videoIdx
-(void)removeObserver:(NSObject*)observer andVideoIdxkey:(NSString*)key;
-(void)notifyObserver:(BXGDownloadBaseModel*)model;

//全部开始下载
- (void)startAllDownload;//:(NSArray<BXGDownloadModel*>*)arrDownloadModel;
//全部暂停下载
- (void)suspendAllDownload;

//正在下载-全选删除
- (void)removeAllDownloading;
//正在下载-单选删除
- (void)removeDownloadingVideo:(BXGDownloadModel*)downloadModel;
//正在下载-多选删除
- (void)removeDownloadingVideos:(NSArray<BXGDownloadModel*>*)arrDownloadModel;
//程序退出时,需要先取消当前所有正在进行的下载
- (void)cancelAllDownloading;

//开始下载
- (void)startDownloadModel:(BXGDownloadModel*)downloadModel;
// 恢复下载（除非确定对这个model进行了suspend，否则使用start）
- (void)resumeDownloadModel:(BXGDownloadModel*)downloadModel;
// 暂停下载
- (void)suspendDownloadModel:(BXGDownloadModel*)downloadModel;
// 取消下载并清除已下载的数据
//- (void)cancleWithDownloadModel:(BXGDownloadModel*)downloadModel isClear:(BOOL)isClear;

//根据状态返回对应文本显示信息
- (NSString*)downloadText:(BXGDownloadBaseModel*)model fromPageCell:(CALL_FROM_PAGE)callFromPage;

@end
