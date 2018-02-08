//
//  BXGChoiceTagBtn.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGChoiceTagBtn.h"

@implementation BXGChoiceTagBtn

- (void)setIsSelected:(BOOL)isSelected {

    _isSelected = isSelected;
    if(isSelected){
    
        [self setTitleColor:[UIColor colorWithHex:0x38ADFF] forState:UIControlStateNormal];
        self.layer.borderColor = [UIColor colorWithHex:0x38ADFF].CGColor;

    }else {
        [self setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
        self.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
    }
    
}

- (void)setModel:(NSString *)model {

    if(model){
    
        [self setTitle:model forState:UIControlStateNormal];
    }else {
    
        [self setTitle:@"" forState:UIControlStateNormal];
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
    
        [self installUI];
    }
    return self;
}

- (void)installUI {

    
    
    
    self.titleLabel.adjustsFontSizeToFitWidth = true;
    self.titleLabel.minimumScaleFactor = 0.5;
    self.titleLabel.font = [UIFont bxg_fontRegularWithSize:15];
    
    // [btn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    // [btn setTitle:self.modelArray[i] forState:UIControlStateNormal];

    self.isSelected = false;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 3;
}
@end
