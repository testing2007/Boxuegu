//
//  BXGConstrueLivePlayerView.m
//  Boxuegu
//
//  Created by wurenying on 2018/1/15.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGConstrueLivePlayerView.h"
#import "BXGLiveManager.h"
#import "BXGConstrueChannelCell.h"
#import "BXGPlayerHeaderBackBtn.h"
#import "BXGPlayerGradientView.h"
#import "BXGAlertController.h"
#import "BXGPlayerSelectRouteView.h"

typedef NS_ENUM(NSUInteger, BXGConstrueLivePlayerViewStatus) {
    BXGConstrueLivePlayerViewStatusHide,
    BXGConstrueLivePlayerViewStatusMinimum,
    BXGConstrueLivePlayerViewStatusMaximum
};

@interface BXGConstrueLivePlayerView() <BXGLiveManagerDelegate,UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) BXGConstrueLivePlayerViewStatus status;

// ui
@property (nonatomic, strong) UIView *liveComponentsView;
@property (nonatomic, strong) UIButton *popMaskView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIView *fullBackView;
@property (nonatomic, strong) UIButton *channelBtn;
@property (nonatomic, strong) UIButton *sizeBtn;
@property (nonatomic, strong) UIButton *modeBtn;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIImageView *countTagImageV;
@property (nonatomic, strong) UIView *popView;
@property (nonatomic, strong) UITableView *selectSmallRourtView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) BXGLiveManager *liveManager;
@property (nonatomic, strong) BXGPlayerSelectRouteView *selecteRouteView;
@property (nonatomic, strong) UIImageView *audioImgV;
@end

@implementation BXGConstrueLivePlayerView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        self.componentsView = self.liveComponentsView;
        [self installUI];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - life cycle

#pragma mark - ui

- (UIImageView *)audioImgV {
    
    if(_audioImgV == nil) {
        
        _audioImgV = [UIImageView new];
        [_audioImgV setImage:[UIImage imageNamed:@"video_img_sound"]];
        _audioImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _audioImgV;
}

- (BXGPlayerSelectRouteView *)selecteRouteView {
    
    Weak(weakSelf);
    
    if(_selecteRouteView == nil) {
        
        _selecteRouteView = [BXGPlayerSelectRouteView new];
        _selecteRouteView.didSelectedCell = ^(UITableView *tableView, NSIndexPath *indexPath) {
            [weakSelf closePopMaskView];
        };
    }
    return _selecteRouteView;
}

- (UIView *)fullBackView {
    
    if(_fullBackView == nil) {
        
        _fullBackView = [UIView new];
        
        BXGPlayerGradientView *bgView = [[BXGPlayerGradientView alloc]initWithType:BXGPlayerGradientViewTypeHeader];
        BXGPlayerHeaderBackBtn *backBtn = [[BXGPlayerHeaderBackBtn alloc]init];
        
        [_fullBackView addSubview:bgView];
        [_fullBackView addSubview:backBtn];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.offset(0);
        }];
        
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(K_IS_IPHONE_X){
                make.left.offset(15 + K_STATUS_BAR_OFFSET);
            }else {
                make.left.offset(15);
            }
            make.width.equalTo(_fullBackView).multipliedBy(0.5);
            make.top.bottom.offset(0);
        }];
        
        [backBtn addTarget:self action:@selector(onClickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullBackView;
}

- (void)setIsFullScreen:(BOOL)isFullScreen {
    _isFullScreen = isFullScreen;

    [self closePopMaskView];
    
    if(isFullScreen) {
        [self full];
        
    }else {
        [self small];
    }
}

#pragma mark - Observer

- (void)onTimerIntervalResponse {
    
    [[BXGLiveManager share] requestUserCount];
}

- (UIView *)popView {
    
    if(_popView == nil) {
        
        _popView = [UIView new];
    }
    return _popView;
}

- (UIView *)selectSmallRourtView {
    
    if(_selectSmallRourtView == nil) {
        
        _selectSmallRourtView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _selectSmallRourtView.delegate = self;
        _selectSmallRourtView.dataSource = self;
        [_selectSmallRourtView registerClass:[BXGConstrueChannelCell class] forCellReuseIdentifier:BXGConstrueChannelCell.description];
        _selectSmallRourtView.backgroundColor = [UIColor clearColor];
        _selectSmallRourtView.rowHeight = 30;
        _selectSmallRourtView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _selectSmallRourtView.bounces = false;
        [_selectSmallRourtView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.liveManager.currentChannel inSection:0] animated:false scrollPosition:UITableViewScrollPositionNone];
    }
    return _selectSmallRourtView;
}

- (void)popSelectChannelView {
    
    UITableView *selectChannelView = self.selectSmallRourtView;
    UIView *tapView = [UIView new];
    
    [self.popView addSubview:tapView];
    [self.popView addSubview:selectChannelView];
    [self.liveComponentsView addSubview:self.popView];
    CGFloat tableViewHeight = selectChannelView.rowHeight * 111;
    
    [selectChannelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.channelBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.channelBtn);
        make.width.offset(50);
        make.height.offset(tableViewHeight);
        make.top.greaterThanOrEqualTo(selectChannelView.superview).offset(10);
        make.bottom.lessThanOrEqualTo(selectChannelView.superview).offset(-10);
    }];
    
    [tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];

    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPopView:)];
    [tapView addGestureRecognizer:tap];
}

- (void)tapPopView:(UITapGestureRecognizer *)tap {
     [self removePopView];
}

- (void)removePopView {
    
    // 移除
    for (NSInteger i = 0; self.popView.subviews.count > i; i++) {
        UIView *subView = self.popView.subviews[i];
        [subView removeFromSuperview];
    }
    
    [self.popView removeFromSuperview];
    
    self.popView = nil;
    self.selectSmallRourtView = nil;

}

- (BXGLiveManager *)liveManager {
    
    if(_liveManager == nil) {
        
        _liveManager = [BXGLiveManager share];
    }
    return _liveManager;
}

#pragma mark - getter setter

#pragma mark - ui

- (void)removeAudioView {
    
    if(_audioImgV) {
        if(_audioImgV.superview) {
            [_audioImgV removeFromSuperview];
        }
        _audioImgV = nil;
    }
    
}
- (void)addAudioView {
    [self removeAudioView];
    
    [self.mediaView addSubview:self.audioImgV];
    [self.audioImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
}

- (UIButton *)popMaskView {
    
    if(_popMaskView == nil) {
        
        _popMaskView = [UIButton new];
        [_popMaskView addTarget:self action:@selector(onClickPopMaskView:) forControlEvents:UIControlEventTouchDown];
    }
    return _popMaskView;
}

- (UIView *)liveComponentsView {
    
    if(_liveComponentsView == nil) {
        
        _liveComponentsView = [UIView new];
        
        UIButton *backBtn = self.backBtn;
        UIButton *sizeBtn = self.sizeBtn;
        UIButton *modeBtn = self.modeBtn;
        UIButton *channelBtn = self.channelBtn;
        UIImageView *countTagImageV = self.countTagImageV;
        UILabel *countLabel = self.countLabel;
        UIView *fullBackView = self.fullBackView;
    
        [_liveComponentsView addSubview:backBtn];
        [_liveComponentsView addSubview:sizeBtn];
        [_liveComponentsView addSubview:modeBtn];
        [_liveComponentsView addSubview:channelBtn];
        [_liveComponentsView addSubview:countTagImageV];
        [_liveComponentsView addSubview:countLabel];
        [_liveComponentsView addSubview:fullBackView];
        
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(K_IS_IPHONE_X){
                make.left.offset(10);
                make.top.offset(0);
            }else {
                make.left.offset(10);
                make.top.offset(K_STATUS_BAR_OFFSET);
            }
            
            make.width.height.offset(33);
        }];
        
        [modeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(K_IS_IPHONE_X){
                make.right.offset(-10);
            }else {
                make.right.offset(-10);
            }
            make.top.equalTo(backBtn);
            make.width.height.equalTo(backBtn);
        }];
        
        [channelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(modeBtn);
            make.top.equalTo(modeBtn.mas_bottom).offset(15);
            make.width.height.equalTo(backBtn);
        }];
        
        [sizeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(modeBtn);
            make.bottom.offset(-12);
            make.width.height.equalTo(backBtn);
        }];
        
        [countTagImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            if(K_IS_IPHONE_X){
                make.left.offset(15);
            }else {
                make.left.offset(15);
            }
            make.width.offset(9);
            make.height.offset(13);
        }];
        
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(countTagImageV.mas_right).offset(2);
            make.bottom.offset(-14);
            make.centerY.equalTo(countTagImageV);
        }];
        
        [fullBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(0);
            make.right.offset(0);
            make.height.offset(64);
        }];
        
        backBtn.hidden = false;
        sizeBtn.hidden = false;
        
        
        modeBtn.hidden = true;
        channelBtn.hidden = true;
        countTagImageV.hidden = true;
        countLabel.hidden = true;
        fullBackView.hidden = true;
        
    }
    return _liveComponentsView;
}

- (void)full {
    
    UIButton *backBtn = self.backBtn;
    UIButton *sizeBtn = self.sizeBtn;
    UIButton *modeBtn = self.modeBtn;
    UIButton *channelBtn = self.channelBtn;
    UIImageView *countTagImageV = self.countTagImageV;
    UILabel *countLabel = self.countLabel;
    UIView *fullBackView = self.fullBackView;
    
    [sizeBtn setImage:[UIImage imageNamed:@"直播-播放器-缩小"] forState:UIControlStateNormal];
    
    [sizeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if(K_IS_IPHONE_X){
            make.right.offset(-15);
            make.bottom.offset(-10);
        }else {
            make.right.offset(-15);
            make.bottom.offset(-10);
        }
        make.width.height.offset(33);
    }];
    
    [channelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sizeBtn.mas_left).offset(-30);
        make.bottom.equalTo(sizeBtn);
        make.width.height.offset(33);
    }];
    
    [modeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(channelBtn.mas_left).offset(-30);
        make.bottom.equalTo(sizeBtn);
        make.width.height.offset(33);
    }];
    
    
    backBtn.hidden = true;
    sizeBtn.hidden = true;
    modeBtn.hidden = true;
    channelBtn.hidden = true;
    countTagImageV.hidden = true;
    countLabel.hidden = true;
    fullBackView.hidden = true;

    backBtn.hidden = true;
    sizeBtn.hidden = false;
    modeBtn.hidden = false;
    channelBtn.hidden = false;
    countTagImageV.hidden = true;
    countLabel.hidden = true;
    fullBackView.hidden = false;
    
    if(self.liveManager.state == BXGLiveManagerStateLive || self.liveManager.state == BXGLiveManagerStateLoading) {
        [self live];
    }else {
        [self notLive];
    }
}

- (void)small {

    UIButton *backBtn = self.backBtn;
    UIButton *sizeBtn = self.sizeBtn;
    UIButton *modeBtn = self.modeBtn;
    UIButton *channelBtn = self.channelBtn;
    UIImageView *countTagImageV = self.countTagImageV;
    UILabel *countLabel = self.countLabel;
    UIView *fullBackView = self.fullBackView;
    
    [sizeBtn setImage:[UIImage imageNamed:@"直播-播放器-全屏"] forState:UIControlStateNormal];
//    [backBtn removeFromSuperview];
//    [sizeBtn removeFromSuperview];
//    [modeBtn removeFromSuperview];
//    [channelBtn removeFromSuperview];
//    [countTagImageV removeFromSuperview];
//    [countLabel removeFromSuperview];
//    [fullBackView removeFromSuperview];
//
//    [_componentsView addSubview:backBtn];
//    [_componentsView addSubview:sizeBtn];
//    [_componentsView addSubview:modeBtn];
//    [_componentsView addSubview:channelBtn];
//    [_componentsView addSubview:countTagImageV];
//    [_componentsView addSubview:countLabel];
//    [_componentsView addSubview:fullBackView];
    
    [backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if(K_IS_IPHONE_X){
            make.left.offset(10);
            make.top.offset(0);
        }else {
            make.left.offset(10);
            make.top.offset(K_STATUS_BAR_OFFSET);
        }
        make.width.height.offset(33);
    }];
    
    [modeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if(K_IS_IPHONE_X){
            make.right.offset(-10);
        }else {
            make.right.offset(-10);
        }
        make.top.equalTo(backBtn);
        make.width.height.equalTo(backBtn);
    }];
    
    [channelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(modeBtn);
        make.top.equalTo(modeBtn.mas_bottom).offset(15);
        make.width.height.equalTo(backBtn);
    }];
    
    [sizeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(modeBtn);
        make.bottom.offset(-12);
        make.width.height.equalTo(backBtn);
    }];
    
    [countTagImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if(K_IS_IPHONE_X){
            make.left.offset(15);
        }else {
            make.left.offset(15);
        }
        make.width.offset(9);
        make.height.offset(13);
    }];
    
    [countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(countTagImageV.mas_right).offset(2);
        make.bottom.offset(-14);
        make.centerY.equalTo(countTagImageV);
    }];
    
    backBtn.hidden = true;
    sizeBtn.hidden = true;
    modeBtn.hidden = true;
    channelBtn.hidden = true;
    countTagImageV.hidden = true;
    countLabel.hidden = true;
    fullBackView.hidden = true;
    self.liveComponentsView.hidden = true;
    
    backBtn.hidden = false;
    sizeBtn.hidden = false;
    modeBtn.hidden = false;
    channelBtn.hidden = false;
    countTagImageV.hidden = false;
    countLabel.hidden = false;
    fullBackView.hidden = true;
    self.liveComponentsView.hidden = false;
    
    if(self.liveManager.state == BXGLiveManagerStateLive || self.liveManager.state == BXGLiveManagerStateLoading) {
        [self live];
    }else {
        [self notLive];
    }
}

- (UIButton *)backBtn {
    
    if(_backBtn == nil) {
        
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed:@"直播-播放器-返回"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(onClickBackBtn) forControlEvents:UIControlEventTouchDown];
    }
    return _backBtn;
}

- (UIButton *)channelBtn {
    
    if(_channelBtn == nil) {
        
        _channelBtn = [UIButton new];
        [_channelBtn setImage:[UIImage imageNamed:@"直播-播放器-线路"] forState:UIControlStateNormal];
        [_channelBtn addTarget:self action:@selector(onClickCannelBtn) forControlEvents:UIControlEventTouchDown];
    }
    return _channelBtn;
}

- (UIButton *)modeBtn {
    
    if(_modeBtn == nil) {
        
        _modeBtn = [UIButton new];
        // @"直播-播放器-音频"
        [_modeBtn setImage:[UIImage imageNamed:@"直播-播放器-视频"] forState:UIControlStateNormal];
        [_modeBtn addTarget:self action:@selector(onClickModeBtn) forControlEvents:UIControlEventTouchDown];
    }
    return _modeBtn;
}

- (UIButton *)sizeBtn {
    
    if(_sizeBtn == nil) {
        
        _sizeBtn = [UIButton new];
        // @"直播-播放器-缩小"
        [_sizeBtn setImage:[UIImage imageNamed:@"直播-播放器-全屏"] forState:UIControlStateNormal];
        [_sizeBtn addTarget:self action:@selector(onClickSizeBtn) forControlEvents:UIControlEventTouchDown];
    }
    return _sizeBtn;
}

- (UILabel *)countLabel {
    
    if(_countLabel == nil) {
        
        _countLabel = [UILabel new];
        _countLabel.font = [UIFont bxg_fontRegularWithSize:15];
        _countLabel.textColor = [UIColor colorWithHex:0xffffff];
        _countLabel.text = @"0";
    }
    return _countLabel;
}

- (UIImageView *)countTagImageV {
    
    if(_countTagImageV == nil) {
        
        _countTagImageV = [UIImageView new];
        _countTagImageV.image = [UIImage imageNamed:@"直播-播放器-人数"];
        _countTagImageV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _countTagImageV;
}

#pragma mark - response

- (void)onClickBackBtn {
    
    // 全屏时候缩小
    if(self.isFullScreen) {
        
        self.isFullScreen = false;
        if(self.changePlayerViewSizeBlock) {
            self.changePlayerViewSizeBlock(self.isFullScreen);
        }
        return;
    }
    
    // 竖屏时候弹出
    Weak(weakSelf);
    BXGAlertController *vc = [BXGAlertController confirmWithTitle:@"您确认结束观看吗?" message:nil confirmHandler:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(weakSelf.superViewController) {
                if(weakSelf.superViewController.navigationController) {
                    [weakSelf.superViewController.navigationController popViewControllerAnimated:true];
                }else {
                    [weakSelf.superViewController dismissViewControllerAnimated:true completion:nil];
                }
            }
        });
    } cancleHandler:^{
        
    }];
    
    [weakSelf.superViewController presentViewController:vc animated:true completion:nil];
    
//

    
}

- (void)onClickCannelBtn {
    
    if(self.liveManager.channelCount <= 0) {
        return;
    }
    
    if(self.isFullScreen) {
        // 判断弹出 全屏时候
        UIView *popMaskView = self.popMaskView;
        BXGPlayerSelectRouteView *selectRouteView = self.selecteRouteView;
        
        [self.liveComponentsView addSubview:popMaskView];
        [self.liveComponentsView addSubview:selectRouteView];
        
        [popMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.offset(0);
        }];
        
        [selectRouteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.bottom.offset(0);
            make.width.offset(227);
            make.right.offset(227);
        }];
        
        [self.liveComponentsView layoutIfNeeded];
        
        [selectRouteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.liveComponentsView layoutIfNeeded];
        }];
        
    }else {
        // 判断弹出 小屏时候
        
        UIView *popMaskView = self.popMaskView;
        UITableView *selectSmallRourtView = self.selectSmallRourtView;
        
        [self.liveComponentsView addSubview:popMaskView];
        [self.liveComponentsView addSubview:selectSmallRourtView];
        
        [popMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.offset(0);
        }];
        
        CGFloat tableViewHeight = selectSmallRourtView.rowHeight * self.liveManager.channelCount;
        [selectSmallRourtView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.channelBtn.mas_left).offset(-10);
            make.centerY.equalTo(self.channelBtn);
            make.width.offset(50);
            make.height.offset(tableViewHeight);
            make.top.greaterThanOrEqualTo(selectSmallRourtView.superview).offset(10);
            make.bottom.lessThanOrEqualTo(selectSmallRourtView.superview).offset(-10);
        }];
        
        [popMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.offset(0);
        }];
    }
}

- (void)live {
    self.modeBtn.hidden = false;
    self.channelBtn.hidden = false;
    self.countTagImageV.hidden = false;
    self.countLabel.hidden = false;
}

- (void)notLive {
    self.modeBtn.hidden = true;
    self.channelBtn.hidden = true;
    self.countTagImageV.hidden = true;
    self.countLabel.hidden = true;
}

- (void)onClickModeBtn {
    
    switch (self.liveManager.playMode) {
        case BXGLiveManagerPlayModeVideo:{
            [self.liveManager switchMode:BXGLiveManagerPlayModeAudio];
        }break;
        case BXGLiveManagerPlayModeAudio:{
            [self.liveManager switchMode:BXGLiveManagerPlayModeVideo];
        }break;
    }
}

- (void)onClickSizeBtn {
    
    self.isFullScreen = !self.isFullScreen;
    
    if(self.changePlayerViewSizeBlock) {
        self.changePlayerViewSizeBlock(self.isFullScreen);
    }
}

#pragma mark - method

- (void)onClickPopMaskView:(UIButton *)sender {
    
    [self closePopMaskView];
}

- (void)closePopMaskView {
    
    // 移除
    if(_selecteRouteView) {
        
        if(_selecteRouteView.superview) {
            [_selecteRouteView removeFromSuperview];
        }
        _selecteRouteView = nil;
    }
    
    // 移除
    if(_selectSmallRourtView) {
        
        if(_selectSmallRourtView.superview) {
            [_selectSmallRourtView removeFromSuperview];
        }
        _selectSmallRourtView = nil;
    }
    
    // 移除
    if(_popMaskView) {
        
        if(_popMaskView.superview) {
            [_popMaskView removeFromSuperview];
        }
        _popMaskView = nil;
    }
}

- (void)install {
    
}



#pragma mark - UITableViewDelegate,UITableViewDataSource 线路

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.liveManager.channelCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BXGConstrueChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:BXGConstrueChannelCell.description forIndexPath:indexPath];
    cell.cellTitle = [NSString stringWithFormat:@"线路%zd",indexPath.row + 1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.liveManager switchChannel:indexPath.row];
    [tableView selectRowAtIndexPath:indexPath animated:false scrollPosition:UITableViewScrollPositionNone];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self closePopMaskView];
    });
}

#pragma mark - BXGLiveManagerDelegate

- (void)liveManager:(BXGLiveManager *)liveManager userCount:(NSInteger)userCount {
    
    if(userCount > 0) {
        self.countLabel.text = @(userCount).description;
    }else {
        self.countLabel.text = @"0";
    }
}

- (void)liveManager:(BXGLiveManager *)liveManager state:(BXGLiveManagerState)state msg:(NSString *)msg {
    
    // 刷新直播显示状态
    [liveManager framev:self.mediaView];
    
    if(self.liveManager.state == BXGLiveManagerStateLive || self.liveManager.state == BXGLiveManagerStateLoading) {
        [self live];
    }else {
        [self notLive];
    }
}

- (void)liveManager:(BXGLiveManager *)liveManager changeMode:(BXGLiveManagerPlayMode)mode {

    switch (mode) {
        case BXGLiveManagerPlayModeVideo:{
            [self removeAudioView];
            [self.modeBtn setImage:[UIImage imageNamed:@"直播-播放器-视频"] forState:UIControlStateNormal];
            
        }break;
        case BXGLiveManagerPlayModeAudio:{
            [self.modeBtn setImage:[UIImage imageNamed:@"直播-播放器-音频"] forState:UIControlStateNormal];
            [self addAudioView];
        }break;
    }
}

- (void)liveManager:(BXGLiveManager *)liveManager currentChannel:(NSInteger)currentChannel {
    [self closePopMaskView];
}



@end
