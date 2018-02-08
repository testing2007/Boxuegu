//
//  BXGPlayerLockBtn.h
//  demo-CCMedia
//
//  Created by HM on 2017/6/8.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    BXGPlayerLockBtnTypeNoLocked = 0,
    BXGPlayerLockBtnTypeLocked,
} BXGPlayerLockBtnType;

@interface BXGPlayerLockBtn : UIButton


@property (nonatomic, assign) BXGPlayerLockBtnType condition;

@end
