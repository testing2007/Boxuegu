//
//  RWStarView.m
//  RWStarView
//
//  Created by RenyingWu on 2017/7/20.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "RWStarView.h"

@interface RWStarView()
@property (nonatomic, strong) NSMutableArray<UIImageView *>* starArray;
@property (nonatomic, assign) NSInteger currentStar;
@end

@implementation RWStarView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
    
        [self installUI];
        
    }
    return self;
}

- (void)awakeFromNib {

    [super awakeFromNib];
    [self installUI];
}

- (void)installUI {

    self.currentStar = 0;
    
    UIView *lastView;
    self.starArray = [NSMutableArray new];
    NSInteger count = 5;
    for(NSInteger i = 0; i < 5; i++) {
    
        
        
        UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"评论-灰色星星"]];
        view.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:view];
        
        if(!lastView){
        
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.left.offset(0);
            }];
        }else {
        
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(lastView.mas_right);
                make.width.equalTo(lastView);
            }];
        }
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.bottom.offset(0);
        }];
            
        if (i == count -1){
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.right.offset(0);
            }];
        }
        lastView = view;
        [self.starArray addObject:view];
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    UITouch *touch = touches.anyObject;
    
    [self changeStarWithTouch:touch];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    UITouch *touch = touches.anyObject;
   
    [self changeStarWithTouch:touch];

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    if([self pointInside:point withEvent:event]) {
    
        if(self.touchUpInsideBlock){
        
            self.touchUpInsideBlock(self.stars);
        }
    }
}


- (void)setStars:(NSInteger)stars {

    [self changeStar:stars];
}
- (NSInteger)stars {

    return self.currentStar;
}

- (void)changeStar:(NSInteger )stars {

    
    
    if(self.currentStar == stars) {
        
        return;
    }else {
        
        self.currentStar = stars;
    }
    
    for(NSInteger i = 0; i < 5; i++) {
        
        if(i < stars) {
            
            self.starArray[i].image = [UIImage imageNamed:@"评论-蓝色星星"];
        }else {
            
            self.starArray[i].image = [UIImage imageNamed:@"评论-灰色星星"];
        }
    }
    if(self.starDidChageBlock) {
        
        self.starDidChageBlock(stars);
    }
}

- (void)changeStarWithTouch:(UITouch *)touch {

    CGPoint point = [touch locationInView:self];
    CGFloat length = point.x;
    CGFloat stars = length / (self.frame.size.width / 5);
    NSInteger count = (NSInteger)stars;
    if(stars - count > 0) {
        count ++;
    }
    
    if(count <= 0){
    
        count = 1;
    }
    
    if(count > 5){
    
        count = 5;
    }
    
    if(self.changeStarEnable == false) {
        
        return;
    }
    [self changeStar:count];

}

@end
