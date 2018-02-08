//
//  BXGConsultCommitViewModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/11/1.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGConsultCommitViewModel.h"
@interface BXGConsultCommitViewModel()
@property (nonatomic, copy) NSString *subjectId;
@property (nonatomic, copy) NSString *subjectName;
@property (nonatomic, copy) NSString *courseName;
@end
@implementation BXGConsultCommitViewModel

- (instancetype)initWithSubjectId:(NSString *)subjectId andCourseName:(NSString *)courseName; {
    self = [super init];
    if(self) {
        self.subjectId = subjectId;
        self.courseName = courseName;
    }
    return self;
}
- (instancetype)initWithSubjectName:(NSString *)subjectName andCourseName:(NSString *)courseName {
    self = [super init];
    if(self) {
        self.subjectName = subjectName;
        self.courseName = courseName;
    }
    return self;
}

- (void)postConsultCollectRecordWithName:(NSString *)name andWechat:(NSString *)wechat andQQ:(NSString *)qq andMobile:(NSString *)mobile Finished:(void(^)(BOOL succeed, NSString *msg))finished {
    
    [self.networkTool consultRequestCollectRecordWithUserId:nil andName:name andSubjectId:self.subjectId andCourseName:self.courseName andWechat:wechat andQQ:qq andMobile:mobile andFinished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        if(status == 200) {
            finished(true,@"成功");
        }else {
            finished(false,message);
        }
    }];
//    [self.networkTool consultRequestCollectRecordWithUserId:nil andName:name andSubjectId:self.subjectId andCourseName:self.courseName andWechat:wechat andQQ:qq andMobile:mobile Finished:^(id  _Nullable responseObject) {
//        [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
//
//        }];
//    } Failed:^(NSError * _Nonnull error) {
//        finished(false,);
//    }];
}

- (void)loadApplyInfoWithFinished:(void(^)(BOOL succeed, NSString *msg))finished {
//     获取用户信息
        [self.networkTool requestGetApplyInfoWithFinished:^(id  _Nullable responseObject) {
    
        } andFailed:^(NSError * _Nonnull error) {
    
        }];

}

- (void)loadConsultTelWithFinished:(void(^)(NSString *telString, NSString *msg))finished  {
    // 电话
    [self.networkTool consultRequestQueryConsultTelWithFinished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        if(status == 200 && [result isKindOfClass:NSString.class]) {
            finished(result,@"成功");
        }else {
            finished(nil,message);
        }
    }];
}

@end
