//
//  BXGMeViewRecordVC.m
//  Boxuegu
//
//  Created by Renying Wu on 2017/6/2.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMeLearnedHistoryVC.h"
#import "UIExtTableView.h"
#import "BXGMeViewModel.h"
// cell
#import "BXGCourseHorizentalCell.h"
#import "BXGLearnedHistoryModel.h"

// lib tool
#import "MJRefresh.h"
#import "BXGMaskView.h"

#import "BXGBasePlayerVC.h"
#import "BXGProCoursePlayerContentVC.h"
#import "BXGMiniCoursePlayerContentVC.h"

@interface BXGMeLearnedHistoryVC ()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) BXGMeViewModel *viewModel;
@property (nonatomic, weak) UIButton *clearItemBtn;
@property (nonatomic, strong) NSArray *modelArray;
@end

@implementation BXGMeLearnedHistoryVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self installUI];
}

- (BXGMeViewModel *)viewModel{

    if(!_viewModel){
     
        _viewModel = [BXGMeViewModel share];
    }
    return _viewModel;
}

#pragma mark - Install UI

- (void)installUI {
    
    self.title = @"观看记录";
    self.pageName = @"观看记录页";
    
    UIView *spView = [UIView new];
    [self.view addSubview:spView];
    spView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.right.offset(0);
        make.height.offset(9);
    }];
    
    UIView *tableView= [self installTableView];
    tableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(spView.mas_bottom).offset(0);
        make.left.right.bottom.offset(0);
    }];
    
    [self installNavigationBarItem];
}



- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    __weak typeof (self) weakSelf = self;
    [weakSelf.tableView bxg_beginHeaderRefresh];
    
}

#pragma mark - Load Data

- (void)loadData {
    
    __weak typeof (self) weakSelf = self;
    
    [[BXGMeViewModel share] loadCourseHistoryWithFinished:^(BOOL succeed, NSArray *historyArray, NSString *message) {
        
        [weakSelf.tableView removeMaskView];
        if(succeed){
        
            weakSelf.modelArray = historyArray;
            if(historyArray.count <= 0){
            
                [weakSelf.tableView installMaskView:BXGMaskViewTypeNoRecentLearned];
            }
            
        }else{
        
            [weakSelf.tableView installMaskView:BXGMaskViewTypeLoadFailed];
        }
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView bxg_endHeaderRefresh];
    }];
    
}

- (void)updateData {

    __weak typeof (self) weakSelf = self;
    
    // 从网络加载
    
//    [[BXGMeViewModel share] loadCourseHistoryIsUpdate:true andFinished:^(BOOL succeed, NSString *message) {
//        
//        [weakSelf.tableView removeMaskView];
//        if(succeed)
//        {
//            
//            [weakSelf.tableView reloadData];
//        }else {
//        
//            [weakSelf.tableView installMaskView];
//        }
//        [weakSelf.tableView.mj_header endRefreshing];
//    }];
    
//从数据库加载
    [[BXGMeViewModel share] loadCourseHistoryFormDatabaseIsUpdate:true andFinished:^(BOOL succeed, NSString *message) {

        [weakSelf.tableView removeMaskView];
        if(succeed)
        {
            
            if(weakSelf.viewModel.historyLearnedModelArray.count <= 0) {
            
                [weakSelf.tableView installMaskView:BXGMaskViewTypeNoRecentLearned];
                self.clearItemBtn.hidden = true;
            }else {
            
                self.clearItemBtn.hidden = false;
            }
            [weakSelf.tableView reloadData];
            
        }else {

            [weakSelf.tableView installMaskView:BXGMaskViewTypeLoadFailed];
        }
        [weakSelf.tableView bxg_endHeaderRefresh];
    }];
    
    
}

- (void)dealloc {

}

#pragma mark - Response

- (UIView *)installTableView {

    __weak typeof (self) weakSelf = self;
    UIExtTableView *tableView = [[UIExtTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [tableView registerNib:[UINib nibWithNibName:@"BXGCourseHorizentalCell" bundle:nil] forCellReuseIdentifier:@"BXGCourseHorizentalCell"];
    
    tableView.numberOfRowsInSectionBlock = ^NSInteger(UITableView *__weak tableView, NSInteger section) {
        
        NSInteger count = weakSelf.modelArray.count;
        return count;
        
    };
    
    tableView.didSelectRowAtIndexPathBlock = ^(UITableView *__weak tableView, NSIndexPath *__weak indexPath) {
      
        BXGLearningRecordModel *model = weakSelf.modelArray[indexPath.row];
//        typedef enum : NSUInteger {
//            
//            BXGCourseModelTypeProCourse = 0,
//            BXGCourseModelTypeMiniCourse = 1,
//        } BXGCourseModelType;
        
        
        
        if(model.courseType.integerValue == BXGCourseModelTypeMiniCourse) {
        
            BXGMiniCoursePlayerContentVC *miniContentVC = [[BXGMiniCoursePlayerContentVC alloc]initWithCourseModel:model.generateCourseModel];
            
            // BXGBasePlayerVC *playerVC = [[BXGBasePlayerVC alloc]initWithContentVC:miniContentVC];
            BXGBasePlayerVC *playerVC = [[BXGBasePlayerVC alloc] initWithCourseModel:model.generateCourseModel ContentVC:miniContentVC];
            [playerVC autoPlayWithPointId:model.point_id andVideoId:model.video_id];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.navigationController pushViewController:playerVC animated:true];
            });
            
        }else {
        
            BXGProCoursePlayerContentVC *proContentVC = [[BXGProCoursePlayerContentVC alloc]initWithCourseModel:model.generateCourseModel andSectionModel:model.generateSectionModel];
            BXGBasePlayerVC *playerVC = [[BXGBasePlayerVC alloc] initWithCourseModel:model.generateCourseModel ContentVC:proContentVC];
            // BXGBasePlayerVC *playerVC = [[BXGBasePlayerVC alloc]initWithContentVC:proContentVC];
            [playerVC autoPlayWithPointId:model.point_id andVideoId:model.video_id];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.navigationController pushViewController:playerVC animated:true];
            });

        }

        
    };
    
//    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf loadData];
//        // [weakSelf updateData];
//    }];
    
    [tableView bxg_setHeaderRefreshBlock:^{
        [weakSelf loadData];
    }];
    
    tableView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
    self.tableView = tableView;
    tableView.numberOfSectionsInTableViewBlock = ^NSInteger(UITableView *__weak tableView) {
      
        return 1;
    };
    
    tableView.cellForRowAtIndexPathBlock = ^UITableViewCell *(UITableView *__weak tableView, NSIndexPath *__weak indexPath) {
      
        BXGCourseHorizentalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGCourseHorizentalCell" forIndexPath:indexPath];
        
        cell.recordModel = weakSelf.modelArray[indexPath.row];
        return cell;
    };
    // tableView.rowHeight = 105;
    // tableView.rowHeight = [UIScreen mainScreen].bounds.size.width / 3.2;
    tableView.rowHeight = [UIScreen mainScreen].bounds.size.width / 3.2;
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    return tableView;

}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除模型
    //[self.wineArray removeObjectAtIndex:indexPath.row];
    
    // 刷新
    // [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

/**
 *  修改Delete按钮文字为“删除”
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}




- (void)installNavigationBarItem{

    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    itemBtn.tintColor = [UIColor whiteColor];
    [itemBtn setTitle:@"清空"forState:UIControlStateNormal];
    itemBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:15];
    [itemBtn sizeToFit];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:itemBtn];
    [itemBtn addTarget:self action:@selector(clickClearBtn:) forControlEvents:UIControlEventTouchUpInside];
    itemBtn.hidden = true;
    self.clearItemBtn = itemBtn;
}

- (void)clickClearBtn:(UIButton *)sender {

    __weak typeof (self) weakSelf = self;
    
    BXGAlertController *alert = [BXGAlertController confirmWithTitle:@"确定要清空观看记录么?" message:nil handler:^{
        
        
        [self.viewModel clearRecentLearnedWithFinished:^(BOOL succeed, NSString *message) {
            
            weakSelf.viewModel.historyLearnedModelArray = nil;
            [weakSelf.tableView reloadData];
            self.clearItemBtn.hidden = true;
            [weakSelf.tableView installMaskView:BXGMaskViewTypeNoRecentLearned];
        }];
    }];
    
    [self presentViewController:alert animated:true completion:nil];
    
}

@end
