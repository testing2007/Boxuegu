//
//  BXGPlayerListManager.m
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/18.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGPlayerListManager.h"
#import "BXGPlayerManager.h"

static BXGPlayerListManager *_instance;

@interface BXGPlayerListManager() <BXGPlayerManagerDelegate>
@property (nonatomic, strong) BXGPlayerManager *playerManager;



@end

@implementation BXGPlayerListManager

#pragma mark - method

- (BXGPlayerManager *)playerManager {
    
    if(_playerManager == nil) {
        
        _playerManager = [BXGPlayerManager share];
    }
    return _playerManager;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        [self.playerManager addDelegate:self];
    }
    return self;
}
- (void)dealloc {
    
}

- (void)playWithVideoList:(NSArray <BXGVODPlayerVideoModel *> *)videos andPlay:(BOOL)isPlay {
    self.videos = videos;
    
    if(videos.count > 0 && isPlay) {
        [self playOnListWithIndex:0];
    }
}

- (void)uninstall {
    [self.playerManager removeDelegate:self];
}

- (void)playOnListWithVideoId:(NSString *)videoId {
    // 搜索相应的 video idx
    
    NSInteger index = -1;
    
    for(NSInteger i = 0; i < self.videos.count; i ++) {
        BXGVODPlayerVideoModel *videoModel = self.videos[i];
        if([videoModel.idx isEqualToString:videoId]) {
            index = i;
            break;
        }
    }
    
    if(index != -1) {
        [self playOnListWithIndex:index];
    }
}

// 入口
- (void)playOnListWithIndex:(NSInteger)index {

    if(index >= self.videos.count) {
        return;
    }

    self.currentIndex = index;
    BXGVODPlayerVideoModel *videoModel = self.videos[index];
    self.currentVideo = videoModel;
    [self playWithVideoModel:videoModel];
}

// 私有播放
- (void)playWithVideoModel:(BXGVODPlayerVideoModel *)videoModel {

    [self.playerManager playWithVideoId:videoModel.resourceId];
}

- (BOOL)checkNext {
    
    if(self.currentIndex + 1 < self.videos.count) {
        
        return true;
    }
    return false;
}

- (void)playNext {
    
    [self playOnListWithIndex:self.currentIndex + 1];
}

#pragma mark - playerManager

- (void)setDefalutPlayList {
    self.currentIndex = 0;
}

- (void)playerManagerVideoReadyToPlay:(BXGPlayerManager *)playerManager {
    // 调用 开始播放 代理
}
- (void)playerManagerVideoDidReachEnd:(BXGPlayerManager *)playerManager {
    
    // 调用 结束播放 代理
    if([self.delegate respondsToSelector:@selector(playerListManager:doneWithVideo:index:)]) {
        [self.delegate playerListManager:self doneWithVideo:self.currentVideo index:self.currentIndex];
    }

    // 判断有没有下一个
    if(self.currentIndex + 1 < self.videos.count) {
        // 存在下一个
        if([self.delegate respondsToSelector:@selector(playerListManager:willPlayVideo:index:)]) {
            if(![self.delegate playerListManager:self willPlayVideo:self.videos[self.currentIndex + 1] index:self.currentIndex + 1]) {
                // 不执行下一个
                return;
            }
        }
        [self playNext];
    }else {
        // 播放结束
        if([self.delegate respondsToSelector:@selector(playerListManager:doneWithPlayList:)]) {
            [self.delegate playerListManager:self doneWithPlayList:self.videos];
        }
    }
}

- (void)playerManagerVideoDidStop:(BXGPlayerManager *)playerManager {
    if([self.delegate respondsToSelector:@selector(playerListManager:stopWithPlayVideo:index:)]) {
        
        [self.delegate playerListManager:self stopWithPlayVideo:self.currentVideo index:self.currentIndex];
    }
}

@end


@implementation BXGVODPlayerVideoModel : NSObject
@end
