//
//  BXGPlayerVolumeManager.h
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/17.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXGPlayerVolumeManager : NSObject
+ (instancetype)share;

@property (nonatomic, assign) float startVolume;
- (void)setVlomeWithStartVolumeOffset:(float)offset;

@property(nonatomic) float volume;
@end
