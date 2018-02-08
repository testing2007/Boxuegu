//
//  BXGCourseInfoViewModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseInfoViewModel.h"
#import "BXGCourseInfoChapterModel.h"
#import "BXGCourseLecturerModel.h"
#import "BXGHomeCourseModel.h"

@interface BXGCourseInfoViewModel()
//@property (nonatomic, strong) NSString *courseId;
//@property (nonatomic, strong) BXGHomeCourseModel *courseModel;
//@property (nonatomic, assign) BXGCourseInfoApplyType applyType;
@end

@implementation BXGCourseInfoViewModel

#pragma mark - Interface

- (instancetype _Nonnull)initWithCourseId:(NSString * _Nonnull)courseId; {
    self = [super init];
    if(self) {
        self.courseId = courseId;
    }
    return self;
}
- (instancetype _Nonnull)initWithCourseModel:(BXGHomeCourseModel * _Nonnull)courseModel; {
    self = [self initWithCourseId:courseModel.courseId];
    if(self) {
        self.courseModel = courseModel;
    }
    return self;
}

/// 获取: 课程是否已购买
- (void)loadCourseIsApplyWithCourseId:(NSString * _Nullable)courseId
                     andFinishedBlock:(void(^ _Nullable)(NSNumber * _Nullable isApply)) finishedBlock; {
    BXGUserModel *userModel = [BXGUserCenter share].userModel;
    if(!userModel && userModel.user_id) {
        finishedBlock(@(false));
        return;
    }
    
    [self.networkTool requestCourseIsApplyWithCourseId:courseId andUserId:userModel.user_id andFinished:^(id  _Nullable responseObject) {
        [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
            switch (status) {
                case BXGNetworkResultStatusSucceed: {
                    if([result isKindOfClass:NSDictionary.class]) {
                        id isApply = result[@"isApply"];
                        if(![isApply isKindOfClass:NSNumber.class]) {
                            isApply = nil;
                        }
                        finishedBlock(isApply);
                        return;
                    }
                }
                default:
                    break;
            }
            finishedBlock(nil);
        }];
        
        return;
    } andFailed:^(NSError * _Nonnull error) {
        finishedBlock(nil);
        return;
    }];
}

/// 判断: 该课程下是否有视频
- (void)checkCourseExistVideos:(NSString *)courseId andFinished:(void(^)(BOOL isExist, NSString *msg))finished {
    [self.networkTool requestExistVideosByCourseIdWithCourseId:courseId andFinished:^(id  _Nullable responseObject) {
        [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
            switch (status) {
                    
                case BXGNetworkResultStatusSucceed:
                    finished(true,@"");
                    return;
                    break;
                case BXGNetworkResultStatusFailed:
//                    finished(false,message);
                    break;
                case BXGNetworkResultStatusExpired:
//                    finished(false,message);
                    break;
                case BXGNetworkResultStatusParserError:
//                    finished(false,message);
                    break;
            }
            finished(false,message);
        }];
        
    } andFailed:^(NSError * _Nonnull error) {
        finished(false,kBXGToastNoNetworkError);
    }];
}
- (void)loadCourseInfoDetailWithRefresh:(BOOL)isRefresh Finished:(void(^)(BXGHomeCourseModel *courseModel))finished {
    Weak(weakSelf);
    [self.networkTool requestCourseDetailWithCourseId:self.courseId Finished:^(id  _Nullable responseObject) {
        [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
            if(status == 200 && [result isKindOfClass:[NSDictionary class]]) {
                BXGHomeCourseModel *courseModel = [BXGHomeCourseModel yy_modelWithDictionary:result];
                if(courseModel) {
                    weakSelf.courseModel = courseModel;
                    finished(courseModel);
                    return;
                }
            }
            finished(nil);
        }];
        
    } andFailed:^(NSError * _Nonnull error) {
        finished(nil);
    }];
}
//- (void)loadCourseInfoDetailWithRefresh:(BOOL)isRefresh Finished:(void(^)(BXGHomeCourseModel *courseModel, BXGCourseInfoApplyType))finished {
//    Weak(weakSelf);
//    if(isRefresh){
//        weakSelf.applyType = BXGCourseInfoApplyTypeNone;
//    }
//    BXGUserModel *userModel = [BXGUserCenter share].userModel;
//    dispatch_group_t group = dispatch_group_create();
//    if(userModel == nil) {
//        weakSelf.applyType = BXGCourseInfoApplyTypeNoLogin;
//    }else {
//        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//            [self.networkTool requestCourseIsApplyWithCourseId:self.courseId andUserId:userModel.user_id andFinished:^(id  _Nullable responseObject) {
//                [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
//                    if(status == 200) {
//                        id isApply = result[@"isApply"];
//                        if([isApply isKindOfClass:NSNumber.class]) {
//                            if([isApply boolValue]) {
//                                weakSelf.applyType = BXGCourseInfoApplyTypeApplied;
//                            }else {
//                                weakSelf.applyType = BXGCourseInfoApplyTypeNotApplied;
//                            }
//                        }else {
//                            weakSelf.applyType = BXGCourseInfoApplyTypeNone;
//                        }
//                    }else {
//                        weakSelf.applyType = BXGCourseInfoApplyTypeNone;
//                    }
//                }];
//                dispatch_semaphore_signal(semaphore);
//            } andFailed:^(NSError * _Nonnull error) {
//                weakSelf.applyType = BXGCourseInfoApplyTypeNone;
//                dispatch_semaphore_signal(semaphore);
//            }];
//            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        });
//    }
//
//    if(self.courseModel) {
//
//    }else {
//        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//             dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//            [self.networkTool requestCourseDetailWithCourseId:self.courseId Finished:^(id  _Nullable responseObject) {
//                [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
//                    if(status == 200 && [result isKindOfClass:[NSDictionary class]]) {
//                        BXGHomeCourseModel *courseModel = [BXGHomeCourseModel yy_modelWithDictionary:result];
//                        if(courseModel) {
//                            weakSelf.courseModel = courseModel;
//                        }
//                    }
//                }];
//                dispatch_semaphore_signal(semaphore);
//            } andFailed:^(NSError * _Nonnull error) {
//                dispatch_semaphore_signal(semaphore);
//            }];
//            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        });
//    }
//
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//
//        finished(weakSelf.courseModel,weakSelf.applyType);
//    });
//}
@end
