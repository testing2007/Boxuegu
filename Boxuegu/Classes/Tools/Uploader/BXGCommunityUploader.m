//
//  BXGCommunityUploader.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/1.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommunityUploader.h"
#import "BXGCommunityUploaderItem.h"

static BXGCommunityUploader *_instance;

@interface BXGCommunityUploader()
@property (nonatomic, strong) BXGCommunityUploaderItem *currentItem;
@end

@implementation BXGCommunityUploader

#pragma mark - Interface

+ (instancetype)share; {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [BXGCommunityUploader new];
    });
    return _instance;
}

#pragma mark - Function

- (void)uploadCommunityImageArray:(NSArray *)imageArray andFinishedBlock:(void(^)(NSArray<NSString *> *urlStringArray))finishedBlock; {
    Weak(weakSelf);
    // 创建下载任务
    BXGCommunityUploaderItem *item = [BXGCommunityUploaderItem new];
    self.currentItem = item;
    item.imageArray = imageArray;
    item.imageDictionary = [NSMutableDictionary new];
    // 成功回调
    item.succeedBlock = ^(NSArray<NSString *> *urlStringArray) {
        finishedBlock(urlStringArray);
        weakSelf.currentItem = nil;
    };
    // 失败回调
    item.failedBlock = ^{
        finishedBlock(nil);
        weakSelf.currentItem = nil;
    };
    // 开启任务
    [item start];
}
@end
