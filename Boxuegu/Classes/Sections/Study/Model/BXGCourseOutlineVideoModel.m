//
//  BXGCourseOutlineVideoModel.m
//  Boxuegu
//
//  Created by HM on 2017/4/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseOutlineVideoModel.h"

@implementation BXGCourseOutlineVideoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"idx" :@"id"};
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        _idx = [aDecoder decodeObjectForKey:@"idx"];
        _video_id = [aDecoder decodeObjectForKey:@"video_id"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _lock_status = [aDecoder decodeObjectForKey:@"lock_status"];
        _sort = [aDecoder decodeObjectForKey:@"sort"];
        _study_status = [aDecoder decodeObjectForKey:@"study_status"];
        _superPointModel = [aDecoder decodeObjectForKey:@"superPointModel"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.idx forKey:@"idx"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.video_id forKey:@"video_id"];
    [aCoder encodeObject:self.lock_status forKey:@"lock_status"];
    [aCoder encodeObject:self.sort forKey:@"sort"];
    [aCoder encodeObject:self.study_status forKey:@"study_status"];
    [aCoder encodeObject:self.superPointModel forKey:@"superPointModel"];
}
@end
