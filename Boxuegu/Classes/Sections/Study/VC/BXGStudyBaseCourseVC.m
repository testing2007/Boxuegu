//
//  BXGStudyCourceBaseController.m
//  Boxuegu
//
//  Created by HM on 2017/4/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGStudyBaseCourseVC.h"
#import "BXGAlertController.h"

@interface BXGStudyBaseCourseVC ()


@end

@implementation BXGStudyBaseCourseVC

- (UIView *)loadingMaskView {
    
    if(!_loadingMaskView) {
        
        _loadingMaskView = [UIView new];
        _loadingMaskView.backgroundColor = [UIColor whiteColor];
        
        UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_loadingMaskView addSubview:aiView];
        //        [aiView mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        //            make.centerX.offset(0);
        //            make.centerY.offset(0);
        //        }];
        self.aiView = aiView;
    }
    return _loadingMaskView;
    
}
- (void)installNoCourseMaskView:(NSString *)courseDesString;{

    [self.maskForNoCourseView removeFromSuperview];
    UITableView *maskView = [UITableView new];
    maskView.separatorStyle = UITableViewCellSeparatorStyleNone;
    maskView.backgroundColor = [UIColor whiteColor];
    self.maskForNoCourseView = maskView;
    self.maskView = maskView;
    [self.view addSubview:maskView];
    
    UILabel *label = [UILabel new];
    [maskView addSubview:label];
    //label.text = @"您还没有的“职业课程学习计划”\n马上去官网选择！";
    //
    // label.text = [NSString stringWithFormat:@"您还没有课程\n高新程序员之路,从这里开始!",courseDesString];
    label.text = [NSString stringWithFormat:@"您还没有课程，马上开启高薪之路!"];
    // 职业课程学习计划
    
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont bxg_fontRegularWithSize:15];
    label.textColor = [UIColor colorWithHex:0x333333];
    [label sizeToFit];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];

    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"没有课程"]];
    [maskView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.equalTo(label.mas_top).offset(8);
    }];
    
    
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    
    // 添加下拉刷新
//    maskView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updateData)];
    Weak(weakSelf);
    [maskView bxg_setHeaderRefreshBlock:^{
        [weakSelf updateData];
    }];
    
}

- (void)clickMaskForNoCourseView:(UITapGestureRecognizer *)tap{

    BXGAlertController *alertVc = [BXGAlertController confirmWithTitle:@"是否要前往官方查看更多课程?" message:nil handler:^{
        NSURL *url = [[NSURL alloc]initWithString:@"https://www.boxuegu.com"];
        [[UIApplication sharedApplication] openURL:url];
    }];
    
    [self presentViewController:alertVc animated:true completion:nil];
}

- (void)updateData{

}
- (void)loadData {

}

- (void)installLoadFailedMaskView{
    
    [self.maskloadFailedView removeFromSuperview];
    UITableView *maskView = [UITableView new];
    maskView.backgroundColor = [UIColor whiteColor];
    maskView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.maskloadFailedView = maskView;
    // self.maskView = maskView;
    [self.view addSubview:maskView];
    UILabel *label = [UILabel new];
    [maskView addSubview:label];
    // 添加下拉刷新
//    maskView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updateData)];
    Weak(weakSelf);
    [maskView bxg_setHeaderRefreshBlock:^{
        [weakSelf updateData];
    }];
    //label.text = @"您还没有的“职业课程学习计划”\n马上去官网选择！";
    label.text = @"加载失败，请点击刷新重试 ~";
    // 职业课程学习计划
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont bxg_fontRegularWithSize:15];
    label.textColor = [UIColor colorWithHex:0x333333];
    [label sizeToFit];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"加载失败"]];
    [maskView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.equalTo(label.mas_top).offset(8);
    }];
    
    
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];

}

-(void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.loadingMaskView.frame = self.view.bounds;
    
    self.aiView.center = CGPointMake(self.loadingMaskView.frame.size.width / 2.0, self.loadingMaskView.frame.size.height / 2.0);
    
}



@end
