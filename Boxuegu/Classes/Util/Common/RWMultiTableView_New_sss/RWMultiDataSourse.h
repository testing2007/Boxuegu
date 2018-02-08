//
//  RWMTVDataSource.h
//  RWMuiltyTableView-Demo
//
//  Created by HM on 2017/4/21.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWMultiItem.h"

@interface RWMultiDataSourse : RWMultiItem

@property (nonatomic, strong) NSMutableArray<RWMultiItem *> *currentItems;

- (RWMultiItem *)itemforIndexPath:(NSUInteger)indexPath;
- (NSUInteger)indexPathForItem:(RWMultiItem *)item;
- (NSInteger)tagForIndexPath:(NSUInteger)indexPath;
- (NSInteger)levelForIndexPath:(NSUInteger)indexPath;

- (void)removeAll;
- (void)installRoot;
- (void)installAll;
- (void)close:(NSUInteger)indexPath;
- (void)openRecursiveForIndexPath:(NSUInteger)indexPath;
- (void)openRecursiveForItem:(RWMultiItem *)item;
- (void)openForIndexPath:(NSUInteger)indexPath;
- (void)openForItem:(RWMultiItem *)item;
- (void)installSubItemChild;
@end
