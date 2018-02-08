//
//  BXGTabView.m
//  ImageTextLayoutButtonPrj
//
//  Created by apple on 2017/10/17.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "BXGTabView.h"
#import "BXGTabViewItem.h"

@interface BXGTabView()
@property(nonatomic, weak, readwrite) BXGTabViewItem *prevSelView;
@end

@implementation BXGTabView

- (instancetype)initWithItemViews:(NSArray<BXGTabViewItem*> *)arrItemViews {
    
    self = [super init];
    if(self) {        
        UIView *preView = nil;
        for(int i=0; i<arrItemViews.count; ++i) {
            UIView *itemView = arrItemViews[i];
            [self addSubview:itemView];
            
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
            itemView.tag = i;
            [itemView addGestureRecognizer:tapRecognizer];
            
            if(!preView) {
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.offset(0);
                    make.width.equalTo(self.mas_width).dividedBy(arrItemViews.count);
                    make.height.equalTo(self);
                }];
            } else {
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.offset(0);
                    make.left.equalTo(preView.mas_right).offset(0);
                    make.width.equalTo(self.mas_width).dividedBy(arrItemViews.count);
                    make.height.equalTo(self);
                }];
            }
            preView = itemView;
        }
    }
    return self;
}

- (void)onTapGesture:(UITapGestureRecognizer*)tapGesture {
    BXGTabViewItem *itemView = (BXGTabViewItem*)tapGesture.view;
    if(_prevSelView!=itemView) {
        
        if(_prevSelView) {
            [itemView onSelectChangeBeforeItem:_prevSelView];
        } else {
            [itemView onSwitchTabViewItem];
        }
        
    } else {
        [itemView onSwitchTabViewItem];
    }
    
    _prevSelView = itemView;
}


@end
