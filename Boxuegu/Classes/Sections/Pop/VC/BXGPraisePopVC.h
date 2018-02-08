//
//  BXGPraisePopVC.h
//  Boxuegu
//
//  Created by HM on 2017/5/8.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGPraisePopVC : UIViewController

-(instancetype)initWithCommenBlock:( void (^)() )commentBlock
                 withFeedbackBlock:( void (^)() )feedbackBlock
                   withCancelBlock:( void (^)() )cancelBlock;

@end
