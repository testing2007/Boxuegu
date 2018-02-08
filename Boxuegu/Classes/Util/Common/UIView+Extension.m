//
//  UIView+Extension.m
//  Boxuegu
//
//  Created by apple on 17/6/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

-(void)sinkMessageAnimationDuration:(NSTimeInterval)timeDuration delayTimeInterval:(NSTimeInterval)delayTimeInterval
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayTimeInterval*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [UIView beginAnimations:@"sinkMessageAnimation" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        //    [UIView setAnimationDelay:10];
        [UIView setAnimationDuration:timeDuration];
        [self.superview layoutIfNeeded];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(64);
            make.left.offset(0);
            make.right.offset(0);
            make.height.offset(0);
        }];
        [self.superview layoutIfNeeded];
        [UIView commitAnimations];
    });
}

-(UIViewController*)findOwnerVC
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
