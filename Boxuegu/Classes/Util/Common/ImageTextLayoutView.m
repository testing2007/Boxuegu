//
//  ImageTextLayoutView.m
//  ImageTextLayoutButtonPrj
//
//  Created by apple on 2017/10/16.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "ImageTextLayoutView.h"

@interface ImageTextLayoutView()
@property(nonatomic, weak) UIImageView *imageView;
@property(nonatomic, weak) UILabel *lableView;
@end

@implementation ImageTextLayoutView

- (instancetype)initImage:(UIImage*)image
               andLabel:(UILabel*)label
     andImageTextLayout:(ImageTextLayout)layout
            andTapBlock:(TapBlock)tapBlock {
    self = [super init];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        _imageView = imageView;
        if(!label) {
            UILabel *labelView = [UILabel new];
            _lableView = labelView;
        } else {
            _lableView = label;
        }
        [self addSubview:_imageView];
        [self addSubview:_lableView];
        
        _layout = layout;
        _tapBlock = tapBlock;
        
        _midSpace = 8;

        self.layer.borderColor = [UIColor blueColor].CGColor;
        self.layer.borderWidth = 0;
        
        if(tapBlock) {
            UITapGestureRecognizer *tapRecognizer = [UITapGestureRecognizer new];
            [tapRecognizer addTarget:self action:@selector(tapGesture:)];
            [self addGestureRecognizer:tapRecognizer];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_lableView sizeToFit];
    switch (_layout) {
        case ImageTextLayout_Left_Right:
            [self layoutLeftView:self.imageView andRightView:self.lableView];
            break;
        case ImageTextLayout_Right_Left:
            [self layoutLeftView:self.lableView andRightView:self.imageView];
            break;
        case ImageTextLayout_Down_Up:
            [self layoutUpView:self.lableView andDownView:self.imageView];
            break;
        case ImageTextLayout_Up_Down:
            [self layoutUpView:self.imageView andDownView:self.lableView];
            break;
    }
}

-(void)tapGesture:(UIGestureRecognizer*)gesture {
    if(_tapBlock) {
        _tapBlock();
    }
}

- (void)setMidSpace:(NSInteger)midSpace {
    _midSpace = midSpace;
    [self setNeedsDisplay];
}

- (void)setImage:(UIImage*)image {
    [_imageView setImage:image];
    [self setNeedsDisplay];
}

- (void)setText:(NSString*)text {
    _lableView.text = text;
    [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor*)textColor {
    [_lableView setTextColor:textColor];
    [self setNeedsLayout];
}

- (void)layoutLeftView:(UIView*)leftView andRightView:(UIView*)rightView {
    
    CGFloat originX = (CGRectGetWidth(self.frame)-(CGRectGetWidth(leftView.frame)+_midSpace+CGRectGetWidth(rightView.frame)) ) / 2.0;
    
    [leftView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(originX);
        make.width.mas_equalTo(CGRectGetWidth(leftView.frame));
        make.height.mas_equalTo(CGRectGetHeight(leftView.frame));
    }];
    
    [rightView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(leftView.mas_right).offset(_midSpace);
        make.width.mas_equalTo(CGRectGetWidth(rightView.frame));
        make.height.mas_equalTo(CGRectGetHeight(rightView.frame));
    }];
}

- (void)layoutUpView:(UIView*)upView andDownView:(UIView*)downView {
    
    CGFloat originY = ( CGRectGetHeight(self.frame)-(CGRectGetHeight(upView.frame)+_midSpace+CGRectGetHeight(downView.frame)) ) / 2.0;
    
    [upView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(originY);
        make.width.mas_equalTo(CGRectGetWidth(upView.frame));
        make.height.mas_equalTo(CGRectGetHeight(upView.frame));
    }];
    
    [downView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(upView.mas_bottom).offset(_midSpace);
        make.width.mas_equalTo(CGRectGetWidth(downView.frame));
        make.height.mas_equalTo(CGRectGetHeight(downView.frame));
    }];
}

@end
