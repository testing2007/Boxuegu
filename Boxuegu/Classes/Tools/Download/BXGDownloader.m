//
//  BXGDownloader.m
//  Demo
//
//  Created by apple on 17/5/31.
//  Copyright © 2017年 com.bokecc.www. All rights reserved.
//

#import "BXGDownloader.h"
#import "BXGResourceManager.h"
#import "BXGVideoInfo.h"
#import "BXGVideoInfoItem.h"
#import "BXGLoadVideoInfo.h"
#import "BXGDownloadingCell.h"
#import "NSString+Extension.h"

#pragma --mark begin 注册观察者
@interface BXGObserver : NSObject
//@property(nonatomic, strong) NSObject* observer;
@property(nonatomic, strong) NSMutableArray* arrObserver;
@property(nonatomic, strong) NSString* key;//videoIdx
@end

@implementation BXGObserver
-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _arrObserver = [NSMutableArray array];
    }
    return self;
}
@end
#pragma --mark end 注册观察者

@interface BXGObserverBlock : NSObject
@property(nonatomic, copy) NotifyProgressBlock valueNotifyProgressBlock;//进度通知块
@property(nonatomic, strong) NSString* key;//videoIdx
@end

@implementation BXGObserverBlock
@end

#pragma --mark begin 下载器
@interface BXGDownloader()

@property(nonatomic, strong) NSMutableDictionary* dictDownloadingDWDownloadModel; //key=videoIdx, value=DWDownloadModel

-(BXGVideoInfoItem*)needDownloadVideoInfo:(BXGVideoInfo*)videoInfo;

//@property(nonatomic, strong) NSMutableDictionary* dictVideoCourseInfo; //方便下载完成后,信息显示

@property(nonatomic, strong) NSMutableDictionary* dictObservers; //通知的观察者<key=videoIdx, value=BXGObserver>

@property(nonatomic, strong) NSMutableDictionary* dictObserverBlocks; //通知的观察者<key=videoIdx, value=BXGObserverBlock>

@end

@implementation BXGDownloader

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static BXGDownloader* downloadManager;
    dispatch_once(&onceToken, ^{
        downloadManager = [[BXGDownloader alloc] init];
    });
    return downloadManager;
}

-(instancetype)init{
    self = [super init];
    if(self)
    {
        _dictDownloadingDWDownloadModel = [NSMutableDictionary new];
        _dictObservers = [NSMutableDictionary new];
        //        _dictVideoCourseInfo = [NSMutableDictionary new];
        _dictObserverBlocks = [NSMutableDictionary new];
    }
    return self;
}

-(void)addDownloadCourseModel:(BXGCourseModel*)courseModel
                   pointModel:(BXGCourseOutlinePointModel*)pointModel
              withVideoModels:(NSArray<BXGCourseOutlineVideoModel*>*)arrVideoModel
{
    BXGDownloadModel *readyPlayModel = nil;
    for (BXGCourseOutlineVideoModel *videoModelItem in arrVideoModel) {
        BXGDownloadModel *tempPlayModel = [self recordDownloadCourseModel:courseModel pointModel:pointModel videoModel:videoModelItem];
        if(readyPlayModel==nil)
        {
            if(tempPlayModel!=nil)
            {
                if(readyPlayModel==nil)
                {
                    readyPlayModel = tempPlayModel;
                }
            }
        }
    }
    
    //if(_dictDownloadingDWDownloadModel.count==0)
    if(![[BXGResourceManager shareInstance] isExistDownloadRunnningItem])
    {
        //表示还没有正在下载的,将第一个等待运行的视频运行起来.
        [self startDownloadModel:readyPlayModel];
    }
}

-(DWDownloadState)inquireDownlaodStateByVideoIdx:(NSString*)videoIdx
{
    BXGDownloadModel* downloadModel = [[BXGResourceManager shareInstance] existDowloadItem:videoIdx];
    if(downloadModel==nil)
    {
        return DWDownloadStateNone;
    }
    return downloadModel.downloadBaseModel.state;
}

-(void)startDownloadCourseModel:(BXGCourseModel*)courseModel
                     pointModel:(BXGCourseOutlinePointModel*)pointModel
                 withVideoModel:(BXGCourseOutlineVideoModel*)videoModel
                    notifyBlock:(NotifyProgressBlock)notifyBlock
{
    BXGObserverBlock *observerBlock = [BXGObserverBlock new];
    if(videoModel.idx!=nil && notifyBlock!=nil)
    {
        observerBlock.key = videoModel.idx;
        observerBlock.valueNotifyProgressBlock = notifyBlock;
        [_dictObserverBlocks setObject:observerBlock forKey:videoModel.idx];
    }
    
    BXGDownloadModel *downloadModel = [self recordDownloadCourseModel:courseModel
                                                           pointModel:pointModel
                                                           videoModel:videoModel];
    
    if(downloadModel!=nil)
    {
        if(_dictDownloadingDWDownloadModel.count==0)
        {
            //表示还没有正在下载的,将第一个等待运行的视频运行起来.
            
            [self startDownloadModel:downloadModel];
        }
        else
        {
            //将之前下载的视频暂停起来,然后启动当前视频
            [self pausePreDownloadingVideoAndRunSpecificDownloadModel:downloadModel];
        }
    }
}

-(void)pausePreDownloadingVideo
{
    NSArray<BXGDownloadModel*>* arrayDownloadingVideoModel = [[BXGResourceManager shareInstance] getAllRunningDownloadVideos];
    //将之前下载的视频暂停起来,然后启动当前视频
    for (BXGDownloadModel* item in arrayDownloadingVideoModel)
    {
        [self suspendDownloadModel:item];
        item.downloadBaseModel.state = DWDownloadStateReadying;
    }
}

-(void)pausePreDownloadingVideoAndRunSpecificDownloadModel:(BXGDownloadModel*)downloadModel
{
    [self pausePreDownloadingVideo];
    [self startDownloadModel:downloadModel];
}

-(void)downloadNextWaitingVideo
{
    BXGDownloadModel* nextDownloadModel =  [[BXGResourceManager shareInstance] checkNextReadyingDownloadModel];
    if(nextDownloadModel!=nil)
    {
        [self startDownloadModel:nextDownloadModel];
    }
}

-(BXGDownloadModel*)recordDownloadCourseModel:(BXGCourseModel*)courseModel
                                   pointModel:(BXGCourseOutlinePointModel*)pointModel
                                   videoModel:(BXGCourseOutlineVideoModel*)videoModel
{
    BXGDownloadModel *downloadModel = [[BXGResourceManager shareInstance] existDowloadItem:videoModel.idx];
    if(downloadModel)
    {
        [self notifyObserver:downloadModel.downloadBaseModel];
        return downloadModel;
    }
    
    downloadModel = [[BXGDownloadModel alloc] init];
    downloadModel.downloadBaseModel.videoModel = videoModel;
    downloadModel.downloadBaseModel.state = DWDownloadStateReadying;
    downloadModel.downloadBaseModel.courseId = courseModel.course_id;
    downloadModel.downloadBaseModel.pointId = pointModel.idx;
    downloadModel.course = courseModel;

    NSMutableArray* tempVideos = [NSMutableArray new];
    [tempVideos addObject:videoModel];
    downloadModel.point.idx = pointModel.idx;
    downloadModel.point.name = pointModel.name;
    downloadModel.point.sort = pointModel.sort;
    downloadModel.point.videos = [NSMutableArray arrayWithArray:tempVideos];
    
    [[BXGResourceManager shareInstance] addDownloadingItem:downloadModel];
    
    [self notifyObserver:downloadModel.downloadBaseModel];

    return downloadModel;
}

-(void)addObserver:(id)object withVideoIdxKey:(NSString*)key
{
    BXGObserver *observer = [BXGObserver new];
    if([_dictObservers.allKeys containsObject:key])
    {
        BXGObserver* oldObserver = [_dictObservers objectForKey:key];
        observer.arrObserver = oldObserver.arrObserver;
    }
    observer.key = key;
    [observer.arrObserver addObject:object];
    [_dictObservers setObject:observer forKey:key];
}

-(void)removeObserver:(NSObject*)observer andVideoIdxkey:(NSString*)key
{
    if([_dictObservers.allKeys containsObject:key])
    {
        BXGObserver* existObserver = _dictObservers[key];
        if(!existObserver || !existObserver.arrObserver)
        {
            return ;
        }
        if([existObserver.arrObserver containsObject:observer])
        {
            [existObserver.arrObserver removeObject:observer];
        }
        if(existObserver.arrObserver.count==0)
        {
            [_dictObservers removeObjectForKey:key];
        }
        return ;
    }
}

-(void)notifyObserver:(BXGDownloadBaseModel*)model
{
    NSArray* arrObserverKey = _dictObservers.allKeys;
    for (NSString* keyItem in arrObserverKey)
    {
        NSArray* arrDownloadObserver = ((BXGObserver*)_dictObservers[keyItem]).arrObserver;
        for (NSObject* downloadObserver in arrDownloadObserver)
        {
            if([keyItem isEqualToString:model.videoModel.idx] &&
               [downloadObserver respondsToSelector:@selector(downloadProgressModel:)])
            {
                [(id<BXGDownloadDelegate>)downloadObserver downloadProgressModel:model];
            }
        }
    }
}

- (void)startAllDownload
{
    NSArray* arrDownloadModel= [[BXGResourceManager shareInstance] dictDownloading].allValues;
    if(arrDownloadModel && arrDownloadModel.count>0)
    {
        for (BXGDownloadModel* item in arrDownloadModel) {
            item.downloadBaseModel.state = DWDownloadStateReadying;
        }
        if(![[BXGResourceManager shareInstance] isExistDownloadRunnningItem])
        {
            [self startDownloadModel:arrDownloadModel[0]];
        }
    }
}

- (void)suspendAllDownload
{
    NSArray* arrDownloading = [BXGResourceManager shareInstance].dictDownloading.allValues;
    for (BXGDownloadModel* model in arrDownloading) {
        [self suspendDownloadModel:model];
    }
}

- (void)removeAllDownloading
{
    NSDictionary* dictDownloading = [BXGResourceManager shareInstance].dictDownloading;
    NSArray* arrDownloading = dictDownloading.allValues;
    for(BXGDownloadModel* item  in arrDownloading)
    {
        [self removeDownloadingVideo:item];
    }
}
- (void)removeDownloadingVideo:(BXGDownloadModel*)item
{
    if(item &&
       _dictDownloadingDWDownloadModel &&
       [_dictDownloadingDWDownloadModel.allKeys containsObject:item.downloadBaseModel.videoModel.idx])
    {
        //调用CCSDK下载中视频进行取消 / 删除临时文件 /清除保留的 DWDownloadModel.
        DWDownloadModel* downloadModel = _dictDownloadingDWDownloadModel[item.downloadBaseModel.videoModel.idx];
        if(downloadModel!=nil)
        {
            [[DWDownloadSessionManager manager] cancleWithDownloadModel:downloadModel isClear:YES];
            [[DWDownloadSessionManager manager] deleteFileWithDownloadModel:downloadModel];
            [_dictDownloadingDWDownloadModel removeObjectForKey:item.downloadBaseModel.videoModel.idx];
            
            //NSLog(@"###downloader removeDownloadingVideo : the videoIdx=%@, removeModel=%p", item.downloadBaseModel.videoModel.idx, downloadModel);
        }
    }
    //删除保留在本地的正在下载记录
    if(item)
    {
        [[BXGResourceManager shareInstance] removeDownloadingItem:item];
    }
}
- (void)removeDownloadingVideos:(NSArray<BXGDownloadModel*>*)arrDownloadingModel
{
    for(BXGDownloadModel* item  in arrDownloadingModel)
    {
        [self removeDownloadingVideo:item];
    }
}

- (void)cancelAllDownloading
{
    NSDictionary* dictDownloading = [BXGResourceManager shareInstance].dictDownloading;
    NSArray* arrDownloading = dictDownloading.allValues;
    for(BXGDownloadModel* item  in arrDownloading)
    {
        [self cancleWithDownloadModel:item isClear:NO];
    }
}

- (void)startDownloadModel:(BXGDownloadModel*)downloadModel {
    //检测无网络情况
    BXGReachabilityStatus status= [[BXGNetWorkTool sharedTool] getReachState];
    if(status == BXGReachabilityStatusReachabilityStatusNotReachable) {
        [[BXGHUDTool share]showHUDWithString:kBXGToastNonNetworkTip];
        return ;
    }
    if (!downloadModel) {
        return;
    }
    if(downloadModel.downloadBaseModel.state == DWDownloadStateCompleted)
    {
        return ;
    }
    //判断是否已在 下载中/下载完成 列表中,
    BXGResourceManager *resourceManager = [BXGResourceManager shareInstance];
    BXGDownloadModel* existModal = [resourceManager existDowloadItem:downloadModel.downloadBaseModel.videoModel.idx];
    
    if(!existModal || existModal.downloadBaseModel.state==DWDownloadStateCompleted)
    {
        return ;
    }
    NSArray *allKeys = _dictDownloadingDWDownloadModel.allKeys;
    NSString *keyVideoIdx = existModal.downloadBaseModel.videoModel.idx;
    if(allKeys!=nil && [allKeys containsObject:keyVideoIdx])
    {
        NSInteger existModelState = existModal.downloadBaseModel.state;
        DWDownloadModel* dwModel = _dictDownloadingDWDownloadModel[keyVideoIdx];
        if( (existModelState==DWDownloadStateReadying || existModelState==DWDownloadStateSuspended) &&
            (dwModel.state==DWDownloadStateSuspended) )
        {
            [[DWDownloadSessionManager manager] resumeWithDownloadModel:_dictDownloadingDWDownloadModel[keyVideoIdx]];
            
            //NSLog(@"###downloader startDownloadModel : the videoIdx=%@, resumeModel=%p, ccstate=%ld", keyVideoIdx, dwModel, dwModel.state);
        }
        return ;//已经在下载中.不需要重复添加
    }
    
    if(existModal &&
       existModal.downloadBaseModel &&
       [self isValidateURL:existModal])
    {
        [self requestDownloadVideo:existModal];
    }
    else
    {
        BXGLoadVideoInfo* loadVideoInfo = [[BXGLoadVideoInfo alloc] init];
        [loadVideoInfo loadVideoId:downloadModel.downloadBaseModel.videoModel.video_id errorBlock:^(NSError *error) {
            //todo 网络请求失败有哪些类型
            NSLog(@"can't reponse info normally, the error code need info from response info. the error code=%ld, the error info = %@", error.code, error.debugDescription);
            //[[BXGHUDTool share] showHUDWithString:@"网络请求失败"];
            return ;
        } finishBlock:^(NSDictionary* dictVideoInfo){
            BXGVideoInfo* videoInfo = [[BXGVideoInfo alloc] initWithInfo:dictVideoInfo];
            BXGVideoInfoItem *needDownloadInfo = [self needDownloadVideoInfo:videoInfo];
            if(!needDownloadInfo)
            {
                NSLog(@"can't find need info from response info. the response info = %@", dictVideoInfo.debugDescription);
                return ;//没有指定视频提供下载
            }
            downloadModel.downloadBaseModel.videoInfo = videoInfo;
            downloadModel.downloadBaseModel.downloadUrl = needDownloadInfo.playurl;
            downloadModel.downloadBaseModel.downloadQualityDesp = needDownloadInfo.desp;
            downloadModel.downloadBaseModel.downloadQualityDefinition = needDownloadInfo.definition;
            downloadModel.downloadBaseModel.downloadLocalFileName = [resourceManager parseDownloadFileSuffixNameByDownloadURL:needDownloadInfo.playurl];
            downloadModel.downloadBaseModel.downloadQualityDefinition = needDownloadInfo.definition;
            [resourceManager addDownloadingItem:downloadModel];
            [self requestDownloadVideo:downloadModel];
        }];//finishBlock getPlayInfo
    }
}

-(void)requestDownloadVideo:(BXGDownloadModel*)bxgDownloadModel
{
    BXGDownloadBaseModel *downloadBaseModel = bxgDownloadModel.downloadBaseModel;
    if(downloadBaseModel==nil)
    {
        NSLog(@"requestDownloadVideo--downloadBaseModel is nil");
        return ;
    }
    
    BXGResourceManager *resourceManager = [BXGResourceManager shareInstance];
    //[resourceManager.dictDownloading setObject:findDWItem forKey:findDWItem.videoId];//toresearch 为什么 dictDownloading 设置成 readonly, 在外面还是可以添加
    BXGUserModel* userModel = [[BXGUserDefaults share] userModel];
    
    NSString* localPath = [resourceManager downloadFilePathByDownloadModel:downloadBaseModel];
    //[resourceManager.downloadDirectory stringByAppendingString:downloadBaseModel.downloadLocalFileName];
    DWDownloadModel *loadModel = [[DWDownloadModel alloc]initWithURLString:downloadBaseModel.downloadUrl
                                                                  filePath:localPath //downloadModelData.downloadLocalPath
                                                             responseToken:downloadBaseModel.videoInfo.token
                                                                    userId:userModel.cc_user_id
                                                                   videoId:downloadBaseModel.videoModel.video_id];
    
    //保存下载的模型
    [self.dictDownloadingDWDownloadModel setObject:loadModel forKey:downloadBaseModel.videoModel.idx];
    
    DWDownloadSessionManager* downloadSessionManager = [DWDownloadSessionManager manager];
    __weak typeof (DWDownloadSessionManager*) weakDownloadSessionManager = downloadSessionManager;
    [weakDownloadSessionManager startWithDownloadModel:loadModel
                                              progress:^(DWDownloadProgress *progress, DWDownloadModel *downloadModel)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             @autoreleasepool {
                 if(progress.totalBytesExpectedToWrite>resourceManager.freeSizeInBytes)
                 {
                     //本地磁盘空间不够,不能继续下载
                     [self downloadProgressNotEnoughSpace:bxgDownloadModel ccDownloadModel:downloadModel];
                 }
                 else
                 {
                     if(downloadModel.state==DWDownloadStateRunning)
                     {
                         [self downloadProgressRecordInfoIntoDatabase:bxgDownloadModel ccDownloadModel:downloadModel];
                     }
                 }
             }
         });
     }//end progress
                                                 state:^(DWDownloadModel *downloadModel,
                                                         DWDownloadState state,
                                                         NSString *filePath,
                                                         NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             //NSLog(@"state: the videoId=%@, state=%ld", downloadModel.videoId, state);
             if(error)
             {
                 [self downloadNonNetworkHandle:bxgDownloadModel error:error];
             }
             else if(state==DWDownloadStateCompleted)
             {
                 [self downloadCompleteHandle:bxgDownloadModel ccDownloadModel:downloadModel];
             }
             else if(state == DWDownloadStateFailed)
             {
                 [self downloadFailHandle:bxgDownloadModel ccDownloadModel:downloadModel];
             }
             else
             {
                 if(downloadBaseModel.state != state)
                 {
                     downloadBaseModel.state = state;
                 }
                 NSLog(@"download state else=%lu", (unsigned long)state);
             }
             NSLog(@"download state=%lu", (unsigned long)state);
         });
     }];
}

-(void)downloadNonNetworkHandle:(BXGDownloadModel*)bxgDownloadModel error:(NSError*)error
{
    if(error)
    {
        BXGReachabilityStatus status= [[BXGNetWorkTool sharedTool] getReachState];
        if(error.code == -1002 || status == BXGReachabilityStatusReachabilityStatusNotReachable)
        {
            [[BXGHUDTool share]showHUDWithString:kBXGToastNonNetworkTip];
            [self downloadStatusBlockNotification:bxgDownloadModel.downloadBaseModel];
        }
    }
}

-(void)downloadProgressNotEnoughSpace:(BXGDownloadModel*)bxgDownloadModel ccDownloadModel:(DWDownloadModel*)downloadModel
{
    bxgDownloadModel.downloadBaseModel.state = DWDownloadStateFailed;
    
    [[BXGResourceManager shareInstance] removeDownloadingItem:bxgDownloadModel];
    [self.dictDownloadingDWDownloadModel removeObjectForKey:bxgDownloadModel.downloadBaseModel.videoModel.idx];
    [[DWDownloadSessionManager manager] cancleWithDownloadModel:downloadModel isClear:YES];
    
    //NSLog(@"###downloader over storage size : the videoIdx=%@, ccstate=%ld, removeModel=%p", bxgDownloadModel.downloadBaseModel.videoModel.idx, downloadModel.state, downloadModel);
    
    [self downloadStatusBlockNotification:bxgDownloadModel.downloadBaseModel];
}

-(void)downloadProgressRecordInfoIntoDatabase:(BXGDownloadModel*)bxgDownloadModel ccDownloadModel:(DWDownloadModel*)downloadModel
{
    //下载过程中每累计或下载500KB个字节就写入一次数据库
    static int64_t sumTotalBytesWritten=0;
    if(sumTotalBytesWritten+500*1024<=downloadModel.progress.totalBytesWritten)
    {
        sumTotalBytesWritten = downloadModel.progress.totalBytesWritten;
        
        bxgDownloadModel.downloadBaseModel.totalBytesWritten = downloadModel.progress.totalBytesWritten;
        bxgDownloadModel.downloadBaseModel.totalBytesExpectedToWrite = downloadModel.progress.totalBytesExpectedToWrite;
        bxgDownloadModel.downloadBaseModel.progress = downloadModel.progress.progress;
        bxgDownloadModel.downloadBaseModel.speed = downloadModel.progress.speed;
        if(bxgDownloadModel.downloadBaseModel.state!=downloadModel.state)
        {
            bxgDownloadModel.downloadBaseModel.state = downloadModel.state;
        }
        [[BXGResourceManager shareInstance] addDownloadingItem:bxgDownloadModel];
    }
    
    bxgDownloadModel.downloadBaseModel.totalBytesWritten = downloadModel.progress.totalBytesWritten;
    bxgDownloadModel.downloadBaseModel.totalBytesExpectedToWrite = downloadModel.progress.totalBytesExpectedToWrite;
    bxgDownloadModel.downloadBaseModel.progress = downloadModel.progress.progress;
    bxgDownloadModel.downloadBaseModel.speed = downloadModel.progress.speed;
    if(bxgDownloadModel.downloadBaseModel.state!=downloadModel.state)
    {
        bxgDownloadModel.downloadBaseModel.state = downloadModel.state;
    }
    [self downloadStatusBlockNotification:bxgDownloadModel.downloadBaseModel];
}

-(void)downloadFailHandle:(BXGDownloadModel*)bxgDownloadModel ccDownloadModel:(DWDownloadModel*)downloadModel
{
    bxgDownloadModel.downloadBaseModel.state = DWDownloadStateFailed;
    
    [[BXGResourceManager shareInstance] removeDownloadingItem:bxgDownloadModel];
    [[DWDownloadSessionManager manager] cancleWithDownloadModel:downloadModel isClear:YES];
    [[DWDownloadSessionManager manager] deleteFileWithDownloadModel:downloadModel];
    [self.dictDownloadingDWDownloadModel removeObjectForKey:bxgDownloadModel.downloadBaseModel.videoModel.idx];
    
    //NSLog(@"###downloader failed : the videoIdx=%@, ccstate=%ld, removeModel=%p", bxgDownloadModel.downloadBaseModel.videoModel.idx, downloadModel.state, downloadModel);

    [self downloadStatusBlockNotification:bxgDownloadModel.downloadBaseModel];
    //执行下一个等待的视频
    [self downloadNextWaitingVideo];
}

-(void)downloadCompleteHandle:(BXGDownloadModel*)bxgDownloadModel ccDownloadModel:(DWDownloadModel*)downloadModel
{
    //下面三行顺序很重要
    [[BXGResourceManager shareInstance] removeDownloadingItemFromMemory:bxgDownloadModel];
    bxgDownloadModel.downloadBaseModel.state = DWDownloadStateCompleted; //kvo
    [[BXGResourceManager shareInstance] downloadedItem:bxgDownloadModel];
    
    //下载完成,删除下载模型
    [self.dictDownloadingDWDownloadModel removeObjectForKey:bxgDownloadModel.downloadBaseModel.videoModel.idx];
    
    //NSLog(@"###downloader state : the videoIdx=%@, ccstate=%ld, removeModel=%p", bxgDownloadModel.downloadBaseModel.videoModel.idx, downloadModel.state, downloadModel);

    //通知页面更新
    [self downloadStatusBlockNotification:bxgDownloadModel.downloadBaseModel];
    
    //执行下一个等待的视频
    [self downloadNextWaitingVideo];
}

-(void)downloadStatusBlockNotification:(BXGDownloadBaseModel*)downloadBaseModel
{
    [[BXGDownloader shareInstance] notifyObserver:downloadBaseModel];//通知下载列表项

    //下载完成视频通知回调,只针对视频播放页面点击下载的回调
    if(_dictObserverBlocks &&
       [_dictObserverBlocks.allKeys containsObject:downloadBaseModel.videoModel.idx])
    {
        BXGObserverBlock* observerBlock = _dictObserverBlocks[downloadBaseModel.videoModel.idx];
        observerBlock.valueNotifyProgressBlock(downloadBaseModel);
        if(downloadBaseModel.state==DWDownloadStateCompleted || downloadBaseModel.state==DWDownloadStateFailed)
        {
            [_dictObserverBlocks removeObjectForKey:downloadBaseModel.videoModel.idx];
        }
    }
}

- (void)resumeDownloadModel:(BXGDownloadModel*)downloadModel
{
    BXGResourceManager *resourceManager = [BXGResourceManager shareInstance];
    BXGDownloadModel* existModal = [resourceManager existDowloadItem:downloadModel.downloadBaseModel.videoModel.idx];
    if(!existModal && existModal.downloadBaseModel.state==DWDownloadStateCompleted)
        return ;
    DWDownloadModel* dwDownloadModel = nil;
    if(_dictDownloadingDWDownloadModel)
    {
        dwDownloadModel = _dictDownloadingDWDownloadModel[existModal.downloadBaseModel.videoModel.idx];
    }
    if(existModal && existModal.downloadBaseModel.state==DWDownloadStateSuspended &&
       dwDownloadModel!=nil &&
       [dwDownloadModel.downloadURL isEqualToString:existModal.downloadBaseModel.downloadUrl] &&
       dwDownloadModel.state==DWDownloadStateSuspended)
    {
        [[DWDownloadSessionManager manager] resumeWithDownloadModel:dwDownloadModel];
        //NSLog(@"###downloader resumeDownloadModel: the videoIdx=%@, resumeModel=%p, ccstate=%ld", downloadModel.downloadBaseModel.videoModel.idx, dwDownloadModel, dwDownloadModel.state);
        //### existModal.downloadBaseModel.state = DWDownloadStateRunning;
        return ;
    }
    //NSLog(@"###downloader resumeDownloadModel fail and startDownloadModel: the videoIdx=%@, mystate=%ld, dwDownloadModel=%p, dwUrl=%@, existModelURL=%@", downloadModel.downloadBaseModel.videoModel.idx, downloadModel.downloadBaseModel.state, dwDownloadModel, dwDownloadModel?dwDownloadModel.downloadURL:@"", existModal.downloadBaseModel.downloadUrl?:@"");
    [self startDownloadModel:downloadModel];
}

- (void)suspendDownloadModel:(BXGDownloadModel*)downloadModel
{
    BXGResourceManager *resourceManager = [BXGResourceManager shareInstance];
    BXGDownloadModel* existModal = [resourceManager existDowloadItem:downloadModel.downloadBaseModel.videoModel.idx];
    if(!existModal || existModal.downloadBaseModel.state==DWDownloadStateCompleted)
        return ;
    DWDownloadModel* dwDownloadModel = nil;
    if(_dictDownloadingDWDownloadModel)
    {
        dwDownloadModel = _dictDownloadingDWDownloadModel[existModal.downloadBaseModel.videoModel.idx];
    }
    if(existModal.downloadBaseModel.state==DWDownloadStateRunning)
    {
        if(dwDownloadModel!=nil && dwDownloadModel.state==DWDownloadStateRunning)
        {
            [[DWDownloadSessionManager manager] suspendWithDownloadModel:dwDownloadModel];
            //NSLog(@"###downloader suspendDownloadModel: the videoIdx=%@, suspendModel=%p, ccstate=%ld", downloadModel.downloadBaseModel.videoModel.idx, dwDownloadModel, dwDownloadModel.state);
            //### existModal.downloadBaseModel.state = DWDownloadStateSuspended;
        }
        else
        {
            //todo 这种状态不应该发生吧.
            NSAssert(FALSE, @"suspendDownloadModel (existModel && DWDownloadStateRunning && dwDownloadModel==nil), videoIdx=%@", downloadModel.downloadBaseModel.videoModel.idx);
            existModal.downloadBaseModel.state = DWDownloadStateSuspended;
        }
    }
    else
    {
        existModal.downloadBaseModel.state = DWDownloadStateSuspended;
    }
}

// 取消下载 YES清除已下载的数据 NO不清除
- (void)cancleWithDownloadModel:(BXGDownloadModel*)downloadModel isClear:(BOOL)isClear
{
    BXGResourceManager *resourceManager = [BXGResourceManager shareInstance];
    BXGDownloadModel* existModal = [resourceManager existDowloadItem:downloadModel.downloadBaseModel.videoModel.idx];
    if(!existModal && existModal.downloadBaseModel.state==DWDownloadStateCompleted)
        return ;
    DWDownloadModel* dwDownloadModel = nil;
    if(_dictDownloadingDWDownloadModel)
    {
        dwDownloadModel = _dictDownloadingDWDownloadModel[existModal.downloadBaseModel.videoModel.idx];
    }
    if(existModal && dwDownloadModel!=nil)
    {
        existModal.downloadBaseModel.state = DWDownloadStateNone;//取消下载将状态重置
        [_dictDownloadingDWDownloadModel removeObjectForKey:existModal.downloadBaseModel.videoModel.idx];
        [[DWDownloadSessionManager manager] cancleWithDownloadModel:dwDownloadModel isClear:NO];

        //NSLog(@"###downloader cancleWithDownloadModel: the videoIdx=%@, removeModel=%p", downloadModel.downloadBaseModel.videoModel.idx, dwDownloadModel);

        return ;
    }
}

-(BXGVideoInfoItem*)needDownloadVideoInfo:(BXGVideoInfo*)videoInfo
{
    NSArray<BXGVideoInfoItem*> *videos = videoInfo.definitions;
    BXGVideoInfoItem *videoInfoItem = nil;
    if(videos && videos.count>0)
    {
        videoInfoItem = videos[videos.count-1];
    }
    return videoInfoItem;
}

/**
 判断URL是否有效
 *取得时间戳与失效时间戳做比对
 *http://d1-33.play.bokecc.com/flvs/cb/QxhEr/hKboX7hTIY-20.pcm?t=1496894440&key=F458F79EF07944EAAF38AC01A4F49CC9&upid=2625321496887240251
 *t=1496894440为失效时间点
 */
//*
-(BOOL)isValidateURL:(BXGDownloadModel *)model{
    BOOL bValidate = NO;
    BXGVideoInfoItem *needDownloadInfo = [self needDownloadVideoInfo:model.downloadBaseModel.videoInfo];
    if([NSString isEmpty:needDownloadInfo.playurl])
    {
        NSLog(@"invalidate playurl=%@", needDownloadInfo.playurl);
        return bValidate;
    }
    NSRange range =[needDownloadInfo.playurl rangeOfString:@"t="];
    NSRange timeRang =NSMakeRange(range.location+2, 10);
    NSString *oldStr =[needDownloadInfo.playurl substringWithRange:timeRang];
    NSLog(@"时间%@",oldStr);
    
    NSDate *date =[NSDate date];
    NSString *timeString =[NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
    NSString *nowString =[timeString substringWithRange:NSMakeRange(0, 10)];
    NSLog(@"__%@___%@",oldStr,nowString);
    
    if ([nowString integerValue] >= [oldStr integerValue]) {
        
        NSLog(@"url不可用");
        bValidate = NO;
    }else{
        NSLog(@"url可用");
        bValidate = YES;
    }
    return bValidate;
}

- (NSString*)downloadText:(BXGDownloadBaseModel*)model fromPageCell:(CALL_FROM_PAGE)callFromPage
{
    NSString *statusText = nil;
    switch (model.state) {
        case DWDownloadStateReadying:
            statusText=@"等待";
            break;
            
        case DWDownloadStateNone:
//            statusText=@"未开始";
            statusText=@"暂停";
            break;
            
        case DWDownloadStateRunning:
            if(callFromPage==CALL_FROM_PAGE_DOWNLOADING_CELL)
            {
                //显示下载进度
                statusText = [NSString stringWithFormat:@"%@/%@",
                                                       [[BXGResourceManager shareInstance] bytesToString:model.totalBytesWritten],
                                                       [[BXGResourceManager shareInstance] bytesToString:model.totalBytesExpectedToWrite]];
            }
            else if(callFromPage==CALL_FROM_PAGE_PLAY_LIST_CELL)
            {
                //显示下载速度
                model.progress = model.progress<0 ? 0 : model.progress;
                statusText = [NSString stringWithFormat:@"%.1f%%", model.progress*100];
            }
            else
            {
                statusText=@"";
            }
            break;
            
        case DWDownloadStateSuspended:
            statusText=@"暂停";
            break;
            
        case DWDownloadStateFailed:
            statusText=@"下载失败";
            break;
            
        case  DWDownloadStateCompleted:
            statusText=@"已下载";
            break;
        default:
            //don't happen
            assert(false);
            break;
    }
    return statusText;
}

@end
#pragma --mark end 下载器
