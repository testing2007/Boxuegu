//
//  BXGCommunityAttentionView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommunityAttentionView.h"

@interface BXGCommunityAttentionView();
@property (nonatomic, strong) NSArray<UIImage *> *imageArray;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageViewArray;
@property (nonatomic, strong) NSMutableArray<UIButton *> *btnArray;

@property (nonatomic, assign) NSInteger currentCountNum; // #Debug

@end

@implementation BXGCommunityAttentionView

- (void)setCuModelArray:(NSArray<BXGCommunityUserModel *> *)cuModelArray {

    _cuModelArray = cuModelArray;
    // 清理显示缓存
    for (NSInteger i = 0; i < self.imageViewArray.count; i++) {
        
        [self.imageViewArray[i] removeFromSuperview];
    }
    [self.imageViewArray removeAllObjects];
    
    if(!cuModelArray){
        
        return;
    }
    // currentCountNum
    self.currentCountNum = 10;
    
    // for (NSInteger i = 0; i < self.currentCountNum; i++){
    for (NSInteger i = 0; i < cuModelArray.count; i++){
        
        UIImageView *imgV = [UIImageView new];
        [self addSubview:imgV];
        
        [imgV sd_setImageWithURL:[NSURL URLWithString:cuModelArray[i].smallHeadPhoto] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        // [btn setImage:[UIImage imageNamed:] forState:UIControlStateNormal];
        [self.imageViewArray addObject:imgV];
        imgV.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickBtn:)];
        // [self.imageViewArray[i] addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.imageViewArray[i] addGestureRecognizer:tap];
    }
    [self layoutSubviews];
    
}

- (void)setImageArray:(NSArray<UIImage *> *)imageArray {

    _imageArray = imageArray;
    
    // 清理显示缓存
    for (NSInteger i = 0; i < self.btnArray.count; i++) {
    
        [self.btnArray[i] removeFromSuperview];
    }
    [self.btnArray removeAllObjects];
    
    if(!imageArray){
    
        return;
    }
    // currentCountNum
    self.currentCountNum = 10;
    
    // for (NSInteger i = 0; i < self.currentCountNum; i++){
     for (NSInteger i = 0; i < imageArray.count; i++){
    
        UIButton *btn = [UIButton new];
        [btn setImage:imageArray[i] forState:UIControlStateNormal];
        [self.btnArray addObject:btn];
        self.btnArray[i].tag = i;
        [self.btnArray[i] addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
    
        [self installUI];
    }
    return self;
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    CGFloat baseMargin = 5;
    CGFloat rightMargin = 0;
    CGFloat leftMargin = 0;
    CGFloat topMargin = baseMargin;
    CGFloat bottomMargin = 5;
    CGFloat verticalMargin = 5;
    CGFloat horizontalMargin = 5;
    
    
    CGFloat superHeight = self.frame.size.height; // #None
    CGFloat superWidth = self.frame.size.width;
    
    CGFloat width;
    if(self.maxColNum == 0){
    
        width = 0;
    }
    // width = (superWidth - leftMargin - rightMargin - (self.maxColNum - 1) * horizontalMargin) / self.maxColNum;
    width = 30;
    CGFloat height = width;
    
    
    
    for (NSInteger i = 0; i < self.imageViewArray.count; i++) {
    
        NSInteger row = i / self.maxColNum;
        NSInteger col = i % self.maxColNum;
        
        // 逆序排放
        
        CGFloat x;
        CGFloat y = topMargin + row * (height + verticalMargin);;
        if((self.imageViewArray.count - 1) / self.maxColNum == 0) {
        
            x = superWidth - rightMargin - (col + 1) * (width + horizontalMargin) + horizontalMargin;
            
            
        }else {
        
            
            x = leftMargin + col * (width + horizontalMargin);
        }
        
        // CGFloat x = leftMargin + col * (width + horizontalMargin) ;
        // CGFloat x = superWidth - rightMargin - (col + 1) * (width + horizontalMargin) + horizontalMargin;
        // CGFloat y = topMargin + row * (height + verticalMargin);
        
        self.imageViewArray[i].frame = CGRectMake(x, y, width, height);
        self.imageViewArray[i].layer.cornerRadius = height / 2;
        self.imageViewArray[i].layer.masksToBounds = true;
    }
    
    
    
    if(!self.imageViewArray || self.imageViewArray.count <= 0) {
     
        superHeight = 0;
    }else {
    
        superHeight = topMargin + bottomMargin + ((self.imageViewArray.count - 1) / self.maxColNum + 1) * (height) + ((self.imageViewArray.count - 1) / self.maxColNum) * verticalMargin;
    }
    if(self.frame.size.height == superHeight) {
        
        return;
    }
    // 更新约束
    self.bounds = CGRectMake(0, 0, superWidth, superHeight);
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.offset(superHeight);
    }];
    
}
- (void)onClickBtn:(UITapGestureRecognizer *)sender; {

    
    if(self.onClickBtnBlock) {
    
        self.onClickBtnBlock(sender.view.tag);
    }
}

- (void)installUI {

    self.maxColNum = 2;
    self.btnArray = [NSMutableArray new];
    self.imageViewArray = [NSMutableArray new];
}
@end
