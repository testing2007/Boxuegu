//
//  UIView+SuperVC.m
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/18.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "UIView+SuperVC.h"

@implementation UIView (SuperVC)

- (UIViewController *)superViewController
{
    for(UIView* next=self.superview; next; next=next.superview)
    {
        UIResponder *nextResponse = next.nextResponder;
        if([nextResponse isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponse;
        }
    }
    return nil;
}
@end
