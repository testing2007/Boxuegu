//
//  BXGRefreshTool.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/11/8.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGRefreshTool.h"
#import "MJRefresh.h"

@implementation UITableView(BXGRefreshTool)
- (void)bxg_setHeaderRefreshBlock:(void(^)())headerRefreshBlock; {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:headerRefreshBlock];
    header.stateLabel.font = [UIFont bxg_fontRegularWithSize:12];
    header.stateLabel.textColor = [UIColor colorWithHex:666666];
    header.lastUpdatedTimeLabel.font = [UIFont bxg_fontRegularWithSize:12];
    header.lastUpdatedTimeLabel.textColor = [UIColor colorWithHex:666666];
    self.mj_header = header;
}
- (void)bxg_removeHeaderRefresh {
    self.mj_header = nil;
}
- (void)bxg_beginHeaderRefresh {
    [self.mj_header beginRefreshing];
}
- (void)bxg_endHeaderRefresh {
    [self.mj_header endRefreshing];
}

- (void)bxg_setFootterRefreshBlock:(void(^)())footterRefreshBlock {
    MJRefreshAutoNormalFooter *footter =  [MJRefreshAutoNormalFooter footerWithRefreshingBlock:footterRefreshBlock];
    footter.stateLabel.font = [UIFont bxg_fontRegularWithSize:12];
    footter.stateLabel.textColor = [UIColor colorWithHex:666666];
    self.mj_footer = footter;
}
- (void)bxg_removeFootterRefresh {
    self.mj_footer = nil;
}
- (void)bxg_beginFootterRefresh {
    [self.mj_footer beginRefreshing];
}
- (void)bxg_endFootterRefresh {
    [self.mj_footer endRefreshing];
}
- (void)bxg_endFootterRefreshNoMoreData {
    [self.mj_footer endRefreshingWithNoMoreData];
}
@end

@implementation UICollectionView(BXGRefreshTool)
- (void)bxg_setHeaderRefreshBlock:(void(^)())headerRefreshBlock; {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:headerRefreshBlock];
    header.stateLabel.font = [UIFont bxg_fontRegularWithSize:12];
    header.stateLabel.textColor = [UIColor colorWithHex:666666];
    header.lastUpdatedTimeLabel.font = [UIFont bxg_fontRegularWithSize:12];
    header.lastUpdatedTimeLabel.textColor = [UIColor colorWithHex:666666];
    self.mj_header = header;
}
- (void)bxg_removeHeaderRefresh {
    self.mj_header = nil;
}
- (void)bxg_beginHeaderRefresh {
    [self.mj_header beginRefreshing];
}
- (void)bxg_endHeaderRefresh {
    [self.mj_header endRefreshing];
}
- (void)bxg_setFootterRefreshBlock:(void(^)())footterRefreshBlock {
    MJRefreshAutoNormalFooter *footter =  [MJRefreshAutoNormalFooter footerWithRefreshingBlock:footterRefreshBlock];
    footter.stateLabel.font = [UIFont bxg_fontRegularWithSize:12];
    footter.stateLabel.textColor = [UIColor colorWithHex:666666];
    self.mj_footer = footter;
}
- (void)bxg_removeFootterRefresh {
    self.mj_footer = nil;
}
- (void)bxg_beginFootterRefresh {
    [self.mj_footer beginRefreshing];
}
- (void)bxg_endFootterRefresh {
    [self.mj_footer endRefreshing];
}
- (void)bxg_endFootterRefreshNoMoreData {
    [self.mj_footer endRefreshingWithNoMoreData];
}
@end

