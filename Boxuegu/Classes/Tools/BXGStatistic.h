//
//  BXGStatistic.h
//  Boxuegu
//
//  Created by apple on 2017/7/21.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXGStatistic : NSObject

+(instancetype)shareInstance;

//恢复记录的统计数据
-(void)recoverAllInfoFromPlist;

//记录统计数据
-(void)recordAllInfoIntoPlist;

//检测是否应该弹出评价窗口
-(BOOL)isShouldPopupComment;

//添加启动次数
-(void)addLaunchTimes;

//去AppStore评价
-(void)redirectCommentLink;
//吐个槽
-(void)toFeedback;
//取消评价
-(void)cancelComment;

-(void)prepareForNextComment;

@end
