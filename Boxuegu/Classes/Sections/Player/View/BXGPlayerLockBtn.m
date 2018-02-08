//
//  BXGPlayerLockBtn.m
//  demo-CCMedia
//
//  Created by HM on 2017/6/8.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "BXGPlayerLockBtn.h"

@implementation BXGPlayerLockBtn

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        [self installUI];
    }
    return self;
}

- (void)setCondition:(BXGPlayerLockBtnType)condition {
    
    _condition = condition;
    switch (condition) {
        case BXGPlayerLockBtnTypeNoLocked: {
            
            [self setImage:[UIImage imageNamed:@"播放器-未锁屏"] forState:UIControlStateNormal];
            
        }break;
            
        case BXGPlayerLockBtnTypeLocked: {
            
            [self setImage:[UIImage imageNamed:@"播放器-锁屏"] forState:UIControlStateNormal];
            
        }break;
            
        default: {
            
        }
            break;
    }
}

- (void)installUI {
    
    // 默认值
    self.condition = BXGPlayerLockBtnTypeNoLocked;
    // self.condition = BXGLearnedTypeLearned;
}
@end
