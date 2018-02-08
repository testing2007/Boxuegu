//
//  BXGStatistic.m
//  Boxuegu
//
//  Created by apple on 2017/7/21.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGStatistic.h"
#import "BXGResourceManager.h"
#import "NSMutableDictionary+Accessors.h"

const NSString* STATISTIC_INFO_PLIST = @"statistic.plist";      //文件名

const NSString* kAppVersionKey = @"AppVersionKey";              //App版本号
const NSString* kLaunchTimesKey = @"LaunchTimesKey";            //启动次数
const NSString* kCommentThresholdKey = @"CommentThresholdKey";  //评价阀值
const NSString* kCommentedKey = @"CommentedKey";                //是否已评价

const NSUInteger INITIAL_COMMENT_THREASHOLD = 5;                //初始启动评价阀值
const NSUInteger MAX_COMMENT_THREASHOLD = 40;                   //最大启动评价阀值

@interface BXGStatistic()

@property(nonatomic, strong) NSMutableDictionary *statisticContent;

@property(nonatomic, strong) NSString *appVersion;
@property(nonatomic, assign) NSUInteger launchTimes;
@property(nonatomic, assign) NSUInteger commentThreshold;

@property(nonatomic, strong) NSString *statisticFilePath;

@end

@implementation BXGStatistic

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static BXGStatistic *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[BXGStatistic alloc] init];
    });
    return instance;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self recoverAllInfoFromPlist];
    }
    return self;
}

-(NSString*)statisticFilePath
{
    if(!_statisticFilePath)
    {
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        NSString *statisticDirectory = [NSString stringWithFormat:@"%@", [[BXGResourceManager shareInstance] userDirectory]];
        _statisticFilePath = [NSString stringWithFormat:@"%@/%@", statisticDirectory, STATISTIC_INFO_PLIST];
        if(![defaultManager fileExistsAtPath:_statisticFilePath])
        {
            if(![defaultManager fileExistsAtPath:statisticDirectory])
            {
                [defaultManager createDirectoryAtPath:statisticDirectory withIntermediateDirectories:YES attributes:nil error:nil];
            }
            [defaultManager createFileAtPath:_statisticFilePath contents:nil attributes:nil];
        }
    }
    return _statisticFilePath;
}

-(void)recoverAllInfoFromPlist
{
    _statisticContent = [NSMutableDictionary dictionaryWithContentsOfFile:self.statisticFilePath];
    if(_statisticContent==nil)
    {
        [self reset];
    }
    else
    {
        _appVersion = [_statisticContent stringForKey:(NSString*)kAppVersionKey];
        _launchTimes = [_statisticContent unsignedIntegerForKey:(NSString*)kLaunchTimesKey];
        _commentThreshold = [_statisticContent unsignedIntegerForKey:(NSString*)kCommentThresholdKey];
    }
}

-(void)recordAllInfoIntoPlist
{
    if(_statisticContent)
    {
        [_statisticContent updateString:_appVersion forKey:(NSString*)kAppVersionKey];
        [_statisticContent updateNSUInteger:_launchTimes forKey:(NSString*)kLaunchTimesKey];
        [_statisticContent updateNSUInteger:_commentThreshold forKey:(NSString*)kCommentThresholdKey];
        [_statisticContent writeToFile:_statisticFilePath atomically:YES];
    }
}

-(BOOL)isShouldPopupComment
{
    //return YES;//for debuging
    
    if(!_statisticContent)
    {
        return NO;
    }
    
    NSString *currentVersion = [[BXGResourceManager shareInstance] appVersion];
    if(![currentVersion isEqualToString:_appVersion])
    {
        //说明安装了新版本, 而保存的记录文件还是老版本的, 需要将老版本的数据信息进行更新
        [self reset];
        [self addLaunchTimes];
    }
    if(_launchTimes<_commentThreshold)
    {
        return NO;
    }
    return YES;
}

-(void)cancelComment
{
    [self prepareForNextComment];
}

//跳转去AppStore评价
-(void)redirectCommentLink
{
    NSString *strAppStoreLink = @"https://itunes.apple.com/cn/app/%E5%8D%9A%E5%AD%A6%E8%B0%B7/id1241182369?mt=8";
    NSURL *urlAppstoreLink = [NSURL URLWithString:strAppStoreLink];
    [[UIApplication sharedApplication] openURL:urlAppstoreLink];
    
    [self prepareForNextComment];
}

-(void)prepareForNextComment
{
    //取消评价/跳转去AppStore/吐个嘈, 将启动阀值修改为初始阀值的2倍且不超过最大阀值, 记录已启动次数变为 1.
    _commentThreshold = (2*_commentThreshold)>=MAX_COMMENT_THREASHOLD ? MAX_COMMENT_THREASHOLD : (2*_commentThreshold);
    _launchTimes = 0;
}

-(void)toFeedback
{
    //点击吐槽, 跳转到反馈页面
    [self prepareForNextComment];
}

-(void)addLaunchTimes
{
    _launchTimes+=1;
}

-(void)reset
{
    NSMutableDictionary *mutableDiction = [NSMutableDictionary new];
    _launchTimes = 0;
    _commentThreshold = INITIAL_COMMENT_THREASHOLD;
    _appVersion = [[BXGResourceManager shareInstance] appVersion];
    [mutableDiction setObject:_appVersion forKey:kAppVersionKey];
    [mutableDiction setObject:[NSNumber numberWithUnsignedInteger:_launchTimes] forKey:kLaunchTimesKey];
    [mutableDiction setObject:[NSNumber numberWithUnsignedInteger:_commentThreshold] forKey:kCommentThresholdKey];
    _statisticContent = [NSMutableDictionary dictionaryWithDictionary:mutableDiction];
}

@end
