//
//  TabViewProtocol.h
//  ImageTextLayoutButtonPrj
//
//  Created by apple on 2017/10/17.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BXGTabViewItem;
@protocol BXGTabViewProtocol<NSObject>
//在同一个tab下点击切换
- (void)onSwitchTabViewItem:(BXGTabViewItem*)tabViewItem;
//在不同tab下点击切换
- (void)onSelectChangeBeforeItem:(BXGTabViewItem*)beforeItem andCurItem:(BXGTabViewItem*)curItem;

@end
