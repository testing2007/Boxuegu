//
//  BXGMeMyMessageVC.m
//  Boxuegu
//
//  Created by Renying Wu on 2017/6/2.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMeMyMessageVC.h"
#import "BXGMeMessageDetailVC.h"
#import "UIExtTableView.h"
#import "BXGAssistantCell.h"
#import "BXGMessageTool.h"
#import "BXGMaskView.h"
#import "MJRefresh.h"

@interface BXGMeMyMessageVC ()
@property (nonatomic, weak) BXGMessageTool *messageTool;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray<BXGMessageModel *> *models;
@end

@implementation BXGMeMyMessageVC

#pragma mark - Getter Setter

- (BXGMessageTool *)messageTool {
    return [BXGMessageTool share];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self installUI];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 刷新列表
    [self.tableView bxg_beginHeaderRefresh];
}

#pragma mark - UI

- (void)installUI {
    
    self.title = @"我的消息";
    
    UIView *spView = [UIView new];
    [self.view addSubview:spView];
    spView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.right.offset(0);
        make.height.offset(9);
    }];
    
    UIView *tableView = [self installTableView];
    tableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(spView.mas_bottom).offset(0);
        make.left.bottom.right.offset(0);
    }];
}

- (UIView *)installTableView {
    
    Weak(weakSelf);
    UIExtTableView *tableView = [[UIExtTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [tableView bxg_setHeaderRefreshBlock:^{
        [weakSelf loadData];
    }];
    
    tableView.rowHeight = 73;
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    
    tableView.numberOfRowsInSectionBlock = ^NSInteger(UITableView *__weak tableView, NSInteger section) {
        
        return weakSelf.models.count;
    };
    
    tableView.cellForRowAtIndexPathBlock = ^UITableViewCell *(UITableView *__weak tableView, NSIndexPath *__weak indexPath) {
        
        BXGAssistantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGAssistantCell" forIndexPath:indexPath];
        cell.model = weakSelf.models[indexPath.row];
        if(cell.model.type.integerValue == BXGMessageTypeCourseMessage){
            cell.badgeNumber = weakSelf.models[indexPath.row].unReadCount.integerValue;
        }else if(cell.model.type.integerValue == BXGMessageTypeEventMessage){
            
            cell.badgeNumber = weakSelf.models[indexPath.row].unReadCount.integerValue;
        }else {
            cell.badgeNumber = weakSelf.models[indexPath.row].unReadCount.integerValue;
        }
        return cell;
    };
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.didSelectRowAtIndexPathBlock = ^(UITableView *__weak tableView, NSIndexPath *__weak indexPath) {
        
        BXGMeMessageDetailVC *vc = [BXGMeMessageDetailVC new];
        vc.model = weakSelf.models[indexPath.row];
        
        if(vc.model.type.integerValue == BXGMessageTypeCourseMessage){
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatMessageEventTypeMessageIntoType andLabel:@"课程消息"];
        }else if(vc.model.type.integerValue == BXGMessageTypeEventMessage){
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatMessageEventTypeMessageIntoType andLabel:@"系统消息"];
        }else {
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatMessageEventTypeMessageIntoType andLabel:@"学习反馈"];
        }
        
        [self.navigationController pushViewController:vc animated:true];
    };
    
    [tableView registerNib:[UINib nibWithNibName:@"BXGAssistantCell" bundle:nil] forCellReuseIdentifier:@"BXGAssistantCell"];
    self.tableView = tableView;
    return tableView;
}

#pragma mark - Data

- (void)loadData {

    __weak typeof (self) weakSelf = self;
    // 更新当前列表
    [[BXGMessageTool share] loadMessageTypeListWithFinishedBlock:^(BOOL succeesd, NSString *message, NSArray *models) {
        [self.tableView bxg_endHeaderRefresh];
        [self.tableView removeMaskView];
        self.models = models;
        if(succeesd){
            if(models.count <= 0) {
                [weakSelf.tableView installMaskView:BXGMaskViewTypeNoMessage];
            }
        }else {
            [weakSelf.tableView installMaskView:BXGMaskViewTypeLoadFailed];
        }
        [weakSelf.tableView reloadData];
    }];
    
    // 更新未读消息数
    [[BXGMessageTool share] loadAllNewMessageCountWithFinishedBlock:^(BOOL succeesd, NSString *message, NSInteger count) {
        
    }];
}
@end
