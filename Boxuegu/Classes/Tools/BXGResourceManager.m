//
//  BXGResourceManager.m
//  Demo
//
//  Created by apple on 17/6/7.
//  Copyright © 2017年 com.bokecc.www. All rights reserved.
//

#import "BXGResourceManager.h"
#import "BXGDownloadModel.h"
#import "BXGDatabase.h"
#import "BXGDownloadTable.h"
#import "BXGCourseOutlinePointModel.h"
#import "BXGCourseTable.h"
#import "BXGCourseModel.h"
#import "BXGDownloader.h"

@interface BXGResourceManager()<BXGNotificationDelegate>

@property(nonatomic, strong, readwrite) NSString *userDirectory;
@property(nonatomic, strong, readwrite) NSString *documentDirectory;
@property(nonatomic, strong, readwrite) NSString *downloadDirectory;

@property(strong, nonatomic, readwrite) NSMutableDictionary *dictDownloaded; //key=videoIdx, value=BXGDownloadModel
@property(strong, nonatomic, readwrite) NSMutableDictionary *dictDownloading;//key=videoIdx, value=BXGDownloadModel
@property(strong, nonatomic, readwrite) NSMutableDictionary *dictDownloadedRender; //key=courseId, value=BXGDownloadedRenderModel


@property(strong, nonatomic) BXGDownloadTable* downloadTable;

@property (nonatomic, assign, readwrite) CGFloat totalSizeInBytes;
@property (nonatomic, assign, readwrite) CGFloat freeSizeInBytes;

@end

@implementation BXGResourceManager

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static BXGResourceManager* instance = NULL;
    dispatch_once(&onceToken, ^{
        instance = [[BXGResourceManager alloc] init];
        
    });
    return instance;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)addLoginRegisterNotification
{
    // 监听用户登录登出
    [BXGNotificationTool addObserverForUserLogin:self];
}

-(void)catchUserLoginNotificationWith:(BOOL)isLogin
{
    if(isLogin)
    {
        //启动数据库
        [[BXGDatabase shareInstance] open];
        //初始化下载信息
        [[BXGResourceManager shareInstance] initialDowloadInfo];
    }
    else
    {
        //退出登录
        [[BXGDownloader shareInstance] cancelAllDownloading];
        [[BXGDatabase shareInstance] close];
    }
}

-(void)initialDowloadInfo
{
    _downloadTable = [[BXGDownloadTable alloc] init];
    _dictDownloaded = [[NSMutableDictionary alloc] initWithDictionary:[_downloadTable searchAllDownloaded]];
    _dictDownloading = [[NSMutableDictionary alloc] initWithDictionary:[_downloadTable searchAllDownloading]];
    _dictDownloadedRender = [[NSMutableDictionary alloc] initWithDictionary:[_downloadTable searchAllDownloadedOrderByCourseId]];
}

-(NSString*)documentDirectory
{
    if(!_documentDirectory)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _documentDirectory = [paths objectAtIndex:0];
        NSLog(@"the documentDirector=%@", _documentDirectory);
    }
    return _documentDirectory;
}

-(NSString*)userDirectory
{
    if(!_userDirectory)
    {
        _userDirectory = [NSString stringWithFormat:@"%@/%@", self.documentDirectory, [BXGUserDefaults share].userModel.user_id];
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        if(![defaultManager fileExistsAtPath:_userDirectory])
        {
            [defaultManager createDirectoryAtPath:_userDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return _userDirectory;
}

-(NSString*)appVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

-(NSString*)downloadDirectory
{
    if(!_downloadDirectory)
    {
        _downloadDirectory = [NSString stringWithFormat:@"%@/Download", [self userDirectory]];
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        if(![defaultManager fileExistsAtPath:_downloadDirectory])
        {
            [defaultManager createDirectoryAtPath:_downloadDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return _downloadDirectory;
}

-(NSString*)downloadDBPath
{
    NSString* strDBPath =  [self.userDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", DB_NAME]];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if(![defaultManager fileExistsAtPath:strDBPath])
    {
        [defaultManager createFileAtPath:strDBPath contents:nil attributes:nil];
    }
    return strDBPath;
}

-(NSString*)downloadFileNameByDownloadURL:(BXGDownloadBaseModel*)baseModel
{
    NSString *suffixName = [self parseDownloadFileSuffixNameByDownloadModel:baseModel];
    return [NSString stringWithFormat:@"%@.%@", baseModel.videoModel.idx, suffixName];
}

//-(NSString*)downloadFilePathByVideoIdx:(NSString*)videoIdx
//{
//    return [NSString stringWithFormat:@"%@/%@", self.downloadDirectory, [self downloadFileNameByVideoIdx:videoIdx]];
//}

-(NSString*)parseDownloadFileSuffixNameByDownloadURL:(NSString*)downloadURL
{
    assert(downloadURL!=nil);
    NSString *strUrl = downloadURL;
    NSString *suffixName = nil;
    if(strUrl)
    {
        NSRange range = [strUrl rangeOfString:@"?" options:NSCaseInsensitiveSearch];
        if(range.location != NSNotFound)
        {
            strUrl = [strUrl substringToIndex:range.location];
        }
        suffixName = strUrl.pathExtension;
        assert([suffixName compare:@"pcm" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
               [suffixName compare:@"mp4" options:NSCaseInsensitiveSearch] == NSOrderedSame);
        
        return suffixName;
    }
    return @"pcm";
}

-(NSString*)parseDownloadFileSuffixNameByDownloadModel:(BXGDownloadBaseModel*)baseModel
{
    return [self parseDownloadFileSuffixNameByDownloadURL:baseModel.downloadUrl];
}

-(NSString*)downloadFilePathByDownloadModel:(BXGDownloadBaseModel*)baseModel
{
    NSString *suffixName = [self parseDownloadFileSuffixNameByDownloadModel:baseModel];
    if(suffixName)
    {
        return [NSString stringWithFormat:@"%@/%@.%@", self.downloadDirectory, baseModel.videoModel.idx, suffixName];
    }
    return nil;
}

-(BOOL)isDownloadFileExistInLocalByVideoIdx:(NSString*)videoIdx withReturnLocalPath:(NSString**)returnLocalPath
{
    BXGDownloadModel *downloadedModel = [[BXGResourceManager shareInstance] existDownloadedItem:videoIdx withReturnLocalPath:returnLocalPath];
    return (downloadedModel!=nil) ? YES : NO;
}

-(BOOL)isAllVideoDownloadedUnderPointMode:(BXGCourseOutlinePointModel*)pointModel
{
    BOOL bAllDownloaded = YES;
    BOOL bDownloadedVideoItem = NO;
    NSMutableIndexSet *removeIndexSet = [NSMutableIndexSet new];
    int nIndex = 0;
    for(BXGCourseOutlineVideoModel* videoModelItem in pointModel.videos)
    {
        bDownloadedVideoItem = [self isDownloadFileExistInLocalByVideoIdx:videoModelItem.idx withReturnLocalPath:nil];
        if(bDownloadedVideoItem)
        {
            [removeIndexSet addIndex:nIndex];
        }
        ++nIndex;
        bAllDownloaded &= bDownloadedVideoItem;
    }
    if(!bAllDownloaded && removeIndexSet.count>0)
    {
        NSMutableArray *mutableVideos = [NSMutableArray arrayWithArray:pointModel.videos];
        [mutableVideos removeObjectsAtIndexes:removeIndexSet];
        pointModel.videos = [NSMutableArray arrayWithArray:mutableVideos];
    }
    return bAllDownloaded;
}

-(void)addDownloadingItem:(BXGDownloadModel*)item
{
    if(item.downloadBaseModel.state != DWDownloadStateCompleted)
    {
        [_dictDownloading setObject:item forKey:item.downloadBaseModel.videoModel.idx];
        NSLog(@"@@@add: addDownloadingItem:itemIdx=%@, _dictDownloading.count=%ld", item.downloadBaseModel.videoModel.idx, _dictDownloading.count);
        [_downloadTable addDownloadOneRecord:item];
    }
}

//-(void)recordAllDownloadingInfo
//{
//    for(BXGDownloadModel* item in self.dictDownloading.allValues)
//    {
//        [_downloadTable addDownloadOneRecord:item];
//    }
//}

-(void)removeDownloadingItem:(BXGDownloadModel*)item
{
    [_dictDownloading removeObjectForKey:item.downloadBaseModel.videoModel.idx];
    NSLog(@"@@@remove: removeDownloadingItem:itemIdx=%@, _dictDownloading.count=%ld", item.downloadBaseModel.videoModel.idx, _dictDownloading.count);
    [_downloadTable deleteDownloadingVideo:item];
}

-(void)removeDownloadingItemFromMemory:(BXGDownloadModel*)item
{
    [_dictDownloading removeObjectForKey:item.downloadBaseModel.videoModel.idx];
}

-(void)downloadedItem:(BXGDownloadModel*)item
{
//    if(item.downloadBaseModel.state == DWDownloadStateCompleted)
//    {
//        [_dictDownloading removeObjectForKey:item.downloadBaseModel.videoModel.idx];
        NSLog(@"@@@remove: downloadedItem:itemIdx=%@, _dictDownloading.count=%ld", item.downloadBaseModel.videoModel.idx, _dictDownloading.count);
        [_dictDownloaded setObject:item forKey:item.downloadBaseModel.videoModel.idx];
        [_downloadTable addDownloadOneRecord:item];
        
        [self updateDownloadedRenderInfo];
//    }
}

//删除单个课程下单个/多个/所有课程
-(void)removeDownloadedCourse:(BXGDownloadedRenderModel*)model
{
    [_downloadTable deleteDownloadedVideosUnderOneCourse:model];
    //删除已下载的缓存文件
    for(BXGDownloadBaseModel* item in model.arrDownloadModel)
    {
        [self removeDownloadedFile:item];
        [_dictDownloaded removeObjectForKey:item.videoModel.idx];
    }
    [self updateDownloadedRenderInfo];
}
//删除多个课程下单个/多个/所有课程
-(void)removeDownloadedCourses:(NSArray<BXGDownloadedRenderModel*>*)models
{
    for (BXGDownloadedRenderModel *downloadedRenderModelItem in models) {
        [self removeDownloadedCourse:downloadedRenderModelItem];
    }
}

-(void)removeDownloadedVideoIdx:(NSString*)videoIdx
{
    //删除数据库表信息
    [_downloadTable deleteDownloadedOneRecordWithVideoIdx:videoIdx];
    
    //删除缓存文件
    NSString *localFilePath = nil;
    if([self isDownloadFileExistInLocalByVideoIdx:videoIdx withReturnLocalPath:&localFilePath])
    {
        [self removeDownloadedFileByPath:localFilePath];
        [_dictDownloaded removeObjectForKey:videoIdx];
    }
//    [self updateDownloadedRenderInfo];
}

-(void)updateDownloadedRenderInfo
{
    //更新显示字典 todo 修改内存
    _dictDownloadedRender = [[NSMutableDictionary alloc] initWithDictionary:[_downloadTable searchAllDownloadedOrderByCourseId]];
}

-(void)removeDownloadedFileByPath:(NSString*)filePath
{
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    if([fileMgr fileExistsAtPath:filePath])
    {
        [fileMgr removeItemAtPath:filePath error:nil];
    }
}

-(void)removeDownloadedFile:(BXGDownloadBaseModel*)item
{
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSString* filePath = [self downloadFilePathByDownloadModel:item];
//    [self.downloadDirectory stringByAppendingString:item.downloadLocalFileName];
    if([fileMgr fileExistsAtPath:filePath])
    {
        [fileMgr removeItemAtPath:filePath error:nil];
    }
}

-(BXGDownloadModel*)existDowloadItem:(NSString*)videoIdx
{
    NSArray *arrDownloading = self.dictDownloading.allValues;
    for (BXGDownloadModel *item in arrDownloading) {
        if([item.downloadBaseModel.videoModel.idx isEqualToString:videoIdx])
        {
            return item;
        }
    }
    NSArray *arrDownloaded = self.dictDownloaded.allValues;
    for (BXGDownloadModel *item in arrDownloaded) {
        if([item.downloadBaseModel.videoModel.idx isEqualToString:videoIdx])
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *filePath = [self downloadFilePathByDownloadModel:item.downloadBaseModel];
            if(![fileManager fileExistsAtPath:filePath])
            {
                break;
            }
            return item;
        }
    }
    return nil;
}

-(BXGDownloadModel*)existDownloadedItem:(NSString*)videoIdx withReturnLocalPath:(NSString**)returnLocalPath
{
    NSArray *arrDownloaded = self.dictDownloaded.allValues;
    for (BXGDownloadModel *item in arrDownloaded) {
        if([item.downloadBaseModel.videoModel.idx isEqualToString:videoIdx])
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *filePath = [self downloadFilePathByDownloadModel:item.downloadBaseModel];
            if(![fileManager fileExistsAtPath:filePath])
            {
                break;
            }
            if(returnLocalPath!=nil)
            {
                *returnLocalPath = [NSString stringWithFormat:@"%@", filePath];
            }
            return item;
        }
    }
    return nil;
}


-(BXGDownloadModel*)existDownloadingItem:(NSString*)videoIdx
{
    NSArray *arrDownloading = self.dictDownloading.allValues;
    for (BXGDownloadModel *item in arrDownloading) {
        if([item.downloadBaseModel.videoModel.idx isEqualToString:videoIdx] && item.downloadBaseModel.state==DWDownloadStateRunning)
        {
            return item;
        }
    }
    return nil;
}

-(NSArray<BXGDownloadModel*>*)getAllRunningDownloadVideos
{
    NSMutableArray* downloadingArray = [NSMutableArray new];
    NSArray *arrDownloading = self.dictDownloading.allValues;
    for (BXGDownloadModel *item in arrDownloading) {
        if(item.downloadBaseModel.state==DWDownloadStateRunning)
        {
            [downloadingArray addObject:item];
        }
    }
    NSArray* returnArray = nil;
    if(downloadingArray.count>0)
    {
        returnArray = [NSArray arrayWithArray:downloadingArray];
    }
    return returnArray;
}

-(BXGDownloadModel*)checkNextReadyingDownloadModel
{
    NSArray *arrDownloading = self.dictDownloading.allValues;
    for (BXGDownloadModel *item in arrDownloading) {
        if(item.downloadBaseModel.state==DWDownloadStateReadying)
        {
            return item;
        }
    }
    return nil;
}

-(BOOL)isExistDownloadRunnningItem
{
    NSArray *arrDownloading = self.dictDownloading.allValues;
    for (BXGDownloadModel *item in arrDownloading) {
        if(item.downloadBaseModel.state==DWDownloadStateRunning)
        {
            return YES;
        }
    }
    return NO;
}

-(CGFloat)totalSizeInBytes
{
    if(_totalSizeInBytes>-0.1 && _totalSizeInBytes<0.1)
    {
        NSError *error = nil;
        NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error: &error];
        if(error) {
            NSLog(@"error: %@", error.localizedDescription);
        }
        else{
            NSNumber *_free = [dictionary objectForKey:NSFileSystemSize];
            _totalSizeInBytes = [_free unsignedLongLongValue];
        }
    }
    return _totalSizeInBytes;
}

-(CGFloat)freeSizeInBytes
{
    NSError *error = nil;
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if(error) {
        NSLog(@"error: %@", error.localizedDescription);
    }
    else{
        NSNumber *_free = [dictionary objectForKey:NSFileSystemFreeSize];
        _freeSizeInBytes = [_free unsignedLongLongValue];
    }
    return _freeSizeInBytes;
}

-(NSString*)totalSizeInString
{
    return [self bytesToString:[self totalSizeInBytes]];
}

-(NSString*)freeSizeInString
{
    return [self bytesToString:[self freeSizeInBytes]];
}

-(NSString*)bytesToString:(CGFloat)bytes
{
    NSString *strBytes;
    if(bytes>1024*1024*1024)
    {
        //GByte
        strBytes = [NSString stringWithFormat:@"%.1fGB", bytes/1024.f/1024.f/1024];
    }
    else if(bytes>1024*1024)
    {
        //MBytes
        strBytes = [NSString stringWithFormat:@"%.1fMB", bytes/1024.f/1024.f];
    }
    else if(bytes>1024)
    {
        //KBytes
        strBytes = [NSString stringWithFormat:@"%.1fKB", bytes/1024.f];
    }
    else
    {
        strBytes = [NSString stringWithFormat:@"%.1fB", bytes];
    }
    return strBytes;
}

-(void)clearUserDirectory; {

    self.userDirectory = nil;
}
@end
