//
//  BXGCommunityRootVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/28.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommunityRootVC.h"

#import "RWTabDetailView.h"
#import "BXGComunityRootSegmentView.h"
#import "UIControl+Custom.h"
#import "RWCommonFunction.h"
#import "BXGMeLearnedHistoryVC.h"
#import "BXGDownloadManagerVC.h"
#import "RWBadgeView.h"
#import "BXGMessageTool.h"
#import "BXGCommunitySquareVC.h"
#import "BXGCommunityAttentionVC.h"
#import "BXGCommunityPostingVC.h"
#import "BXGCommunityRootViewModel.h"

@interface BXGCommunityRootVC () <UITabBarDelegate, BXGNotificationDelegate>
@property (nonatomic, weak)     RWTabDetailView             *detailView;
@property (nonatomic, weak)     BXGComunityRootSegmentView  *titleSegmentedControl;
@property (nonatomic, strong)   BXGCommunityRootViewModel   *communityRootViewModel;
@property (nonatomic, weak)     UIView                      *panView;
@property (nonatomic, strong)   RWBadgeView                 *badgeView;
@end

@implementation BXGCommunityRootVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageName = @"博学圈页";
    [self installUI];
    [self installNavigationItems];
    _communityRootViewModel = [BXGCommunityRootViewModel new];
}

- (void)dealloc {

    [self uninstallObservers];
}

#pragma mark - Observer

- (void)installObservers{
    
    [BXGNotificationTool addObserverForNewMessageCount:self];
}
- (void)uninstallObservers{
    
    [BXGNotificationTool removeObserver:self];
}

#pragma mark - Install UI

- (void)installUI {
    Weak(weakSelf);
    
    // Pan View
    UIView *panView = [UIView new];
    [self.view addSubview:panView];
    self.panView = panView;
    
    // 展示
    BXGCommunitySquareVC *squareVC = [BXGCommunitySquareVC new];
    BXGCommunityAttentionVC *attentionVC = [BXGCommunityAttentionVC new];
    RWTabDetailView *detailView = [[RWTabDetailView alloc]initWithDetailViews:@[squareVC.view,attentionVC.view]];
    self.detailView = detailView;
    detailView.pagingEnabled = true;
    detailView.scrollEnabled = false;
    detailView.bounces = false;
    [panView addSubview:detailView];
    
    detailView.indexChangedBlock = ^(UIView *detailView, NSInteger index) {
      
        weakSelf.titleSegmentedControl.selectedIndex = index;
    };
    [self addChildViewController:squareVC];
    [self addChildViewController:attentionVC];

    // 发帖
    UIButton *postBtn = [UIButton buttonWithType:0];
    [panView addSubview:postBtn];
    [postBtn setImage:[UIImage imageNamed:@"学习圈-发帖"] forState:UIControlStateNormal];
    postBtn.frame = CGRectMake(0, 0, 65, 65);
    NSValue *value = [BXGUserDefaults share].communityPostBtnCenterPoint;
    if(value) {
        
        postBtn.center = value.CGPointValue;
    }else {
        
        postBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width - 50, [UIScreen mainScreen].bounds.size.height - 50 - 44 - K_NAVIGATION_BAR_OFFSET);
    }
    
    // 拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panBtn:)];
    [postBtn addGestureRecognizer:pan];
    [postBtn addTarget:self action:@selector(onClickPostBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    // *** Layout
    
    [panView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
//        make.bottom.offset(-44);
        make.bottom.offset(0);
        make.left.right.offset(0);
    }];
    
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
    }];
}

- (void)installNavigationItems {

    [super installNavigationBar];
    
    // 右边导航栏
//    BarElement *downloadBarElement = [BarElement new];
//    downloadBarElement.target = self;
//    downloadBarElement.sel = @selector(operationDownload);
//    downloadBarElement.imageName = @"导航栏-下载";
//    downloadBarElement.size = CGSizeMake(RWAutoFontSize(24), RWAutoFontSize(24));
//    downloadBarElement.tintColor = [UIColor whiteColor];
//
//    BarElement *viewRecordBarElement = [BarElement new];
//    viewRecordBarElement.target = self;
//    viewRecordBarElement.sel = @selector(operationViewRecord);
//    viewRecordBarElement.imageName = @"导航栏-观看记录";
//    //    viewRecordBarElement.size = CGSizeMake(18+4, 18+4);
//    viewRecordBarElement.size = CGSizeMake(RWAutoFontSize(24), RWAutoFontSize(24));
//    viewRecordBarElement.tintColor = [UIColor whiteColor];
//
//    BXGBaseNaviController *navi = (BXGBaseNaviController*)self.navigationController;
//    NSArray *arrRightBarItems = [navi createNaviBarItemsWithBarElements:@[downloadBarElement,
//                                                                           viewRecordBarElement]
//                                                         andBarItemSpace:15];
//    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    
//
//    BarElement *messageBarElement = [BarElement new];
//    messageBarElement.target = self;
//    messageBarElement.sel = @selector(actionToMessage);
//    messageBarElement.imageName = @"导航栏-我的消息";
//
//
//    // messageBarElement.size = CGSizeMake(18+4 + 4, 18+4 + 4);
//    messageBarElement.size = CGSizeMake(RWAutoFontSize(24), RWAutoFontSize(24));
//    messageBarElement.tintColor = [UIColor whiteColor];
//
//    BXGBaseNaviController *navi = (BXGBaseNaviController*)self.navigationController;
//    NSArray *arrRightBarItems = [navi createRightBarItemsWithBarElements:@[
//                                                                           // downloadBarElement,
//                                                                           //viewRecordBarElement,
//                                                                           messageBarElement]
//                                                         andBarItemSpace:15];
//    self.navigationItem.rightBarButtonItems = arrRightBarItems;
//    UIBarButtonItem *messagBarButtonItem = arrRightBarItems[0];
//    messagBarButtonItem.customView.clipsToBounds = NO;
//    RWBadgeView *badgeView = [RWBadgeView new];
//    [messagBarButtonItem.customView addSubview:badgeView];
//    badgeView.badgeFontSize = 8;
//    badgeView.badgeNumber = [BXGMessageTool share].countOfNewMessage;
//    badgeView.userInteractionEnabled = NO;
//    [badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(-5);
//        make.right.offset(6);
//        make.width.mas_equalTo(20);
//        make.height.mas_equalTo(20);
//    }];
//    _badgeView = badgeView;
    
    
    /*
    UIButton *checkItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     
    [checkItemBtn setImage:[UIImage imageNamed:@"导航栏-签到"] forState:UIControlStateNormal];
    [checkItemBtn setTitle: @"签到" forState:UIControlStateNormal];

    UIButton *rankItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rankItemBtn setImage:[UIImage imageNamed:@"导航栏-榜单"] forState:UIControlStateNormal];
    [rankItemBtn setTitle: @"榜单" forState:UIControlStateNormal];
    
    UIButton *downlaodItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [downlaodItemBtn setImage:[UIImage imageNamed:@"导航栏-下载"] forState:UIControlStateNormal];
    [downlaodItemBtn setTitle: @"下载" forState:UIControlStateNormal];
    
    UIButton *historyItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [historyItemBtn setImage:[UIImage imageNamed:@"导航栏-观看"] forState:UIControlStateNormal];
    [historyItemBtn setTitle: @"观看" forState:UIControlStateNormal];
    
    [checkItemBtn addTarget:self action:@selector(onClickCheckItem) forControlEvents:UIControlEventTouchUpInside];
    [rankItemBtn addTarget:self action:@selector(onClickRankItem) forControlEvents:UIControlEventTouchUpInside];
    [downlaodItemBtn addTarget:self action:@selector(onClickHistoryItem) forControlEvents:UIControlEventTouchUpInside];
    [historyItemBtn addTarget:self action:@selector(onClickDownloadItem) forControlEvents:UIControlEventTouchUpInside];
    
    checkItemBtn.bounds = CGRectMake(0, 0, 25, 25);
    rankItemBtn.bounds = CGRectMake(0, 0, 25, 25);
    downlaodItemBtn.bounds = CGRectMake(0, 0, 25, 25);
    historyItemBtn.bounds = CGRectMake(0, 0, 25, 25);
     
    // 打卡 item
    UIBarButtonItem *checkItem = [[UIBarButtonItem alloc]initWithCustomView:checkItemBtn];
    // 榜单 item
    UIBarButtonItem *rankItem = [[UIBarButtonItem alloc]initWithCustomView:rankItemBtn];
    // 观看item
    UIBarButtonItem *downlaodItem = [[UIBarButtonItem alloc]initWithCustomView:downlaodItemBtn];
    // 下载item
    UIBarButtonItem *historyItem = [[UIBarButtonItem alloc]initWithCustomView:historyItemBtn];
    
    checkItemBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -checkItemBtn.imageView.bounds.size.width - 2.5, -checkItemBtn.imageView.bounds.size.height - 0, 0);
    checkItemBtn.imageEdgeInsets = UIEdgeInsetsMake(-checkItemBtn.titleLabel.bounds.size.height - 0, 0, 0, -checkItemBtn.titleLabel.bounds.size.width);
    checkItemBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:10];
    [checkItemBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
    
    
    rankItemBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -rankItemBtn.imageView.bounds.size.width - 2.5, -rankItemBtn.imageView.bounds.size.height - 0, 0);
    rankItemBtn.imageEdgeInsets = UIEdgeInsetsMake(-rankItemBtn.titleLabel.bounds.size.height - 0, 0, 0, -rankItemBtn.titleLabel.bounds.size.width);
    rankItemBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:10];
    [rankItemBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
    
    downlaodItemBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -downlaodItemBtn.imageView.bounds.size.width - 2.5, -downlaodItemBtn.imageView.bounds.size.height - 0, 0);
    downlaodItemBtn.imageEdgeInsets = UIEdgeInsetsMake(-downlaodItemBtn.titleLabel.bounds.size.height - 0, 0, 0, -downlaodItemBtn.titleLabel.bounds.size.width);
    downlaodItemBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:10];
    [downlaodItemBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
    
    historyItemBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -historyItemBtn.imageView.bounds.size.width - 2.5, -historyItemBtn.imageView.bounds.size.height - 0, 0);
    historyItemBtn.imageEdgeInsets = UIEdgeInsetsMake(-historyItemBtn.titleLabel.bounds.size.height - 0, 0, 0, -historyItemBtn.titleLabel.bounds.size.width);
    historyItemBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:10];
    [historyItemBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
    
    // 设置左item
     self.navigationItem.leftBarButtonItems = @[checkItem, rankItem];
    
    // 设置右item
     self.navigationItem.rightBarButtonItems = @[downlaodItem, historyItem];

    */

    // Title View
    
    // BXGComunityRootSegmentView
    Weak(weakSelf);
    BXGComunityRootSegmentView *titleView = [[BXGComunityRootSegmentView alloc]init];
    titleView.frame = CGRectMake(0, 0, 135, 30);
    [titleView setItems:@[@"广场",@"关注"]];
    self.titleSegmentedControl = titleView;
    self.navigationItem.titleView = titleView;
    titleView.selectedIndex = 0;
    titleView.clickSegmentItemBlock = ^(BXGComunityRootSegmentView *segmentView, NSInteger index) {
        
        switch (index) {
            case 0:
                NSLog(@"选择广场");
                weakSelf.detailView.currentIndex = 0;
                [[BXGBaiduStatistic share] statisticEventString:bxq_gc andParameter:nil];
                break;
                
            case 1:
                NSLog(@"选择关注");
                [weakSelf isNeedPresentLoginBlock:nil];
                weakSelf.detailView.currentIndex = 1;
                [[BXGBaiduStatistic share] statisticEventString:bxq_gz andParameter:nil];
                break;
        }
    };
}

#pragma mark - Action

- (void)onClickCheckItem {

    NSLog(@"选择打卡");
}

- (void)onClickRankItem {
    
    NSLog(@"选择榜单");
}

- (void)onClickHistoryItem {
    
    NSLog(@"选择观看");
}

- (void)onClickDownloadItem {
    
    NSLog(@"选择下载");
}

- (void)operationDownload {
    RWLog(@"跳转到下载");
    BXGDownloadManagerVC *vc = [BXGDownloadManagerVC new];
    [self.navigationController pushViewController:vc animated:true needLogin:true];
}

- (void)operationViewRecord {
    RWLog(@"跳转到观看记录");
    BXGMeLearnedHistoryVC *vc = [BXGMeLearnedHistoryVC new];
    [self.navigationController pushViewController:vc animated:true needLogin:true];
}

- (void)onClickPostBtn:(UIButton *)sender {
    RWLog(@"跳转到发布帖子");
    [[BXGBaiduStatistic share] statisticEventString:bxq_ftan_1 andParameter:nil];
    if(![self isNeedPresentLoginBlock:nil]) {
        
        [[BXGHUDTool share] showLoadingHUDWithString:nil];
        sender.enabled = false;
        [_communityRootViewModel requstIsBannedFinishedBlock:^(BannerType bannerType, NSString *errorMessage) {
            
            if(bannerType==BannerType_None) {
                
                [[BXGHUDTool share] closeHUD];
                [self.navigationController pushViewController:[BXGCommunityPostingVC new] animated:true];
            }
            else if(bannerType==BannerType_Prohibit_Speak) {
                
                [[BXGHUDTool share] showHUDWithString:kBXGToastBannerProhibitSpeak];
            }
            else if(bannerType==BannerType_Black_Name_List) {
                
                [[BXGHUDTool share] showHUDWithString:kBXGToastBannerBlackList];
            }
            else { //if(bannerType==BannerType_Unknow) {
                
                [[BXGHUDTool share] showHUDWithString:kBXGToastBannerException];
            }
            
            sender.enabled = true;
        } isRefresh:NO];
    }
}

/// "发帖按钮" 拖拽手势
- (void)panBtn:(UIPanGestureRecognizer *)pan {
    
    UIView *view = pan.view;
    CGFloat width = view.bounds.size.width;
    CGFloat height = view.bounds.size.height;
    CGFloat centerX = view.center.x;
    CGFloat centerY = view.center.y;
    CGFloat newX = [pan locationInView:self.panView].x;
    CGFloat newY = [pan locationInView:self.panView].y;

    if(newX - width / 2 < 0) {
        
        newX = centerX;
    }
    if(newX + width / 2 > self.panView.bounds.size.width) {
        
        newX = centerX;
    }
    if(newY - height / 2 < 0) {
        
        newY = centerY;
    }
    if(newY + height / 2 > self.panView.bounds.size.height) {
        
        newY = centerY;
    }
    
    // 修改frame
    view.center = CGPointMake(newX, newY);
    
    if(pan.state == UIGestureRecognizerStateEnded) { // 手势结束时

        // 吸顶
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:1 animations:^{
            if (view.center.x > self.panView.bounds.size.width / 2) {
                
                    view.center = CGPointMake(self.panView.bounds.size.width - (view.bounds.size.width / 2 + 15), newY);
            }else {
                view.center = CGPointMake(view.bounds.size.width / 2 + 15, newY);
            }}completion:^(BOOL finished) {
                
            }];
         
        // 保存到 user default
        [BXGUserDefaults share].communityPostBtnCenterPoint =  [NSValue valueWithCGPoint:view.center];
    }
}

#pragma mark - Notification

/// 接收消息通知
- (void)catchNewMessageCount:(NSInteger)count
{
    if(count > 0)
    {
        self.badgeView.badgeNumber = count;
    }
    else
    {
        self.badgeView.badgeNumber = 0;
    }
}
@end
