//
//  BXGVideoInfo.m
//  Demo
//
//  Created by apple on 17/6/7.
//  Copyright © 2017年 com.bokecc.www. All rights reserved.
//

#import "BXGVideoInfo.h"
#import "BXGVideoInfoItem.h"

@implementation BXGVideoInfo

//@property(nonatomic, assign) NSInteger defaultDefinition;
//@property(nonatomic, strong) NSArray* definitionDescription;
//@property(nonatomic, strong) NSArray* definitions;

-(instancetype) initWithInfo:(NSDictionary*)dict
{
    self = [super init];
    if(self)
    {
        _defaultDefinition = [dict[@"defaultdefinition"] integerValue];
        _definitionDescription = dict[@"definitionDescription"];
        NSArray* arrDefinitions = dict[@"definitions"];
        NSMutableArray *arrVideoInfo = [NSMutableArray new];
        for (NSDictionary* dictItem in arrDefinitions) {
            BXGVideoInfoItem *item = [[BXGVideoInfoItem alloc] initWithInfoItem:dictItem];
            [arrVideoInfo addObject:item];
        }
        _definitions = [NSArray arrayWithArray:arrVideoInfo];
        _status = [dict[@"status"] integerValue];
        _statusInfo = dict[@"statusinfo"];
        _token = dict[@"token"];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        _defaultDefinition = [aDecoder decodeIntegerForKey:@"defaultDefinition"];
        _definitionDescription = [aDecoder decodeObjectForKey:@"definitionDescription"];
        _definitions = [aDecoder decodeObjectForKey:@"definitions"];
        _status = [aDecoder decodeIntegerForKey:@"status"];
        _statusInfo = [aDecoder decodeObjectForKey:@"statusInfo"];
        _token = [aDecoder decodeObjectForKey:@"token"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.defaultDefinition forKey:@"defaultDefinition"];
    [aCoder encodeObject:self.definitionDescription forKey:@"definitionDescription"];
    [aCoder encodeObject:self.definitions forKey:@"definitions"];
    [aCoder encodeInteger:self.status forKey:@"status"];
    [aCoder encodeObject:self.statusInfo forKey:@"statusInfo"];
    [aCoder encodeObject:self.token forKey:@"token"];
}

@end
