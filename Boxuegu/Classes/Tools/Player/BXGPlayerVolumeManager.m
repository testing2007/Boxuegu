//
//  BXGPlayerVolumeManager.m
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/17.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGPlayerVolumeManager.h"
#import <MediaPlayer/MediaPlayer.h>

static BXGPlayerVolumeManager *_instance;
@interface BXGPlayerVolumeManager()
@property (nonatomic, strong) UISlider *volumeViewSlider;
@end
@implementation BXGPlayerVolumeManager

+ (instancetype)share {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [BXGPlayerVolumeManager new];
    });
    return _instance;
}

- (UISlider *)volumeViewSlider {
    
    if(_volumeViewSlider == nil) {
        
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        for (UIView *view in [volumeView subviews]) {
            
            if ([view.class.description isEqualToString:@"MPVolumeSlider"])
            {
                _volumeViewSlider = (UISlider *)view;
                break;
            }
        }
    }
    return _volumeViewSlider;
}

-  (float)volume {
    
    if(self.volumeViewSlider) {
        return self.volumeViewSlider.value;
    }
    return 0;
}

- (void)setVolume:(float)volume {
    
    if(self.volumeViewSlider) {
        self.volumeViewSlider.value = volume;
    }
}

- (void)setVlomeWithStartVolumeOffset:(float)offset  {
    self.volume = self.startVolume + offset;
}

@end
