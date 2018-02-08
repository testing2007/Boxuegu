//
//  BXGRefreshTool.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/11/8.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableView(BXGRefreshTool)
- (void)bxg_setHeaderRefreshBlock:(void(^)())headerRefreshBlock;
- (void)bxg_removeHeaderRefresh;
- (void)bxg_beginHeaderRefresh;
- (void)bxg_endHeaderRefresh;

- (void)bxg_setFootterRefreshBlock:(void(^)())footterRefreshBlock;
- (void)bxg_removeFootterRefresh;
- (void)bxg_beginFootterRefresh;
- (void)bxg_endFootterRefresh;
- (void)bxg_endFootterRefreshNoMoreData;
@end

@interface UICollectionView(BXGRefreshTool)

- (void)bxg_setHeaderRefreshBlock:(void(^)())headerRefreshBlock;
- (void)bxg_removeHeaderRefresh;
- (void)bxg_beginHeaderRefresh;
- (void)bxg_endHeaderRefresh;

- (void)bxg_setFootterRefreshBlock:(void(^)())footterRefreshBlock;
- (void)bxg_removeFootterRefresh;
- (void)bxg_beginFootterRefresh;
- (void)bxg_endFootterRefresh;
- (void)bxg_endFootterRefreshNoMoreData;
@end
