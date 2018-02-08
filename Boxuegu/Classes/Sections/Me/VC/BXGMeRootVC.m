//
//  BXGMeRootVC.m
//  Boxuegu
//
//  Created by Renying Wu on 2017/10/9.
//  Copyright © 2017年 itcast. All rights reserved.

//BXGMeMenuView
#import "BXGMeRootVC.h"
#import "BXGMeImfomationView.h"
#import "BXGMeMenuTableViewCell.h"
#import "BXGMeAboutVC.h"
#import "BXGMeFeedbackVC.h"
#import "BXGUserLoginVC.h"
#import "BXGMeViewModel.h"
#import "BXGNotificationTool.h"
// BASE
#import "BXGBaseNaviController.h"
#import "BXGUserLoginVC.h"
#import "BXGMeLearnedHistoryVC.h"
#import "BXGMeMyMessageVC.h"
#import "BXGMeSettingVC.h"
#import "UIPushTableViewCell.h"
#import "BXGShopMiniCourseVC.h"
#import "BXGCourseNotesRootVC.h"
#import "BXGCommunityRootVC.h"

#import "BXGMessageTool.h"
#import "RWBadgeView.h"

#import "BXGDownloadManagerVC.h"
#import "RWCommonFunction.h"
// 1.3.1
#import "BXGBaseNaviController.h"
// 2.0.1
#import "BXGCommunityAttentionVC.h"
#import "BXGMeHomePostVC.h"
// 3.0.1
#import "BXGMeOrderVC.h"
#import "BXGMeCouponVC.h"

#import "BXGUserInfoVC.h"


#import "BXGMeMenuView.h"

#import "BXGDebugPanelVC.h"

@interface BXGMeRootVC () <UINavigationControllerDelegate, BXGNotificationDelegate>

@property (nonatomic, weak) BXGMeImfomationView *imafomationView;
@property (nonatomic, strong) BXGMeMenuView *menuTableView;
@property (nonatomic, weak) BXGMeViewModel *viewModel;
@property (nonatomic, weak) RWBadgeView *badgeView;
@property (nonatomic, strong) UIBarButtonItem *messagBarButtonItem;

@property (nonatomic, strong) BXGMeMenuView *meMenuView;
@end

@implementation BXGMeRootVC

#pragma mark - Init

- (instancetype)init {
    
    self = [super init];
    if(self){
        
        [BXGNotificationTool addObserverForUserLogin:self];
        [BXGNotificationTool addObserverForNewMessageCount:self];
        [BXGMessageTool share];
    }
    return self;
}

- (void)dealloc {
    
    [BXGNotificationTool removeObserver:self];
}

#pragma mark - Setter Getter

- (BXGMeMenuView *)menuTableView {
    
    Weak(weakSelf);
    if(_meMenuView == nil) {
        
        _meMenuView = [BXGMeMenuView new];
        
        BXGMeMenuViewItem *orderItem = [BXGMeMenuViewItem itemWithCellClass:UIPushTableViewCell.class andSettingCell:^(id deqCell) {
            UIPushTableViewCell *cell = deqCell;
            cell.iconImageView.image = [UIImage imageNamed:@"条目-订单"];
            cell.title = @"我的订单";
            
        } andDidSelected:^{
            [weakSelf actionForShowOrder];
        }];
        
        BXGMeMenuViewItem *couponItem = [BXGMeMenuViewItem itemWithCellClass:UIPushTableViewCell.class andSettingCell:^(id deqCell) {
            UIPushTableViewCell *cell = deqCell;
            cell.iconImageView.image = [UIImage imageNamed:@"条目-优惠券"];
            cell.title = @"我的优惠券";
        } andDidSelected:^{
            [weakSelf actionForShowCoupon];
        }];
        
        BXGMeMenuViewItem *downloadItem = [BXGMeMenuViewItem itemWithCellClass:UIPushTableViewCell.class andSettingCell:^(id deqCell) {
            
            UIPushTableViewCell *cell = deqCell;
            cell.iconImageView.image = [UIImage imageNamed:@"条目-下载管理"];
            cell.title = @"下载管理";
            
        } andDidSelected:^{
            [weakSelf actionForShowDownload];
        }];
        
        BXGMeMenuViewItem *studyHistoryItem = [BXGMeMenuViewItem itemWithCellClass:UIPushTableViewCell.class andSettingCell:^(id deqCell) {
            
            UIPushTableViewCell *cell = deqCell;
            cell.iconImageView.image = [UIImage imageNamed:@"条目-观看记录"];
            cell.title = @"观看记录";
        } andDidSelected:^{
            [weakSelf actionForShowLearnedRecord];
        }];
        
        BXGMeMenuViewItem *noteItem = [BXGMeMenuViewItem itemWithCellClass:UIPushTableViewCell.class andSettingCell:^(id deqCell) {
            UIPushTableViewCell *cell = deqCell;
            cell.iconImageView.image = [UIImage imageNamed:@"条目-课程笔记"];
            cell.title = @"课程笔记";
        } andDidSelected:^{
            [weakSelf actionForShowNotes];
        }];
        
        BXGMeMenuViewItem *feedbackItem = [BXGMeMenuViewItem itemWithCellClass:UIPushTableViewCell.class andSettingCell:^(id deqCell) {
            UIPushTableViewCell *cell = deqCell;
            cell.iconImageView.image = [UIImage imageNamed:@"条目-意见反馈"];
            cell.title = @"意见反馈";
        } andDidSelected:^{
            [weakSelf actionForShowFeedback];
        }];
        
        BXGMeMenuViewItem *settingItem = [BXGMeMenuViewItem itemWithCellClass:UIPushTableViewCell.class andSettingCell:^(id deqCell) {
            UIPushTableViewCell *cell = deqCell;
            cell.iconImageView.image = [UIImage imageNamed:@"条目-设置"];
            cell.title = @"设置";
        } andDidSelected:^{
            [weakSelf actionForShowSetting];
        }];
        
#ifdef DEBUG
        BXGMeMenuViewItem *debugingItem = [BXGMeMenuViewItem itemWithCellClass:UIPushTableViewCell.class andSettingCell:^(id deqCell) {
            UIPushTableViewCell *cell = deqCell;
            cell.iconImageView.image = [UIImage imageNamed:@"条目-设置"];
            cell.title = @"调试";
        } andDidSelected:^{
            [weakSelf actionForShowDebug];
        }];
#endif

#ifdef DEBUG
        _meMenuView.items = @[
                             @[orderItem,couponItem],
                             @[downloadItem,studyHistoryItem,noteItem],
                             @[feedbackItem],
                             @[settingItem],
                             @[debugingItem]];
#else
        _meMenuView.items = @[
                              @[orderItem,couponItem],
                              @[downloadItem,studyHistoryItem,noteItem],
                              @[feedbackItem],
                              @[settingItem]];
#endif
        
        [_meMenuView install];
    }
    
    return _meMenuView;
}

- (BXGMeViewModel *)viewModel {
    
    if(!_viewModel) {
        
        _viewModel = [BXGMeViewModel share];
    }
    return _viewModel;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.navigationItem.title = @"";
    
    self.pageName = @"我的页";
    
    [self installNavigationBar];
    // 监听 登录通知
    [self installUI];
}

#pragma mark - ui

- (void)installUI {
    
    self.view.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
    //个人信息
    BXGMeImfomationView *imafomationView = [[BXGMeImfomationView alloc]init];
    self.imafomationView = imafomationView;
    [self.view addSubview:imafomationView];
    [imafomationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.height.offset(150-64);
    }];
    
    BXGMeMenuView *menuView = self.menuTableView;
    [self.view addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imafomationView.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.bottom.offset(0);
    }];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapInformationView)];
    
    [self.imafomationView addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self loadInformation];
}

#pragma mark - Load Data

- (void)loadInformation{
    
    Weak(weakSelf);
    [self.viewModel updateUserInfomationFinished:^(id responseObject) {
        [weakSelf.imafomationView updateImfomation];
    } Failed:^(NSError *error) {
        // pass
    }];
}

#pragma mark - Install UI

- (void)installNavigationBar {
    [super installNavigationBar];
    //  左边导航栏
    //    UILabel *label = [UILabel new];
    //    label.font = [UIFont bxg_fontRegularWithSize:18];
    //    label.textColor = [UIColor whiteColor];
    //    label.text = @"学习中心";
    //    [label sizeToFit];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:label];
    
    // 右边导航栏
    BarElement *downloadBarElement = [BarElement new];
    downloadBarElement.target = self;
    downloadBarElement.sel = @selector(actionForShowDownload);
    downloadBarElement.imageName = @"导航栏-下载";
    downloadBarElement.size = CGSizeMake(RWAutoFontSize(24), RWAutoFontSize(24));
    downloadBarElement.tintColor = [UIColor whiteColor];
    
    BarElement *viewRecordBarElement = [BarElement new];
    viewRecordBarElement.target = self;
    viewRecordBarElement.sel = @selector(actionForShowLearnedRecord);
    viewRecordBarElement.imageName = @"导航栏-观看记录";
    //    viewRecordBarElement.size = CGSizeMake(18+4, 18+4);
    viewRecordBarElement.size = CGSizeMake(RWAutoFontSize(24), RWAutoFontSize(24));
    viewRecordBarElement.tintColor = [UIColor whiteColor];
    
    BarElement *messageBarElement = [BarElement new];
    messageBarElement.target = self;
    messageBarElement.sel = @selector(actionForShowMessage);
    messageBarElement.imageName = @"导航栏-我的消息";
    
    
    // messageBarElement.size = CGSizeMake(18+4 + 4, 18+4 + 4);
    messageBarElement.size = CGSizeMake(RWAutoFontSize(24), RWAutoFontSize(24));
    messageBarElement.tintColor = [UIColor whiteColor];
    
    BXGBaseNaviController *navi = (BXGBaseNaviController*)self.navigationController;
    NSArray *arrRightBarItems = [navi createNaviBarItemsWithBarElements:@[downloadBarElement,
                                                                          viewRecordBarElement]
                                                        andBarItemSpace:15];
    NSArray *arrLeftBarItems =  [navi createNaviBarItemsWithBarElements:@[messageBarElement]
                                                        andBarItemSpace:0];
    self.navigationItem.leftBarButtonItem = arrLeftBarItems[0];
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    _messagBarButtonItem = arrLeftBarItems[0];
    _messagBarButtonItem.customView.clipsToBounds = NO;
    RWBadgeView *badgeView = [RWBadgeView new];
    [_messagBarButtonItem.customView addSubview:badgeView];
    self.badgeView = badgeView;
    badgeView.badgeFontSize = 10;
    badgeView.badgeNumber = [BXGMessageTool share].countOfNewMessage;
    badgeView.userInteractionEnabled = NO;
    [badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(-5);
        make.right.offset(6);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    _badgeView = badgeView;
}

#pragma mark - Response

- (void)tapInformationView {
    
    if([BXGUserCenter share].userModel) {
        BXGUserInfoVC *vc = [BXGUserInfoVC new];
        [self.navigationController pushViewController:vc animated:YES needLogin:NO];
    }else {
        UIViewController *vc = [BXGUserLoginVC new];
        vc.view.backgroundColor = [UIColor whiteColor];
        BXGBaseNaviController *nav = [[BXGBaseNaviController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:true completion:nil];
    }
}

-(void)actionForShowNotes {
    
    RWLog(@"跳转到课程笔记");
    [[BXGBaiduStatistic share]statisticEventString:wdkcbj andParameter:nil];
    BXGCourseNotesRootVC *vc = [BXGCourseNotesRootVC new];
    [self.navigationController pushViewController:vc animated:true needLogin:true];
}

-(void)actionForShowPost {
    
    RWLog(@"跳转到我的帖子");
    BXGMeHomePostVC *vc = [BXGMeHomePostVC new];
    [self.navigationController pushViewController:vc animated:true needLogin:true];
}

- (void)actionForShowFeedback {
    
    RWLog(@"跳转到意见反馈");
    [[BXGBaiduStatistic share]statisticEventString:wdkcbj andParameter:nil];
    BXGMeFeedbackVC *vc = [BXGMeFeedbackVC new];
    [self.navigationController pushViewController:vc animated:true needLogin:true];
}

- (void)actionForShowDownload {
    
    RWLog(@"跳转到下载");
    [[BXGBaiduStatistic share]statisticEventString:wdxzgl_icon_42 andParameter:nil];
    BXGDownloadManagerVC *vc = [BXGDownloadManagerVC new];
    [self.navigationController pushViewController:vc animated:true needLogin:true];
}

- (void)actionForShowLearnedRecord {
    
    RWLog(@"跳转到观看记录");
    [[BXGBaiduStatistic share]statisticEventString:wdgkjl2_icon andParameter:nil];
    BXGMeLearnedHistoryVC *vc = [BXGMeLearnedHistoryVC new];
    [self.navigationController pushViewController:vc animated:true needLogin:true];
}

- (void)actionForShowMessage {
    
    RWLog(@"跳转到我的消息");
    BXGMeMyMessageVC *vc = [BXGMeMyMessageVC new];
    [self.navigationController pushViewController:vc animated:true needLogin:true];
}

- (void)actionForShowSetting {
    
    RWLog(@"跳转到设置");
    [[BXGBaiduStatistic share]statisticEventString:wdsz andParameter:nil];
    BXGMeSettingVC *vc = [BXGMeSettingVC new];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)actionForShowOrder {
    
    RWLog(@"跳转到我的订单");
    BXGMeOrderVC *vc = [BXGMeOrderVC new];
    [[BXGBaiduStatistic share]statisticEventString:kBXGStatMeRootEventTypeMeOrder andLabel:nil];
    [self.navigationController pushViewController:vc animated:true needLogin:true];
}

- (void)actionForShowCoupon {
    
    RWLog(@"跳转到我的优惠券");
    BXGMeCouponVC *vc = [BXGMeCouponVC new];
    [self.navigationController pushViewController:vc animated:true needLogin:true];
}

- (void)actionForShowCommunity {
    
    RWLog(@"跳转到我的学习圈");
    BXGCommunityRootVC *vc = [BXGCommunityRootVC new];
    [self.navigationController pushViewController:vc animated:true needLogin:true];
}

- (void)actionForShowDebug {
     RWLog(@"跳转到调试窗口");
    BXGDebugPanelVC *debugPanelVC = [BXGDebugPanelVC new];
    [self.navigationController pushViewController:debugPanelVC animated:YES];
    return ;
}

#pragma mark - BXGNotification

-(void)catchUserLoginNotificationWith:(BOOL)isLogin {
    
    self.imafomationView.isLogin = isLogin;
}

- (void)catchNewMessageCount:(NSInteger)count {
    
    if(count > 0){
        self.badgeView.badgeNumber = count;
    }else {
        self.badgeView.badgeNumber = 0;
    }
    [self.menuTableView reload];
}

@end
