//
//  BXGPlayerChangeSizeBtn.m
//  demo-CCMedia
//
//  Created by HM on 2017/6/8.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "BXGPlayerChangeSizeBtn.h"

@implementation BXGPlayerChangeSizeBtn

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        [self installUI];
    }
    return self;
}

- (void)setCondition:(BXGPlayerChangeSizeType)condition {
    
    _condition = condition;
    switch (condition) {
        case BXGPlayerChangeSizeTypeMinimum: {
            
            [self setImage:[UIImage imageNamed:@"播放器-全屏"] forState:UIControlStateNormal];
            
        }break;
            
        case BXGPlayerChangeSizeTypeMaximum: {
            
            [self setImage:[UIImage imageNamed:@"播放器-收起全屏"] forState:UIControlStateNormal];
        
        }break;
            
        default: {
            
        }
            break;
    }
}

- (void)installUI {
    
    // 默认值
    self.condition = BXGPlayerChangeSizeTypeMinimum;
    // self.condition = BXGLearnedTypeLearned;
}
@end
