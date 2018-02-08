//
//  BXGTabView.h
//  ImageTextLayoutButtonPrj
//
//  Created by apple on 2017/10/17.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXGTabViewItem;

@interface BXGTabView : UIView

- (instancetype)initWithItemViews:(NSArray<BXGTabViewItem*> *)arrItems;
@property(nonatomic, weak, readonly) BXGTabViewItem *prevSelView;


@end
