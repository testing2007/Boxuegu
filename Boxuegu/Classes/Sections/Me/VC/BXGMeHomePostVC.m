//
//  BXGMeHomePostVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/13.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMeHomePostVC.h"
#import "BXGCommunityAttentionVC.h"

@interface BXGMeHomePostVC ()

@end

@implementation BXGMeHomePostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的帖子";
    BXGCommunityAttentionVC *vc = [[BXGCommunityAttentionVC alloc]initWithType:ShowTypeHome];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.right.bottom.offset(0);
    }];
    
}


@end
