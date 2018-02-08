//
//  BXGBaseModel.m
//  Boxuegu
//
//  Created by HM on 2017/5/12.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@implementation BXGBaseModel

/**
 模型转字典
 提示:不会把空值传入字典
 */
- (NSDictionary<NSString *,id> *)dictionaryWithValuesForKeys:(NSArray<NSString *> *)keys {
    
    NSMutableArray * fittedKeys = [NSMutableArray new];
    NSArray *allkeys = keys;
    for(NSInteger i = 0; i < allkeys.count; i++) {
        
        id value = [self valueForKey:allkeys[i]];
        if(value && (value != [NSNull null])) {
            
            [fittedKeys addObject:allkeys[i]];
        }
    }
    if(fittedKeys.count > 0) {
        
        return [super dictionaryWithValuesForKeys:fittedKeys];
    }else {
        
        return [NSDictionary new];
    }
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"idx" : @"id",
            @"des" : @"description",
            @"isDelete" : @"delete"
            };
}
@end
