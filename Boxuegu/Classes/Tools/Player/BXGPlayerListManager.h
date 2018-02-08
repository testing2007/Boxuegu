//
//  BXGPlayerListManager.h
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/18.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXGVODPlayerVideoModel : NSObject

@property (nonatomic, strong) NSString *idx;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *resourceId;
@end

@class BXGPlayerListManager;

@protocol BXGPlayerListManagerDelegate <NSObject>

- (void)playerListManager:(BXGPlayerListManager *)manager playingVideo:(BXGVODPlayerVideoModel *)video index:(NSInteger)index;

- (void)playerListManager:(BXGPlayerListManager *)manager doneWithVideo:(BXGVODPlayerVideoModel *)video index:(NSInteger)index; // 播放完毕

- (BOOL)playerListManager:(BXGPlayerListManager *)manager willPlayVideo:(BXGVODPlayerVideoModel *)video index:(NSInteger)index;


- (void)playerListManager:(BXGPlayerListManager *)manager stopWithPlayVideo:(BXGVODPlayerVideoModel *)video index:(NSInteger)index; // 手动或异常中断

- (void)playerListManager:(BXGPlayerListManager *)manager doneWithPlayList:(NSArray<BXGVODPlayerVideoModel *> *)playList;
@end

@interface BXGPlayerListManager : NSObject

@property (nonatomic, strong) id<BXGPlayerListManagerDelegate> delegate;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger listCount;
@property (nonatomic, strong) BXGVODPlayerVideoModel *currentVideo;
@property (nonatomic, strong) NSArray <BXGVODPlayerVideoModel *> *videos; // readonly

- (void)playWithVideoList:(NSArray <BXGVODPlayerVideoModel *> *)videos andPlay:(BOOL)isPlay; //
- (void)playOnListWithVideoId:(NSString *)videoId;
- (void)playOnListWithIndex:(NSInteger)index;
- (void)playNext;
- (void)uninstall;
@end
