//
//  BXGPraisePersonVC.m
//  Boxuegu
//
//  Created by apple on 2017/9/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPraisePersonVC.h"
#import "BXGPraisePersonListViewModel.h"
#import "BXGMaskView.h"
#import "BXGPraisePersonListCell.h"

@interface BXGPraisePersonVC ()<UITableViewDelegate,
                                UITableViewDataSource,
                                BXGPraisePersonListCellDelegate>
@property(nonatomic, weak) UITableView* tableView;
@property(nonatomic, strong) BXGPraisePersonListViewModel *praisePersonListViewModel;
@end

@implementation BXGPraisePersonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"点赞的人";
    self.pageName = @"博学圈点赞的人列表页";
    
    _praisePersonListViewModel = [BXGPraisePersonListViewModel new];
    
    [self installUI];
    
    [self installPullRefresh];
}

-(void)installUI
{
    UIView *spView = [UIView new];
    [self.view addSubview:spView];
    spView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.right.offset(0);
        make.height.offset(9);
    }];
    
    UITableView *tableView= [self installTableView];
    [self.view addSubview:tableView];
    _tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(spView.mas_bottom).offset(0);
        make.left.right.bottom.offset(0);
    }];
}

-(UITableView*)installTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource =self;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    tableView.separatorColor =  [UIColor colorWithHex:0xF5F5F5];
    
    return tableView;
}

-(void)installPullRefresh
{
    __weak typeof(self) weakSelf = self;
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf refreshUI:YES];
//    }];
    [_tableView bxg_setHeaderRefreshBlock:^{
        [weakSelf refreshUI:YES];
    }];
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf refreshUI:NO];
//    }];
    
    [self.tableView bxg_setFootterRefreshBlock:^{
        [weakSelf refreshUI:NO];
    }];
    
    // 马上进入刷新状态
    [self.tableView bxg_beginHeaderRefresh];
}

-(void)refreshUI:(BOOL)bRefresh
{
    //__weak UITableView *tableView = self.tableView;
    __weak typeof(self) weakSelf = self;
    [_praisePersonListViewModel requestPraisePersonListInfoWithRefresh:bRefresh
                                                             andPostId:_postId
                                                        andFinishBlock:^(BOOL succeed, NSString *errorMessage)
     {
         if(succeed)
         {
             [weakSelf.tableView removeMaskView];
             [weakSelf.tableView reloadData];
         }
         else
         {
             NSLog(@"fail to get note detail data");
         }
         [weakSelf.tableView bxg_endHeaderRefresh];
         if(weakSelf.praisePersonListViewModel.bHaveMoreData)
         {
             [weakSelf.tableView bxg_endFootterRefresh];
         }
         else
         {
             [weakSelf.tableView bxg_endFootterRefreshNoMoreData];
         }
         if(weakSelf.praisePersonListViewModel.arrPraisePersoner.count == 0)
         {
             if(bRefresh)
             {
                 [weakSelf.tableView installMaskView:BXGMaskViewTypeNoPraisePerson];
             }
             else
             {
                 [weakSelf.tableView installMaskView:BXGMaskViewTypeLoadFailed];
             }
         }
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _praisePersonListViewModel.arrPraisePersoner.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXGPraisePersonListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGPraisePersonListCell"];
    if(!cell)
    {
        cell = [[BXGPraisePersonListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BXGPraisePersonListCell"];
    }
    BXGCommunityUserModel *userModel = _praisePersonListViewModel.arrPraisePersoner[indexPath.row];
    [cell setModel:userModel andDelegate:self];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

#pragma mark -- BXGPraisePersonListCellDelegate
-(void)confirmAttention:(NSString*)followUUID
{
    [[BXGBaiduStatistic share] statisticEventString:bxq_dzdr_gzan andParameter:nil];
    [self.praisePersonListViewModel updatePraiseStatusByFollowUUID:[NSNumber numberWithInteger:followUUID.integerValue]
                                                      andAttention:[NSNumber numberWithBool:YES]
                                                    andFinishBlock:^(BOOL bSuccess, NSError *errorMessage) {
    }];
}
    
-(void)cancelAttention:(NSString*)followUUID
{
    [[BXGBaiduStatistic share] statisticEventString:bxq_dzdr_gzan andParameter:nil];
    [self.praisePersonListViewModel updatePraiseStatusByFollowUUID:[NSNumber numberWithInteger:followUUID.integerValue]
                                                      andAttention:[NSNumber numberWithBool:NO]
                                                    andFinishBlock:^(BOOL bSuccess, NSError *errorMessage) {
    }];
}


@end
