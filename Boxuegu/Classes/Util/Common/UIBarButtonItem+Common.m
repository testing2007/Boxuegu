//
//  UIBarButtonItem+Common.m
//  Boxuegu
//
//  Created by apple on 2017/6/26.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "UIBarButtonItem+Common.h"

@implementation UIBarButtonItem (Common)

+(UIBarButtonItem*)createBarButtonItemWithTitle:(NSString*)titleString
                                      withImage:(UIImage*)image
                                     withTarget:(nullable id)target
                                     withAction:(nullable SEL)sel
{
    NSAssert(titleString!=nil || image!=nil, @"Both titleString and image couldn't nil at the same time");
    UIBarButtonItem *item;
    if(titleString!=nil)
    {
        item = [[UIBarButtonItem alloc] initWithTitle:titleString
                                                style:UIBarButtonItemStylePlain
                                               target:target
                                               action:sel];
        [item setTintColor:[UIColor whiteColor]];
        [item setTitleTextAttributes:@{NSFontAttributeName: [UIFont bxg_fontRegularWithSize:15]
                                       } forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSFontAttributeName: [UIFont bxg_fontRegularWithSize:15]
                                       } forState:UIControlStateHighlighted];
    }
    else
    {
        item = [[UIBarButtonItem alloc] initWithImage:image
                                                style:UIBarButtonItemStylePlain
                                               target:target
                                               action:sel];
    }
    return item;
}

@end
