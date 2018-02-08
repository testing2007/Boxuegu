//
//  BXGOrderCouponVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderCouponVC.h"
#import "BXGOrderCouponModel.h"
#import "BXGOrderCouponDetailCell.h"
#import "BXGOrderBindCouponView.h"
#import "BXGOrderCouponDetailView.h"
#import "RWTabView.h"
#import "BXGOrderCouponDetailViewModel.h"
#import "BXGOrderCouponDetailView.h"
#import "BXGCouponUseProtocolVC.h"
#define kCouponDetailCellId @"BXGOrderCouponDetailCell"
@interface BXGOrderCouponVC ()
@property (nonatomic, strong) BXGOrderCouponDetailViewModel *viewModel;
@property (nonatomic, copy) void(^selectedBlock)(NSString * couponId);
@property (nonatomic, strong) NSString *courseId;
@property (nonatomic, strong) NSString *couponids;
@property (nonatomic, strong) NSString *couponId;
@property (nonatomic, strong) BXGOrderCouponDetailView *useableDetailView;
@property (nonatomic, strong) BXGOrderCouponDetailView *disableDetailView;
//@property (nonatomic, strong) NSString *selectedCouponId;
@end

@implementation BXGOrderCouponVC

#pragma mark - Interface

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    Weak(weakSelf);
    if(weakSelf.selectedBlock) {
        weakSelf.selectedBlock(weakSelf.useableDetailView.selectedCouponId);
    }
}

- (instancetype)initWithCourseId:(NSString *)courseId andCoupons:(NSArray<BXGOrderCouponModel *> *)coupons andCurrentCouponId:(NSString *)couponId andSelectedCoupon:(void(^)(NSString * couponId))selectedBlock {
    self = [self init];
    if(self) {
        NSMutableString *couponids;
//        NSMutableArray *mCouponArray = [NSMutableArray new];
        for (NSInteger i = 0; i < coupons.count; i++) {
            if(i != 0){
                [couponids appendString:@","];
            }else {

                couponids = [NSMutableString new];
            }
            [couponids appendString:coupons[i].idx];
//            if(coupons[i].idx) {
//                [mCouponArray addObject:coupons[i].idx];
//            }
        }
        self.courseId = courseId;
        self.couponids = couponids;
//        self.couponids = [mCouponArray yy_modelToJSONString];
//        self.couponids = [mCouponArray yy_modelToJSONData];
        self.couponId = couponId;
        
        self.selectedBlock = selectedBlock;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if(self) {
    }
    return self;
}
#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠券";
    self.pageName = @"使用优惠券";
    [self installUI];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"优惠券-使用说明"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(onClickHelp:)];
    self.navigationItem.rightBarButtonItem = item;
    
}
- (void)onClickHelp:(UIButton *)btn {
    [self.navigationController pushViewController:[BXGCouponUseProtocolVC new] animated:true];
    
}
#pragma mark - UI

- (void)installUI {
    Weak(weakSelf);
    // useable
    BXGOrderCouponDetailViewModel *useableVM = [[BXGOrderCouponDetailViewModel alloc]initWithType:BXGOrderCouponDetailCourseCouponTypeEnable andCourseId:self.courseId andCoupons:self.couponids andCurrentCouponId:self.couponId];
    BXGOrderCouponDetailView *useableDetailView = [[BXGOrderCouponDetailView alloc]initWithViewModel:useableVM];
    self.useableDetailView = useableDetailView;
    useableDetailView.didSelectedCouponWithSelectedId = ^(BXGOrderCouponDetailView *coupondView, BXGOrderCouponModel *model, NSString *selectedCouponId) {
         // 响应被点击
        
        if(selectedCouponId && [model.idx isEqualToString:selectedCouponId]) {
            
            coupondView.selectedCouponId = nil;
//            weakSelf.selectedCouponId = nil;
            if(weakSelf.selectedBlock) {
                weakSelf.selectedBlock(weakSelf.useableDetailView.selectedCouponId);
            }
        }else {
//            weakSelf.selectedCouponId = model.idx;
            coupondView.selectedCouponId = model.idx;
            
            if(weakSelf.selectedBlock) {
                weakSelf.selectedBlock(weakSelf.useableDetailView.selectedCouponId);
            }
            [self.navigationController popViewControllerAnimated:true];
        }
    };
    useableDetailView.loadfailed = ^{
    };
    useableDetailView.topRefresh = true;
    // disableVM
    BXGOrderCouponDetailViewModel *disableVM = [[BXGOrderCouponDetailViewModel alloc]initWithType:BXGOrderCouponDetailCourseCouponTypeDisable andCourseId:self.courseId andCoupons:self.couponids andCurrentCouponId:self.couponId];
    BXGOrderCouponDetailView *disableDetailView = [[BXGOrderCouponDetailView alloc]initWithViewModel:disableVM];
    self.disableDetailView = disableDetailView;
    disableDetailView.topRefresh = true;
    // tab
    RWTabView *tab = [[RWTabView alloc]initWithTitles:@[@"可使用",@"不可用"] andDetailViews:@[useableDetailView,disableDetailView]];
    [self.view addSubview:tab];
    [tab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.right.bottom.offset(0);
    }];
    [self addNewCoupondId];
}

- (void)addNewCoupondId; {
    Weak(weakSelf);
    void(^block)(bool success, NSString *msg, NSString *couponId)= ^(bool success, NSString *msg, NSString *couponId) {
        if(success) {
            [weakSelf.disableDetailView.viewModel addCouponId:couponId];
            [weakSelf.useableDetailView.viewModel addCouponId:couponId];
            [weakSelf.disableDetailView reloadData];
            [weakSelf.useableDetailView reloadData];
        }
    };
    self.disableDetailView.bindSerialNoBlock = block;
    self.useableDetailView.bindSerialNoBlock = block;
}
@end
