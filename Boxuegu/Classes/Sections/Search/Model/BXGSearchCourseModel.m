//
//  BXGSearchCourseModel.m
//  Boxuegu
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGSearchCourseModel.h"

@implementation BXGSearchCourseModel

+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"items" : [BXGHomeCourseModel class]};
}

-(NSMutableArray*)items {
    if(_items==nil) {
        _items = [NSMutableArray new];
    }
    return _items;
}

@end
