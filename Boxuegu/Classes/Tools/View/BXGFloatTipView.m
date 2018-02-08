//
//  BXGFloatTipView.m
//  Boxuegu
//
//  Created by apple on 2017/11/2.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGFloatTipView.h"

#define kCloseBtnTag 100

@interface BXGFloatTipView()
@end

@implementation BXGFloatTipView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0, 0, 0, 38)];
    if(self){
        // self.backgroundColor = [UIColor colorWithHex:0x38ADFF alpha:1];
        [self installRecentStudyView];
        self.layer.masksToBounds = true;
    }
    
    return self;
}

- (void)dealloc {
   [self closeTimer];
}

- (UIView *) installRecentStudyView {
    
    // 1.创建父控件
    UIButton *superView = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // superView.backgroundColor = [UIColor colorWithRed:127 green:127 blue:127];
    superView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.69];
    UIImageView *boderView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"学习记录浮层"]];
    
    // 2.创建子控件
    // superView.contentMode = UIViewContentModeScaleAspectFill;
    UILabel *markLabel = [UILabel new];
    UILabel *startMarkLabel = [UILabel new];
    UILabel *recentLabel = [UILabel new];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.tag = kCloseBtnTag;

    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clock"]];
    
    boderView.hidden = true;
    // 3.创建控件关联
    [superView addSubview:boderView];
    [superView addSubview:markLabel];
    [superView addSubview:recentLabel];
    [superView addSubview:startMarkLabel];
    [superView addSubview:iconImageView];
    [superView addSubview:closeButton];
    
    markLabel.text = @"";
    markLabel.textColor = [UIColor whiteColor];
    markLabel.font = [UIFont bxg_fontRegularWithSize:14];
    markLabel.hidden = true;
    recentLabel.hidden = true;
    startMarkLabel.text = @"";
    
    startMarkLabel.font = [UIFont bxg_fontRegularWithSize:14];
    startMarkLabel.textColor = [UIColor whiteColor];
    
    recentLabel.font = [UIFont bxg_fontRegularWithSize:14];
    recentLabel.textColor = [UIColor whiteColor];

    UIImageView *closeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"浮窗关闭"]];
//    closeImageView.layer.borderWidth = 1;
//    closeImageView.layer.borderColor = [UIColor greenColor].CGColor;
    [closeButton addSubview:closeImageView];
    closeButton.backgroundColor = [UIColor clearColor];
//    [closeButton setImage:[UIImage imageNamed:@"浮窗关闭"] forState:UIControlStateNormal];
//    closeButton.layer.borderColor = [UIColor redColor].CGColor;
//    closeButton.layer.borderWidth = 1;
    [closeButton addTarget:self action:@selector(closeTipView) forControlEvents:UIControlEventTouchDown];
    
    // 5.布局
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
        make.height.width.offset(16);
        make.height.lessThanOrEqualTo(iconImageView.superview);
    }];
    
    [boderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.right.offset(-12);
        make.centerY.offset(0);
    }];
    
    [startMarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(10);
        make.right.offset(-15);
        make.centerY.offset(0);
        make.height.offset(16);
        make.height.lessThanOrEqualTo(startMarkLabel.superview);
    }];
    
    [markLabel sizeToFit];
    [markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(10);
        make.centerY.offset(0);
        make.width.offset(markLabel.bounds.size.width);
        make.height.offset(16);
        make.height.lessThanOrEqualTo(markLabel.superview);
    }];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-8);
        make.centerY.offset(0);
        make.height.equalTo(closeButton.superview);
        make.width.equalTo(closeButton.mas_height);
    }];
    
    
    [closeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.height.equalTo(closeImageView.superview.mas_height).dividedBy(2);
        make.width.equalTo(closeImageView.superview.mas_width).dividedBy(2);
    }];
    
    [recentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(markLabel.mas_right).offset(6);
        // make.right.offset(-15);
        make.right.equalTo(closeButton.mas_left).offset(0);
        // make.width 自动进行计算
        make.height.offset(14);
        make.centerY.offset(0);
        make.height.lessThanOrEqualTo(recentLabel.superview);
    }];
    
    // 6.设置接口
    self.recentLabel = recentLabel;
    self.markLabel = markLabel;
    self.startMarkLabel = startMarkLabel;
    
    // 7.临时配置信息
    // UITapGestureRecognizer *tap = [UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickProceedBtn)
    [superView addTarget:self action:@selector(clickProceedBtn:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:superView];
    [superView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    
    return superView;
}

- (void)clickProceedBtn:(UIButton *)sender {
    return ;//子类来实现
}

- (void)loadContent:(id)info {
}

- (void)launchCloseFloatTipViewTimer {
    [self closeTimer];
    
    self.closeFloatTipViewTimer = [NSTimer timerWithTimeInterval:kCloseFloatTipViewInterval target:self selector:@selector(closeTipView) userInfo:nil repeats:NO];
    
    [[NSRunLoop currentRunLoop] addTimer:_closeFloatTipViewTimer forMode:NSRunLoopCommonModes];
}

- (void)closeTipView {
    __weak typeof (self) weakSelf = self;
    [weakSelf mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0);
    }];
    
    [weakSelf layoutIfNeeded];
    if(weakSelf.closeTipViewBlock) {
        weakSelf.closeTipViewBlock();
    }
    [self closeTimer];
}

-(void)closeTimer {
    if(self.closeFloatTipViewTimer!=nil) {
        [self.closeFloatTipViewTimer invalidate];
        self.closeFloatTipViewTimer = nil;
    }
}



@end
