//
//  StateImageVeiw.m
//  PraiseCtrlPrj
//
//  Created by apple on 2017/8/30.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "StateImageView.h"
#import <UIKit/UITapGestureRecognizer.h>

@interface StateImageView()
@property(nonatomic, assign) BOOL bAnimal;
@property(nonatomic, assign) BOOL bActive;
@property(nonatomic, strong) UIImage *inactiveImage;
@property(nonatomic, strong) UIImage *activeImage;
@property(nonatomic, copy) void (^activeBlock)(void) ;
@property(nonatomic, copy) void (^inactiveBlock)(void) ;
@end

@implementation StateImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithInactiveImage:(UIImage*)inactiveImage
                     withActiveImage:(UIImage*)activeImage
                            isActive:(BOOL)bActive
                            isAnimal:(BOOL)bAnimal
                         activeBlock:(void(^)(void))activeBlock
                       inactiveBlock:(void(^)(void))inactiveBlock;
{
    self = [super init];//WithImage:image highlightedImage:highlightedImage];
    if(self)
    {
        _inactiveImage = inactiveImage;
        _activeImage = activeImage;
        
        _bAnimal = bAnimal;
        _bActive = bActive;
        
        [self setImageByActiveState:_bActive];
//        self.layer.borderColor = [UIColor redColor].CGColor;
//        self.layer.borderWidth = 1;
        
        UITapGestureRecognizer *tap =  [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(tapImageView:)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
        
        _activeBlock = activeBlock;
        _inactiveBlock = inactiveBlock;
    }
    return self;
}

-(void)setImageByActiveState:(BOOL)bActive
{
    self.image = bActive ? _activeImage : _inactiveImage;
}

-(void)tapImageView:(UITapGestureRecognizer*)tap
{
    if(self.bActive)
    {
        [UIView animateWithDuration:1 animations:^{
            self.transform = CGAffineTransformScale(self.transform, 0.5, 0.5);
        } completion:^(BOOL finished) {
            self.transform = CGAffineTransformIdentity;
        }];
        _inactiveBlock();
    }
    else
    {
        [UIView animateWithDuration:1 animations:^{
            self.transform = CGAffineTransformScale(self.transform, 2.0, 2.0);
        }completion:^(BOOL finished) {
            self.transform = CGAffineTransformIdentity;
        }];
        _activeBlock();
    }
    self.bActive = !self.bActive;
    [self setImageByActiveState:self.bActive];
}

//- (BOOL)isActive
//{
//    return self.highlighted;
//}
//
//- (void)setIsActive:(BOOL)isActive {
//
//    self.highlighted = isActive;
//}

@end
