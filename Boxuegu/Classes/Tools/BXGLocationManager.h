//
//  BXGLocationManager.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXGLocationManager : NSObject
+ (instancetype)share;
- (void)requestCurrentProvinceAndCityStringWithFinishedBlock:(void(^)(NSString *string))finishedBlock;
@end
