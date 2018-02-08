//
//  BXGLearnedBtn.h
//  demo-CCMedia
//
//  Created by HM on 2017/6/8.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    BXGLearnedTypeNOLearned = 0,
    BXGLearnedTypeLearned,
} BXGLearnedType;

@interface BXGLearnedBtn : UIButton

@property (nonatomic, assign) BXGLearnedType condition;
@end
