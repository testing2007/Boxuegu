//
//  RWDynamicLabel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "RWDynamicLabel.h"
@interface RWDynamicLabel()
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation RWDynamicLabel

- (UILabel *)contentLabel {

    if(!_contentLabel) {
    
        _contentLabel = [UILabel new];
    }
    return _contentLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
        
        [self installUI];
    }
    return self;
}

- (void)installUI {

    [self addSubview:self.contentLabel];
    self.contentLabel.text = @"12345678901234567890123456677901231203-123012-3-210312-0312-301-203-1-302-3";
    [self.contentLabel sizeToFit];
    self.layer.masksToBounds = true;
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(0);
    }];
}

- (void)setText:(NSString *)text {

    _text = text;
    self.contentLabel.text = text;
}
- (void)layoutSubviews {

    [super layoutSubviews];
    
    self.contentLabel.hidden = true;
    self.contentLabel.transform = CGAffineTransformIdentity;
    [self startAnimation];
}

- (void)startAnimation {

    self.contentLabel.hidden = false;
    if(self.bounds.size.width >= self.contentLabel.bounds.size.width) {
    
        self.contentLabel.transform = CGAffineTransformIdentity;
        return;
    }
    NSInteger timeInterval = self.contentLabel.frame.size.width / 25;
    
    self.contentLabel.transform = CGAffineTransformIdentity;
    
    
    [UIView animateWithDuration:timeInterval delay:2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.contentLabel.transform = CGAffineTransformMakeTranslation(-self.contentLabel.frame.size.width - 10, 0);
    } completion:^(BOOL finished) {
        [self startAnimation];
    }];
    
}

@end
