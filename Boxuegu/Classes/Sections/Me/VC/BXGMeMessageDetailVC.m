//
//  BXGMeMessageDetailVC.m
//  Boxuegu
//
//  Created by Renying Wu on 2017/6/2.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMeMessageDetailVC.h"
#import "BXGMessageCell.h"
#import "UIExtTableView.h"
#import "BXGMessageTool.h"
#import "BXGStudyFeedbackVC.h"
#import "BXGConstruePlanVC.h"
#import "BXGConstruePlanViewModel.h"
#import "BXGConstrueLiveVC.h"
#import "BXGConstrueReplayVC.h"

@interface BXGMeMessageDetailVC ()
@property (nonatomic, weak) NSArray *arr;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<BXGMessageModel *> *models;
@property (nonatomic, strong) BXGConstruePlanViewModel *construePlanViewModel;
@end

@implementation BXGMeMessageDetailVC


#pragma mark - Getter Setter

- (BXGConstruePlanViewModel *)construePlanViewModel {
    
    if(_construePlanViewModel == nil) {
        
        _construePlanViewModel = [BXGConstruePlanViewModel new];
    }
    return _construePlanViewModel;
}

- (void)setModel:(BXGMessageModel *)model {
    
    _model = model;
    if(model.type.integerValue  == 0) {
        self.title = @"系统消息";
    }else if(model.type.integerValue  == 1){
        self.title = @"课程消息";
    }else if(model.type.integerValue  == 5){
        self.title = @"学习反馈";
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self installUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.view installLoadingMaskViewWithInset:UIEdgeInsetsMake(K_NAVIGATION_BAR_OFFSET, 0, 0, 0)];
    [self.tableView bxg_endFootterRefreshNoMoreData];
    [self loadDataWithRefresh:true];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

#pragma mark - Data

- (void)loadDataWithRefresh:(BOOL)isRefresh {
    
    Weak(weakSelf);
    [[BXGMessageTool share] loadMessageDetailListWithType:self.model.type.integerValue isReflesh:isRefresh FinishedBlock:^(BOOL succeesd, BOOL isNoMore, NSArray *models) {
        weakSelf.models = models;
        [weakSelf.tableView removeMaskView];
        [weakSelf.view removeMaskView];
        
        if(isNoMore) {
            [weakSelf.tableView bxg_endFootterRefreshNoMoreData];
        }else {
            [weakSelf.tableView bxg_endFootterRefresh];
        }
        [weakSelf.tableView bxg_endHeaderRefresh];;
    
        if(succeesd) {
            if(models.count <= 0){
                [weakSelf.tableView installMaskView:BXGMaskViewTypeNoMessage];
            }
        }else {
            [weakSelf.tableView installMaskView:BXGMaskViewTypeLoadFailed];
        }
        [weakSelf.tableView reloadData];
    }];
    
    [[BXGMessageTool share] updateMessageStatusByType:self.model.type.integerValue Finished:^(BOOL succeesd, NSString *message, NSArray *models) {
        
    }];
}

#pragma mark - Install UI

- (void)installUI {
    
    UITableView *tableView = [self installTableView];
    tableView.backgroundColor = [UIColor colorWithHex:0XF5F5F5];
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.bottom.right.offset(0);
    }];
}

- (UITableView *)installTableView {
    
    __weak typeof(self) weakSelf = self;
    UIExtTableView *tableView = [[UIExtTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];

    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    tableView.numberOfRowsInSectionBlock = ^NSInteger(UITableView *__weak tableView, NSInteger section) {
        
        return weakSelf.models.count;
    };
    
    tableView.cellForRowAtIndexPathBlock = ^UITableViewCell *(UITableView *__weak tableView, NSIndexPath *__weak indexPath) {
        
        BXGMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGMessageCell" forIndexPath:indexPath];
        cell.model = weakSelf.models[indexPath.row];
        return cell;
    };
    
    tableView.didSelectRowAtIndexPathBlock = ^(UITableView *__weak tableView, NSIndexPath *__weak indexPath) {
        BXGMessageModel *model = weakSelf.models[indexPath.row];
        if(model.type.integerValue == BXGMessageTypeFeedbackMessage && model.link){
            // 跳转详情页
            BXGStudyFeedbackVC *vc = [BXGStudyFeedbackVC new];
            vc.link = model.link;
            [self.navigationController pushViewController:vc animated:true];
            
        }else if(model.type.integerValue == BXGMessageTypeCourseMessage && model.liveId) {
            [weakSelf onClickPlanDetail:model.liveId];
        }else {
            [[BXGHUDTool share] showHUDWithString:@"功能完善中，暂不支持跳转，请到官网查看！"];
        }
    };
    
    [tableView registerNib:[UINib nibWithNibName:@"BXGMessageCell" bundle:nil] forCellReuseIdentifier:@"BXGMessageCell"];
    
    [tableView bxg_setHeaderRefreshBlock:^{
        [weakSelf loadDataWithRefresh:true];
    }];
    
    [tableView bxg_setFootterRefreshBlock:^{
        [weakSelf loadDataWithRefresh:false];
    }];
    
    weakSelf.tableView = tableView;
    return tableView;
}

- (void)onClickPlanDetail:(NSString *)planId {
    
    Weak(weakSelf);
    [[BXGHUDTool share] showLoadingHUDWithString:nil];
    [self.construePlanViewModel checkConstrueStatusWithPlanId:planId Finished:^(NSString *planId, BXGConstruePlanStatus status, NSString *msg) {
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
                    [[BXGHUDTool share] showHUDWithString:@"直播已结束，10分钟后可看回放视频"];
//                    [weakSelf toLivePlayerWithPlanId:planId];
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

@end
