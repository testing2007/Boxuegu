//
//  BXGPageControl.m
//  Boxuegu
//
//  Created by apple on 2017/7/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPageControl.h"

@interface BXGPageControl()
{
    UIColor *_activeColor;
    UIColor *_inactiveColor;
}
@end

@implementation BXGPageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)activeColor:(UIColor*)activeColor
{
    _activeColor = activeColor;
}

-(void)inactiveColor:(UIColor*)inactiveColor
{
    _inactiveColor = inactiveColor;
}

-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIView* dot = [self.subviews objectAtIndex:i];
        if(dot.subviews.count==0)
        {
            [dot addSubview:[UIView new]];
        }
        dot.backgroundColor = [UIColor clearColor];
        UIView* dotView = dot.subviews[0];
        dotView.frame = CGRectMake(0, 0, 9, 4);
        dotView.layer.cornerRadius = 2;
        if (i == self.currentPage)
        {
            [dotView setBackgroundColor:_activeColor];
        }
        else
        {
            [dotView setBackgroundColor:_inactiveColor];
        }
    }
}

-(void) setCurrentPage:(NSInteger)page
{
     [super setCurrentPage:page];
     [self updateDots];
}

@end
