//
//  DynamicParameter.m
//  Boxuegu
//
//  Created by apple on 2017/9/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "DynamicParameter.h"
#import "NetworkParameter.h"

@interface DynamicParameter()

@property(nonatomic, readwrite, strong) NSDictionary *finalNetworkParameter;

@property(nonatomic, strong) NSMutableArray<NetworkParameter*> *arrParameters;
-(BOOL)isValidParameter:(NSString**)errorMessage;

@end

@implementation DynamicParameter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _arrParameters = [NSMutableArray new];
        _finalNetworkParameter = [NSDictionary new];
    }
    return self;
}


-(void)addParameter:(NetworkParameter*)parameter
{
    [_arrParameters addObject:parameter];
}

-(void)setParameters:(NSArray<NetworkParameter*>*)arrNetworkParameter
{
    _arrParameters =[[NSMutableArray alloc] initWithArray:arrNetworkParameter];
}

-(BOOL)isValidParameter:(NSString**)errorMessage
{
    __block BOOL bValid = YES;
    NSMutableDictionary *dictParameter = [NSMutableDictionary new];
    [_arrParameters enumerateObjectsUsingBlock:^(NetworkParameter * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(!obj.bOption) {
            if(!obj.value)
            {
                bValid = false;
                return ;
            }
        }
        
        //不可选 或者 可选且value不为空, 才放入参数里面
        if(!obj.bOption ||
           (obj.bOption && obj.value) ) {
            [dictParameter setObject:obj.value forKey:obj.key];
        }
    }];
    //最终网络传输参数集
    _finalNetworkParameter = [NSDictionary dictionaryWithDictionary:dictParameter];
    return bValid;
}

@end
