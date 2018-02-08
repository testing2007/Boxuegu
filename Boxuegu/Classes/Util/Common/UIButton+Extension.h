//
//  UIButton+Extension.h
//  Boxuegu
//
//  Created by HM on 2017/5/16.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

-(void)animationImage:(UIImage*)image bZoomIn:(BOOL)bZoomIn andCompletionBlock:(void (^)())completionBlock;

@end
