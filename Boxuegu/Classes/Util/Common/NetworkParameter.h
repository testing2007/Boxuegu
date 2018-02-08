//
//  NetworkParameter.h
//  Boxuegu
//
//  Created by apple on 2017/9/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkParameter : NSObject

@property(nonatomic, strong) NSString *key;
@property(nonatomic, strong) id value;
@property(nonatomic, assign) BOOL bOption;

-(instancetype)initObjectKey:(NSString*)key value:(id)value isOption:(BOOL)bOption;

@end
