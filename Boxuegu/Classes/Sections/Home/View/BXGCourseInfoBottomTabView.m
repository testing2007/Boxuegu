//
//  BXGCourseInfoBottomTabView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseInfoBottomTabView.h"
@interface BXGCourseInfoBottomTabView() <UITabBarDelegate>
@end

@implementation BXGCourseInfoBottomTabView
- (void)setType:(BXGCourseInfoBottomTabType)type {
    _type = type;
    for (NSInteger i = 0; i < self.subviews.count; i++){
        [self.subviews[i] removeFromSuperview];
    }
    switch (type) {
        case BXGCourseInfoBottomTabTypeApply:
            [self installForLearn];
            break;
        case BXGCourseInfoBottomTabTypeFreeCourse:
            [self installFreeOrder];
            break;
        case BXGCourseInfoBottomTabTypeMiniCourse:
            [self installForMiniCourse];
            break;
        case BXGCourseInfoBottomTabTypeProCourse:
            [self installProCourse];
            break;
        case BXGCourseInfoBottomTabTypeProCourseNoSample:
            [self installProCourseNoSample];
            break;
    }
}

/// 立即学习
- (void)installForLearn {
    UIButton *learnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:learnBtn];
    learnBtn.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    learnBtn.tintColor = [UIColor whiteColor];
    learnBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    [learnBtn setTitle:@"立即学习" forState:UIControlStateNormal];
    [learnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.offset(0);
        make.width.equalTo(self);
    }];
    [learnBtn addTarget:self action:@selector(onClickLearn) forControlEvents:UIControlEventTouchUpInside];
}

/// 立即报名
- (void)installFreeOrder {
    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:orderBtn];
    orderBtn.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    orderBtn.tintColor = [UIColor whiteColor];
    orderBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    [orderBtn setTitle:@"立即报名" forState:UIControlStateNormal];
    [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.offset(0);
        make.width.equalTo(self);
    }];
    [orderBtn addTarget:self action:@selector(onClickOrder) forControlEvents:UIControlEventTouchUpInside];
}

- (void)installForMiniCourse{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:leftBtn];
    leftBtn.backgroundColor = [UIColor whiteColor];
    leftBtn.tintColor = [UIColor colorWithHex:0x333333];
    leftBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    [leftBtn setTitle:@"试学课程" forState:UIControlStateNormal];


    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    [leftBtn addTarget:self action:@selector(onClickSample) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:orderBtn];
    orderBtn.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    orderBtn.tintColor = [UIColor whiteColor];
    orderBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    [orderBtn setTitle:@"立即报名" forState:UIControlStateNormal];
    [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.offset(0);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    [orderBtn addTarget:self action:@selector(onClickOrder) forControlEvents:UIControlEventTouchUpInside];
}
- (void)installProCourseNoSample{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:leftBtn];
    leftBtn.backgroundColor = [UIColor whiteColor];
    leftBtn.tintColor = [UIColor colorWithHex:0x333333];
    leftBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    [leftBtn setTitle:@"咨询课程" forState:UIControlStateNormal];
    
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    [leftBtn addTarget:self action:@selector(onClickConsult) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:orderBtn];
    orderBtn.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    orderBtn.tintColor = [UIColor whiteColor];
    orderBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    [orderBtn setTitle:@"立即报名" forState:UIControlStateNormal];
    [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.offset(0);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    [orderBtn addTarget:self action:@selector(onClickOrder) forControlEvents:UIControlEventTouchUpInside];
}
- (void)installProCourse{
    
    UITabBar *tabBar = [self makeLeftTabBar];
    tabBar.items = @[[self makeSampleItem],[self makeConsultItem]];
    [self addSubview:tabBar];
    [tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    
    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:orderBtn];
    orderBtn.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    orderBtn.tintColor = [UIColor whiteColor];
    orderBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    [orderBtn setTitle:@"立即报名" forState:UIControlStateNormal];
    [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.offset(0);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    [orderBtn addTarget:self action:@selector(onClickOrder) forControlEvents:UIControlEventTouchUpInside];
}


- (UITabBar *)makeLeftTabBar {
    UITabBar *tabbar = [[UITabBar alloc]init];
    tabbar.delegate = self;
    tabbar.backgroundColor = [UIColor colorWithHex:0xffffff];
    if (@available(iOS 10.0, *)) {
        tabbar.unselectedItemTintColor = [UIColor colorWithHex:0x666666];
    } else {
        // Fallback on earlier versions
    }
    
    tabbar.tintColor = [UIColor colorWithHex:0x666666];
    tabbar.backgroundImage = [UIImage new];
    tabbar.shadowImage = [UIImage new];
    
    return tabbar;
}

- (UITabBarItem *)makeSampleItem {
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:@"试学课程" image:[[UIImage imageNamed:@"课程信息-免费试学"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    return item;
}

- (UITabBarItem *)makeConsultItem {
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:@"咨询课程" image:[[UIImage imageNamed:@"课程信息-课程咨询"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:1];
    return item;
}

#pragma mark - Tab Bar Delegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if(item.tag == 0) {
        [self onClickSample];
        
    }else {
        [self onClickConsult];
    }
}

- (void)onClickSample; {
    if(self.didSelectedBtn) {
        self.didSelectedBtn(BXGCourseInfoBottomTabResponseTypeSample);
    }
    
}
- (void)onClickLearn; {
    if(self.didSelectedBtn) {
        self.didSelectedBtn(BXGCourseInfoBottomTabResponseTypeLearn);
    }
    
}
- (void)onClickOrder; {
    if(self.didSelectedBtn) {
        self.didSelectedBtn(BXGCourseInfoBottomTabResponseTypeOrder);
    }
}
- (void)onClickConsult; {
    if(self.didSelectedBtn) {
        self.didSelectedBtn(BXGCourseInfoBottomTabResponseTypeConsult);
    }
}

@end
