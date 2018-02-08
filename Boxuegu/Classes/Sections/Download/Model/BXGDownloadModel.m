//
//  BXGDownloadModel.m
//  Demo
//
//  Created by apple on 17/6/7.
//  Copyright © 2017年 com.bokecc.www. All rights reserved.
//

#import "BXGDownloadModel.h"
#import "BXGVideoInfo.h"
#import "BXGDownloader.h"

@implementation BXGDownloadBaseModel

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _videoInfo = [BXGVideoInfo new];
        _videoModel = [BXGCourseOutlineVideoModel new];
        _state = DWDownloadStateNone;
    }
    
    return self;
}


//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super init];
//    if (self) {
//        _videoInfo = [aDecoder decodeObjectForKey:@"videoInfo"];
//        _videoId = [aDecoder decodeObjectForKey:@"videoId"];
//        
//        _downloadQualityDefinition = [aDecoder decodeIntegerForKey:@"downloadQualityDefinition"];
//        _downloadQualityDesp = [aDecoder decodeObjectForKey:@"downloadQualityDesp"];
//        _downloadUrl = [aDecoder decodeObjectForKey:@"downloadUrl"];
//        _downloadLocalFileName = [aDecoder decodeObjectForKey:@"downloadLocalFileName"];
//        _state = [aDecoder decodeIntegerForKey:@"state"];
//        _resumeBytesWritten = [aDecoder decodeInt64ForKey:@"resumeBytesWritten"];
//        _bytesWritten = [aDecoder decodeInt64ForKey:@"bytesWritten"];
//        _totalBytesWritten = [aDecoder decodeInt64ForKey:@"totalBytesWritten"];
//        _totalBytesExpectedToWrite = [aDecoder decodeInt64ForKey:@"totalBytesExpectedToWrite"];
//        _progress = [aDecoder decodeFloatForKey:@"progress"];
//        _speed = [aDecoder decodeFloatForKey:@"speed"];
//        _remainingTime = [aDecoder decodeIntForKey:@"remainingTime"];
//    }
//    return self;
//}
//
//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeObject:self.videoInfo forKey:@"videoInfo"];
//    [aCoder encodeObject:self.videoId forKey:@"videoId"];
//    [aCoder encodeInteger:self.downloadQualityDefinition forKey:@"downloadQualityDefinition"];
//    [aCoder encodeObject:self.downloadQualityDesp forKey:@"downloadQualityDesp"];
//    [aCoder encodeObject:self.downloadUrl forKey:@"downloadUrl"];
//    [aCoder encodeObject:self.downloadLocalFileName forKey:@"downloadLocalFileName"];
//    [aCoder encodeInteger:self.state forKey:@"state"];
//    [aCoder encodeInt64:self.resumeBytesWritten forKey:@"resumeBytesWritten"];
//    [aCoder encodeInt64:self.bytesWritten forKey:@"bytesWritten"];
//    [aCoder encodeInt64:self.totalBytesWritten forKey:@"totalBytesWritten"];
//    [aCoder encodeInt64:self.totalBytesExpectedToWrite forKey:@"totalBytesExpectedToWrite"];
//    [aCoder encodeFloat:self.progress forKey:@"progress"];
//    [aCoder encodeFloat:self.speed forKey:@"speed"];
//    [aCoder encodeInt:self.remainingTime forKey:@"remainingTime"];
//}

-(void)dealloc
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

//-(void)setState:(DWDownloadState)newState
//{
//    if(_state != newState)
//    {
//        _state = newState;
//        [[BXGDownloader shareInstance] notifyObserver:self];
//    }
//}

//-(void)setProgress:(float)newProgress
//{
//    if(newProgress>1.0 || newProgress<0)
//    {
//        NSAssert(FALSE, @"the progress is unnormally, videoId=%@", _videoModel.video_id);
//        return ;
//    }
//    if(_progress != newProgress)
//    {
//        NSLog(@"the videoIdx=%@, progress=%lf", _videoModel.video_id, newProgress);
//        _progress = newProgress;
//        [[BXGDownloader shareInstance] notifyObserver:self];
//    }
//}

@end

#pragma mark begin 已下载完成模型
@implementation BXGDownloadModel
-(BXGDownloadModel*)initDownloadedModel:(BXGDownloadBaseModel*)downloadModel
                          withCourseModel:(BXGCourseModel*)courseModel
                           withPointModel:(BXGCourseOutlinePointModel*)pointModel
{
    self = [super init];
    if(self)
    {
        _downloadBaseModel = downloadModel;
        _course = courseModel;
        _point = pointModel;
//        _point.videos = [NSArray arrayWithObject:_downloadBaseModel.videoModel];
    }
    return self;
    
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _downloadBaseModel = [BXGDownloadBaseModel new];
        _course = [BXGCourseModel new];
        _point = [BXGCourseOutlinePointModel new];
    }
    return self;
}

@end
#pragma mark end 已下载完成模型

#pragma mark begin 已下载完成显示模型
@implementation BXGDownloadedRenderModel

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _courseModel = [BXGCourseModel new];
        _arrPointModel = [NSMutableArray new];
        _arrDownloadModel = [NSMutableArray new];
    }
    return self;
}

-(CGFloat)allVideoTotalSpace
{
    CGFloat totalSizeInBytes = 0;
    for (BXGDownloadBaseModel* downloadBaseModel in self.arrDownloadModel)
    {
        totalSizeInBytes += downloadBaseModel.totalBytesExpectedToWrite;
    }
    return totalSizeInBytes;
}

-(CGFloat)subVideoSpace:(BXGDownloadBaseModel*)subModel
{
    CGFloat subVideoSpace = 0;
    for (BXGDownloadBaseModel* downloadBaseModel in self.arrDownloadModel)
    {
        if([downloadBaseModel.videoModel.idx isEqualToString:subModel.videoModel.idx])
        {
            subVideoSpace = downloadBaseModel.totalBytesExpectedToWrite;
        }
    }
    return subVideoSpace;
}


@end

#pragma mark end 已下载完成显示模型


