//
//  BXGQAMainVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/28.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGQAMainVC.h"
// util
#import "RWTab.h"
#import "UIColor+Extension.h"
#import "UIExtTableView.h"

// #import "BXGCommunityDetailVC.h"
#import "BXGQADetailVC.h"

// cell id

#import "BXGCommunityCell.h"
@interface BXGQAMainVC ()

@end

@implementation BXGQAMainVC
static NSString *communityCellId = @"BXGCommunityCell";
#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init
    self.title = @"问答";
    [self installUI];
    [self installNavigationBarItem];
}

#pragma mark - Install UI

- (void)installUI {
    
    UIExtTableView *tableView = [UIExtTableView new];
    [self.view addSubview:tableView];
    tableView.numberOfRowsInSectionBlock = ^NSInteger(UITableView *__weak tableView, NSInteger section) {
        
        return 10;
    };
    tableView.numberOfSectionsInTableViewBlock = ^NSInteger(UITableView *__weak tableView) {
        
        return 1;
    };
    [tableView registerNib:[UINib nibWithNibName:@"BXGCommunityCell" bundle:nil] forCellReuseIdentifier:communityCellId];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.cellForRowAtIndexPathBlock = ^UITableViewCell *(UITableView *__weak tableView, NSIndexPath *__weak indexPath) {
        
        BXGCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:communityCellId forIndexPath:indexPath];
        return cell;
    };
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 100;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.right.offset(0);
        make.bottom.offset(-46);
    }];
    
    tableView.didSelectRowAtIndexPathBlock = ^(UITableView *__weak tableView, NSIndexPath *__weak indexPath) {
        [tableView deselectRowAtIndexPath:indexPath animated:true];
        
        [self.navigationController pushViewController:[BXGQADetailVC new] animated:true];
        
        
    };
    
    tableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
    //    UIView *inputView = [UIView new];
    //    [self.view addSubview:inputView];
    //    inputView.backgroundColor = [UIColor grayColor];
    //    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(tableView.mas_bottom);
    //        make.left.right.offset(0);
    //        make.height.offset(44);
    //        make.bottom.offset(-44);
    //    }];
    
    //    UIViewController *vc1 = [UIViewController new];
    //    vc1.view.backgroundColor = [UIColor randomColor];
    //    UIViewController *vc2 = [UIViewController new];
    //    vc2.view.backgroundColor = [UIColor randomColor];
    //    UIViewController *vc3 = [UIViewController new];
    //    vc3.view.backgroundColor = [UIColor randomColor];
    //
    //    UIView *superView = [[RWTab alloc]initWithDetailViewArrary:@[vc1.view,vc2.view,vc3.view] andTitleArray:@[@"问答精灵", @"学习空间", @"学员故事"] andCount:3];
    //    [self.view addSubview:superView];
    //    [superView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.offset(64);
    //        make.left.right.bottom.offset(0);
    //    }];
    
}

- (void)installNavigationBarItem {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"导航栏-排行"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickRankingItem)];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"榜单" style:UIBarButtonItemStylePlain target:self action:@selector(clickRankingItem)];
}

- (void)clickRankingItem {
    
    // [self.navigationController pushViewController: [BXGCommunityRankingVC new] animated:true];
}

@end
