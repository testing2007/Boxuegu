//
//  BXGPlayerPlaybtn.m
//  demo-CCMedia
//
//  Created by HM on 2017/6/8.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "BXGPlayerPlayBtn.h"

@implementation BXGPlayerPlayBtn

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        [self installUI];
    }
    return self;
}

- (void)setCondition:(BXGPlayerPlayBtnType)condition {
    
    _condition = condition;
    switch (condition) {
        case BXGPlayerPlayBtnTypeStop: {
            
            [self setImage:[UIImage imageNamed:@"播放器-播放"] forState:UIControlStateNormal];
            
        }break;
            
        case BXGPlayerPlayBtnTypePlaying: {
            
            [self setImage:[UIImage imageNamed:@"播放器-暂停"] forState:UIControlStateNormal];
            
        }break;
            
        default: {
            
        }
            break;
    }
}

- (void)installUI {
    
    // 默认值
    self.condition = BXGPlayerPlayBtnTypeStop;
    // self.condition = BXGLearnedTypeLearned;
}


@end
