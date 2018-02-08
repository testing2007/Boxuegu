//
//  UIBarButtonItem+Common.h
//  Boxuegu
//
//  Created by apple on 2017/6/26.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Common)

+(UIBarButtonItem*_Nullable)createBarButtonItemWithTitle:(NSString*)titleString
                                      withImage:(UIImage*)image
                                     withTarget:(nullable id)target
                                     withAction:(nullable SEL)sel;

@end
