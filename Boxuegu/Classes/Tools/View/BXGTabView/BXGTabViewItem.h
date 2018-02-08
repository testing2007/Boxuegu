//
//  BXGTabViewItem.h
//  ImageTextLayoutButtonPrj
//
//  Created by apple on 2017/10/17.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGTabViewProtocol.h"

@interface BXGTabViewItem : UIView

- (instancetype)initWithItemView:(UIView*)itemView
                          andTag:(NSInteger)tag
                       andIsOpen:(BOOL)bOpen
                     andDelegate:(id<BXGTabViewProtocol>)tabViewProtocol;

@property(nonatomic, assign, readwrite) BOOL bOpen;

- (void)onSwitchTabViewItem;
- (void)onSelectChangeBeforeItem:(BXGTabViewItem*)beforeItem;

@end
