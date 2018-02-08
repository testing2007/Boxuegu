 //
//  BXGCourseOutlinePointModel.m
//  Boxuegu
//
//  Created by HM on 2017/4/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseOutlinePointModel.h"



@implementation BXGCourseOutlinePointModel

-(instancetype)init
{
    self = [super init];
    if(self){
        _videos = [NSMutableArray new];
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"idx" :@"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"videos":[BXGCourseOutlineVideoModel class]};
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        _videos = [aDecoder decodeObjectForKey:@"videos"];
        _idx = [aDecoder decodeObjectForKey:@"idx"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _parent_id = [aDecoder decodeObjectForKey:@"parent_id"];
        _lock_status = [aDecoder decodeObjectForKey:@"lock_status"];
        _barrier_status = [aDecoder decodeObjectForKey:@"barrier_stauts"];
        _sort = [aDecoder decodeObjectForKey:@"sort"];
        //### _superChapterModel = [aDecoder decodeObjectForKey:@"superChapterModel"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.videos forKey:@"videos"];
    [aCoder encodeObject:self.idx forKey:@"idx"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.parent_id forKey:@"parent_id"];
    [aCoder encodeObject:self.lock_status forKey:@"lock_status"];
    [aCoder encodeObject:self.barrier_status forKey:@"barrier_status"];
    [aCoder encodeObject:self.sort forKey:@"sort"];
    //###  [aCoder encodeObject:self.superChapterModel forKey:@"superChapterModel"]; //todo 不能对weak属性进行操作
}

//- (id)copyWithZone:(nullable NSZone *)zone
//{
    /*
     @property (nonatomic, strong) NSArray<BXGCourseOutlineVideoModel *> *videos; // BXGCourseOutlineVideoModel
     @property (nonatomic, strong) NSString *idx;
     @property (nonatomic, strong) NSString *name;
     @property (nonatomic, strong) NSString *parent_id;
     @property (nonatomic, assign) NSNumber *lock_status;
     @property (nonatomic, assign) NSNumber *barrier_status;
     @property (nonatomic, strong) NSNumber *sort;
     @property (nonatomic,weak) BXGCourseOutlineChapterModel *superChapterModel;
    //*/
  //  BXGCourseOutlinePointModel *model = [BXGCourseOutlinePointModel allocWithZone:zone];
    /*
    for (BXGCourseOutlineVideoModel* item in model.videos) {
        item = BXGCourseOutlineVideoModel cop
    }
    //*/  
//}

- (NSInteger)indexForVideoModel:(BXGCourseOutlineVideoModel *)videoModel;{
    
    if(videoModel == nil) {
    
    
        return NSNotFound;
    }
        
    for(NSInteger i = 0; i < self.videos.count; i ++) {
    
        if(self.videos[i] == videoModel){
        
            return i;
        }
    }
    return NSNotFound;
    
}

- (NSInteger)indexForVideoId:(NSString *)videoId; {

    if(videoId == nil) {
        
        
        return NSNotFound;
    }
    
    for(NSInteger i = 0; i < self.videos.count; i ++) {
        
        if([self.videos[i].idx isEqualToString: videoId]){
            
            return i;
        }
    }
    return NSNotFound;

}

- (BXGCourseOutlineVideoModel *)videoModelForVideoId:(NSString *)videoId; {
    
    if(videoId == nil) {
        
        
        return nil;
    }
    
    for(NSInteger i = 0; i < self.videos.count; i ++) {
        
        if([self.videos[i].idx isEqualToString: videoId]){
            
            return self.videos[i];
        }
    }
    return nil;
    
}

- (void)setVideos:(NSMutableArray<BXGCourseOutlineVideoModel *> *)videos {

    _videos = videos;
}

- (BXGCourseOutlineVideoModel *)videoModelForLastLearned; {

    NSTimeInterval lastInterval = 0;
    NSInteger lastIndex = NSNotFound;
    
    for (NSInteger i = 0; i < self.videos.count; i ++) {
    
        if(self.videos[i].last_learn_time) {
        
            NSDate *date = [[BXGDateTool share] dateFormFormaterStringForLongRequest:self.videos[i].last_learn_time];
            if(date) {
            
                NSTimeInterval interval = [date timeIntervalSinceNow];
                
                if(interval >= lastInterval || lastInterval == 0) {
                
                    lastInterval = interval;
                    lastIndex = i;
                }
            }
        }
    }
    if(lastIndex != NSNotFound && lastIndex < self.videos.count) {
    
        return self.videos[lastIndex];
    }else {
    
        return nil;
    }
}
@end
