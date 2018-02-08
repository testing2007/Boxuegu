//
//  BXGRoundedBtn.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/30.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGRoundedBtn.h"
#import "UIColor+Extension.h"

@interface BXGRoundedBtn()
@property (nonatomic, strong) UIColor *roundedBackgroundColor;
@end


@implementation BXGRoundedBtn

- (void)drawRect:(CGRect)rect {

    CGFloat radius = self.frame.size.height / 2;
    
    // draw back ground
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI_2 endAngle:1.5 * M_PI clockwise:true];

    [path addArcWithCenter:CGPointMake(self.frame.size.width - radius, radius) radius:radius startAngle:1.5 * M_PI endAngle:M_PI_2 clockwise:true];
    [self.roundedBackgroundColor set];
    
    [path fill];
}

- (UIColor *)roundedBackgroundColor {

    if(!_roundedBackgroundColor){
    
        _roundedBackgroundColor = [UIColor colorWithHex:0xFF38ADFF];
    }
    return _roundedBackgroundColor;
}

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
    
        [self installUI];
    }
    return self;
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType withTitle:(NSString *)title{

    BXGRoundedBtn *instance = [super buttonWithType:buttonType];
    [instance setTitle:title forState:UIControlStateNormal];
    return instance;
}

- (void)installUI {
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];

    if(enabled == true) {
    
        self.roundedBackgroundColor = [UIColor colorWithHex:0xFF38ADFF];
        
    }else {
    
        self.roundedBackgroundColor = [UIColor colorWithHex:0xCCCCCC];
        
    }

}

@end
