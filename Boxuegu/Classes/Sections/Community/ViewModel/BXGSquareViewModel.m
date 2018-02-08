//
//  BXGSquareViewModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGSquareViewModel.h"

@interface BXGSquareViewModel()

@end
@implementation BXGSquareViewModel
- (void)loadPostTopicListWithFinished:(void(^)(NSArray<BXGPostTopicModel *>* topicModelArray))finishedBlock {
    
    if(!finishedBlock) {
        
        return;
    }
    
    [self.networkTool requestPostTopicListWithFinished:^(id  _Nullable responseObject) {
        
        if(responseObject) {
            
            NSMutableArray *modelArray;
            id status = responseObject[@"status"];
            if([status isKindOfClass:[NSNumber class]] && ([status integerValue] / 200) == 1) {
                
                id result = responseObject[@"result"];
                if([result isKindOfClass:[NSArray class]]) {
                    
                    modelArray = [NSMutableArray new];
                    for(NSInteger i = 0; i < [result count]; i++) {
                        
                        BXGPostTopicModel *model = [BXGPostTopicModel yy_modelWithDictionary:result[i]];
                        if(model) {
                            
                            [modelArray addObject:model];
                        }
                    }
                    
                }
                
            }
            
            finishedBlock(modelArray);
        }else {
            
            finishedBlock(nil);
        }
        
    } Failed:^(NSError * _Nonnull error) {
        
        finishedBlock(nil);
    }];
}


@end
