//
//  BXGPlayerBigPlayBtn.m
//  demo-CCMedia
//
//  Created by HM on 2017/6/8.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "BXGPlayerBigPlayBtn.h"

@implementation BXGPlayerBigPlayBtn

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        [self installUI];
    }
    return self;
}

- (void)setCondition:(BXGPlayerBigPlayBtnType)condition {
    
    _condition = condition;
    switch (condition) {
        case BXGPlayerBigPlayBtnTypeStop: {
            
            [self setImage:[UIImage imageNamed:@"播放器-播放-大"] forState:UIControlStateNormal];
            
        }break;
            
        case BXGPlayerBigPlayBtnTypePlaying: {
            
            [self setImage:[UIImage imageNamed:@"播放器-暂停-大"] forState:UIControlStateNormal];
            
        }break;
            
        default: {
            
        }
            break;
    }
}

- (void)installUI {
    
    // 默认值
    self.condition = BXGPlayerBigPlayBtnTypeStop;
    // self.condition = BXGLearnedTypeLearned;
}


@end
