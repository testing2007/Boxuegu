//
//  BXGShopViewModel.m
//  Boxuegu
//
//  Created by HM on 2017/6/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGShopViewModel.h"


#import "BXGUserDefaults.h"


typedef enum : NSUInteger {
    
    BuyFreeMicroCourseStateAlready = 1,
    BuyFreeMicroCourseStateNoVideo = 2,
    BuyFreeMicroCourseStateSucceed = 3,
} BuyFreeMicroCourseState;


@interface BXGShopViewModel()

@end


@implementation BXGShopViewModel

static BXGShopViewModel *instance;
+ (instancetype)share {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BXGShopViewModel new];
    });
    
    return instance;
}

- (void)requestBuyFreeMicroCourse:(NSString *)courseId Finished:(void(^)(BOOL succeed,id responseObject,NSString* errorMessage))completedBlock{
    
    if(!self.userModel || !self.userModel.sign || !self.userModel.user_id || !courseId) {
        
        completedBlock(false,nil,@"参数错误");
        // TODO :强制登录
        return;
    }
    // 设置参数
    NSString *sign = self.userModel.sign;
    NSString *userId = self.userModel.user_id;
    
    // 请求
    
//    [self.networkTool requestBuyFreeMicroCourse:courseId andUserId:userId andSign:sign Finished:^(id  _Nullable responseObject) {
//
//        if(responseObject) {
//
//            id successValue = responseObject[@"success"];
//            if(successValue && successValue != [NSNull null] && [successValue isKindOfClass:[NSNumber class]]) {
//
//                if([successValue boolValue]){
//
//                    // TODO: 成功回调
//                    id resultObjectValue = responseObject[@"resultObject"];
//                    if(resultObjectValue && resultObjectValue != [NSNull null] && [resultObjectValue isKindOfClass:[NSDictionary class]]) {
//
//                        // TODO: 解析数据
//                        NSDictionary *resultObjectDict = resultObjectValue;
//                        NSNumber *reslutEncode = resultObjectDict[@"reslutEncode"];
//
//                        if(reslutEncode && [reslutEncode isKindOfClass:[NSNumber class]])
//                        {
//                            switch ([reslutEncode integerValue]) {
//
//                                case BuyFreeMicroCourseStateAlready: {
//
//                                    completedBlock(false,nil,@"本课程您已添加,请到学习中心查看");
//                                }break;
//
//                                case BuyFreeMicroCourseStateNoVideo: {
//
//                                    completedBlock(false,nil,@"该课程正在准备中..."); // 没有视频的情况
//                                }break;
//                                case BuyFreeMicroCourseStateSucceed: {
//
//                                    completedBlock(false,nil,@"恭喜您,成功添加课程");
//                                }break;
//
//                                default: {
//
//                                }break;
//                            }
//                        }
//
//                    }else {
//
//                        completedBlock(false,nil,@"加载失败");
//                    }
//
//                }else {
//
//                    // TODO: 失败回调
//                    id errorMessageValue = responseObject[@"errorMessage"];
//                    if(errorMessageValue && errorMessageValue != [NSNull null] && [errorMessageValue isKindOfClass:[NSString class]]) {
//
//                        completedBlock(false,nil,errorMessageValue);
//                    }else {
//
//                        completedBlock(false,nil,@"加载失败");
//                    }
//                }
//            }else {
//
//                completedBlock(false,nil,@"加载失败");
//            }
//        }
//
//    } Failed:^(NSError * _Nonnull error) {
//
//        completedBlock(false,nil,@"加载失败");
//    }];

}
- (void)loadFreeMicroCourses:(BOOL)isUpdate andFinished:(void(^)(id responseObject,NSString* errorMessage))completedBlock{
    
    __weak typeof (self) weakSelf = self;
    
    
    // 1.使用缓存
    if(!isUpdate){
    
        if(self.courseModelArray) {
            dispatch_async(dispatch_get_main_queue(), ^{
           
            });
        return;
        }
    }
    
    if(!self.userModel) {
    
        // TODO :强制登录
        return;
    }
    
    NSString *sign = self.userModel.sign;
    // 2.使用加载
    [self.networkTool requestFreeMicroCoursesWithSign:sign Finished:^(id  _Nullable responseObject) {
 
        if(responseObject) {
        
            id successValue = responseObject[@"success"];
            if(successValue && successValue != [NSNull null] && [successValue isKindOfClass:[NSNumber class]]) {
            
                if([successValue boolValue]){
                
                    // TODO: 成功回调
                    id resultObjectValue = responseObject[@"resultObject"];
                    if(resultObjectValue && resultObjectValue != [NSNull null] && [resultObjectValue isKindOfClass:[NSArray class]]) {
                        
                        // TODO: 解析数据
                        NSArray *arr = resultObjectValue;
                        NSMutableArray *modelArr = [NSMutableArray new];
                        for(NSInteger i = 0; i < arr.count; i++) {
                        
                            BXGCourseModel *model = [BXGCourseModel yy_modelWithDictionary:arr[i]];
                            if(model) {
                            
                                [modelArr addObject:model];
                            }
                        }
                        weakSelf.courseModelArray = modelArr.copy;
                        completedBlock(modelArr,nil);
                        
                        
                    }else {
                    
                        completedBlock(nil,@"加载失败");
                    }
                    
                }else {
                
                    // TODO: 失败回调
                    id errorMessageValue = responseObject[@"errorMessage"];
                    if(errorMessageValue && errorMessageValue != [NSNull null] && [errorMessageValue isKindOfClass:[NSString class]]) {
                        
                        completedBlock(nil,errorMessageValue);
                    }else {
                    
                        completedBlock(nil,@"加载失败");
                    }
                }
            }else {
            
                completedBlock(nil,@"加载失败");
            }
        }
        
    } Failed:^(NSError * _Nonnull error) {
        
        completedBlock(nil,@"加载失败");
    }];
}

@end
