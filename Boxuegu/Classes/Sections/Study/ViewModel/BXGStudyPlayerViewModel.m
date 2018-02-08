//
//  BXGStudyPlayerViewModel.m
//  Boxuegu
//
//  Created by HM on 2017/5/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGStudyPlayerViewModel.h"
#import "BXGUserModel.h"
#import "BXGUserDefaults.h"



@interface BXGStudyPlayerViewModel()
@property(nonatomic, readonly) BXGUserModel *userModel;



@end
@implementation BXGStudyPlayerViewModel
static BXGStudyPlayerViewModel *instance;
+ (instancetype)share {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BXGStudyPlayerViewModel new];
    });
    
    return instance;
}


- (BXGUserModel *)userModel{

    return [BXGUserDefaults share].userModel;
}


- (void)loadCourseOutLineWithCourseID:(NSString *)courseID andFinished:(void(^)(id responseObject))completedBlock Failed:(void(^)(NSError* error))failedBlock;{

    [self updateCourseOutLineWithCourseID:courseID andFinished:^(id responseObject) {
        
        completedBlock(responseObject);
    } Failed:^(NSError *error) {
        
        failedBlock(error);
    }];
}

- (void)updateCourseOutLineWithCourseID:(NSString *)courseID andFinished:(void(^)(id responseObject))completedBlock Failed:(void(^)(NSError* error))failedBlock;{
    
    __weak typeof (self) weakSelf = self;
    [[BXGNetWorkTool sharedTool] requestCourceOutlineWithCourseID:courseID andUserID:self.userModel.user_id andSign:self.userModel.sign andFinished:^(id  _Nullable responseObject) {
        
        NSMutableArray <BXGCourseOutlineChapterModel*> *modelArray;
        if(responseObject) {
            
            id success = responseObject[@"success"];
            if(success && success != [NSNull null] && [success boolValue]){
                
                id resultObject = responseObject[@"resultObject"];
                if(resultObject && resultObject != [NSNull null]){
                    
                    modelArray = [NSMutableArray new];
                    for (NSInteger i = 0; i < [resultObject count]; i++) {
                        
                        BXGCourseOutlineChapterModel *model = [BXGCourseOutlineChapterModel yy_modelWithDictionary:resultObject[i]];
                        [modelArray addObject:model];
                    }
                    // 做缓存
                    weakSelf.courseOutlineCacheDict[courseID] = modelArray.copy;
                    
                }else {
                    
                    // 异常
                }
                
            }else {
                
                // 异常
            }
            
        }else {
            
            // 异常
        }
        completedBlock(modelArray.copy);
        
    } Failed:^(NSError * _Nullable error) {
        
    }];
    
}

- (void)loadCurrentCourseOutLineFinished:(void (^)(id resultObject ,NSString *errorMessage))completedBlock {

    [self loadCourseOutLineWithCourseID:self.courseId andFinished:completedBlock];
}

- (void)loadCourseOutLineWithCourseID:(NSString *)courseID andFinished:(void (^)(id resultObject,NSString *errorMessage))completedBlock {

    if(!courseID){
    
         completedBlock(nil,@"课程大纲加载失败");
    }
    
    __weak typeof (self) weakSelf = self;
    [[BXGNetWorkTool sharedTool] requestCourceOutlineWithCourseID:courseID andUserID:self.userModel.user_id andSign:self.userModel.sign andFinished:^(id  _Nullable responseObject) {
        
        NSMutableArray <BXGCourseOutlineChapterModel*> *modelArray;
        if(responseObject) {
            
            id success = responseObject[@"success"];
            if(success && success != [NSNull null] && [success boolValue]){
                
                id resultObject = responseObject[@"resultObject"];
                if(resultObject && resultObject != [NSNull null]){
                    
                    modelArray = [NSMutableArray new];
                    for (NSInteger i = 0; i < [resultObject count]; i++) {
                        
                        BXGCourseOutlineChapterModel *model = [BXGCourseOutlineChapterModel yy_modelWithDictionary:resultObject[i]];
                        [modelArray addObject:model];
                    }
                    // 做缓存
                    weakSelf.courseOutlineModelArray = modelArray.copy;
                    completedBlock(modelArray.copy,nil);
                    
                }else {
                    
                    completedBlock(nil,@"课程大纲加载失败");
                }
                
            }else {
                
                completedBlock(nil,@"课程大纲加载失败");
            }
            
        }else {
            
            completedBlock(nil,@"课程大纲加载失败");
        }
        
    } Failed:^(NSError * _Nullable error) {
        
        completedBlock(nil,kBXGToastLodingError);
    }];

}


@end
