//
//  BXGConstruePlanVC.m
//  Boxuegu
//
//  Created by wurenying on 2018/1/10.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGConstruePlanVC.h"
#import "BXGConstruePlanViewModel.h"
#import "BXGConstruePlanMonthView.h"
#import "BXGConstruePlanDayView.h"
#import "BXGConstrueLiveVC.h"
#import "BXGConstrueReplayVC.h"

@interface BXGConstruePlanVC () <UIGestureRecognizerDelegate>
@property (nonatomic,strong) BXGConstruePlanViewModel *viewModel;
@property (nonatomic, strong) BXGConstruePlanMonthView *monthView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) BXGConstruePlanDayView *dayView;
@property (nonatomic, assign) BOOL isYes;
@end

@implementation BXGConstruePlanVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播计划";
    self.pageName = @"直播计划";
    [self installUI];
    [self loadDataWithDay:[NSDate new]];
    [self loadData];
}

- (void)installUI {
    Weak(weakSelf);
    BXGConstruePlanMonthView *monthView = self.monthView;
    [self.view addSubview:monthView];
    [monthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.right.offset(0);
        if(K_IS_IPAD) {
            make.height.offset(230);
        }else if (K_IS_IPHONE_5){
            make.height.offset(280);
        }else {
            make.height.offset(346);
        }
    }];
    
    BXGConstruePlanDayView *dayView = self.dayView;
    [self.view addSubview:dayView];
    [dayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(monthView.mas_bottom);
        make.left.right.offset(0);
        make.bottom.offset(0);
    }];
    //
    self.dayView.onScrollToTopBlock = ^(BOOL isTop) {
        if(isTop) {
            weakSelf.monthView.calendar.scope = BXGCalendarScopeMonth;
        }else {
            weakSelf.monthView.calendar.scope = BXGCalendarScopeWeek;
        }
    };
    
    self.dayView.onClickPlanBlock = ^(NSString *planId) {
        [weakSelf onClickPlanDetail:planId];
    };
    
    self.monthView.didSelectedBlock = ^(NSDate *date) {
        [weakSelf loadDataWithDay:date];
    };
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanView:)];
    [self.view addGestureRecognizer:pan];
}

- (void)onPanView:(UIPanGestureRecognizer *)pan {
    [self.monthView.calendar pan:pan];
}

#pragma mark - getter setter

- (BXGConstruePlanViewModel *)viewModel {
    
    if(_viewModel == nil) {
        _viewModel = [BXGConstruePlanViewModel new];
    }
    return _viewModel;
}

- (BXGConstruePlanMonthView *)monthView {
    if(_monthView == nil) {
        
        _monthView = [BXGConstruePlanMonthView new];
    }
    return _monthView;
}

- (UIView *)centerView {
    
    if(_centerView == nil) {
        
        _centerView = [UIView new];
        
    }
    return _centerView;
}

- (BXGConstruePlanDayView *)dayView {
    
    if(_dayView == nil) {
        
        _dayView = [BXGConstruePlanDayView new];
        _dayView.date = [NSDate new];
    }
    return _dayView;
}




#pragma mark - Response

//BXGConstruePlanStatusNone = -1,
//BXGConstruePlanStatusNotStart = 0,
//BXGConstruePlanStatusOnAir = 1,
//BXGConstruePlanStatusEnded = 2,
//BXGConstruePlanStatusReplay = 3,


// 直播计划详情
- (void)onClickPlanDetail:(NSString *)planId {
    
    Weak(weakSelf);
    [[BXGHUDTool share] showLoadingHUDWithString:nil];
    [self.viewModel checkConstrueStatusWithPlanId:planId Finished:^(NSString *planId, BXGConstruePlanStatus status, NSString *msg) {
        [[BXGHUDTool share] closeHUD];
        if(planId) {
            // 请求成功
            
            switch (status) {
                case BXGConstruePlanStatusNone:{
                    // 请求异常
                    [[BXGHUDTool share] showHUDWithString:@"视频信息获取失败，请稍后重试"];
                    return;
                }break;
                case BXGConstruePlanStatusNotStart:{
                    // 直播未开始 跳转到直播页面
                    [weakSelf toLivePlayerWithPlanId:planId];
                    return;
                }break;
                case BXGConstruePlanStatusOnAir:{
                    // 直播开始 跳转到直播页面
                    [weakSelf toLivePlayerWithPlanId:planId];
                    return;
                }break;
                case BXGConstruePlanStatusEnded:{
                    // 直播已结束
//                    [weakSelf toLivePlayerWithPlanId:planId];
                    [[BXGHUDTool share] showHUDWithString:@"直播已结束，10分钟后可看回放视频"];
                    return;
                }break;
                case BXGConstruePlanStatusReplay:{
                    // 可回放
                    [weakSelf toReplayPlayerWithPlanId:planId];
                    return;
                }break;
            }
        }else {
            // 请求失败
            [[BXGHUDTool share] showHUDWithString:msg];
        }
    }];
}

#pragma mark - method

// 跳转到直播页
- (void)toLivePlayerWithPlanId:(NSString *)planId {
    
    if(planId.length <= 0) {
        
        [[BXGHUDTool share] showHUDWithString:@"视频信息获取失败，请稍后重试"];
        return;
    }
    BXGConstrueLiveVC *vc = [BXGConstrueLiveVC new];
    vc.planId = planId;
    [self.navigationController pushViewController:vc animated:true];
}
// 跳转到回放页
- (void)toReplayPlayerWithPlanId:(NSString *)planId {
    
    if(planId.length <= 0) {
        [[BXGHUDTool share] showHUDWithString:@"视频信息获取失败，请稍后重试"];
        return;
    }
    BXGConstrueReplayVC *replayVC = [[BXGConstrueReplayVC alloc]initWithPlanId:planId];
    replayVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:replayVC animated:true completion:nil];
}

#pragma mark - Data

- (void)loadData {
    
    Weak(weakSelf);
    
    [self.viewModel loadConstruePlanByMonthWithMenuId:nil Finished:^(NSArray<BXGConstruePlanMonthItemModel *> *modelArray, NSString *msg) {
        weakSelf.monthView.models = modelArray;
    }];
}
- (void)loadDataWithDay:(NSDate *)day {
    Weak(weakSelf)
    weakSelf.dayView.date = day;
    
    [self.dayView installLoadingMaskViewWithInset:UIEdgeInsetsMake(34, 0, 0, 0)];
    [self.viewModel loadConstruePlanByDay:day WithMenuId:nil Finished:^(NSArray<BXGConstruePlanDayModel *> * _Nullable modelArray, NSString * _Nullable msg) {
        weakSelf.dayView.modelArray = modelArray;
        
        [weakSelf.dayView removeMaskView];
        
        if(modelArray){
            if(modelArray.count <= 0) {
                
                [weakSelf.dayView installMaskView:BXGMaskViewTypeNoConstruePlan andInset:UIEdgeInsetsMake(34, 0, 0, 0)];
            }
        }else {
            [weakSelf.dayView installMaskView:BXGButtonMaskViewTypeLoadFailed andInset:UIEdgeInsetsMake(34, 0, 0, 0) buttonBlock:^{
                [weakSelf loadData];
                [weakSelf loadDataWithDay:day];
            }];
        }
    }];
}

@end
