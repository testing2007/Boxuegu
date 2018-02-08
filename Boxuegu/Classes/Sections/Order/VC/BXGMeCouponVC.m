//
//  BXGMeCouponVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/16.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMeCouponVC.h"
#import "BXGDiscountCourseVC.h"

#import "BXGOrderCouponModel.h"
#import "BXGOrderCouponDetailCell.h"
#import "BXGOrderBindCouponView.h"
#import "BXGOrderCouponDetailView.h"
#import "RWTabView.h"
#import "BXGOrderCouponDetailViewModel.h"
#import "BXGDiscountCourseVC.h"
#import "BXGDiscountCourseViewModel.h"
#import "BXGCouponUseProtocolVC.h"
#define kCouponDetailCellId @"BXGOrderCouponDetailCell"
@interface BXGMeCouponVC ()
@property (nonatomic, strong) BXGOrderCouponDetailViewModel *viewModel;
@property (nonatomic, weak) BXGOrderCouponDetailView *enableView;
@property (nonatomic, weak) BXGOrderCouponDetailView *usedView;
@property (nonatomic, weak) BXGOrderCouponDetailView *expiredView;
@end

@implementation BXGMeCouponVC

#pragma mark - Interface

- (instancetype)initWithCourseId:(NSString *)courseId andCoupons:(NSArray<BXGOrderCouponModel *> *)coupons andCurrentCouponId:(NSString *)couponId andSelectedCoupon:(void(^)(NSString * couponId))selectedBlock {
    self = [super init];
    if(self) {
        NSMutableString *couponids;
        for (NSInteger i = 0; i < coupons.count; i++) {
            if(i != 0){
                [couponids appendString:@","];
            }else {
                couponids = [NSMutableString new];
            }
            [couponids appendString:coupons[i].idx];
        }
    }
    return self;
}

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的优惠券";
    self.pageName = @"我的优惠券";
    [self installUI];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"优惠券-使用说明"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(onClickHelp:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)onClickHelp:(UIButton *)btn {
    [[BXGBaiduStatistic share] statisticEventString:kBXGStatMeCouponEventTypeCouponProtocol andLabel:nil];
    [self.navigationController pushViewController:[BXGCouponUseProtocolVC new] animated:true];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self becomeFirstResponder];
}

#pragma mark - UI
- (void)installUI {
    Weak(weakSelf);
    // Def
    BXGOrderCouponDetailViewModel *enableViewModel = [[BXGOrderCouponDetailViewModel alloc]initWithType:BXGOrderCouponDetailMyCouponTypeEnable];
    BXGOrderCouponDetailView *enableView = [[BXGOrderCouponDetailView alloc]initWithViewModel:enableViewModel];
    enableView.didSelectedCoupon = ^(BXGOrderCouponModel *model) {
        // 跳转到优惠课程
        [[BXGBaiduStatistic share] statisticEventString:kBXGStatMeCouponEventTypeUseCoupon andLabel:nil];
        [weakSelf toDiscountCourseWithCouponId:model.idx];
    };
    enableView.topRefresh = true;
    enableView.bottomAddMore = true;
    BXGOrderCouponDetailViewModel *usedViewModel = [[BXGOrderCouponDetailViewModel alloc]initWithType:BXGOrderCouponDetailMyCouponTypeCouponUsed];
    BXGOrderCouponDetailView *usedView = [[BXGOrderCouponDetailView alloc]initWithViewModel:usedViewModel];
    usedView.topRefresh = true;
    usedView.bottomAddMore = true;
    
    BXGOrderCouponDetailViewModel *expiredViewModel = [[BXGOrderCouponDetailViewModel alloc]initWithType:BXGOrderCouponDetailMyCouponTypeExpired];
    BXGOrderCouponDetailView *expiredView = [[BXGOrderCouponDetailView alloc]initWithViewModel:expiredViewModel];
    expiredView.topRefresh = true;
    expiredView.bottomAddMore = true;
    RWTabView *tab = [[RWTabView alloc]initWithTitles:@[@"可使用",@"已使用",@"已过期"] andDetailViews:@[enableView,usedView,expiredView]];
    [self.view addSubview:tab];
    tab.DidChangedIndex = ^(RWTabView *tab, NSInteger index, NSString *title, UIView *view) {
        switch (index) {
            case 0:[[BXGBaiduStatistic share] statisticEventString:kBXGStatMeCouponEventTypeUsable andLabel:nil];
                break;
            case 1:[[BXGBaiduStatistic share] statisticEventString:kBXGStatMeCouponEventTypeUsed andLabel:nil];
                break;
            case 2:[[BXGBaiduStatistic share] statisticEventString:kBXGStatMeCouponEventTypeInvalid andLabel:nil];
                break;
        }
    };
    
    // Layout
    [tab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.right.bottom.offset(0);
    }];
    
    self.usedView = usedView;
    self.expiredView = expiredView;
    self.enableView = enableView;
    
    enableView.bindSerialNoBlock = ^(bool success, NSString *msg, NSString *couponId) {
        [weakSelf.enableView reloadData];
        [weakSelf.expiredView reloadData];
        [weakSelf.usedView reloadData];
    };
    
    enableView.bindSerialNoBlock = ^(bool success, NSString *msg, NSString *couponId) {
        [weakSelf.enableView reloadData];
        [weakSelf.expiredView reloadData];
        [weakSelf.usedView reloadData];
    };
    
    enableView.bindSerialNoBlock = ^(bool success, NSString *msg, NSString *couponId) {
        [weakSelf.enableView reloadData];
        [weakSelf.expiredView reloadData];
        [weakSelf.usedView reloadData];
    };
}

- (void)toDiscountCourseWithCouponId:(NSString *)couponId {
    // 跳转到优惠课程
    [[BXGBaiduStatistic share] statisticEventString:kBXGStatMeCouponEventTypeUseCoupon andLabel:kBXGStatMeCouponEventTypeUseCoupon];
    
    BXGDiscountCourseViewModel *disountViewModel= [[BXGDiscountCourseViewModel alloc] initWithCouponId:couponId];
    BXGDiscountCourseVC *vc = [[BXGDiscountCourseVC alloc]initWithDiscountCourseViewModel:disountViewModel];;
    [self.navigationController pushViewController:vc animated:true needLogin:true];
}
@end

