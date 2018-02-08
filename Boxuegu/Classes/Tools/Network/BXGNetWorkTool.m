#import "BXGNetWorkTool.h"
#import "RWDeviceInfo.h"
#import "BXGUserCenter.h"
#import "BXGNetworkParser.h"
#import "DynamicParameter.h"
#import "BXGNetwork.h"
#import "BXGNetworkParser.h"

#define K_SERIAL_FAILED_MAX_COUNT 3
@interface BXGNetWorkTool()

@property (nonatomic, assign) NSInteger serialFailedCount;
@property (nonatomic, strong) AFHTTPSessionManager *communityNetworkManager;
@end

@implementation BXGNetWorkTool

#pragma mark - Init

static BXGNetWorkTool*instance;
+ (instancetype)sharedTool;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BXGNetWorkTool alloc]initWithBaseURL:[NSURL URLWithString:MainBaseUrlString]];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"text/html",@"text/javascript",@"text/xml",@"application/json", @"image/jpeg",@"image/png", nil];
        instance.requestSerializer.timeoutInterval = 10;
    });
    return instance;
}

#pragma mark - Getter Setter

- (NSString *)imei{

    if(!_imei){
    
        _imei = [BXGKeyChain getDeviceIDInKeychain];
    }
    return _imei;
}

#pragma mark - Request

#pragma mark 开始检测网络状态
/**
 开始检测网络状态
 */
- (void)startReach{

    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        [BXGNotificationTool postNotificationForReachability:(NSInteger)status];
        
    }];
    [self.reachabilityManager startMonitoring];
}

#pragma mark 获取当前网络状态

/**
 获取当前网络状态
 */
- (BXGReachabilityStatus)getReachState{

    return (BXGReachabilityStatus)[self.reachabilityManager networkReachabilityStatus];
}

#pragma mark Base网络请求

/**
 Base网络请求 (最新)
 */

- (void)requestType:(RequestType)type
       andBaseURLString:(NSString * _Nullable)baseURLString
           andUrlString:(NSString * _Nullable) urlString
           andParameter:(id _Nullable)para
            andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failed {
    
    // 全局字段
    NSMutableDictionary *mPara = [NSMutableDictionary dictionaryWithDictionary:para];
    if([RWDeviceInfo deviceModel]) {
        mPara[@"device"] = [RWDeviceInfo deviceModel];
        mPara[@"imei"] = self.imei;
        mPara[@"os"] = @"ios";
    }
    BXGUserModel *userModel = [BXGUserCenter share].userModel;
    if(userModel){
        mPara[@"user_id"]= userModel.user_id;
        mPara[@"sign"] = userModel.sign;
    }
    // 路径拼接
    NSString *absolutePath = [baseURLString stringByAppendingPathComponent:urlString];
    // 设置回调
    void(^success)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)  = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RWNetworkLog(@"\nBase URL:%@\nURL:%@\nPARA:\n%@\nResponse:\n%@\n",baseURLString, urlString ,mPara ,responseObject);
        finished(responseObject);
    };
    void(^failure)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RWNetworkLog(@"\nBase URL: %@\nURL:%@\n,PARA:\n%@\n,error:\n%@\n",baseURLString, urlString, mPara, error);
        failed(error);
    };
    void(^progress)(NSProgress * _Nonnull Progress) = ^(NSProgress * _Nonnull Progress) {
    };
    
    // 请求
    switch(type) {
        case GET:
            [self GET:absolutePath parameters:mPara progress:progress success:success failure:failure];
            break;
        case POST:
            [self POST:absolutePath parameters:mPara progress:progress success:success failure:failure];
            break;
    }
}



@end
