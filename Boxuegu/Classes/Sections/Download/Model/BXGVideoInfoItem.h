//
//  BXGVideoInfoItem.h
//  Demo
//
//  Created by apple on 17/6/7.
//  Copyright © 2017年 com.bokecc.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXGVideoInfoItem : NSObject<NSCoding>

-(instancetype)initWithInfoItem:(NSDictionary*)dict;

@property(nonatomic, assign) NSInteger definition;
@property(nonatomic, strong) NSString *desp;
@property(nonatomic, strong) NSString *playurl;

@end
