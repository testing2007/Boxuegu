#import <AFNetworking/AFNetworking.h>
#import "BXGNetwork.h"

#define BXGNetworkFinishedBlockType (void(^ _Nullable )(id _Nullable responseObject))
#define BXGNetworkFailedBlockType (void(^ _Nullable )(NSError * _Nonnull error))
// 通用回调
typedef void (^BXGNetworkCallbackBlockType)(NSInteger status, NSString * _Nullable message, id _Nullable result);

typedef NS_ENUM(NSInteger,RequestType) {
    GET,
    POST
};

typedef NS_ENUM(NSUInteger, BXGNetworkType) {
    BXGNetworkTypeMain,
    BXGNetworkTypeCourse,
    BXGNetworkTypeCommunity,
    BXGNetworkTypeOrder,
};

typedef enum : NSUInteger {
    BaseURLTypeMain,
    BaseURLTypeComunity,
} BaseURLType;

typedef NS_ENUM(NSInteger, BXGReachabilityStatus) {
    BXGReachabilityStatusReachabilityStatusUnknown          = -1,
    BXGReachabilityStatusReachabilityStatusNotReachable     = 0,
    BXGReachabilityStatusReachabilityStatusReachableViaWWAN = 1,
    BXGReachabilityStatusReachabilityStatusReachableViaWiFi = 2,
};

typedef NS_ENUM(NSInteger, BXGStudyStatus) {
    BXGStudyStatusBegin = 2,
    BXGStudyStatusFinish = 1
};


@class BXGNetWorkTool;
@protocol BXGNetWorkToolDelegate <NSObject>

@optional
- (void)networkServerError;

@end

@interface BXGNetWorkTool : AFHTTPSessionManager

@property (nonatomic, weak) _Nullable id<BXGNetWorkToolDelegate> networkDelegate;
@property (nonatomic, strong) NSString * _Nullable imei;
/// 单例
+ (instancetype _Nullable )sharedTool;

#pragma mark - Base
- (void)requestType:(RequestType)type
       andBaseURLString:(NSString * _Nullable)baseURLString
           andUrlString:(NSString * _Nullable) urlString
           andParameter:(id _Nullable)para
            andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failed;

#pragma mark - 网络状态

/**
 开始检测网络
 */
- (void)startReach;


/**
 获取当前网路状态
 */
- (BXGReachabilityStatus)getReachState;

@end
