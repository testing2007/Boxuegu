//
//  BXGVideoInfoItem.m
//  Demo
//
//  Created by apple on 17/6/7.
//  Copyright © 2017年 com.bokecc.www. All rights reserved.
//

#import "BXGVideoInfoItem.h"

@implementation BXGVideoInfoItem

-(instancetype)initWithInfoItem:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        _definition = [dict[@"definition"] integerValue];
        _desp = dict[@"desp"];
        _playurl = dict[@"playurl"];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        _definition = [aDecoder decodeIntegerForKey:@"definition"];
        _desp = [aDecoder decodeObjectForKey:@"desp"];
        _playurl = [aDecoder decodeObjectForKey:@"playurl"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.definition forKey:@"definition"];
    [aCoder encodeObject:self.desp forKey:@"desp"];
    [aCoder encodeObject:self.playurl forKey:@"playurl"];
}

@end
