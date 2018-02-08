//
//  BXGShopViewModel.h
//  Boxuegu
//
//  Created by HM on 2017/6/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
#import "BXGCourseModel.h"

@interface BXGShopViewModel : BXGBaseViewModel

// 精品微课展示数据
@property (nonatomic, strong) NSArray<BXGCourseModel *> *courseModelArray;


+ (instancetype)share;

- (void)loadFreeMicroCourses:(BOOL)isUpdate andFinished:(void(^)(id responseObject,NSString* errorMessage))completedBlock;

- (void)requestBuyFreeMicroCourse:(NSString *)courseId Finished:(void(^)(BOOL succeed,id responseObject,NSString* errorMessage))completedBlock;



@end
