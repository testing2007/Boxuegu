//
//  BXGSampleOutlineViewModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGSampleOutlineViewModel.h"

@interface BXGSampleOutlineViewModel()
@property (nonatomic, copy) NSString *courseId;
@end

@implementation BXGSampleOutlineViewModel
- (instancetype)initWithCourseId:(NSString *)courseId {
    self = [super init];
    if(self) {
        _courseId = courseId;
    }
    return self;
}
- (void)loadDataForSampleOutline {
    [self.networkTool requestCourseTryOutlineWithCourseId:_courseId andFinished:^(id  _Nullable responseObject) {
        RWLog(@"responseObject")
    } andFailed:^(NSError * _Nonnull error) {
        
    }];
}
@end
