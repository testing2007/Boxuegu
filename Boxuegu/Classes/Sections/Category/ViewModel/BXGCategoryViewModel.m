//
//  BXGCategoryViewModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCategoryViewModel.h"


@implementation BXGCategoryViewModel
- (void)loadCourseCategorySubjectWithFinished:(void(^)(NSMutableArray<BXGCategorySubjectModel*> *models))finishedBlock {
    
    [self.networkTool requestCourseCategorySubjectWithFinished:^(id  _Nullable responseObject) {
    
        [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
            switch (status) {
                case BXGNetworkResultStatusSucceed:{
                    
                    if([result isKindOfClass:[NSArray class]]){
                    
                        NSMutableArray *models = [NSMutableArray new];
                        for(NSInteger i = 0; i < [result count]; i++) {
                        
                            BXGCategorySubjectModel *model = [BXGCategorySubjectModel yy_modelWithDictionary:result[i]];
                            if(model) {
                                [models addObject:model];
                            }
                        }
                        RWLog(@"成功");
                        finishedBlock(models);
                        return;
                    }
                }break;
                case BXGNetworkResultStatusFailed: {
    
                    break;
                }
                case BXGNetworkResultStatusExpired: {
                    
                    break;
                }
                case BXGNetworkResultStatusParserError: {
                    
                    break;
                }
            }
            finishedBlock(nil);
        }];
    } Failed:^(NSError * _Nonnull error) {
        finishedBlock(nil);
    }];
}

- (void)loadCourseCategoryInfoWithSubjectId:(NSString *)subjectId
                                andFinished:(void(^)(BOOL succeed, BXGHomeCourseModel *proCourseModel,
                                                     NSArray<BXGCategoryMiniCourseModel *> *miniCourseModels))finishedBlock {
    [self.networkTool requestCourseCategoryInfoWithSubjectId:subjectId andFinished:^(id  _Nullable responseObject) {
        [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
            switch (status) {
                case BXGNetworkResultStatusSucceed:{
                    NSMutableArray<BXGCategoryMiniCourseModel *> *miniCourseModels = [NSMutableArray new];
                    BXGHomeCourseModel *proCourseModel;
                    
                    if([result isKindOfClass:[NSDictionary class]]) {
                        id tagsList = result[@"tagsList"];
                        id careerCourse = result[@"careerCourse"];
                        if([tagsList isKindOfClass:[NSArray class]]){
                            for (NSInteger i = 0; i < [tagsList count]; i++) {
                                BXGCategoryMiniCourseModel *miniCourse = [BXGCategoryMiniCourseModel yy_modelWithDictionary:tagsList[i]];
                                if(miniCourse){
                                    [miniCourseModels addObject:miniCourse];
                                }
                            }
                        }
                        if([careerCourse isKindOfClass:[NSDictionary class]]){
                            
                           proCourseModel = [BXGHomeCourseModel yy_modelWithDictionary:careerCourse];
                        }
                    }
                    return finishedBlock(true, proCourseModel, miniCourseModels);
                }break;
                case BXGNetworkResultStatusFailed:
                    
                    break;
                case BXGNetworkResultStatusExpired:
                    
                    break;
                case BXGNetworkResultStatusParserError:
                    break;
            }
            return finishedBlock(false, nil, nil);
        }];
    } Failed:^(NSError * _Nonnull error) {
        finishedBlock(false, nil, nil);
    }];
}
@end
