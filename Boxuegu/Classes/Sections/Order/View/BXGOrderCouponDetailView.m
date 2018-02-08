//
//  BXGOrderCouponListView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderCouponDetailView.h"
#import "BXGOrderCouponModel.h"
#import "BXGOrderBindCouponView.h"
#import "BXGOrderCouponDetailCell.h"
#import "BXGOrderCouponDetailViewModel.h"
#import "RWDeviceInfo.h"
#import "MJRefresh.h"

#define kCouponDetailCellId @"BXGOrderCouponDetailCell"
#define kBXGOrderBindCouponViewHeight 41

@interface BXGOrderCouponDetailView() <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>


@property (nonatomic, strong) NSArray<BXGOrderCouponModel *> *models;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) BXGOrderBindCouponView *couponView;
@end
@implementation BXGOrderCouponDetailView


- (void)setSelectedCouponId:(NSString *)selectedCouponId {
    self.viewModel.selectedCouponId = selectedCouponId;
    [self.tableView reloadData];
}

- (NSString *)selectedCouponId {
    return self.viewModel.selectedCouponId;
}

//- (instancetype)initWithCourseId:(NSString *)courseId andCoupons:(NSArray<BXGOrderCouponModel *> *)coupons andCurrentCouponId:(NSString *)couponId andSelectedCoupon:(void(^)(NSString * couponId))selectedBlock; {
//    self = [super initWithFrame:CGRectZero];
//    if(self) {
//        self.selectedCouponId = couponId;
//        [self installUI];
//        [self loadDataWithRefresh:true];
//    }
//    return self;
//}

- (instancetype)initWithViewModel:(BXGOrderCouponDetailViewModel *)viewModel {
    self = [super init];
    if(self) {
        _viewModel = viewModel;
        [self installUI];
        [self installLoadingMaskView];
        [self loadDataWithRefresh:true];
    }
    return self;
}

- (void)setTopRefresh:(BOOL)topRefresh {
    Weak(weakSelf);
    _topRefresh = topRefresh;
    if(!self.tableView){
        return;
    }
    if(topRefresh) {
        [self.tableView bxg_setHeaderRefreshBlock:^{
            [weakSelf loadDataWithRefresh:true];
        }];
        
//        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [weakSelf loadDataWithRefresh:true];
//        }];
    }else {
        [self.tableView bxg_removeHeaderRefresh];
//        self.tableView.mj_header = nil;
    }
}

- (void)setBottomAddMore:(BOOL)bottomAddMore {
    Weak(weakSelf);
    _bottomAddMore = bottomAddMore;
    if(!self.tableView){
        return;
    }
    if(bottomAddMore) {
//        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            [weakSelf loadDataWithRefresh:false];
//        }];
        
        [self.tableView bxg_setFootterRefreshBlock:^{
            [weakSelf loadDataWithRefresh:false];
        }];
        
    }else {
        self.tableView.mj_footer = nil;
    }
}

// 关闭键盘
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hit = [super hitTest:point withEvent:event];
    if([hit isKindOfClass:[BXGOrderBindCouponView class]]) {
        
    } else {
        [self endEditing:true];
    }
    return hit;
}

- (void)installUI {
     // init
    Weak(weakSelf);
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableView];

    // config
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [tableView registerNib:[UINib nibWithNibName:@"BXGOrderCouponDetailCell" bundle:nil] forCellReuseIdentifier:kCouponDetailCellId];

    // layout
    BXGOrderBindCouponView *couponView = [[BXGOrderBindCouponView alloc]initWithBind:weakSelf.bindSerialNoBlock andCourseId:_viewModel.courseId];
    self.couponView = couponView;
    couponView.bounds = CGRectMake(0, 0, 0, kBXGOrderBindCouponViewHeight);

    tableView.tableHeaderView = couponView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.bottom.offset(0);
    }];
    
    if(self.topRefresh) {
        [self.tableView bxg_setHeaderRefreshBlock:^{
            [weakSelf loadDataWithRefresh:true];
        }];
//        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [weakSelf loadDataWithRefresh:true];
//        }];
    }
    
    if(self.bottomAddMore) {
//        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            [weakSelf loadDataWithRefresh:false];
//        }];
        
        [self.tableView bxg_setFootterRefreshBlock:^{
            [weakSelf loadDataWithRefresh:false];
        }];
    }
//    self.tableView = tableView;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.didSelectedCoupon){
        self.didSelectedCoupon(self.models[indexPath.row]);
    }
    if(self.didSelectedCouponWithSelectedId) {
        self.didSelectedCouponWithSelectedId(self, self.models[indexPath.row],self.selectedCouponId);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BXGOrderCouponDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kCouponDetailCellId forIndexPath:indexPath];
    cell.couponModel = self.models[indexPath.row];
    if([cell.couponModel.idx isEqualToString:self.viewModel.selectedCouponId]) {
        cell.isArrow = true;
    }else {
        cell.isArrow = false;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([RWDeviceInfo deviceScreenType] == RWDeviceScreenTypeSE || [RWDeviceInfo deviceScreenType] == RWDeviceScreenTypeLowerSE) {
        return 110;
    }else {
        return 120 + 15;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (void)loadDataWithRefresh:(BOOL)isRefresh {
    Weak(weakSelf);
    
    [self.viewModel loadCouponModelsWithRefresh:isRefresh andFinished:^(NSArray<BXGOrderCouponModel *> *models) {
        weakSelf.models = models;
        [weakSelf.tableView removeMaskView];
        [weakSelf removeMaskView];
        if(models == nil) {
            [weakSelf.tableView installMaskView:BXGMaskViewTypeLoadFailed andInset:UIEdgeInsetsMake(kBXGOrderBindCouponViewHeight, 0, 0, 0)];
            weakSelf.viewModel.selectedCouponId = nil;
            if(weakSelf.loadfailed) {
                weakSelf.loadfailed();
            }
        }else if(models.count <= 0) {
            [weakSelf.tableView installMaskView:BXGMaskViewTypeNoCoupon andInset:UIEdgeInsetsMake(kBXGOrderBindCouponViewHeight, 0, 0, 0)];
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
//            [self.tableView.mj_footer endRefreshing];
        }
        
        if(self.viewModel.isNoMoreData){
            [self.tableView bxg_endFootterRefreshNoMoreData];
        }else {
            [self.tableView bxg_endFootterRefresh];
        }
        
        //空白页-没有优惠券
        [weakSelf.tableView reloadData];
        [self.tableView bxg_endHeaderRefresh];
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView becomeFirstResponder];
}

- (void)setBindSerialNoBlock:(void (^)(bool, NSString *, NSString *))bindSerialNoBlock {
    _bindSerialNoBlock = bindSerialNoBlock;
    self.couponView.bindSerialNoBlock = bindSerialNoBlock;
}

- (void)reloadData; {
    [self.tableView bxg_beginHeaderRefresh];
}
@end
