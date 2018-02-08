//
//  BXGPlayerChangeSizeBtn.h
//  demo-CCMedia
//
//  Created by HM on 2017/6/8.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    BXGPlayerChangeSizeTypeMinimum = 0,
    BXGPlayerChangeSizeTypeMaximum,
} BXGPlayerChangeSizeType;

@interface BXGPlayerChangeSizeBtn : UIButton

@property (nonatomic, assign) BXGPlayerChangeSizeType condition;
@end
