//
//  BXGShopMiniCourseVC.m
//  Boxuegu
//
//  Created by HM on 2017/6/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGShopMiniCourseVC.h"
#import "BXGShopViewModel.h"
#import "BXGCourseHorizentalCell.h"
#import "MJRefresh.h"
#import "BXGMaskView.h"

//#import "UIViewController+MaskView.h"
//#import "BXGMaskView.h"

@interface BXGShopMiniCourseVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *miniCourseTableView;
@property (nonatomic, weak) BXGShopViewModel *viewModel;


@property (nonatomic, strong) UIActivityIndicatorView *aiView;


@end

@implementation BXGShopMiniCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.aiView];
    [self.aiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    [self installUI];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self.miniCourseTableView bxg_beginHeaderRefresh];
    
}

- (BXGShopViewModel *)viewModel {

    if(!_viewModel){
    
        _viewModel = [BXGShopViewModel share];
    }
    return _viewModel;
}


- (void)updateData {

    __weak typeof (self) weakSelf = self;
    [self.viewModel loadFreeMicroCourses:true andFinished:^(id responseObject, NSString *errorMessage) {
        if(responseObject) {
            
            
            
            if(responseObject && [responseObject count] > 0){
                
                [weakSelf.miniCourseTableView removeMaskView];
                [weakSelf.miniCourseTableView reloadData];
                
                
                
            }else {
            
                // 数据为空
                [weakSelf.miniCourseTableView installMaskView:BXGMaskViewTypeCourseEmpty];
                
            }
        } else {
        
            // 加载失败
            [weakSelf.miniCourseTableView installMaskView:BXGMaskViewTypeLoadFailed];
        }

        [self.miniCourseTableView bxg_endHeaderRefresh];
    }];

}

- (void)installUI {
 
    self.automaticallyAdjustsScrollViewInsets = false;
    self.title = @"精品微课";
    
    UIView *spView = [UIView new];
    [self.view addSubview:spView];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(64);
        make.height.offset(10);
    }];
    spView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
    
    UIView *miniCourseTableView = [self installDetailTableView];
    [self.view addSubview:miniCourseTableView];
    
    [miniCourseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spView.mas_bottom);
        make.left.bottom.right.offset(0);
    }];
    
}
- (UIView *)installDetailTableView {
    
    __weak typeof (self) weakSelf = self;
    // UITableView *superView = [UITableView new];
    UITableView *superView = [UITableView new];
    // superView.backgroundColor = [UIColor colorWithHex:0xF5f5f5];
    superView.backgroundColor = [UIColor whiteColor];
    superView.dataSource = self;
    superView.delegate = self;
    //superView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
//    superView.contentOffset = CGPointMake(0, -50);
    
    [superView registerNib:[UINib nibWithNibName:@"BXGCourseHorizentalCell" bundle:nil] forCellReuseIdentifier:@"BXGCourseHorizentalCell"];
    superView.rowHeight = [UIScreen mainScreen].bounds.size.width / 3.2;
    superView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
     superView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
//    superView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        [weakSelf updateData];
//        
//    }];
    [superView bxg_setHeaderRefreshBlock:^{
        [weakSelf updateData];
    }];
    superView.tableFooterView = [UIView new];
    
    self.miniCourseTableView = superView;
    return superView;
}
#pragma mark data sourse delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(self.viewModel.courseModelArray) {
    
        return self.viewModel.courseModelArray.count;
    }else {
    
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BXGCourseHorizentalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGCourseHorizentalCell" forIndexPath:indexPath];
    cell.clickAddBtnBlock = ^(BXGCourseModel *model) {
        
        if(model){
            
            [[BXGHUDTool share] showLoadingHUDWithString:@"添加课程中..."];
            [self.viewModel requestBuyFreeMicroCourse:model.course_id Finished:^(BOOL succeed,id responseObject, NSString *errorMessage) {
                
                [[BXGHUDTool share] closeHUD];
                [[BXGHUDTool share] showHUDWithString:errorMessage];
                
            }];
        }else {
            
            [[BXGHUDTool share] showHUDWithString:@"参数异常"];
        }
    };

    cell.model = self.viewModel.courseModelArray[indexPath.row];
    cell.isPurchase = true;
    
    
    
    return cell;
}


- (UIView *)installNoCourseMaskView;{
    
    
    UIView *maskContentView = [UIView new];
    maskContentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [UILabel new];
    [maskContentView addSubview:label];
    label.text = [NSString stringWithFormat:@"您还没有课程，马上开启高薪之路!"];
    
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont bxg_fontRegularWithSize:15];
    label.textColor = [UIColor colorWithHex:0x333333];
    [label sizeToFit];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"没有课程"]];
    [maskContentView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.equalTo(label.mas_top).offset(8);
    }];
    
    return maskContentView;
}


- (UIView *)installLoadFailedMaskView{
    
    UIView *maskContentView = [UIView new];
    maskContentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [UILabel new];
    [maskContentView addSubview:label];

    label.text = @"加载失败，请点击刷新重试 ~";
    
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont bxg_fontRegularWithSize:15];
    label.textColor = [UIColor colorWithHex:0x333333];
    [label sizeToFit];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"加载失败"]];
    [maskContentView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.equalTo(label.mas_top).offset(8);
    }];
    
    return maskContentView;
    
}






@end
