//
//  BXGTabViewItem.m
//  ImageTextLayoutButtonPrj
//
//  Created by apple on 2017/10/17.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "BXGTabViewItem.h"

@interface BXGTabViewItem()
@property(nonatomic, assign) NSInteger tagIndex;
@property(nonatomic, weak) id<BXGTabViewProtocol> delegate;
@end

@implementation BXGTabViewItem

- (instancetype)initWithItemView:(UIView*)itemView
                          andTag:(NSInteger)tag
                       andIsOpen:(BOOL)bOpen
                     andDelegate:(id<BXGTabViewProtocol>)tabViewProtocol {
    self = [super init];
    if (self) {
        _tagIndex = tag;
        _bOpen = bOpen;
        _delegate = tabViewProtocol;
        [self addSubview:itemView];
    }
    return self;
}

- (void)onSwitchTabViewItem {
    if(_delegate && [_delegate respondsToSelector:@selector(onSwitchTabViewItem:)]) {
        self.bOpen = !self.bOpen;
        [_delegate onSwitchTabViewItem:self];
    }
}

- (void)onSelectChangeBeforeItem:(BXGTabViewItem*)beforeItem {
    if(_delegate && [_delegate respondsToSelector:@selector(onSelectChangeBeforeItem:andCurItem:)]) {
        self.bOpen = YES;
        [_delegate onSelectChangeBeforeItem:beforeItem andCurItem:self];
    }
}

@end
