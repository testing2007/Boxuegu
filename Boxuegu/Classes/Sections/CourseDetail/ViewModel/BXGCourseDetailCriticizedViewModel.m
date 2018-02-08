//
//  BXGCourseDetailCriticizedViewModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseDetailCriticizedViewModel.h"
#import "BXGStudentCriticizeTotalModel.h"

@interface BXGCourseDetailCriticizedViewModel()
@property (nonatomic, strong) NSString * courseId;
@property (nonatomic, assign) NSInteger praiseCourseCurrentPage;
@property (nonatomic, strong) NSMutableArray *praiseCourseArray;
@end

@implementation BXGCourseDetailCriticizedViewModel
- (instancetype _Nonnull )initWithCourseId:(NSString * _Nullable)courseId; {
    self = [super init];
    if(self) {
        _courseId = courseId;
    }
    return self;
}
- (void)loadStudentCriticizedListWithRefresh:(BOOL)isRefresh
                            andFinishedBlock:(void(^ _Nullable)(BOOL success,BXGStudentCriticizeTotalModel *totalModel, NSArray * _Nullable modelArray, NSString * _Nullable message))finishedBlock; {
    
    __weak typeof (self) weakSelf = self;
    NSString *courseId = self.courseId;
    NSString *sign = self.userModel.sign;
    if(isRefresh) {
        
        weakSelf.praiseCourseIsEnd = false;
        weakSelf.praiseCourseCurrentPage = 0;
        weakSelf.praiseCourseArray = nil;
        
    }
    
    self.praiseCourseCurrentPage += 1;
    NSInteger page = self.praiseCourseCurrentPage;
    
    if(!self.praiseCourseArray) {
        
        self.praiseCourseArray = [NSMutableArray new];
    }
    
    [self.networkTool requestStudentCriticizeListWithCourseId:courseId
                                                      andPage:@(page).description
                                                  andPageSize:@(20).description andSign:sign
                                                     Finished:^(id  _Nullable responseObject) {
                                                         
                                                         id success = responseObject[@"success"];
                                                         if([success isKindOfClass:[NSNumber class]] && [success boolValue]) {
                                                         id resultObject = responseObject[@"resultObject"];
                                                             if([resultObject isKindOfClass:[NSDictionary class]]){
                                                                 
                                                                 BXGStudentCriticizeTotalModel *model = [BXGStudentCriticizeTotalModel  yy_modelWithDictionary:resultObject];
                                                                 
                                                                 if(model.criticize) {
                                                                     NSArray *modelArray;
                                                                     modelArray = model.criticize.items;
                                                                     weakSelf.praiseCourseIsEnd = (modelArray.count == 0 || modelArray.count < 20);
                                                                     if(modelArray) {
                                                                         
                                                                         [weakSelf.praiseCourseArray addObjectsFromArray:modelArray];
                                                                     }
                                                                 }
                                                                 finishedBlock(true,model,weakSelf.praiseCourseArray,nil);
                                                             }
                                                         }else {
                                                             
                                                             finishedBlock(false,nil,nil,nil);
                                                         }
                                                         
                                                         
                                                     } Failed:^(NSError * _Nonnull error) {
                                                         
                                                         finishedBlock(false,nil,nil,nil);
                                                     }];
}
@end
