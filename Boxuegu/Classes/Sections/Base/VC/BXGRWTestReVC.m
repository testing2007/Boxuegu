//
//  BXGRWTestReVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/11/11.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGRWTestReVC.h"
#import "BXGOrderPayResultVC.h"

@interface BXGRWTestReVC ()

@end

@implementation BXGRWTestReVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btn01:(id)sender {
    // 学习中心
    [self.mainViewController pushToStudyRootVC];

}
- (IBAction)btn02:(id)sender {
    // 我的订单
//    [self.mainViewController pushToMeOrderVC];
}
- (IBAction)btn03:(id)sender {
    [self.navigationController pushViewController:[BXGOrderPayResultVC new] animated:true];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
