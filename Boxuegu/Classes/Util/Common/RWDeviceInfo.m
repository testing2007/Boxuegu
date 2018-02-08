//
//  RWDeviceInfo.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/28.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "RWDeviceInfo.h"

@implementation RWDeviceInfo

+ (RWDeviceScreenType)deviceScreenType; {

    
    UIScreen *screen = [UIScreen mainScreen];
    if(screen.scale == 3) {
    
        return RWDeviceScreenTypePlus;
    }
    NSInteger value = screen.scale * screen.scale * screen.bounds.size.width * screen.bounds.size.height - (640 * 1136);
    if(value > 0){
    
        return RWDeviceScreenTypeUpperSE;
    }
    
    if(value == 0){
    
        return RWDeviceScreenTypeSE;

    }else {
    
        return RWDeviceScreenTypeLowerSE;
    }

}

+ (NSString *)deviceModel; {

    return @"ios-mobile";
//    if([@"iPhone" isEqualToString:[UIDevice currentDevice].model]) {
//
//        return @"ios-mobile";
//    }else {
//
//        return @"ios-pad";
//    }
}

@end
