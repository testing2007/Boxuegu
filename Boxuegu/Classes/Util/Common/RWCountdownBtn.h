//
//  RWCountdownBtn.h
//  Boxuegu
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWCountdownBtn : UIButton

- (instancetype)initWithTitle:(NSString*)title andTimeInterval:(NSInteger)timeInterval;
- (void)timeEnable:(BOOL)bEnable;

@end
