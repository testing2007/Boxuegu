//
//  RWCommonFunction.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "RWCommonFunction.h"

double RWAutoFontSize(double fontSize) {

    UIScreen *screen = [UIScreen mainScreen];
    
    NSInteger value = screen.scale * screen.scale * screen.bounds.size.width * screen.bounds.size.height - (640 * 1136);
    if(value <= 0){
        
        return fontSize;
    }
    
    if(screen.scale == 3){
    
        return fontSize + 2;
    }else {
    
        return fontSize;
    }
}
NSString *formatSecondsToString(NSInteger seconds) {
    NSString *hhmmss = nil;
    if (seconds < 0) {
        return @"00:00:00";
    }
    
    int h = (int)round((seconds%86400)/3600);
    int m = (int)round((seconds%3600)/60);
    int s = (int)round(seconds%60);
    
    hhmmss = [NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s];
    
    return hhmmss;
}

NSString *stringFormCMTime(CMTime cmTime) {
    
    float allSec = CMTimeGetSeconds(cmTime);
    NSInteger hour = (NSInteger)allSec / 60 / 60;
    NSInteger min = (NSInteger)allSec / 60;
    NSInteger sec = (NSInteger)allSec % 60;
    
    return [NSString stringWithFormat:@"%02zd:%02zd:%02zd",hour,min,sec];
}
