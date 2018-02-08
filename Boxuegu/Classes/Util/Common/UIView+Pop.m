//
//  UIView+Pop.m
//  Boxuegu
//
//  Created by apple on 2017/10/30.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "UIView+Pop.h"
#import <objc/runtime.h>
#define TagValue  3333
#define ALPHA  0.2 //背景


@implementation UIView (Pop)
static CGFloat  bgAlpha;

- (void)showInWindowAndBgAlpha:(CGFloat)alpha
                andCancelBlock:(CancelBlockType)cancelBlock
         andMaskViewConstraint:(void (^)(MASConstraintMaker *make))constraint {
    if (self.superview) {
        [self removeFromSuperview];
    }
    bgAlpha = alpha;
    [self addViewInWindow:constraint];
    self.cancelBlock = cancelBlock;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

-(void)setCancelBlock:(CancelBlockType)cancelBlock {
    objc_setAssociatedObject(self, @selector(cancelBlock), cancelBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(CancelBlockType)cancelBlock
{
    return objc_getAssociatedObject(self,@selector(cancelBlock));
}

-(void)hideView{
    if (self.superview) {
        UIView *bgvi = [[UIApplication sharedApplication].keyWindow viewWithTag:TagValue];
        if (bgvi) {
            [bgvi removeFromSuperview];
        }
        [self removeFromSuperview];
    }
}

/**
 加入背景view
 */
-(void)addViewInWindow:(void (^)(MASConstraintMaker *make))constraint {
    UIView *oldView = [[UIApplication sharedApplication].keyWindow viewWithTag:TagValue];
    if (oldView) {
        [oldView removeFromSuperview];
    }
    UIView *v = nil;
    if(!constraint) {
        v = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        [[UIApplication sharedApplication].keyWindow addSubview:v];
    } else {
        v = [UIView new];
        [[UIApplication sharedApplication].keyWindow addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            constraint(make);
        }];
    }
    v.tag = TagValue;
    [self addGuesture:v];
    v.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:bgAlpha == -1 ? ALPHA : bgAlpha];
}
//添加背景view手势
-(void)addGuesture:(UIView *)vi{
    vi.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView)];
    [vi addGestureRecognizer:tap];
}

-(void)tapBgView{
    [self hideView];
    if(self.cancelBlock) {
        self.cancelBlock();
    }
}

@end
