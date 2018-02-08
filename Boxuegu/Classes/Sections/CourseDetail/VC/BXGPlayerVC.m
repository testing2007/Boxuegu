//
//  BXGPlayerVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/30.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPlayerVC.h"
#import "BXGPlayerView.h"
@interface BXGPlayerVC ()

@end

@implementation BXGPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor randomColor];
    BXGPlayerView *playerView = [BXGPlayerView new];
//    _playerView = playerView;
    [self.view addSubview:playerView];
    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.right.offset(0);
        make.height.offset( [UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].bounds.size.width);
    }];
}

@end
