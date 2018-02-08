//
//  BXGSampleOutlineView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGSampleOutlineView.h"
#import "BXGSampleOutlineViewModel.h"

@interface BXGSampleOutlineView()
@property (nonatomic, strong) BXGSampleOutlineViewModel *viewModel;
@property (nonatomic, strong) NSString *courseId;
@end

@implementation BXGSampleOutlineView

- (BXGSampleOutlineViewModel *)viewModel {
    if(_viewModel == nil){
        _viewModel = [[BXGSampleOutlineViewModel alloc]initWithCourseId:_courseId];
    }
    return _viewModel;
}

- (instancetype)initWithCourseId:(NSString *)courseId {
    self = [super initWithFrame:CGRectZero];
    if(self){
        _courseId = courseId;
        [self.viewModel loadDataForSampleOutline];
    }
    return self;
}


@end
