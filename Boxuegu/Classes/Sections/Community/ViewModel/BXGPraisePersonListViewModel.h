//
//  BXGPraisePersonListViewModel.h
//  Boxuegu
//
//  Created by apple on 2017/9/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
#import "BXGPraisePersonDetailModel.h"

@interface BXGPraisePersonListViewModel : BXGBaseViewModel

- (void)requestPraisePersonListInfoWithRefresh:(BOOL)bRefresh
                                  andPostId:(NSNumber*)postId
                             andFinishBlock:(void(^)(BOOL succeed, NSString *errorMessage))finishedBlock;

-(void)updatePraiseStatusByFollowUUID:(NSNumber*)followUUID
                         andAttention:(NSNumber*)attention
                       andFinishBlock:(void (^)(BOOL bSuccess, NSError *errorMessage))finishBlock;

@property(nonatomic, strong) NSArray<BXGCommunityUserModel*> *arrPraisePersoner;

@property(nonatomic, assign) NSInteger currentPage;
@property(nonatomic, assign) BOOL bHaveMoreData;

@end
