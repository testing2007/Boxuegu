//
//  RWMTVItem.h
//  RWMuiltyTableView-Demo
//
//  Created by HM on 2017/4/21.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWMultiItem : NSObject

@property (nonatomic, weak) id model;
@property (nonatomic, strong) NSMutableArray<RWMultiItem *> *subitems;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, weak) RWMultiItem *superitem;
@property (nonatomic, assign) NSInteger level;
// 存放cell 的种类

#warning 这个方法存在问题
- (BOOL)isEqualToItem:(RWMultiItem *)item;
@end
