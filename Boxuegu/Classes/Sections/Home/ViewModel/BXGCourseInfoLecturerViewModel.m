//
//  BXGCourseInfoLecturerViewModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseInfoLecturerViewModel.h"
#import "BXGCourseLecturerModel.h"

@interface BXGCourseInfoLecturerViewModel()
@property (nonatomic, strong) NSString *courseId;
@end

@implementation BXGCourseInfoLecturerViewModel

#pragma mark - Interface

- (instancetype)initWithCourseId:(NSString *)courseId {
    self = [super init];
    if(self) {
        _courseId = courseId;
    }
    return self;
}

- (void)loadCourseCourseLecturerWithFinished:(void (^)(NSArray<BXGCourseLecturerModel *> *lecturerModels))finishedBlock {
    
    [self.networkTool requestCourseCourseLecturerWithCourseId:self.courseId andFinished:^(id  _Nullable responseObject) {
        [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
            switch (status) {
                    
                case BXGNetworkResultStatusSucceed: {
                    NSMutableArray<BXGCourseLecturerModel *> *lecturers = [NSMutableArray new];
                    if([result isKindOfClass:[NSArray class]]) {
                        for (NSInteger i = 0; i < [result count];i++) {
                            BXGCourseLecturerModel *model = [BXGCourseLecturerModel yy_modelWithDictionary:result[i]];
                            if(model) {
                                [lecturers addObject:model];
                            }
                        }
                    }
                    finishedBlock(lecturers);
                    return;
                }break;
                case BXGNetworkResultStatusFailed:
                    
                    break;
                case BXGNetworkResultStatusExpired:
                    
                    break;
                case BXGNetworkResultStatusParserError:
                    
                    break;
            }
            finishedBlock(nil);
            return;
        }];
    } andFailed:^(NSError * _Nonnull error) {
        finishedBlock(nil);
    }];
}
@end
