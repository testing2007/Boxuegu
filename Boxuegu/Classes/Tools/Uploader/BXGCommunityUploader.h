//
//  BXGCommunityUploader.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/1.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 博学圈: 图片上传器
 */
@interface BXGCommunityUploader : NSObject

/**
 单例

 @return 单例
 */
+ (instancetype)share;

/**
 上传图片

 @param imageArray 图片数组
 @param finishedBlock 成功回调(返回url数组)
 */
- (void)uploadCommunityImageArray:(NSArray *)imageArray andFinishedBlock:(void(^)(NSArray<NSString *> *urlStringArray))finishedBlock;
@end
