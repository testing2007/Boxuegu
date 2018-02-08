//
//  RWSlider.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "RWSlider.h"
@interface RWSlider()
@property (nonatomic, assign) BOOL isTouchDown;
//@property (nonatomic, assign) CGFloat lastValue;
@end

@implementation RWSlider

- (void)setHighlighted:(BOOL)highlighted {
    
    __weak typeof (self) weakSelf = self;
    
    
    
    if(self.highlighted != highlighted) {
        
        if(highlighted) {
            
            // touch down
//            weakSelf.lastValue = weakSelf.value;
            
            if(self.touchDownBlock){
                
                self.touchDownBlock(weakSelf,weakSelf.value);
            }
            self.isTouchDown = true;
            
        }else {
        
            self.isTouchDown = false;
            
            // touch up
            if(self.touchUpBlock){
                
                self.touchUpBlock(weakSelf,weakSelf.value);
            }
        }
    }else {
    
        if(self.isTouchDown) {
        
//            if(fabs(fabs(weakSelf.lastValue) - fabs(weakSelf.value)) > 1.0) {
//                if(fabs(weakSelf.lastValue) - fabs(weakSelf.value) > 0) {
//                    weakSelf.value = weakSelf.value + 1.0;
//                }else {
//                    weakSelf.value = weakSelf.value - 1.0;
//                }
//            }
//            weakSelf.lastValue = weakSelf.value;
            // value change
            if(self.valueChangBlock){
                
                self.valueChangBlock(weakSelf,weakSelf.value);
            }
        }
        
    }
    
    [super setHighlighted:highlighted];
}

@end
