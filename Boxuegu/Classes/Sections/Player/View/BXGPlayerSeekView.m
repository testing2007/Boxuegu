//
//  BXGPlayerSeekView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPlayerSeekView.h"
#import <Masonry.h>
#import "RWCommonFunction.h"

@interface BXGPlayerSeekView()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *currentLabel;
@property (nonatomic, weak) UILabel *durationLabel;
@end

@implementation BXGPlayerSeekView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
    
        [self installUI];
        self.userInteractionEnabled = false;
    }
    return self;
}

- (void)installUI {

    UIView *bgView = [UIView new];
    UIImageView *imageView = [UIImageView new];
    UILabel *currentLabel = [UILabel new];
    UILabel *durationLabel = [UILabel new];
    
    [self addSubview:bgView];
    [self addSubview:imageView];
    [self addSubview:currentLabel];
    [self addSubview:durationLabel];
    
    self.imageView = imageView;
    self.currentLabel = currentLabel;
    self.durationLabel = durationLabel;
    
//    currentLabel.backgroundColor = [UIColor whiteColor];
//    durationLabel.backgroundColor = [UIColor whiteColor];
    currentLabel.textColor = [UIColor whiteColor];
    durationLabel.textColor = [UIColor colorWithHex:0xF5F5F5];
    currentLabel.font = [UIFont bxg_fontMediumWithSize:14];
    durationLabel.font = [UIFont bxg_fontMediumWithSize:14];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.top.offset(0);
    }];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.2;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.height.offset(30);
        make.centerX.offset(0);
        make.centerY.offset(-10);
    }];
    
    [currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(imageView.mas_bottom).offset(10);
        make.right.equalTo(imageView.mas_centerX).offset(-5);
    }];
    
    [durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(currentLabel);
        make.left.equalTo(currentLabel.mas_right);
    }];
    
    [self currentTime:0 andDurationTime:0 andSeekTime:0];
}

- (void)currentTime:(NSInteger)currentSec andDurationTime:(NSInteger)durationTime andSeekTime:(NSInteger)seekTime; {

    if(currentSec < 0){
    
        currentSec = 0;
    }
    
    if(seekTime < 0) {
    
        seekTime = 0;
    }
    
    if(durationTime < 0){
    
        durationTime = 0;
    }
    
//    RWLog(@"currentSec:%zd",currentSec);
//    RWLog(@"seekTime:%zd",seekTime);
    if(currentSec > seekTime) {
    
        [self.imageView setImage:[UIImage imageNamed:@"播放器-快退"]];
        
    }else {
    
        [self.imageView setImage:[UIImage imageNamed:@"播放器-快进"]];
    }
    
    self.currentLabel.text = formatSecondsToString(seekTime);
    
    self.durationLabel.text = [NSString stringWithFormat:@"/ %@",formatSecondsToString(durationTime)];

}

- (void)currentTime:(NSInteger)currentSec andDurationTime:(NSInteger)durationTime andOffset:(NSInteger)offset {
    [self currentTime:self.firstSec andDurationTime:durationTime andSeekTime:self.firstSec + offset];
}

@end
