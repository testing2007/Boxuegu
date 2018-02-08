//
//  BXGStudyChapterHeaderView.m
//  RWMuiltyTableView-Demo
//
//  Created by HM on 2017/4/21.
//  Copyright © 2017年 itcast. All rights reserved.
//
#import "Masonry.h"
#import "BXGStudyChapterHeaderView.h"

@interface BXGStudyChapterHeaderView()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *imageView;
@end


@implementation BXGStudyChapterHeaderView

- (void)setBackgroundColor:(UIColor *)backgroundColor {

    _backgroundColor = backgroundColor;
    self.contentView.backgroundColor = backgroundColor;
}

-(void)setTitle:(NSString *)title {

    _title = title;
    self.titleLabel.text = title;
}
-(void)setIsOpen:(BOOL)isOpen {

    _isOpen = isOpen;
    [UIView animateWithDuration:0.2 animations:^{
        
        // self.imageView.transform = CGAffineTransformMakeRotation(M_PI)
        
    } completion:^(BOOL finished) {
        
        self.imageView.highlighted = isOpen;
    }];
    
}
- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier  {

    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self) {
        [self installUI];
    }
    return self;
    
}
- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
    
        [self installUI];
    }
    return self;
}
- (void)installUI {
    
    self.contentView.backgroundColor = [UIColor colorWithHex:0xF6F9FC];
   
    UIImageView *imageView = [UIImageView new];
    [imageView setHighlightedImage:[UIImage imageNamed:@"课程展开"]];
    [imageView setImage:[UIImage imageNamed:@"课程合起"]];

    [self.contentView addSubview:imageView];

    self.imageView = imageView;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(0);
        make.width.height.offset(15);
    }];
    
    UILabel *titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    titleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
        make.height.offset(16);
        make.right.equalTo(imageView.mas_left).offset(-15);
    }];
    titleLabel.textColor = [UIColor colorWithHex:0x333333];
    
    UIView *spView = [UIView new];
    [self addSubview:spView];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.height.offset(1);
        make.left.right.offset(0);
    }];
    spView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
}

@end
