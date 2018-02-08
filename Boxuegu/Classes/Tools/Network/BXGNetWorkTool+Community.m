//
//  BXGNetWorkTool+Community.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGNetWorkTool+Community.h"

@implementation BXGNetWorkTool (Community)

#pragma mark - Community Base Request Function

// base version 3.0
- (void)bbsBaseRequestType:(RequestType)type
                    andURLString:(NSString * _Nullable)urlString
                    andParameter:(id _Nullable)para andFinished:(BXGNetworkCallbackBlockType _Nullable) finished {
    
    // 设置全局参数
    NSMutableDictionary *mPara = [NSMutableDictionary dictionaryWithDictionary:para];
    mPara[@"basicId"] = @"1"; // 渠道
    BXGUserModel *userModel = [BXGUserCenter share].userModel;
    if(userModel) {
        mPara[@"userId"] = userModel.itcast_uuid; // 学习圈id
    }
    // 请求
    [self requestType:type andBaseURLString:MainBaseUrlString andUrlString:urlString andParameter:mPara andFinished:^(id  _Nullable responseObject) {
        [BXGNetworkParser communityNetworkParser:responseObject andFinished:finished];
    } andFailed:^(NSError * _Nonnull error) {
        [BXGNetworkParser communityNetworkParser:error andFinished:finished];
    }];
}

// base version 1.0
-(void)requestCommunityServerWithType:(RequestType)type UrlString:(NSString*) urlString Parameter:(id)para Finished:(void(^)(id responseObject))finishedBlock  Progress:(void(^)(NSProgress* progress))progressBlock  Failed:(void(^)(NSError * _Nonnull error))failedBlock
{
    Weak(weakSelf);
    
    NSMutableDictionary *mpara = [NSMutableDictionary new];
    
    if([para isKindOfClass:[NSDictionary class]]) {
        
        [mpara setDictionary:para];
    }
    
    if(mpara[@"basicId"]!= [NSNull null]){
        
        [mpara setObject:@"1" forKey:@"basicId"];
    }
    
    void(^mfinishedBlock)(id responseObject) = ^(id responseObject){
        
        
        [BXGNetworkParser communityNetworkParser:responseObject andFinished:^(NSInteger status, NSString *message, id result) {
            
            if(status == 400 && [message isEqualToString:@"1001"]) {
                
                if(weakSelf.networkDelegate && [weakSelf.networkDelegate respondsToSelector:@selector(networkServerError)]) {
                    
                    [weakSelf.networkDelegate networkServerError];
                };
                finishedBlock(nil);
                return;
            }else {
                
                finishedBlock(responseObject);
            }
        }];
    };
    [self requestType:POST andBaseURLString:urlString andUrlString:urlString andParameter:mpara andFinished:mfinishedBlock andFailed:failedBlock];
//    self communityBaseRequestType:POST andURLString:urlString andParameter:mpara Finished:mfinishedBlock Failed:<#^(NSError * _Nonnull error)failed#>
//    [self requestType:type baseURLType:BaseURLTypeComunity andUrlString:urlString Parameter:mpara Finished:mfinishedBlock Progress:progressBlock Failed:failedBlock];
}

// base version 2.0
- (void)communityBaseRequestType:(RequestType)type
                    andURLString:(NSString * _Nullable)urlString
                    andParameter:(id _Nullable)para Finished:BXGNetworkFinishedBlockType finished Failed:BXGNetworkFailedBlockType failed {
    Weak(weakSelf);
    
    // 设置全局参数
    NSMutableDictionary *mPara = [NSMutableDictionary dictionaryWithDictionary:para];
    mPara[@"basicId"] = @"1"; // 渠道
    BXGUserModel *userModel = [BXGUserCenter share].userModel;
    if(userModel) {
        mPara[@"userId"] = userModel.itcast_uuid; // 学习圈id
    }
    
    // 设置全局判断 判断是否过期
    void(^mFinished)(id responseObject) = ^(id responseObject){
        [BXGNetworkParser communityNetworkParser:responseObject andFinished:^(NSInteger status, NSString *message, id result) {
            if(status == 400 && [message isEqualToString:@"1001"]) {
                if(weakSelf.networkDelegate && [weakSelf.networkDelegate respondsToSelector:@selector(networkServerError)]) {
                    [weakSelf.networkDelegate networkServerError];
                };
                finished(nil);
                return;
            }else {
                finished(responseObject);
            }
        }];
    };
    [self requestType:type andBaseURLString:MainBaseUrlString andUrlString:urlString andParameter:mPara andFinished:mFinished andFailed:failed];
}

#pragma mark - Request

/**
 帖子列表

 @param topicId 话题id
 @param pageNo pageNumber
 @param pageSize pageSize
 @param finishedBlock finishedBlock
 @param failedBlock failedBlock
 */
-(void)requestPostListWithTopicId:(NSNumber * _Nullable)topicId
                     andPageNo:(NSNumber * _Nullable)pageNo
                     andPageSize:(NSNumber * _Nullable)pageSize
                   andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                        Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"topicId"] = topicId;
    para[@"pageNo"] = pageNo;
    para[@"pageSize"] = pageSize;
    [self communityBaseRequestType:POST andURLString:@"/bbs/post/postList" andParameter:para Finished:finishedBlock Failed:failedBlock];
}

// POST /bbs/post/attentionPostList
// /bbs/post/attentionPostList
// - (void)requesAttentionPostList

/**
 关注页面帖子列表 /bbs/post/attentionPersonList
 */
-(void)requestAttentionPersonListWithUUID:(NSNumber *_Nullable)uuid
                                andPageNo:(NSNumber *_Nullable)pageNo
                              andPageSize:(NSNumber *_Nullable)pageSize
                                  andSign:(NSString *_Nullable)sign
                              andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                   Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"pageNo"] = pageNo;
    para[@"pageSize"] = pageSize;
    
    [self communityBaseRequestType:POST andURLString:@"/bbs/post/attentionPersonList" andParameter:para Finished:finishedBlock Failed:failedBlock];
}

// 我的帖子
// /userHome/homePostList

//homeUserId
//个人主页用户ID
//query	string
//userId
//登录用户ID
//query	string
//basicId
//基础模块ID：学习圈：1
//query	integer
//pageNo
//当前页码 (起始页为1)
//query	integer
//pageSize


-(void)requestUserHomePostListWithSign:(NSString *)sign andHomeUserId:(NSNumber *)homeUserId
                         andUserId:(NSNumber *)userId
                           andPageSize:(NSNumber *)pageSize
                         andPageNo:(NSNumber *)pageNo
                           andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                              Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock

{
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"homeUserId"] = homeUserId;
    para[@"pageSize"] = pageSize;
    para[@"pageNo"] = pageNo;

    [self communityBaseRequestType:POST andURLString:@"/bbs/userHome/homePostList" andParameter:para Finished:finishedBlock Failed:failedBlock];
    
//    [self requestCommunityServerWithType:POST UrlString:@"/bbs/userHome/homePostList" Parameter:para Finished:^(id responseObject) {
//
//        RWNetworkLog(@"%@", responseObject);
//        if(finishedBlock){
//            finishedBlock(responseObject);
//        }
//
//    } Progress:nil Failed:^(NSError * _Nonnull error) {
//
//        RWNetworkLog(@"%@", error);
//        if(failedBlock){
//            failedBlock(error);
//        }
//    }];
}
/// 举报类型

// /bbs/report/reportTypeList
-(void)requestReportTypeListWithSign:(NSString *)sign
                         andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                              Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock {
    [self communityBaseRequestType:POST andURLString:@"/bbs/report/reportTypeList" andParameter:nil Finished:finishedBlock Failed:failedBlock];
}
//    [self requestCommunityServerWithType:POST UrlString: Parameter:nil Finished:^(id responseObject) {
//
//        RWNetworkLog(@"%@", responseObject);
//        if(finishedBlock){
//            finishedBlock(responseObject);
//        }
//
//    } Progress:nil Failed:^(NSError * _Nonnull error) {
//
//        RWNetworkLog(@"%@", error);
//        if(failedBlock){
//            failedBlock(error);
//        }
//    }];


// 发布举报
// /bbs/report/saveReport


//basicId
//被举报内容所属的基础模块ID

//query	integer
//type
//举报的类型 (post-帖子，comment-评论，reply-回复)
//query	string
//reportTypeId
//举报类型ID
//query	integer
//content
//举报说明
//query	string
//userId
//举报用户ID，可匿名举报(null)
//query	string
//reportUserId
//被举报用户ID
//query	string
//postId
//帖子ID，必须
//query	integer
//commentId
//评论ID，如果举报的是评论或回复，必须
//query	integer
//replyId

// POST /bbs/post/attentionPostList 关注页面帖子列表
// /bbs/post/attentionPostList
// - (void)requesAttentionPostList
-(void)requestSaveReportWithUUID:(NSNumber * _Nullable)uuid
                         andType:(NSString * _Nullable)type
                 andReportTypeId:(NSNumber * _Nullable)reportTypeId
                      andContent:(NSString * _Nullable)content
                 andReportUserId:(NSNumber * _Nullable)reportUserId
                       andPostId:(NSNumber * _Nullable)postId
                    andCommentId:(NSNumber * _Nullable)commentId
                      andReplyId:(NSNumber * _Nullable)replyId
                         andSign:(NSString * _Nullable)sign
                     andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                          Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"type"] = type;
    para[@"reportTypeId"] = reportTypeId;
    para[@"content"] = content;
    para[@"reportUserId"] = reportUserId;
    para[@"postId"] = postId;
    para[@"commentId"] = commentId;
    para[@"replyId"] = replyId;
    [self communityBaseRequestType:POST andURLString:@"/bbs/report/saveReport" andParameter:para Finished:finishedBlock Failed:failedBlock];
}

-(void)requestIsBannedWithFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                        Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    [self communityBaseRequestType:POST andURLString:@"/bbs/bbsuser/isBanned" andParameter:nil Finished:finishedBlock Failed:failedBlock];
}


///首页：获取Banner列表 /bbs/banner/getBannerList
- (void)requestBannerFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failed {
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"client_type"] = @"0"; // 渠道
    [self communityBaseRequestType:POST andURLString:@"/bbs/banner/getBannerList" andParameter:para Finished:finished Failed:failed];
}



// *** 学习圈接口

// 打卡
// /checkin/checkinAll
-(void)requestCheckinAllWithFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                              Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    [self requestCommunityServerWithType:GET UrlString:@"/bbs/checkin/checkinAll" Parameter:nil Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
        
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}
// 话题列表 (首页)

// /post/postTopicList

-(void)requestPostTopicListWithFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                 Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    [self requestCommunityServerWithType:POST UrlString:@"/bbs/post/postTopicList" Parameter:nil Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
        
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}

// 话题列表 (发帖)
-(void)requestTopicListWithFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                            andSign:(NSString* _Nullable)sign
                             Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;
{
    NSDictionary *para;
    if(sign) {
        
        para = @{@"sign": sign};
    }
    
    [self requestCommunityServerWithType:POST UrlString:@"/bbs/post/topicList" Parameter:para Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
        
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}


// 我的粉丝列表

//
-(void)requestMyFanListWithUUID:(NSNumber *)uuid
                      andPageNo:(NSString *)pageNo
                    andPageSize:(NSString *)pageSize
                        andSign:(NSString *)sign
                    andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                         Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    if(!uuid) {
        
        finishedBlock(nil);
        return;
    }
    
    if(!pageNo){
        
        finishedBlock(nil);
        return;
    }
    
    if(!pageSize){
        
        finishedBlock(nil);
        return;
    }
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:uuid forKey:@"userId"];
    [para setObject:pageNo forKey:@"pageNo"];
    [para setObject:pageSize forKey:@"pageSize"];
    [para setObject:sign forKey:@"sign"];
    // POST /bbs/post/attentionPersonList
    //[self requestCommunityServerWithType:POST UrlString:@"/post/attentionPersonList" Parameter:para Finished:^(id responseObject) {
    [self requestCommunityServerWithType:POST UrlString:@"/bbs/user/myFanList" Parameter:para Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
        
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}

//
-(void)requestAttentionListWithUUID:(NSNumber *)uuid
                          andPageNo:(NSNumber *)pageNo
                        andPageSize:(NSNumber *)pageSize
                            andSign:(NSString *)sign
                        andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                             Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:sign forKey:@"sign"];
    if(uuid) {
        
        //finishedBlock(nil);
        //return;
        [para setObject:uuid forKey:@"userId"];
    }
    
    if(pageNo){
        
        //finishedBlock(nil);
        //return;
        [para setObject:pageNo forKey:@"pageNo"];
    }
    
    if(pageSize){
        
        //finishedBlock(nil);
        //return;
        [para setObject:pageSize forKey:@"pageSize"];
    }
    
    
    
    
    
    
    // POST /bbs/post/attentionPersonList
    [self requestCommunityServerWithType:POST UrlString:@"/bbs/post/attentionPostList" Parameter:para Finished:^(id responseObject) {
        // [self requestCommunityServerWithType:POST UrlString:@"/user/myFanList" Parameter:para Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
        
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}


// 上传图片
-(void)requestUploadImgWithImageData:(NSData *)imageData
                             andSign:(NSString *)sign
                         andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                              Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    if(!imageData) {
        
        finishedBlock(nil);
        return;
    }
    
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:@"online" forKey:@"projectName"];
    // [para setObject:imageData forKey:@"file"];
    [para setObject:@"1" forKey:@"fileType"];
    [para setObject:sign forKey:@"sign"];
    NSString *urlString = [CommunityBaseUrlString stringByAppendingPathComponent:@"/bbs/bbsAttachment/upload"];
    
    [self POST:urlString parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyy-MM-dd-HH:mm:ss";
        
        NSString *fileName = [NSString stringWithFormat:@"%@2.png",[formatter stringFromDate:[NSDate date]]];
        
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        RWNetworkLog(@"%@", responseObject);
        finishedBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RWNetworkLog(@"%@", error);
        failedBlock(error);
    }];
}
// 发布帖子

// /bbs
-(void)requestSavePostWithUUID:(NSNumber *)uuid
                    andTopicId:(NSNumber *)topicId
                    andContent:(NSString *)content
              andImagePathList:(NSString *)imagePathList
                   andLocation:(NSString *)location
                   andUUIDList:(NSString *)uuidList
                       andSign:(NSString *)sign
                   andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                        Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    NSMutableDictionary *para = [NSMutableDictionary new];
    if(!uuid || !topicId) {
        
        finishedBlock(nil);
        return;
    }
    [para setObject:uuid forKey:@"userId"];
    
    if(content){
        
        [para setObject:content forKey:@"content"];
        
    }
    
    if(imagePathList){
        
        [para setObject:imagePathList forKey:@"imgPathList"];
    }
    
    if(location){
        
        [para setObject:location forKey:@"location"];
    }
    
    if(uuidList){
        
        [para setObject:uuidList forKey:@"userIdList"];
    }
    
    if(topicId) {
        
        [para setObject:topicId forKey:@"topicId"];
    }
    
    [para setObject:@(1) forKey:@"basicId"];
    [para setObject:sign forKey:@"sign"];
    [self requestCommunityServerWithType:POST UrlString:@"/bbs/post/savePost" Parameter:para Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
        
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}



//根据帖子ID获取帖子评论详情, 参数postId, userId
-(void)requestCommunityPostCommentWithPostId:(NSNumber* _Nullable)postId
                                     andUUID:(NSNumber* _Nullable)uuid
                                     andSign:(NSString * _Nullable)sign
                                 andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                      Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;
{
    if(!postId) {
        
        finishedBlock(nil);
        return;
    }
    //    if(!uuid) {
    //        finishedBlock(nil);
    //        return ;
    //    }
    //    if(!sign)
    //    {
    //        finishedBlock(nil);
    //        return ;
    //    }
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:postId forKey:@"postId"];
    if(uuid)
    {
        [para setObject:uuid forKey:@"userId"];
    }
    if(sign)
    {
        [para setObject:sign forKey:@"sign"];
    }
    [self requestCommunityServerWithType:POST UrlString:@"/bbs/postDetail/postComment" Parameter:para Finished:^(id responseObject) {
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
        
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}

//根据帖子ID查询帖子详细信息, 参数postId, userId
-(void)requestCommunityPostDetailWithPostId:(NSNumber* _Nullable)postId
                                    andUUID:(NSNumber* _Nullable)uuid
                                    andSign:(NSString * _Nullable)sign
                                andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                     Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    NSMutableDictionary *para = [NSMutableDictionary new];
    
    
    if(postId) {
        //finishedBlock(nil);
        //return;
        [para setObject:postId forKey:@"postId"];
    }
    if(uuid) {
        //finishedBlock(nil);
        // return;
        [para setObject:uuid forKey:@"userId"];
    }
    if(sign)
    {
        [para setObject:sign forKey:@"sign"];
        // finishedBlock(nil);
        // return ;
    }
    
    
    
    [self requestCommunityServerWithType:POST UrlString:@"/bbs/postDetail/postDetail" Parameter:para Finished:^(id responseObject) {
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}


//根据帖子ID查询点赞用户的列表, 参数postId, userId, pageNo, pageSize=15
-(void)requestCommunityPraisePersonListWithPostId:(NSNumber* _Nullable)postId
                                          andUUID:(NSNumber* _Nullable)uuid
                                        andPageNo:(NSNumber * _Nullable)pageNo
                                      andPageSize:(NSNumber * _Nullable)pageSize
                                          andSign:(NSString * _Nullable)sign

                                      andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                           Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    if(!postId) {
        
        finishedBlock(nil);
        return;
    }
    
    if(!uuid){
        
        finishedBlock(nil);
        return;
    }
    if(!sign) {
        finishedBlock(nil);
        return ;
    }
    
    if(!pageNo){
        
        finishedBlock(nil);
        return;
    }
    
    if(!pageSize){
        
        finishedBlock(nil);
        return;
    }
    
    
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:postId forKey:@"postId"];
    [para setObject:uuid forKey:@"userId"];
    [para setObject:sign forKey:@"sign"];
    [para setObject:pageNo forKey:@"pageNo"];
    [para setObject:pageSize forKey:@"pageSize"];
    [self requestCommunityServerWithType:POST UrlString:@"/bbs/postDetail/praisePersonList" Parameter:para Finished:^(id responseObject) {
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}

//根据帖子ID保存评论, 参数postId, userId, content
-(void)requestCommunitySaveCommentWithPostId:(NSNumber* _Nullable)postId
                                     andUUID:(NSNumber* _Nullable)uuid
                                andCommentId:(NSNumber* _Nullable)commentId
                              andReplyedUUID:(NSNumber* _Nullable)replyedUUID
                                     content:(NSString* _Nullable)content
                                     andSign:(NSString * _Nullable)sign
                                 andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                      Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    if(!postId) {
        
        finishedBlock(nil);
        return;
    }
    
    if(!uuid){
        
        finishedBlock(nil);
        return;
    }
    
    if(!commentId) {
        finishedBlock(nil);
        return ;
    }
    
    if(!replyedUUID) {
        finishedBlock(nil);
        return;
    }
    
    if(!sign)
    {
        finishedBlock(nil);
        return ;
    }
    
    if(!content){
        
        finishedBlock(nil);
        return;
    }
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:postId forKey:@"postId"];
    [para setObject:uuid forKey:@"userId"];
    [para setObject:commentId forKey:@"commentId"];
    [para setObject:replyedUUID forKey:@"replyedUserId"];
    [para setObject:sign forKey:@"sign"];
    [para setObject:content forKey:@"content"];
    
    [self requestCommunityServerWithType:POST UrlString:@"/bbs/postDetail/saveComment" Parameter:para Finished:^(id responseObject) {
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}

//根据帖子ID和用户ID和评论ID回复评论,参数postId, userId, commentId, replyedUserId, content
-(void)requestCommunitySaveReplyedCommentWithPostId:(NSNumber* _Nullable)postId
                                            andUUID:(NSNumber* _Nullable)uuid
                                       andCommentId:(NSNumber* _Nullable)commentId
                                        replyedUUID:(NSNumber* _Nullable)replyedUUID
                                            content:(NSString* _Nullable)content
                                            andSign:(NSString * _Nullable)sign
                                        andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                             Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    if(!postId) {
        
        finishedBlock(nil);
        return;
    }
    
    if(!uuid){
        
        finishedBlock(nil);
        return;
    }
    
    if(!sign)
    {
        finishedBlock(nil);
        return ;
    }
    
    if(!commentId){
        
        finishedBlock(nil);
        return;
    }
    if(!replyedUUID)
    {
        finishedBlock(nil);
        return;
    }
    if(!content)
    {
        finishedBlock(nil);
        return ;
    }
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:postId forKey:@"postId"];
    [para setObject:uuid forKey:@"userId"];
    [para setObject:sign forKey:@"sign"];
    [para setObject:commentId forKey:@"commentId"];
    [para setObject:replyedUUID forKey:@"replyedUserId"];
    [para setObject:content forKey:@"content"];
    [self requestCommunityServerWithType:POST UrlString:@"/bbs/postDetail/saveReplyedComment" Parameter:para Finished:^(id responseObject) {
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}


//评论回复的回复 帖子评论回复保存, 参数postId, userId, commentId, replyedUserId, content
-(void)requestCommunitySaveReplyedReplyWithPostId:(NSNumber* _Nullable)postId
                                          andUUID:(NSNumber* _Nullable)uuid
                                        commentId:(NSNumber* _Nullable)commentId
                                          replyId:(NSNumber* _Nullable)replyId
                                      replyedUUID:(NSNumber* _Nullable)replyedUUID
                                          content:(NSString* _Nullable)content
                                          andSign:(NSString * _Nullable)sign
                                      andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                           Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    if(!postId) {
        
        finishedBlock(nil);
        return;
    }
    
    if(!uuid){
        
        finishedBlock(nil);
        return;
    }
    
    if(!sign)
    {
        finishedBlock(nil);
        return ;
    }
    
    if(!commentId){
        
        finishedBlock(nil);
        return;
    }
    if(!replyedUUID)
    {
        finishedBlock(nil);
        return;
    }
    
    if(!replyId)
    {
        finishedBlock(nil);
        return;
    }
    if(!content)
    {
        finishedBlock(nil);
        return ;
    }
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:postId forKey:@"postId"];
    [para setObject:uuid forKey:@"userId"];
    [para setObject:sign forKey:@"sign"];
    [para setObject:commentId forKey:@"commentId"];
    [para setObject:replyedUUID forKey:@"replyedUserId"];
    [para setObject:content forKey:@"content"];
    [para setObject:replyId forKey:@"replyId"];
    [self requestCommunityServerWithType:POST UrlString:@"bbs/postDetail/saveReplyedReply" Parameter:para Finished:^(id responseObject) {
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}

//根据关注用户ID和被关注者用户ID进行关注(取消关注)操作, 参数: 关注者userId-自己, 被关注者followerId
-(void)requestCommunityUpdateAttentionStatusWithConcernUUID:(NSNumber* _Nullable)concernUUID
                                            andFollowerUUID:(NSNumber* _Nullable)followerUUID
                                                 andOperate:(NSNumber* _Nullable)operate
                                                    andSign:(NSString * _Nullable)sign
                                                andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                                     Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    if(!concernUUID) {
        
        finishedBlock(nil);
        return;
    }
    
    if(!followerUUID){
        
        finishedBlock(nil);
        return;
    }
    
    if(!sign)
    {
        finishedBlock(nil);
        return ;
    }
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:concernUUID forKey:@"userId"];
    [para setObject:followerUUID forKey:@"followerId"];
    [para setObject:operate forKey:@"operate"];
    [para setObject:sign forKey:@"sign"];
    [self requestCommunityServerWithType:POST UrlString:@"/bbs/postDetail/updateAttentionStatus" Parameter:para Finished:^(id responseObject) {
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}

//根据帖子Id收藏帖子, 参数: postId, userId
-(void)requestCommunityUpdateCollectionWithPostId:(NSNumber* _Nullable)postId
                                          andUUID:(NSNumber* _Nullable)uuid
                                          andSign:(NSString * _Nullable)sign
                                      andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                           Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    if(!postId) {
        
        finishedBlock(nil);
        return;
    }
    
    if(!uuid){
        
        finishedBlock(nil);
        return;
    }
    
    if(!sign) {
        finishedBlock(nil);
        return ;
    }
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:postId forKey:@"postId"];
    [para setObject:uuid forKey:@"userId"];
    [self requestCommunityServerWithType:POST UrlString:@"/bbs/postDetail/updateCollection" Parameter:para Finished:^(id responseObject) {
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}


//

///根据评论ID更新评论赞的状态, 参数: commentId, userId /bbs/postDetail/updateCommentPraiseStatus
-(void)requestCommunityUpdateCommentPraiseStatusWithCommentId:(NSNumber* _Nullable)commentId
                                                      andUUID:(NSNumber* _Nullable)uuid
                                                    andPostId:(NSNumber* _Nullable)postId
                                             andPraisedUserId:(NSNumber* _Nullable)praisedUserId
                                                   andOperate:(NSNumber * _Nullable)operate
                                                      andSign:(NSString * _Nullable)sign
                                                  andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                                       Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    if(!commentId) {
        
        finishedBlock(nil);
        return;
    }
    
    if(!uuid){
        
        finishedBlock(nil);
        return;
    }
    
    if(!postId) {
        finishedBlock(nil);
        return ;
    }
    
    if(!operate){
        
        finishedBlock(nil);
        return;
    }
    
    if(!praisedUserId) {
        finishedBlock(nil);
        return ;
    }
    if(!sign)
    {
        finishedBlock(nil);
        return ;
    }
    
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:commentId forKey:@"commentId"];
    [para setObject:uuid forKey:@"userId"];
    [para setObject:postId forKey:@"postId"];
    [para setObject:operate forKey:@"operate"];
    [para setObject:praisedUserId forKey:@"praisedUserId"];
    [para setObject:sign forKey:@"sign"];
    [self requestCommunityServerWithType:POST UrlString:@"/bbs/postDetail/updateCommentPraiseStatus" Parameter:para Finished:^(id responseObject) {
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}


/// 根据帖子ID更新帖子赞的状态, 参数: postId, userId /bbs/postDetail/updatePraiseStatus
-(void)requestCommunityUpdatePraiseStatusWithPosetId:(NSNumber* _Nullable)postId
                                             andUUID:(NSNumber* _Nullable)uuid
                                          andOperate:(NSNumber * _Nullable)operate
                                    andPraisedUserId:(NSNumber* _Nullable)praisedUserId
                                             andSign:(NSString * _Nullable)sign
                                         andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                              Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;
{
    if(!postId) {
        
        finishedBlock(nil);
        return;
    }
    
    if(!uuid){
        
        finishedBlock(nil);
        return;
    }
    if(!operate){
        
        finishedBlock(nil);
        return;
    }
    if(!praisedUserId) {
        finishedBlock(nil);
        return ;
    }
    if(!sign)
    {
        finishedBlock(nil);
        return ;
    }
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:postId forKey:@"postId"];
    [para setObject:uuid forKey:@"userId"];
    [para setObject:operate forKey:@"operate"];
    [para setObject:praisedUserId forKey:@"praisedUserId"];
    [para setObject:sign forKey:@"sign"];
    
    [self requestCommunityServerWithType:POST UrlString:@"/bbs/postDetail/updatePraiseStatus" Parameter:para Finished:^(id responseObject) {
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}

///根据回复ID更新回复赞的状态, 参数replyId, userId /bbs/postDetail/updateReplyPraiseStatus
-(void)requestCommunityUpdateReplyPraiseStatusWithReplyId:(NSNumber* _Nullable)replyId
                                                        andUUID:(NSNumber* _Nullable)uuid
                                                      andPostId:(NSNumber* _Nullable)postId
                                                     andOperate:(NSNumber* _Nullable)operate
                                               andPraisedUserId:(NSNumber* _Nullable)praisedUserId
                                                        andSign:(NSString* _Nullable)sign
                                                    andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                                         Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;
{
    
    if(!replyId) {
        
        finishedBlock(nil);
        return;
    }
    
    if(!uuid){
        
        finishedBlock(nil);
        return;
    }
    
    if(!postId) {
        finishedBlock(nil);
        return ;
    }
    
    if(!operate){
        finishedBlock(nil);
        return;
    }
    
    if(!praisedUserId) {
        finishedBlock(nil);
        return ;
    }
    
    if(!sign) {
        finishedBlock(nil);
        return ;
    }
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:replyId forKey:@"replyId"];
    [para setObject:postId forKey:@"postId"];
    [para setObject:uuid forKey:@"userId"];
    [para setObject:operate forKey:@"operate"];
    [para setObject:praisedUserId forKey:@"praisedUserId"];
    [para setObject:sign forKey:@"sign"];
    [self requestCommunityServerWithType:POST UrlString:@"/bbs/postDetail/updateReplyPraiseStatus" Parameter:para Finished:^(id responseObject) {
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}

///根据回复ID更新回复赞的状态, 参数replyId, userId /bbs/postDetail/updateReplyPraiseStatus
-(void)requestCommunityUpdateReplyPraiseStatusWithReplyId:(NSNumber* _Nullable)replyId
                                                andPostId:(NSNumber* _Nullable)postId
                                               andOperate:(NSNumber* _Nullable)operate
                                         andPraisedUserId:(NSNumber* _Nullable)praisedUserId
                                              andFinished:(BXGNetworkCallbackBlockType _Nullable) finished {
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"replyId"] = replyId;
    para[@"postId"] = postId;
    para[@"operate"] = operate;
    para[@"praisedUserId"] = praisedUserId;

    NSString *url = @"/bbs/postDetail/updateReplyPraiseStatus";
    [self bbsBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

@end
