//
//  NetworkParameter.m
//  Boxuegu
//
//  Created by apple on 2017/9/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "NetworkParameter.h"

@implementation NetworkParameter
-(instancetype)initObjectKey:(NSString*)key value:(id)value isOption:(BOOL)bOption
{
    self = [super init];
    if(self)
    {
        _key = key;
        _value = value;
        _bOption = bOption;
    }
    return self;
}

@end
