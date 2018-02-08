//
//  ImageScrollView.m
//  Boxuegu
//
//  Created by apple on 2017/8/29.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "ImageScrollView.h"
#import "UIView+Frame.h"
#import "UIView+Extension.h"

@interface ImageScrollView()
@end

@implementation ImageScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.alwaysBounceHorizontal = YES;
        self.alwaysBounceVertical = NO;
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

-(void)addImageView:(UIImageView *)imageView
{
    CGFloat viewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat originX = viewW * self.subviews.count;
    imageView.frame = CGRectMake(originX,
                                 (self.frame.size.height-viewW)/2.0,
                                 viewW,
                                 viewW);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    [self setContentSize:CGSizeMake(originX+viewW, [UIScreen mainScreen].bounds.size.height)];
}

-(void)setCurrentIndex:(NSInteger)currentIndex
{
    CGFloat viewW = [UIScreen mainScreen].bounds.size.width;
    [self setContentOffset:CGPointMake(currentIndex*viewW, 0)];
}

-(void)dealloc
{
    NSLog(@"image scroll view dealloc");
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIViewController *vc = [self findOwnerVC];
    if(vc)
    {
        if(_exitCallback)
        {
            _exitCallback();
        }
        [vc dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
