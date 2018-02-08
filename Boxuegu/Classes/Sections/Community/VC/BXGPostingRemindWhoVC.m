//
//  BXGPostingRemindWhoVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPostingRemindWhoVC.h"
#import "RWTableView.h"
#import "BXGComunityRemindUserCell.h"
#import "BXGCommunityUserIconCCell.h"
#import "BXGMaskView.h"
#import "MJRefresh.h"

@interface MYCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, strong) NSArray *modelArray;
@end

@implementation MYCollectionViewFlowLayout

- (void)prepareLayout {

    [super prepareLayout];
    
    self.itemSize = CGSizeMake(53, 53);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

@end

static NSString *remindCellId = @"BXGComunityRemindUserCell";

static NSString *userItemCCellId = @"BXGCommunityUserIconCCell";
@interface BXGPostingRemindWhoVC () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) RWTableView *tableView;
@property (nonatomic, weak) UILabel *maskCollectionLabel;
@end

@implementation BXGPostingRemindWhoVC

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"提醒谁看";
    
    [self installUI];
    [self installNavigationItems];
    
    [self.view installLoadingMaskViewWithInset:UIEdgeInsetsMake(K_NAVIGATION_BAR_OFFSET, 0, 0, 0)];
    [self loadData];
}

#pragma mark - Install UI
- (void)installUI {
    
    Weak(weakSelf);
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.view.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    MYCollectionViewFlowLayout *flowLayout = [[MYCollectionViewFlowLayout alloc]init];

    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 1, 1) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:[BXGCommunityUserIconCCell class] forCellWithReuseIdentifier:userItemCCellId];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.offset(K_NAVIGATION_BAR_OFFSET + 9);
        make.left.right.offset(0);
        make.height.offset(53);
    }];
    
    [collectionView layoutIfNeeded];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    RWTableView *tableView = [RWTableView new];
//    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf moreData];
//    }];
    
    [tableView bxg_setFootterRefreshBlock:^{
       [weakSelf moreData];
    }];
    
    [self.view addSubview:tableView];
    tableView.numberOfRowsInSectionBlock = ^NSInteger(UITableView *__weak tableView, NSInteger section) {
      
        return weakSelf.userModelArray.count;
    };
    [tableView registerClass:[BXGComunityRemindUserCell class] forCellReuseIdentifier:remindCellId];
    
    tableView.cellForRowAtIndexPathBlock = ^UITableViewCell *(UITableView *__weak tableView, NSIndexPath *__weak indexPath) {
        
        BXGComunityRemindUserCell *cell = [tableView dequeueReusableCellWithIdentifier:remindCellId];
        cell.model = weakSelf.userModelArray[indexPath.row];
        
        if([weakSelf.viewModel.selectedCommunityUserModelArray containsObject:weakSelf.userModelArray[indexPath.row]]) {
        
            cell.isUserSelected = true;
        }else {
        
            cell.isUserSelected = false;
        }
        return cell;
    };
    tableView.rowHeight = 50;
    self.collectionView = collectionView;
    
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(collectionView.mas_bottom).offset(9);
        make.left.right.bottom.offset(0);
    }];
   
    tableView.didSelectRowAtIndexPathBlock = ^(UITableView *__weak tableView, NSIndexPath *__weak indexPath) {
        
        // 添加删除选择人
        
        if([weakSelf.viewModel.selectedCommunityUserModelArray containsObject:weakSelf.userModelArray[indexPath.row]]) {
        
            [weakSelf.viewModel.selectedCommunityUserModelArray removeObject:weakSelf.userModelArray[indexPath.row]];
        }else {
        
            if(weakSelf.viewModel.selectedCommunityUserModelArray.count >= 10) {
            
                [[BXGHUDTool share] showHUDWithString:@"最多只能@10名伙伴哟！"];
            }else {
            
                [weakSelf.viewModel.selectedCommunityUserModelArray addObject:weakSelf.userModelArray[indexPath.row]];
            }
        }
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:false];
        [weakSelf.collectionView reloadData];
        
    };
    
    UILabel *maskCollectionLabel = [UILabel new];
    [self.view addSubview:maskCollectionLabel];
    maskCollectionLabel.text = @"还没有@朋友哟！";
    
    maskCollectionLabel.textColor = [UIColor colorWithHex:0x999999];
    maskCollectionLabel.font = [UIFont bxg_fontRegularWithSize:18];
    
    [maskCollectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(collectionView).offset(15);
        make.centerY.equalTo(collectionView).offset(0);
    }];
    self.maskCollectionLabel = maskCollectionLabel;
    
}
- (void)installNavigationItems {
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    commitBtn.tintColor = [UIColor whiteColor];
    [commitBtn setTitle:@"确定"forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:15];
    [commitBtn sizeToFit];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:commitBtn];
    [commitBtn addTarget:self action:@selector(onClickCommitBtn) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Load Data
- (void)loadData {

    Weak(weakSelf);
    [self.viewModel loadAttentionPersonListWithUUID:[BXGUserCenter share].userModel.itcast_uuid andIsMore:false andFinished:^(NSArray<BXGCommunityUserModel *> *modelArray, BOOL isLast) {
        
        [self.view removeMaskView];
        weakSelf.userModelArray = modelArray.copy;
        [weakSelf.tableView reloadData];
        
        if(!weakSelf.userModelArray) {
        
            [self.view installMaskView:BXGMaskViewTypeNoRemindPerson andInset:UIEdgeInsetsMake(K_NAVIGATION_BAR_OFFSET, 0, 0, 0)];
            
        }else {
            
            if(isLast) {
                
                [weakSelf.tableView bxg_endFootterRefreshNoMoreData];
            }else {
                
                
                [weakSelf.tableView bxg_endFootterRefresh];
            }
        }
    }];
}

- (void)moreData {

    Weak(weakSelf);
    [self.viewModel loadAttentionPersonListWithUUID:[BXGUserCenter share].userModel.itcast_uuid andIsMore:true andFinished:^(NSArray<BXGCommunityUserModel *> *modelArray, BOOL isLast) {
        
        weakSelf.userModelArray = modelArray.copy;
        [weakSelf.tableView reloadData];
        if(isLast) {
        
            [weakSelf.tableView bxg_endFootterRefreshNoMoreData];
        }else {
    
            [weakSelf.tableView bxg_endFootterRefresh];
        }
    }];
}

#pragma mark - Action

- (void)onClickCommitBtn {
    
    [self.navigationController popViewControllerAnimated:true];
//    if(self.commitBlock){
//        
//        self.commitBlock(self.viewModel.selectedCommunityUserModelArray);
//    }
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    if(self.commitBlock){
        
        self.commitBlock(self.viewModel.selectedCommunityUserModelArray);
    }
}

#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if(self.viewModel.selectedCommunityUserModelArray.count == 0) {
    
        self.maskCollectionLabel.hidden = false;
    }else {
    
        self.maskCollectionLabel.hidden = true;
    }
    return self.viewModel.selectedCommunityUserModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    BXGCommunityUserIconCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:userItemCCellId forIndexPath:indexPath];
    cell.userModel = self.viewModel.selectedCommunityUserModelArray[indexPath.item];
    return cell;
}

#pragma mark - Collection View Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    NSInteger i = [self.userModelArray indexOfObject:self.viewModel.selectedCommunityUserModelArray[indexPath.item]];
    
    [self.viewModel.selectedCommunityUserModelArray removeObject:self.viewModel.selectedCommunityUserModelArray[indexPath.item]];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:false];
    [collectionView reloadData];
}
@end
