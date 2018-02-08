//
//  RWFrameImageView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/14.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "RWFrameImageView.h"

@implementation RWFrameImageView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
    
        [self installUI];
    }
    return self;
}

- (void)awakeFromNib {

    [super awakeFromNib];
    
    [self installUI];
}

- (void)installUI {
    
    CGFloat marginLeft = 0;
    CGFloat marginRight = 0;
    CGFloat marginTop = 0;
//    CGFloat marginBottom = 0;
//    CGFloat marginVertical = 0;
    CGFloat marginHorizental = 0;
    CGFloat superWidth = [UIScreen mainScreen].bounds.size.width;
//    CGFloat superHeight = [UIScreen mainScreen].bounds.size.height;

    
    NSInteger imagesCount = 4;
    
    if(imagesCount <= 0) {
        
        return;
    }
    [UIDevice currentDevice];
    
    if(imagesCount == 1 || imagesCount == 2 || imagesCount == 4) {
        
        // count 1 / 2 / 4
        CGFloat unitWidth = (superWidth - marginLeft - marginRight - marginHorizental) / 2.0;
        CGFloat unitHeight = unitWidth;
        
        UIView *lastView;
        for(NSInteger i = 0; i < imagesCount; i++) {
        
            UIView *view = [UIView new];
            [self addSubview:view];
            
            if(i / 2) {
            
            }
            
            if(i )
            
            if(lastView == nil) {
            
                lastView = view;
                view.frame = CGRectMake(marginLeft, marginTop, unitWidth, unitHeight);
            }
        
        }
        
        return;
    }
}

@end
