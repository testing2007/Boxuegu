//
//  BXGPlayerPlaybtn.h
//  demo-CCMedia
//
//  Created by HM on 2017/6/8.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    BXGPlayerPlayBtnTypeStop = 0,
    BXGPlayerPlayBtnTypePlaying,
} BXGPlayerPlayBtnType;

@interface BXGPlayerPlayBtn : UIButton
@property (nonatomic, assign) BXGPlayerPlayBtnType condition;
@end
