//
//  BXGReportViewModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGReportViewModel.h"
#import "BXGReportTypeModel.h"
#import "BXGNetworkParser.h"

@implementation BXGReportViewModel

- (void)loadReportTypeListWithFinished:(void(^)(NSArray<BXGReportTypeModel *> *modelArray))finishedBlock {

    [[BXGNetWorkTool sharedTool] requestReportTypeListWithSign:[BXGUserDefaults share].userModel.sign andFinished:^(id  _Nullable responseObject) {
        
        [BXGNetworkParser communityNetworkParser:responseObject andFinished:^(NSInteger status, NSString *message, id result) {
            
            if(status == 200) {
                
                NSMutableArray *modelArray = [NSMutableArray new];
                if([result isKindOfClass:[NSArray class]]) {
                    
                    for (NSInteger i = 0; i < [result count]; i++) {
                        
                        BXGReportTypeModel *model = [BXGReportTypeModel yy_modelWithDictionary:result[i]];
                        if(model) {
                            
                            [modelArray addObject:model];
                        }
                    }
                    finishedBlock(modelArray);
                    return;
                }
            }
            finishedBlock(nil);
        }];
        
        
    } Failed:^(NSError * _Nonnull error) {
        
        finishedBlock(nil);
    }];
}

- (void)reportType:(NSString *)type reportTypeId:(NSNumber *)reportTypeId content:(NSString *)content reportUserId:(NSNumber *)reportUserId postId:(NSNumber *)postId commentId:(NSNumber *)commentId replyId:(NSNumber *)replyId finished:(void(^)(BOOL succeed))finishedBlock{

    
    NSNumber *uuid = [BXGUserCenter share].userModel.itcast_uuid;
    NSString *sign = [BXGUserCenter share].userModel.sign;

    [self.networkTool requestSaveReportWithUUID:uuid andType:type andReportTypeId:reportTypeId andContent:content andReportUserId:reportUserId andPostId:postId andCommentId:commentId andReplyId:replyId andSign:sign andFinished:^(id  _Nullable responseObject) {
       
        [BXGNetworkParser communityNetworkParser:responseObject andFinished:^(NSInteger status, NSString *message, id result) {
        
            if(status == 200) {
            
                finishedBlock(true);
            }else {
            
                finishedBlock(false);
            }
        }];
        
    } Failed:^(NSError * _Nonnull error) {
        
        finishedBlock(false);
    }];
}

- (void)reportPostWithReportTypeId:(NSNumber *)reportTypeId content:(NSString *)content reportUserId:(NSNumber *)reportUserId postId:(NSNumber *)postId finished:(void(^)(BOOL succeed))finishedBlock{

    [self reportType:@"post" reportTypeId:reportTypeId content:content reportUserId:reportUserId postId:postId commentId:nil replyId:nil finished:finishedBlock];
}

- (void)reportCommentWithReportTypeId:(NSNumber *)reportTypeId content:(NSString *)content reportUserId:(NSNumber *)reportUserId postId:(NSNumber *)postId commentId:(NSNumber *)commentId finished:(void(^)(BOOL succeed))finishedBlock{
    
    [self reportType:@"comment" reportTypeId:reportTypeId content:content reportUserId:reportUserId postId:postId commentId:commentId replyId:nil finished:finishedBlock];
}
// reply


@end
