//
//  BXGPlayerGradientView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/11/7.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPlayerGradientView.h"

@interface BXGPlayerGradientView()
@property (nonatomic, assign) BXGPlayerGradientViewType type;
@property (nonatomic, strong) CAGradientLayer *graditLayer;
@end

@implementation BXGPlayerGradientView

- (instancetype)initWithType:(BXGPlayerGradientViewType)type {
    self = [super initWithFrame:CGRectZero];
    if(self) {
        _type = type;
        _graditLayer = [CAGradientLayer layer];
        [self.layer addSublayer:_graditLayer];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    switch (_type) {
        case BXGPlayerGradientViewTypeHeader:
            self.graditLayer.colors = @[(__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor];
            break;
        case BXGPlayerGradientViewTypeFooter:
            self.graditLayer.colors = @[(__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor, (__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor];
            break;
    }
    self.graditLayer.locations = @[@(0.1)];
    self.graditLayer.startPoint = CGPointMake(0, 0);
    self.graditLayer.endPoint = CGPointMake(0, 1);
    self.graditLayer.frame = self.bounds;
    
    
    
    
    //    CAGradientLayer *headerViewGradientLayer = [CAGradientLayer layer];
    //    headerViewGradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor];
    //    headerViewGradientLayer.locations = @[@(0.1)];
    //    headerViewGradientLayer.startPoint = CGPointMake(0, 0);
    //    headerViewGradientLayer.endPoint = CGPointMake(0, 1);
    //    headerViewGradientLayer.frame = CGRectMake(0, 0, 2000, 64);
    //    [headerBGView.layer addSublayer:headerViewGradientLayer];
    
    
    
}

@end
