//
//  BXGLiveManager.m
//  BXGLiveManager
//
//  Created by Renying Wu on 2018/1/3.
//  Copyright © 2018年 Boxuegu. All rights reserved.
//

#import "BXGLiveManager.h"

#if TARGET_IPHONE_SIMULATOR

#elif TARGET_OS_IPHONE
#define K_CCSDK_SIMULATOR_IGNORE
#endif



#ifdef K_CCSDK_SIMULATOR_IGNORE

#import <CCSDK/RequestData.h>

//#define kUserId @"ED9742DB71BAEFEF"
//#define kRoomId @"9318B98FE116FBA29C33DC5901307461"
//#define kRoomId @"9318B9"
//#define kPsw @"wry12345678" // boxuegu
//#define kNickName @"mynSoo3"
#define kPsw @"boxuegu" // boxuegu

#endif

typedef NS_ENUM(NSInteger, ERROR_SERVICE_TYPE) {
    ERROR_ROOM_STATE = 1001,//@"直播间状态不可用，可能没有开始推流"
    ERROR_USELESS_INFO = 1002,//@"没有获取到有用的视频信息"
    ERROR_PASSWORD = 1003,//@"密码错误"
};

typedef NS_ENUM(NSInteger, ERROR_SYSTEM_TYPE) {
    ERROR_RETURNDATA = 1004,//@"返回内容格式错误"
    ERROR_PARAMETER = 1005,//@"可能是参数错误"
    ERROR_NETWORK = 1006,//@"网络错误"
};

@implementation BXGLiveDialogModel
@end


static BXGLiveManager *_instance;

#ifdef K_CCSDK_SIMULATOR_IGNORE
@interface BXGLiveManager()<RequestDataDelegate>
#else
@interface BXGLiveManager()
#endif

#ifdef K_CCSDK_SIMULATOR_IGNORE
@property (nonatomic, strong) PlayParameter *parameter;
@property (nonatomic, strong) RequestData *requestData;
#else

#endif


@property (nonatomic, strong) NSString *viewerId;
@property (nonatomic, strong) NSMutableArray<BXGLiveDialogModel *> *dialogArray;
@property (nonatomic, strong) NSMutableDictionary *userDict;

@property (nonatomic, strong) NSMutableArray<BXGLiveManagerDelegate> *delegates;
@end

@implementation BXGLiveManager

#pragma mark - getter setter


- (void)installCCLiveObserver {
#ifdef K_CCSDK_SIMULATOR_IGNORE
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:nil];
#endif
}

- (void)uninstallCCLiveObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{

#ifdef K_CCSDK_SIMULATOR_IGNORE
    switch (_requestData.ijkPlayer.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            break;
        }
        case IJKMPMoviePlaybackStatePlaying:{
            
            [self setState:BXGLiveManagerStateLive withError:nil];
            break;
        }
        case IJKMPMoviePlaybackStatePaused:{
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            break;
        }
        default: {
            break;
        }
    }
#endif
}

- (void)setState:(BXGLiveManagerState)state withError:(NSError *)error {
    _state = state;
    
    NSString *msg = @"";
    switch (state) {
        case BXGLiveManagerStateLoading:{
            msg = kStringBXGLiveManagerStateLoading;
        }break;
        case BXGLiveManagerStateLive:{
            msg = kStringBXGLiveManagerStateLive;
        }break;
        case BXGLiveManagerStateStop:{
            msg = kStringBXGLiveManagerStateStop;
        }break;
        case BXGLiveManagerStateNotStarted:{
            msg = kStringBXGLiveManagerStateNotStarted;
        }break;
        case BXGLiveManagerStateNetworkError:{
            msg = kStringBXGLiveManagerStateNetworkError;
        }break;
        case BXGLiveManagerStateUnknownError:{
            msg = [NSString stringWithFormat:@"%@:%zd",kStringBXGLiveManagerStateUnknownError,error.code];
        }break;
    }
    // 
    [self updatePlayerViewFrame];
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(liveManager:state:msg:)]) {
            
            [self.delegates[i] liveManager:self state:state msg:msg];
        }
    }
}

- (void)setPlayMode:(BXGLiveManagerPlayMode)playMode {
    
    _playMode = playMode;

    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(liveManager:changeMode:)]) {
            
            [self.delegates[i] liveManager:self changeMode:playMode];
        }
    }
}

+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [BXGLiveManager new];
        
    });
    return _instance;
}

#pragma mark - method

- (void)chatMessage:(NSString *)message; {
    
#ifdef K_CCSDK_SIMULATOR_IGNORE
    [self.requestData chatMessage:message];
#endif
    
}


- (void)switchMode:(BXGLiveManagerPlayMode)mode {
    #ifdef K_CCSDK_SIMULATOR_IGNORE
    
    if(self.state != BXGLiveManagerStateLive) {
        return;
    }
//    [self setState:BXGLiveManagerStateLoading withError:nil];
    [self setState:BXGLiveManagerStateLoading withError:nil];
    switch (mode) {
        case BXGLiveManagerPlayModeVideo:{
            
            if(self.playMode != BXGLiveManagerPlayModeVideo) {
                
                NSInteger currentIndex = self.currentChannel;
                [self.requestData switchToPlayUrlWithFirIndex:currentIndex key:nil];
                self.playMode = BXGLiveManagerPlayModeVideo;
            }
        }break;
        case BXGLiveManagerPlayModeAudio:{
            if(self.playMode != BXGLiveManagerPlayModeAudio) {
                
                NSInteger currentIndex = self.currentChannel;
                [self.requestData switchToPlayUrlWithFirIndex:currentIndex key:@""];
                self.playMode = BXGLiveManagerPlayModeAudio;
            }
        }break;
    }
#endif
}

- (void)setCurrentChannel:(NSInteger)currentChannel {
    
    _currentChannel = currentChannel;
    // 通知
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(liveManager:currentChannel:)]) {
            
            [self.delegates[i] liveManager:self currentChannel:currentChannel];
        }
    }
}

- (void)switchChannel:(NSInteger)index {
#ifdef K_CCSDK_SIMULATOR_IGNORE
    if(self.channelCount <= index) {
        return;
    }
    [self setState:BXGLiveManagerStateLoading withError:nil];
    _currentChannel = index;
    switch (self.playMode) {
        case BXGLiveManagerPlayModeVideo:{
            [self.requestData switchToPlayUrlWithFirIndex:index key:nil];
        }break;
            
        case BXGLiveManagerPlayModeAudio:{
            [self.requestData switchToPlayUrlWithFirIndex:index key:@""];
        }break;
    }
#endif
}

#pragma mark - Delegate

- (NSMutableArray<BXGLiveManagerDelegate> *)delegates {
    
    if(_delegates == nil) {
        _delegates = [NSMutableArray<BXGLiveManagerDelegate> new];
    }
    return _delegates;
}

// 添加代理
- (void)addDelegate:(id<BXGLiveManagerDelegate>)delegate {
    
    // 1.空则返回
    if(delegate == nil) {
        
        return;
    }
    
    // 2.重复则返回
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if(self.delegates[i] == delegate) {
            return;
        }
    }
    
    // 3.添加代理
    [self.delegates addObject:delegate];
    
}

// 移除代理
- (void)removeDelegate:(id<BXGLiveManagerDelegate>)delegate {
    
    // 1.空则返回
    if(delegate == nil) {
        
        return;
    }
    
    // 2.重复则删除
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if(self.delegates[i] == delegate) {
            [self.delegates removeObject:delegate];
            return;
        }
    }
    
}

#pragma mark - getter setter

#ifdef K_CCSDK_SIMULATOR_IGNORE
- (PlayParameter *)parameter {
    
    if(_parameter == nil) {
        _parameter = [[PlayParameter alloc]init];
    }
    return _parameter;
}
#else

#endif


- (NSMutableDictionary *)userDict {
    if(_userDict == nil) {
        _userDict = [[NSMutableDictionary alloc]init];
    }
    return _userDict;
}

- (NSMutableArray *)dialogArray {
    if(_dialogArray == nil) {
        _dialogArray = [[NSMutableArray alloc]init];
    }
    return _dialogArray;
}

- (void)install {

#ifdef K_CCSDK_SIMULATOR_IGNORE
    self.parameter.userId = [BXGUserCenter share].userModel.cc_live_user_id;
    self.parameter.viewerName = [BXGUserCenter share].userModel.user_id;
    self.parameter.token = @"boxuegu";
    self.parameter.security = NO;
    self.parameter.PPTScalingMode = 2;
    self.parameter.defaultColor = [UIColor whiteColor];
    self.parameter.scalingMode = 1;
    self.parameter.pauseInBackGround = NO;
#else
    
#endif
    [self setState:BXGLiveManagerStateLoading withError:nil];
    self.playMode = BXGLiveManagerPlayModeVideo;
    [self installCCLiveObserver];
}
#ifdef K_CCSDK_SIMULATOR_IGNORE
- (void)installRoomId:(NSString *)roomId {
    
    self.parameter.roomId = roomId;
}
#else
- (void)installRoomId:(NSString *)roomId {}
#endif

- (void)unintall {
    
#ifdef K_CCSDK_SIMULATOR_IGNORE
    
    if(_playerView) {
        if(_playerView.superview) {
            [_playerView removeFromSuperview];
        }
        self.playerView = nil;
    }
    
    if(_requestData) {
        [_requestData requestCancel];
        [_requestData shutdownPlayer];
        [_requestData.ijkPlayer shutdown];
        _requestData.ijkPlayer = nil;
        _requestData = nil;
    }
    _parameter = nil;
    _viewerId = nil;
    if(_delegates) {
        [_delegates removeAllObjects];
    }
    
    _viewerId = nil;
    if(_dialogArray) {
        [_dialogArray removeAllObjects];
    }
    
    _userDict = nil;
    
    
    [self uninstallCCLiveObserver];
#else
    
#endif
    
}


- (void)installLiveView:(UIView *)liveView {
    
#ifdef K_CCSDK_SIMULATOR_IGNORE
    self.parameter.playerParent = liveView;
    self.parameter.playerFrame = liveView.bounds;
    self.playerView = liveView;
#endif
    
}


- (UIView *)generatePlayerView {
    UIView *playerView = [UIView new];
    [self installLiveView:playerView];
    return playerView;
}


- (void)installDocView:(UIView *)docView {
    
#ifdef K_CCSDK_SIMULATOR_IGNORE
    self.parameter.docParent = docView;
    self.parameter.docFrame = docView.bounds;
#endif
    
}

- (void)requestPlay {
    
#ifdef K_CCSDK_SIMULATOR_IGNORE
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PlayParameter *reqpara = self.parameter;
//        _requestData= [[RequestData alloc]initLoginWithParameter:self.parameter];
        _requestData = [[RequestData alloc] initWithParameter:reqpara];
        _requestData.delegate = self;
    });
    [self setState:BXGLiveManagerStateLoading withError:nil];
#endif
    
}


// 请求在线人数 (完成)
- (void)requestUserCount {
    
#ifdef K_CCSDK_SIMULATOR_IGNORE
    if(self.requestData) {
        
        [self.requestData roomUserCount];
    }
#endif
    
    
    
}



- (void)framev:(UIView *)view {
    
#ifdef K_CCSDK_SIMULATOR_IGNORE
    self.playerView = view;
    [self.requestData changePlayerFrame:view.bounds];
#endif
    
}


- (void)updatePlayerViewFrame {
    if(self.playerView) {
#ifdef K_CCSDK_SIMULATOR_IGNORE
        [self.requestData changePlayerFrame:self.playerView.bounds];
#endif
    }
}

- (void)setPlayerView:(UIView *)playerView {
    _playerView = playerView;
}

#pragma mark - RequestDataDelegate

// 在线人数 (完成)
- (void)onUserCount:(NSString *)count{
    
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(liveManager:userCount:)]) {
            
            [self.delegates[i] liveManager:self userCount:count.integerValue];
        }
    }
}

/**
 *    直播状态
 */




/// 请求成功
-(void)requestSucceed { // 首次进入直播间 正在直播状态下 getPlayStatue 然后 第二次被调用
    // 首次进入直播间时 正在直播 加载成功
    
    // 状态为 直播中
    [self setState:BXGLiveManagerStateLoading withError:nil];
}

-(void)requestFailed:(NSError *)error reason:(NSString *)reason {

    NSString *msg = nil;
    
    switch (error.code) {
        case ERROR_ROOM_STATE:{ //@"直播间状态不可用，可能没有开始推流"
            [self setState:BXGLiveManagerStateNotStarted withError:nil];
        }break;
        case ERROR_NETWORK:{ // //@"网络错误" // **** 首先调用 getPlayStatue 然后调用 2.直播未开始 直接调用这个代理方法
            [self setState:BXGLiveManagerStateNetworkError withError:nil];
        }break;
        default:{
            [self setState:BXGLiveManagerStateUnknownError withError:error];
        }break;
    }
}

/// 主讲开始推流
- (void)onLiveStatusChangeStart;{ // **** 直播未开始状态下 开始直播 调用此
    // 进入直播间后 未直播 -> 直播 请求成功后 requestSucceed
    // 状态为 加载中
    
    [self setState:BXGLiveManagerStateLoading withError:nil];
}

/// 停止直播，endNormal表示是否异常停止推流，这个参数对观看端影响不大
- (void)onLiveStatusChangeEnd:(BOOL)endNormal;{ /// ****直播状态中退出直播
    NSLog(@"停止直播，endNormal表示是否异常停止推流，这个参数对观看端影响不大");
    // 进入直播间后 直播 -> 未直播
    
    // 状态为 停止直播
    [self setState:BXGLiveManagerStateStop withError:nil];
}

/// 收到播放直播状态 0直播 1未直播 // 首次进入直播间 直播未开始时会被调用
- (void)getPlayStatue:(NSInteger)status;{
    // 调用
    if(status == 0) {
        NSLog(@"直播状态: 直播");
        return;
    }
    if(status == 1) {
        NSLog(@"直播状态: 未直播");
        return;
    }
    NSLog(@"直播状态: 未知");
    return;
}

/// 加载视频失败
- (void)play_loadVideoFail;{
    // 断网情况下调用第一次会被调用
}

/// 登录成功 (未被调用)
- (void)loginSucceedPlay;{
    
}

/// 登录失败 (未被调用)
-(void)loginFailed:(NSError *)error reason:(NSString *)reason;{
    
}

/// 线路和清晰度
- (void)firRoad:(NSInteger)firRoadNum secRoadKeyArray:(NSArray *)secRoadKeyArray {
    
    // 本地保存
    _channelCount = firRoadNum;
    [self setState:BXGLiveManagerStateLoading withError:nil];
    // 代理通知
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(liveManager:channelCount:)]) {
            
            [self.delegates[i] liveManager:self channelCount:firRoadNum];
        }
        
        if([self.delegates[i] respondsToSelector:@selector(liveManager:qualityArray:)]) {
            
            [self.delegates[i] liveManager:self qualityArray:secRoadKeyArray];
        }
    }
}

/// 首次获得 公告
- (void)announcement:(NSString *)str;{
    
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(liveManager:announcement:)]) {
            
            [self.delegates[i] liveManager:self announcement:str];
        }
    }
}

/// 公告被替换
- (void)on_announcement:(NSDictionary *)dict {
    
    NSString *str = nil;
    if([dict[@"action"] isEqualToString:@"release"]) {
        str = dict[@"announcement"];
    } else if([dict[@"action"] isEqualToString:@"remove"]) {
        str = nil;
    }
    
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(liveManager:announcement:)]) {
            
            [self.delegates[i] liveManager:self announcement:str];
        }
    }
}

#pragma mark - 其他功能

/**
 * 聊天
 */

/// 历史聊天数据
- (void)onChatLog:(NSArray *)chatLogArr;{
    
    // 暂不使用历史消息
    
//    self.dialogArray = nil;
//
//    for (NSInteger i = 0; i < chatLogArr.count; i++) {
//        if([chatLogArr[i] isKindOfClass:[NSDictionary class]]) {
//            BXGLiveDialogModel *model = [BXGLiveDialogModel new];
//            [model setValuesForKeysWithDictionary:chatLogArr[i]];
//            [self.dialogArray addObject:model];
//        }
//    }
//
//    for (NSInteger i = 0; i < self.delegates.count; i++) {
//
//        if([self.delegates[i] respondsToSelector:@selector(liveManager:dialogArray:)]) {
//
//            [self.delegates[i] liveManager:self dialogArray:self.dialogArray];
//        }
//    }
}

/// 收到公聊消息
- (void)onPublicChatMessage:(NSDictionary *)message;{
    
    if(message == nil) {
        return;
    }
    
    BXGLiveDialogModel *model = [BXGLiveDialogModel new];
    model.userId = message[@"userid"];
    model.userName = message[@"username"];
    model.content = message[@"msg"];
    model.time = message[@"time"];
    model.userRole = message[@"userrole"];
    model.userCustomMark = message[@"userCustomMark"];
    model.userAvatar = message[@"useravatar"];
    
    [self.dialogArray addObject:model];
    
    // TODO: 添加公聊的状态
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(liveManager:dialogArray:)]) {
            
            [self.delegates[i] liveManager:self dialogArray:self.dialogArray];
        }
    }
}

/// 收到私聊信息
- (void)OnPrivateChat:(NSDictionary *)dic;{
    
    BXGLiveDialogModel *model = [BXGLiveDialogModel new];
    model.userId = dic[@"userid"];
    model.userName = dic[@"userName"];
    model.content = dic[@"content"];
    model.time = dic[@"time"];
    model.userRole = dic[@"userRole"];
    model.userCustomMark = dic[@"userCustomMark"];
    model.userAvatar = dic[@"userAvatar"];
    
    [self.dialogArray addObject:model];
    // TODO: 添加私聊的状态
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(liveManager:dialogArray:)]) {
            
            [self.delegates[i] liveManager:self dialogArray:self.dialogArray];
        }
    }
    
}

/// 收到自己的禁言消息，如果你被禁言了，你发出的消息只有你自己能看到，其他人看不到
- (void)onSilenceUserChatMessage:(NSDictionary *)message;{
    
    // 弹出消息
    
    
//    BXGLiveDialogModel *model = [BXGLiveDialogModel new];
//    model.userId = message[@"userid"];
//    model.userName = message[@"userName"];
//    model.content = message[@"content"];
//    model.time = message[@"time"];
//    model.userRole = message[@"userRole"];
//    model.userCustomMark = message[@"userCustomMark"];
//    model.userAvatar = message[@"userAvatar"];
//
//    // TODO: 添加禁言的状态
//    for (NSInteger i = 0; i < self.delegates.count; i++) {
//
//        if([self.delegates[i] respondsToSelector:@selector(liveManager:dialogArray:)]) {
//
//            [self.delegates[i] liveManager:self dialogArray:self.dialogArray];
//        }
//    }
}

/**
 *    @brief    当主讲全体禁言时，你再发消息，会出发此代理方法，information是禁言提示信息
 */
- (void)information:(NSString *)information;{
    // TODO: 提示窗
}

/**
 *    @brief    服务器端给自己设置的UserId
 */
- (void)setMyViewerId:(NSString *)viewerId {
    
    self.viewerId = viewerId;
}

/// 收到踢出消息，停止推流并退出播放（被主播踢出）
- (void)onKickOut;{
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(liveManager:kickOut:)]) {
            
            [self.delegates[i] liveManager:self kickOut:true];
        }
    }
}

/// 房间信息
-(void)roomInfo:(NSDictionary *)dic{
    
    // 获取简介
    NSString *str = dic[@"desc"];
    if(![str isKindOfClass:[NSString class]] || str.length <= 0) {
        str = @"暂无简介";
    }
    
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(liveManager:introduce:)]) {
            
            [self.delegates[i] liveManager:self introduce:str];
        }
    }
}

/**
 *  未分类
 */

/// 获取文档内白板或者文档本身的宽高，来进行屏幕适配用的
- (void)getDocAspectRatioOfWidth:(CGFloat)width height:(CGFloat)height;{
    
}

/// 自定义消息
- (void)customMessage:(NSString *)message;{
    
}

/*
 *  开始签到
 */
- (void)start_rollcall:(NSInteger)duration;{
    
}

/*
 *  接收到发送的广播
 */
- (void)broadcast_msg:(NSDictionary *)dic;{
    
}
/*
 *  发布问题的ID
 */
- (void)publish_question:(NSString *)publishId;{
    
}

/*
 *  答题
 */

/// 开始答题
- (void)start_vote:(NSInteger)count singleSelection:(BOOL)single;{
    
}

/// 结束答题
- (void)stop_vote;{
    
}

/// 答题结果
- (void)vote_result:(NSDictionary *)resultDic;{
    
}

/*
 *  抽奖
 */

/// 开始抽奖
- (void)start_lottery;{
    
}

/// 抽奖结果
- (void)lottery_resultWithCode:(NSString *)code myself:(BOOL)myself winnerName:(NSString *)winnerName remainNum:(NSInteger)remainNum;{
    
}

/// 退出抽奖
- (void)stop_lottery;{
    
}

/*
 *  问卷
 */

/// 获取问卷详细内容
- (void)questionnaireDetailInformation:(NSDictionary *)detailDic; {
    
}

/// 提交问卷结果（成功，失败）
- (void)commitQuestionnaireResult:(BOOL)success; {
    
}

/// 结束发布问卷
- (void)questionnaire_publish_stop; {
    
}

/// 发布问卷
- (void)questionnaire_publish;{
    
}

/**
 *    @brief  收到提问，用户观看时和主讲的互动问答信息
 */
- (void)onQuestionDic:(NSDictionary *)questionDic;{
    
}
/**
 *    @brief  收到回答，用户观看时和主讲的互动问答信息
 */
- (void)onAnswerDic:(NSDictionary *)answerDic;{
    
}
/**
 *    @brief  收到提问&回答，在用户登录之前，主讲和其他用户的历史互动问答信息
 */
- (void)onQuestionArr:(NSArray *)questionArr onAnswerArr:(NSArray *)answerArr;{
    // 第四次调用 收到提问&回答
}
@end
