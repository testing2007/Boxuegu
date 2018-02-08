//
//  BXGLearnedBtn.m
//  demo-CCMedia
//
//  Created by HM on 2017/6/8.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "BXGLearnedBtn.h"
#import "UIColor+Extension.h"

@implementation BXGLearnedBtn

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:CGRectMake(0, 0, 53, 22)];
    if(self) {
    
        [self installUI];
    }
    return self;
}

- (void)setCondition:(BXGLearnedType)condition {

    _condition = condition;
    switch (condition) {
        case BXGLearnedTypeNOLearned: {
        
            [self setTitle:@"未学习" forState:UIControlStateNormal];
            self.backgroundColor = [UIColor colorWithHex:0xFFFFFF alpha:0.3];
            self.layer.borderWidth = 0;
            self.layer.borderColor = [UIColor whiteColor].CGColor;
            self.layer.cornerRadius = 11;
            
        }break;
        
        case BXGLearnedTypeLearned: {
        
            
            [self setTitle:@"已学习" forState:UIControlStateNormal];
            self.backgroundColor = [UIColor clearColor];
            self.layer.borderWidth = 1;
            self.layer.borderColor = [UIColor whiteColor].CGColor;
            self.layer.cornerRadius = 11;
        }break;
        
        default: {
        
        }
            break;
    }
}

- (void)installUI {

    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont bxg_fontRegularWithSize:13];
    
    // 默认值
    self.condition = BXGLearnedTypeNOLearned;
    // self.condition = BXGLearnedTypeLearned;
}

@end
