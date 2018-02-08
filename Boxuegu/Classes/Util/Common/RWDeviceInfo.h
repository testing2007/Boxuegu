//
//  RWDeviceInfo.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/28.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWDeviceInfo : NSObject
typedef enum : NSUInteger {
    RWDeviceScreenTypeLowerSE = -1,
    RWDeviceScreenTypeSE = 0,
    RWDeviceScreenTypeUpperSE = 1,
    RWDeviceScreenTypePlus = 2,
    //    RWDeviceScreenType6_7Plus,
    //    RWDeviceScreenTypeUpperPlus,
}RWDeviceScreenType;
+ (RWDeviceScreenType)deviceScreenType;
+ (NSString *)deviceModel;
@end
