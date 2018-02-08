//
//  BXGCourseTryOutlineViewModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseTryOutlineViewModel.h"
#import "BXGCourseOutlineChapterModel.h"

@interface BXGCourseTryOutlineViewModel()
@property (nonatomic, copy) NSString *courseId;
@end

@implementation BXGCourseTryOutlineViewModel
- (instancetype)initWithCourseId:(NSString *)courseId {
    self = [super init];
    if(self) {
        _courseId = courseId;
    }
    return self;
}
- (void)loadDataForSampleOutlineWithFinihsed:(void(^)(NSArray<BXGCourseOutlineChapterModel *> *models))finished {
    [self.networkTool requestCourseTryOutlineWithCourseId:_courseId andFinished:^(id  _Nullable responseObject) {
        [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
            switch (status) {

                case BXGNetworkResultStatusSucceed:{
                    NSMutableArray *modelArray = [NSMutableArray new];
                    if([result isKindOfClass:[NSArray class]]){
                        for (NSInteger i = 0; i < [result count]; i++) {
                            BXGCourseOutlineChapterModel *model = [BXGCourseOutlineChapterModel yy_modelWithDictionary:result[i]];
                            if(model) {
                                [modelArray addObject:model];
                            }
                        }
                    }
                    finished(modelArray);
                    return;
                }break;
                default: {
                } break;
            }
            finished(nil);
        }];
    } andFailed:^(NSError * _Nonnull error) {
        finished(nil);
    }];
}
@end
