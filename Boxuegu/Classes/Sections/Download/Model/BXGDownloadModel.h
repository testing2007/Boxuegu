//
//  BXGDownloadModel.h
//  Demo
//
//  Created by apple on 17/6/7.
//  Copyright © 2017年 com.bokecc.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BXGDownloadProgress;
@class BXGVideoInfo;
@class BXGCourseOutlineVideoModel;
@interface BXGDownloadBaseModel : NSObject///<NSCoding>

@property (strong, nonatomic) BXGVideoInfo *videoInfo;//文件总的信息

/*
 *视频videoId
 */
@property (nonatomic, strong) BXGCourseOutlineVideoModel *videoModel;
//@property (nonatomic, strong) NSString *videoIdx;//视频idx,确保唯一
//@property (nonatomic, strong) NSString *videoId; //视频id,有可能有重复
@property (nonatomic, strong) NSString *courseId;//课程id
@property (nonatomic, strong) NSString *pointId; //点id
@property (nonatomic, assign) NSInteger downloadQualityDefinition;//下载的definition, 10-清晰, 20-高清
@property (nonatomic, strong) NSString *downloadQualityDesp;      //下载的desp
@property (nonatomic, strong) NSString *downloadUrl;              //下载的url
@property (nonatomic, strong) NSString *downloadLocalFileName;    //视频本地存储文件名

// 下载状态
@property (nonatomic, assign) DWDownloadState state;
// 续传大小
@property (nonatomic, assign) int64_t resumeBytesWritten;
// 这次写入的数量
@property (nonatomic, assign) int64_t bytesWritten;
// 已下载的数量
@property (nonatomic, assign) int64_t totalBytesWritten;
// 文件的总大小
@property (nonatomic, assign) int64_t totalBytesExpectedToWrite;
// 下载进度
@property (nonatomic, assign) float progress;
// 下载速度
@property (nonatomic, assign) float speed;
// 下载剩余时间
@property (nonatomic, assign) int remainingTime;

@end

@class BXGCourseModel;
@class BXGCourseOutlinePointModel;

@interface BXGDownloadModel : NSObject

@property (nonatomic, strong) BXGDownloadBaseModel* downloadBaseModel;
@property (nonatomic, strong) BXGCourseModel* course;
@property (nonatomic, strong) BXGCourseOutlinePointModel* point;

-(BXGDownloadModel*)initDownloadedModel:(BXGDownloadBaseModel*)dowloadModel
                          withCourseModel:(BXGCourseModel*)courseModel
                           withPointModel:(BXGCourseOutlinePointModel*)pointModel;

-(instancetype)init;

@end

@interface BXGDownloadedRenderModel : NSObject

@property (nonatomic, strong) BXGCourseModel *courseModel;
@property (nonatomic, strong) NSMutableArray<BXGCourseOutlinePointModel*> *arrPointModel;
@property (nonatomic, strong) NSMutableArray<BXGDownloadBaseModel*> *arrDownloadModel;

-(CGFloat)allVideoTotalSpace;
-(CGFloat)subVideoSpace:(BXGDownloadBaseModel*)subModel;

@end

