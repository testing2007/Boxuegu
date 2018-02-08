#import "BXGAppDelegate.h"

// 根控制器
#import "BXGMainTabBarController.h"

#import "Reachability.h"

// 下载器
#import "BXGDownloader.h"
#import "BXGDatabase.h"

#import "BXGMessageTool.h"
#import "BXGGuideVC.h"

//统计
#import "BXGStatistic.h"
#import "BaiduMobStat.h"

#import "MOPopWindowController.h"
#import "BXGPraisePopVC.h"
#import "UIViewController+MOPopWindow.h"
#import "BXGMeFeedbackVC.h"
#import <UMSocialCore/UMSocialCore.h>
#import "BXGNetWorkTool.h"
#import "BXGWXApiManager.h"
#import "BXGQQAPIManager.h"
#ifdef DEBUG
#define kStatChannelId @"Development"
#else
#define kStatChannelId @"App Store"
#endif
@interface BXGAppDelegate ()
//启动页
@property (nonatomic, strong) UIViewController *launchVC;

//引导页
@property (nonatomic, strong) BXGGuideVC *guideVC;

//主页
@property (nonatomic, strong) UITabBarController *mainTabBarVC;

@end
@implementation BXGAppDelegate

#pragma mark Life Cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //统计启动次数
    [[BXGStatistic shareInstance] addLaunchTimes];
    
    //创建窗口
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[BXGResourceManager shareInstance] addLoginRegisterNotification];
    
#pragma mark - 创建窗口并且加载根控制器
    // 启动消息管理类
    [BXGMessageTool share];
    
    //后台下载设置
    [[DWDownloadSessionManager manager] setBackgroundSessionDownloadCompleteBlock:^NSString *(NSString *downloadUrl) {
        DWDownloadModel *model = [[DWDownloadModel alloc]initWithURLString:downloadUrl];
        return model.filePath;
    }];
    
    [[DWDownloadSessionManager manager] configureBackroundSession];
    
    
    // 设置导航栏
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
#pragma mark - 启动图
    //创建主页信息
    [self crateRootController];
    
    //加载启动页
    [self loadLaunchPage];
    
    //[NSThread sleepForTimeInterval:1.5];
    // 添加 启动图显示时间
#pragma mark - 监听网络状态
    [BXGNetWorkTool sharedTool].networkDelegate = [BXGNotificationTool share];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    [[BXGNetWorkTool sharedTool] startReach];
    
#pragma mark - 配置友盟
    
    UMConfigInstance.appKey = @"58f753c2b27b0a0849000e20";
    UMConfigInstance.channelId = kStatChannelId;
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
#pragma mark - 配置百度
    [self startBaiduMobileStat];
#pragma mark - 配置微信
//    [WXApi registerApp:kWeiXinAppId];
    [BXGWXApiManager install];
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // 微信
    [[UMSocialManager defaultManager] handleOpenURL:url];
    [BXGQQAPIManager handleOpenURL:url];
    [BXGWXApiManager handleOpenURL:url];
    return true;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // 微信
    [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    [BXGQQAPIManager handleOpenURL:url];
    [BXGWXApiManager handleOpenURL:url];
    return true;
}
//#pragma mark - WXApiDelegate
//
//- (void)onReq:(BaseReq *)req {
////    onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
//}
//
//#pragma mark 微信回调的代理方法
//
//- (void)onResp:(BaseResp *)resp {
////    （2）、支付订单过程中：遇到问题，返回或者关闭时，toast提示 "支付取消”，跳转第三方时，toast提示：“正在加载”，然后回到本页面继续支付；
////    （3）、支付成功，跳转到订单支付成功页面
//    if ([resp isKindOfClass:[PayResp class]]) {
//        PayResp *response = (PayResp *)resp;
//        switch (response.errCode) {
//            case WXSuccess:
//                [BXGNotificationTool postNotificationForOrderPayFinishSuccessCallback];
//                NSLog(@"suceess");
//                break;
//
//            default:
//                [BXGNotificationTool postNotificationForOrderPayFinishFailCallback];
//                NSLog(@"failed");
//                break;
//
//
//        }
//    }else{
//        SendAuthResp *auresp = resp;
//        NSString *appId = kWeiXinAppId;
//        NSString *secret = kWeiXinAppSc;
//        NSString *code = auresp.code;
//        NSString *url = [NSString stringWithFormat:@"/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",appId,secret,code];
//        [[BXGNetWorkTool sharedTool]requestType:POST andBaseURLString:@"https://api.weixin.qq.com" andUrlString:url andParameter:nil andFinished:^(id  _Nullable responseObject) {
//
//        } andFailed:^(NSError * _Nonnull error) {
//
//        }];
////        @"unionid" : @"o5PB1syNYK9joMs5CjPf0mYJ2YQo"
//    }
//}

- (void)loadLaunchPage {
    
    UIStoryboard *launchScreen = [UIStoryboard storyboardWithName:@"BXGLaunchScreen" bundle:nil];
    
    UIViewController *launchScreenVC= [launchScreen instantiateInitialViewController];
    
    self.launchVC = launchScreenVC;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.launchVC =nil;
        
        //加载启动页
        [self loadGuidePage];
        // 设置窗口
        //[self createWindowAndRootController];
    });
     self.window.rootViewController = launchScreenVC;
    
//    launchScreenVC.view.frame = [UIScreen mainScreen].bounds;
//    [self.window addSubview:launchScreenVC.view];
    [self.window makeKeyAndVisible];
    
}

-(void)loadGuidePage
{
    __weak typeof(self) weakSelf = self;
    self.guideVC = [[BXGGuideVC alloc] init];
    self.guideVC.finishGuideBlock = ^(){
        weakSelf.guideVC = nil;
        [weakSelf loadMainPage];
    };
    self.window.rootViewController = self.guideVC;
    [self.window makeKeyAndVisible];
}

-(void)loadMainPage
{
    self.window.rootViewController = self.mainTabBarVC;
    [self.window makeKeyAndVisible];
    
    if([BXGUserDefaults share].userModel)
    {
        //判断是否需要弹出评价页
        BXGStatistic *statistic  = [BXGStatistic shareInstance];
        if([statistic isShouldPopupComment])
        {
            //为下一次启动计数做准备
            [statistic prepareForNextComment];
            //记录统计数据
            [[BXGStatistic shareInstance] recordAllInfoIntoPlist];
            
            //弹出评价窗口
            BXGPraisePopVC *praiseVC = [[BXGPraisePopVC alloc] initWithCommenBlock:^{
                [statistic redirectCommentLink];
                [self.mainTabBarVC mo_dissmissCurrentCompletion:nil];
            } withFeedbackBlock:^{
                // [statistic toFeedback];
                [self.mainTabBarVC mo_dissmissCurrentCompletion:nil];
                BXGMeFeedbackVC *feedbackVC = [BXGMeFeedbackVC new];
                [self.mainTabBarVC.viewControllers[0] pushViewController:feedbackVC animated:YES];
            } withCancelBlock:^{
                //[statistic cancelComment];
                [self.mainTabBarVC mo_dissmissCurrentCompletion:nil];
            }];
            
            [self.mainTabBarVC mo_presentViewController:praiseVC option:Center completion:nil];
        }
    }
}

#pragma mark - install Function

// 创建窗口并设置主控制器
- (void)crateRootController {
    self.mainTabBarVC = [[BXGMainTabBarController alloc] init];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // 停止 drmServer
    [self.drmServer stop];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    // 启动 drmServer
    self.drmServer = [[DWDrmServer alloc] initWithListenPort:20140];
    BOOL success = [self.drmServer start];
    if (!success) {
        logerror(@"drmServer 启动失败");
    }
//    [UMSocialManager defaultManager] tive
}

- (void)applicationWillTerminate:(UIApplication *)application {
    //取消正在执行的下载
    [[BXGDownloader shareInstance] cancelAllDownloading];
    //关闭数据库
    [[BXGDatabase shareInstance] close];
}

#pragma mark--------UIApplicationDelegate--
//在应用处于后台，且后台任务下载完成时回调
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler
{
    // session在后台下载完成调用
    // 回调
    [DWDownloadSessionManager manager].backgroundSessionCompletionHandler = completionHandler;
    
    
}

// 启动百度移动统计
- (void)startBaiduMobileStat{
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];

    statTracker.channelId = kStatChannelId;
    [statTracker setEnableDebugOn:false];
    [statTracker startWithAppId:@"1a4e0fa163"]; // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
}


@end
