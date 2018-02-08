//
//  BXGPlayerBigPlayBtn.h
//  demo-CCMedia
//
//  Created by HM on 2017/6/8.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    
    BXGPlayerBigPlayBtnTypeStop = 0,
    BXGPlayerBigPlayBtnTypePlaying,
} BXGPlayerBigPlayBtnType;

@interface BXGPlayerBigPlayBtn : UIButton

@property (nonatomic, assign) BXGPlayerBigPlayBtnType condition;
@end
