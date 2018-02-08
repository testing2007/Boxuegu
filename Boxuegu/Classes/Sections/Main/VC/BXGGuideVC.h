//
//  BXGGuideVC.h
//  Boxuegu
//
//  Created by apple on 2017/7/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGBaseRootVC.h"
typedef void (^LoadFinishGuideBlock)();

@interface BXGGuideVC : BXGBaseRootVC

@property(nonatomic, copy) LoadFinishGuideBlock finishGuideBlock;

@end
