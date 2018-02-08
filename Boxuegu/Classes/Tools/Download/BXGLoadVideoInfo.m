//
//  BXGVideoInfoOperation.m
//  Demo
//
//  Created by apple on 17/6/9.
//  Copyright © 2017年 com.bokecc.www. All rights reserved.
//

#import "BXGLoadVideoInfo.h"
//#import "BXGVideoInfo.h"
#import "DWPlayInfo.h"
#import "DWUtils.h"

@implementation BXGLoadVideoInfo

-(void)loadVideoId:(NSString*)videoId errorBlock:(void (^)(NSError* error))errorBlock finishBlock:(void (^)(NSDictionary*))finishBlock
{
    BXGUserModel* userModel = [[BXGUserDefaults share] userModel];
    DWPlayInfo *playinfo = [[DWPlayInfo alloc] initWithUserId:userModel.cc_user_id andVideoId:videoId key:userModel.cc_api_key hlsSupport:@"0"];
    //网络请求超时时间
    playinfo.timeoutSeconds =20;
    playinfo.errorBlock = ^(NSError *error){
        errorBlock(error);
    };
    
    playinfo.finishBlock = ^(NSDictionary *response){
        NSDictionary *playUrls =[DWUtils parsePlayInfoResponse:response];
        finishBlock(playUrls);
    };
    [playinfo start];
}

@end
