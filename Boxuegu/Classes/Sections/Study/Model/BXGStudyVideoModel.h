//
//  BXGLastVideoModel.h
//  Boxuegu
//
//  Created by HM on 2017/5/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 学习中心视频模型
 */
@interface BXGStudyVideoModel : BXGBaseModel

/// 用户Id
@property (nonatomic, strong) NSString *userId;

/// 知识点Id
@property (nonatomic, strong) NSString *pointId;

/// 知识点Name
@property (nonatomic, strong) NSString *pointName;

/// 课程Id(职业课/微课)
@property (nonatomic, strong) NSString *courseId;

/// cc视频资源id (CC)
@property (nonatomic, strong) NSString *videoId;

/// 唯一id号 (BXG)
@property (nonatomic, strong) NSString *bxgvideoId;

/// 视频名称
@property (nonatomic, strong) NSString *videoName;

/// 播放时长
@property (nonatomic, strong) NSString *playbackTime;

@end
