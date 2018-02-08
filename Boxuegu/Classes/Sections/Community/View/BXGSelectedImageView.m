//
//  BXGSelectedImageView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/30.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGSelectedImageView.h"
@interface BXGSelectedImageView()



@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *closeButtonArray;
@property (nonatomic, strong) UIButton *addView;
@end
@implementation BXGSelectedImageView



- (void)addImage:(UIImage *)image; {

    if(image){
    
        [self.imageArray addObject:image];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        [self.array addObject:imageView];
        [self addSubview:imageView];
        imageView.layer.borderColor = [UIColor colorWithHex:0xE4E4E4].CGColor;
        imageView.layer.borderWidth = 1;
        imageView.layer.cornerRadius = 2;
        
        imageView.userInteractionEnabled = true;
        UIButton *closeBtn = [UIButton new];
        [closeBtn addTarget:self action:@selector(onClickCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        [self.closeButtonArray addObject:closeBtn];
        [self addSubview:closeBtn];
        [self layoutSubviews];
    }
    
}
- (void)setCurrentCount:(NSInteger)currentCount {
    
    _currentCount = currentCount;
    
    for(NSInteger i = 0; i < self.closeButtonArray.count; i++){
        
        [self.closeButtonArray[i] removeFromSuperview];
    }
    
    for(NSInteger i = 0; i < self.array.count; i++){
        
        [self.array[i] removeFromSuperview];
    }
    
    [self.array removeAllObjects];
    
    [self installUI];
    
    [self layoutSubviews];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        self.maxCount = 9;
        
        // self.lineItemMaxCount = 4;
        self.currentCount = 1;
        self.array = [NSMutableArray new];
        self.closeButtonArray = [NSMutableArray new];
        self.imageArray = [NSMutableArray new];
        UIButton *addView = [UIButton new];
        [addView addTarget:self action:@selector(onClickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
        [addView setImage:[UIImage imageNamed:@"学习圈-选择图片框"] forState:UIControlStateNormal];
        [self addSubview:addView];
        // addView.layer.borderColor = [UIColor blackColor].CGColor;
        // addView.layer.borderWidth = 1;
        self.addView = addView;
    }
    return self;
}

- (void)installUI {
    
    
    // 创建类
    for (NSInteger i = 0; i < self.currentCount; i ++){
        
        UIView *view = [UIView new];
        [self addSubview:view];
        // view.backgroundColor = [UIColor randomColor];
        [self.array addObject:view];
    }
}

- (void)onClickAddBtn:(UIButton *)sender; {

    if(self.onClickAddBtnBlock){
    
        self.onClickAddBtnBlock();
    }
}

- (void)onClickCloseBtn:(UIButton *)sender; {
    
    [self.closeButtonArray[sender.tag] removeFromSuperview];
    [self.closeButtonArray removeObjectAtIndex:sender.tag];
    
    [self.array[sender.tag] removeFromSuperview];
    [self.array removeObjectAtIndex:sender.tag];
    
    [self.imageArray removeObjectAtIndex:sender.tag];
    
    if(self.onClickCloseBtnBlock){
        
        self.onClickCloseBtnBlock(sender.tag);
    }
    
    [self layoutSubviews];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 调整布局
    CGFloat baseMargin = 8;
    CGFloat leftMargin = 15;
    CGFloat rightMargin = 14;
    CGFloat topMargin = baseMargin;
    CGFloat bottomMargin = baseMargin;
    CGFloat verticalMargin = 14;
    CGFloat horizentalMargin = 14;
    
    // size
    // CGFloat superHeight = self.frame.size.height;
    CGFloat superWidth = self.frame.size.width;
    CGFloat width = (superWidth - leftMargin - rightMargin - (self.lineItemMaxCount - 1) * horizentalMargin) / self.lineItemMaxCount;
    CGFloat height = width;
    
    for (NSInteger i = 0; i < self.array.count + 1; i ++) {
        
        if(i == self.maxCount){
            
            return;
        }

        NSInteger row = 0;
        NSInteger col = 0;
        if(self.lineItemMaxCount > 0) {
        
            row = i / self.lineItemMaxCount;
            col = i % self.lineItemMaxCount;
        }
        
        
        UIView *view;
        UIButton *closeBtn;
        
        if(i == self.array.count) {
            
            view = self.addView;
        }else {
            
            view = self.array[i];
        }
        
        view.frame = CGRectMake(leftMargin + col * (horizentalMargin + width), topMargin + row * (verticalMargin + height), width, height);
        
        if(i == self.array.count) {
            
            // closeBtn = self.addView;
        }else {
            
            closeBtn = self.closeButtonArray[i];
            closeBtn.tag = i;
            closeBtn.center = CGPointMake(view.frame.origin.x + view.frame.size.width, view.frame.origin.y);
            closeBtn.bounds = CGRectMake(0, 0, 20, 20);
        }
    }
    
    NSInteger maxRow = 0;
    if(self.lineItemMaxCount > 0) {
        
        maxRow = (self.array.count / self.lineItemMaxCount) + 1;
        
    }
    // NSInteger maxRow = (self.array.count / self.lineItemMaxCount) + 1;
    
    NSInteger superHeight = (maxRow) * (baseMargin + height) + baseMargin;
    
    if(self.frame.size.height == superHeight){
        
        return;
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(superHeight);
    }];
}

@end
