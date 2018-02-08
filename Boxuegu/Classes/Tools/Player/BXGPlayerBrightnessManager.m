//
//  BXGPlayerBrightnessManager.m
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/17.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGPlayerBrightnessManager.h"

static BXGPlayerBrightnessManager *_instance;

@implementation BXGPlayerBrightnessManager

+ (instancetype)share {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [BXGPlayerBrightnessManager new];
        
        
    });
    return _instance;
}
@end
