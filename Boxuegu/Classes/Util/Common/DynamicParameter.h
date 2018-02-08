//
//  DynamicParameter.h
//  Boxuegu
//
//  Created by apple on 2017/9/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>


@class NetworkParameter;
@interface DynamicParameter : NSObject

-(void)addParameter:(NetworkParameter*)networkParameter;
-(void)setParameters:(NSArray<NetworkParameter*>*)arrNetworkParameter;
-(BOOL)isValidParameter:(NSString**)errorMessage;

@property(nonatomic, readonly, strong) NSDictionary *finalNetworkParameter;

@end
