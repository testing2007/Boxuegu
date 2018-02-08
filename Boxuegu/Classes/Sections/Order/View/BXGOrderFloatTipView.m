//
//  BXGOrderFloatTipView.m
//  Boxuegu
//
//  Created by apple on 2017/11/2.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderFloatTipView.h"

@implementation BXGOrderFloatTipView

- (void)loadContent:(id)info {
    [super loadContent:info];
    [self launchCloseFloatTipViewTimer];
    
    if(info) {
        NSAssert([info isKindOfClass:[NSString class]], @"the info type is not match");
        self.recentLabel.text = info;
        self.markLabel.hidden = false;
        self.recentLabel.hidden = false;
        self.startMarkLabel.hidden = true;
        
    } else {
        
        self.recentLabel.text = @"";
        self.markLabel.hidden = true;
        self.recentLabel.hidden = true;
        self.startMarkLabel.hidden = false;
        
    }
}

@end
