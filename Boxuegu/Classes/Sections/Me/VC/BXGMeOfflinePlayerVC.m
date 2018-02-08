//
//  BXGMeOfflinePlayerVC.m
//  Boxuegu
//
//  Created by HM on 2017/6/2.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMeOfflinePlayerVC.h"

@interface BXGMeOfflinePlayerVC ()

@end

@implementation BXGMeOfflinePlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"离线播放界面";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - InstallUI
//
//- (void)installUI {
//    
//    
//    UIView *mediaView = [UIView new];
//    // 1.整体播放器封装UIView
//    [self.view addSubview:mediaView];
//    self.mediaView = mediaView;
//    self.mediaView.backgroundColor = [UIColor whiteColor];
//    
//    
//    CGFloat height = [UIScreen mainScreen].bounds.size.height;
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGFloat multiplied;
//    if(height > width){
//        
//        multiplied = width / height;
//    }else {
//        
//        multiplied = height / width;
//    }
//    
//    [mediaView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(0);
//        make.left.offset(0);
//        make.right.offset(0);
//        make.height.equalTo(mediaView.mas_width).multipliedBy(multiplied);
//    }];
//    
//    
//    
//    
//    // mediaView.con
//    
//    //    [mediaView mas_makeConstraints:^(MASConstraintMaker *make) {
//    //        make.top.offset(0);
//    //        make.left.offset(0);
//    //        make.right.offset(0);
//    //        make.height.offset([UIScreen mainScreen].bounds.size.width * (422.0 / 750.0));
//    //    }];
//    // 2.蒙版层
//    UIView *maskView = [self installMaskView];
//    [mediaView addSubview:maskView];
//    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.offset(0);
//    }];
//    // 2.播放器PlayerView
//    UIView *playerView = [self installPlayerView];
//    
//    [mediaView addSubview:playerView];
//    
//    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.offset(0);
//    }];
//    
//    maskView.backgroundColor = [UIColor clearColor];
//    // 2.透明手势View
//    UIView *gestureView = [self installGestureView];
//    [mediaView addSubview:gestureView];
//    [gestureView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.offset(0);
//    }];
//    
//    UIView *componentView = [self installComponentView];
//    self.componentView = componentView;
//    [gestureView addSubview:componentView];
//    [componentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.offset(0);
//    }];
//    
//    
//    UIView *leftPopView = [self installLeftPopView];
//    self.leftPopView = leftPopView;
//    [mediaView addSubview:leftPopView];
//    [leftPopView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.offset(0);
//        // make.width.equalTo(leftPopView.mas_height).multipliedBy(453.0 / 750.0);
//    }];
//    
//    [self installPlayerSelectSpeedTableView];
//    [self installPlayerSelectVideoTableView];
//    
//    
//    
//    
//    
//    
//}
//#pragma mark 播放视频
//
//- (BXGCourseOutlineVideoModel *)playWithVideoModel:(BXGCourseOutlineVideoModel *)videoModel {
//    
//    __weak typeof (self) weakSelf = self;
//    
//    // 同步学习进度 保存历史信息
//    [weakSelf saveHistoryWithVideoModel:weakSelf.self.currentPlayVideoModel isEnd:false];
//    
//    // 判断是否被锁定 🔐
//    if(!videoModel.lock_status || [videoModel.lock_status integerValue] == 0){
//        
//        [[BXGHUDTool share] showHUDWithString:@"请到官网闯关测试后\n再学习本知识点"];
//        return nil;
//        
//    }
//    
//    // 播放视频
//    
//    weakSelf.player.timeoutSeconds = 10;
//    weakSelf.player.videoId = videoModel.video_id;
//    
//    // set player
//    weakSelf.isSeeking = false;
//    
//    [weakSelf.player pause];
//    [weakSelf.player reset];
//    [weakSelf.player cancelRequestPlayInfo];
//    
//    weakSelf.player.getPlayUrlsBlock = ^(NSDictionary *playUrls) {
//        
//        NSNumber *status = [playUrls objectForKey:@"status"];
//        
//        if (status == nil || [status integerValue] != 0) {
//            RWLog(@"审核未通过");
//            return;
//        }
//        
//        // 判断是否是VR
//        NSNumber *vrmode =[playUrls objectForKey:@"vrmode"];
//        
//        if (vrmode == nil || [vrmode integerValue] != 0) {
//            RWLog(@"审核未通过");
//            return;
//        }
//        
//        // 获得最清晰的分辨率的URL
//        NSArray *qualityArray = [playUrls objectForKey:@"qualities"];
//        if(qualityArray == nil || qualityArray.count <= 0){
//            
//            RWLog(@"没有视频");
//            return;
//        }
//        
//        weakSelf.currentPlayVideoModel = videoModel;
//        
//        NSString *urlString = qualityArray.lastObject[@"playurl"];
//        [weakSelf.player setURL:[NSURL URLWithString:urlString]];
//        weakSelf.playerView.player =weakSelf.player;
//        weakSelf.player.delegate =weakSelf;
//        [weakSelf.player setSeekStartTime:0];
//        weakSelf.playerView.player = weakSelf.player;
//        
//        if(videoModel.study_status.integerValue == BXGStudyStatusFinish){
//            
//            weakSelf.learnedBtn.condition = BXGLearnedTypeLearned;
//            
//        }else {
//            
//            weakSelf.learnedBtn.condition = BXGLearnedTypeNOLearned;
//        }
//        
//        // 更新 List 和 选集 UI
//        [weakSelf.selectVideoTableView reloadData];
//        [weakSelf.listVC updateCurrentVideoModel:videoModel];
//        // [weakSelf.listVC searchVideoModel:videoModel];
//        
//        // 更新学习状态为 开始学习
//        
//        weakSelf.playerHeaderBackBtn.btnTitle = videoModel.name;
//        
//        
//        [weakSelf.courseDetailViewModel updateUserStudyStateWithVideoModel:videoModel andState:BXGStudyStatusBegin];
//        
//        [weakSelf.player play];
//    };
//    
//    [[BXGHUDTool share] showLoadingHUDWithString:@"请求视频中"];
//    [weakSelf.player startRequestPlayInfo];
//    [[BXGHUDTool share] closeHUD];
//    
//    
//    return videoModel;
//    
//}
//
//
//- (void)playVideo:(NSString *)videoId{
//    
//    __weak typeof (self) weakSelf = self;
//    
//    // 同步学习进度 保存历史信息
//    [weakSelf saveHistoryWithVideoModel:weakSelf.lastVideoModel isEnd:false];
//    
//    weakSelf.player.timeoutSeconds = 10;
//    
//    weakSelf.player.videoId = videoId;
//    
//    // set player
//    weakSelf.isSeeking = false;
//    
//    [weakSelf.player pause];
//    [weakSelf.player reset];
//    [weakSelf.player cancelRequestPlayInfo];
//    
//    weakSelf.player.getPlayUrlsBlock = ^(NSDictionary *playUrls) {
//        
//        NSNumber *status = [playUrls objectForKey:@"status"];
//        
//        if (status == nil || [status integerValue] != 0) {
//            NSLog(@"审核未通过");
//            return;
//        }
//        
//        // 判断是否是VR
//        NSNumber *vrmode =[playUrls objectForKey:@"vrmode"];
//        
//        if (vrmode == nil || [vrmode integerValue] != 0) {
//            NSLog(@"审核未通过");
//            return;
//        }
//        
//        // 获得最清晰的分辨率的URL
//        NSArray *qualityArray = [playUrls objectForKey:@"qualities"];
//        if(qualityArray == nil || qualityArray.count <= 0){
//            
//            NSLog(@"没有视频");
//            return;
//        }
//        
//        weakSelf.lastVideoModel = weakSelf.currentPlayVideoModel;
//        
//        NSString *urlString = qualityArray.lastObject[@"playurl"];
//        [weakSelf.player setURL:[NSURL URLWithString:urlString]];
//        weakSelf.playerView.player =weakSelf.player;
//        weakSelf.player.delegate =weakSelf;
//        [weakSelf.player setSeekStartTime:0];
//        weakSelf.playerView.player = weakSelf.player;
//        
//        if(weakSelf.currentPlayVideoModel && weakSelf.courseDetailViewModel.courseModel){
//            
//            NSString *idx = weakSelf.currentPlayVideoModel.idx;
//            NSString *courseId = weakSelf.courseDetailViewModel.courseModel.course_id;
//            [weakSelf.courseDetailViewModel updateUserStudyStateToBeginWithVideoId:idx andCourseId:courseId];
//            if(weakSelf.currentPlayVideoModel.study_status.integerValue != 1){
//                
//                weakSelf.currentPlayVideoModel.study_status = @2; // 正在学习
//            }
//        }
//        [weakSelf.player play];
//    };
//    
//    [[BXGHUDTool share] showLoadingHUDWithString:@"请求视频中"];
//    [weakSelf.player startRequestPlayInfo];
//    [[BXGHUDTool share] closeHUD];
//}
//
//#pragma mark - Install UI
//- (UIView *)installPlayerView {
//    
//    DWVideoPlayerView *playerView = [[DWVideoPlayerView alloc]initWithFrame:CGRectMake(0, 0, 300, 400)];
//    
//    BXGUserModel *userModel = self.courseDetailViewModel.userModel;
//    
//    if(userModel) {
//        
//        NSString *ccUserId = userModel.cc_user_id;
//        NSString *ccKey = userModel.cc_api_key;
//        // 73E5F66625CB30D39C33DC5901307461
//        DWVideoPlayer *player= [[DWVideoPlayer alloc]initWithUserId:ccUserId key:ccKey];
//        //DWVideoPlayer *player = [[DWVideoPlayer alloc]initWithUserId:ccUserId andVideoId:@"73E5F66625CB30D39C33DC5901307461" key:ccKey];
//        playerView.player = player;
//        self.player = player;
//    }
//    
//    [playerView setVideoFillMode:AVLayerVideoGravityResizeAspect];
//    
//    self.playerView = playerView;
//    return playerView;
//    
//}
//
//- (UIView *)installGestureView {
//    
//    UIView *superView = [UIView new];
//    
//    
//    // superView.inter
//    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureView:)];
//    
//    [superView addGestureRecognizer:tapGesture];
//    
//    
//    return superView;
//}
//
//- (void)tapGestureView:(UITapGestureRecognizer *)tap {
//    
//    if(self.componentView.hidden) {
//        
//        self.isStatusBarHiden = false;
//        self.componentView.hidden = !self.componentView.hidden;
//        
//    }else {
//        
//        self.isStatusBarHiden = true;
//        self.componentView.hidden = !self.componentView.hidden;
//    }
//    
//}
//
//- (UIView *)installLeftPopView{
//    
//    
//    UIView *superView = [UIView new];
//    //;
//    
//    UIView *maskView = [UIView new];
//    UIView *popView = [UIView new];
//    UILabel *titleLabel = [UILabel new];
//    UIView *contentView = [UIView new];
//    UIView *spView = [UIView new];
//    
//    [superView addSubview:popView];
//    // [popView addGestureRecognizer:[UITapGestureRecognizer new]];
//    [superView addSubview:maskView];
//    [popView addSubview:contentView];
//    [popView addSubview:spView];
//    [popView addSubview:titleLabel];
//    
//    // pop
//    [popView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.offset(0);
//        make.right.offset(0);
//        make.width.equalTo(superView.mas_height).multipliedBy(453.0 / 750.0);
//    }];
//    self.popView = popView;
//    popView.backgroundColor = [UIColor colorWithHex:0x11161F alpha:0.9];
//    // [UIColor colorWithHex:0x11161F alpha:0.9];
//    
//    
//    
//    
//    // title Label
//    self.leftPopViewTitleLabel = titleLabel;
//    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:13];
//    titleLabel.textColor = [UIColor colorWithHex:0xcccccc];
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.right.offset(0);
//        make.height.offset(43);
//        make.left.offset(15);
//    }];
//    
//    // sp
//    
//    spView.backgroundColor = [UIColor colorWithHex:0xffffff];
//    spView.alpha = 0.1;
//    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(titleLabel.mas_bottom).offset(0);
//        make.left.equalTo(popView).offset(0);
//        make.right.equalTo(popView).offset(0);
//        make.height.offset(1);
//    }];
//    
//    
//    
//    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(spView.mas_bottom).offset(0);
//        make.bottom.right.offset(0);
//        make.left.offset(0);
//    }];
//    
//    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.offset(0);
//        make.right.equalTo(popView.mas_left).offset(0);
//    }];
//    
//    
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeLeftPopView)];
//    [maskView addGestureRecognizer:tap];
//    
//    
//    superView.hidden = true;
//    
//    
//    self.popContentView = contentView;
//    return superView;
//}
//
//- (void)installPlayerSelectSpeedTableView {
//    
//    __weak typeof (self) weakSelf = self;
//    
//    UIExtTableView *selectSpeedTableView = [UIExtTableView new];
//    selectSpeedTableView.backgroundColor = [UIColor clearColor];
//    selectSpeedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    selectSpeedTableView.rowHeight = 50;
//    self.selectSpeedTableView = selectSpeedTableView;
//    [selectSpeedTableView registerClass:[BXGSelectionCell class] forCellReuseIdentifier:@"BXGSelectionCell"];
//    selectSpeedTableView.allowsSelection = true;
//    [selectSpeedTableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.1)]];
//    
//    
//    selectSpeedTableView.numberOfRowsInSectionBlock = ^NSInteger(UITableView *tableView, NSInteger section) {
//        
//        // 倍速相关
//        
//        return weakSelf.playerSpeedSelectionArray.count;
//        
//    };
//    selectSpeedTableView.cellForRowAtIndexPathBlock = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
//        
//        BXGSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGSelectionCell" forIndexPath:indexPath];
//        
//        
//        NSDictionary *dict = weakSelf.playerSpeedSelectionArray[indexPath.row];
//        
//        cell.cellTitle = dict[@"desc"];
//        
//        [weakSelf closeLeftPopView];
//        return cell;
//    };
//    
//    selectSpeedTableView.didSelectRowAtIndexPathBlock = ^(UITableView *__weak tableView, NSIndexPath *__weak indexPath) {
//        
//        NSDictionary *dict = weakSelf.playerSpeedSelectionArray[indexPath.row];
//        
//        weakSelf.player.player.rate = [dict[@"value"] doubleValue];
//        
//        [weakSelf.selectSpeedBtn setTitle:dict[@"desc"]forState:UIControlStateNormal];
//    };
//    
//    
//    
//}
//
//- (void)installPlayerSelectVideoTableView {
//    __weak typeof (self) weakSelf = self;
//    
//    UIExtTableView *selectVideoTableView = [UIExtTableView new];
//    selectVideoTableView.backgroundColor = [UIColor clearColor];
//    selectVideoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    selectVideoTableView.rowHeight = 50;
//    self.selectVideoTableView = selectVideoTableView;
//    [selectVideoTableView registerClass:[BXGSelectionVideoCell class] forCellReuseIdentifier:@"BXGSelectionVideoCell"];
//    selectVideoTableView.allowsSelection = true;
//    [selectVideoTableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.1)]];
//    
//    
//    selectVideoTableView.numberOfRowsInSectionBlock = ^NSInteger(UITableView *tableView, NSInteger section) {
//        
//        return weakSelf.currentPlayVideoModel.superPointModel.videos.count;
//        
//    };
//#warning 选集时不需要刷新 选集tableView reload data 影响选择项
//    selectVideoTableView.cellForRowAtIndexPathBlock = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
//        
//        BXGSelectionVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGSelectionVideoCell" forIndexPath:indexPath];
//        // 1.添加 视频Model
//        BXGCourseOutlineVideoModel *videoModel = weakSelf.currentPlayVideoModel.superPointModel.videos[indexPath.row];
//        
//        if(videoModel == weakSelf.currentPlayVideoModel){
//            
//            cell.isArrow = true;
//        }else {
//            
//            
//            cell.isArrow = false;
//        }
//        // 2.判断是否相同的视频Model 点亮
//        
//        cell.model = videoModel;
//        // cell.cellTitle = weakSelf.playerVideoSelectionArray[indexPath.row];
//        
//        return cell;
//    };
//    
//    selectVideoTableView.didSelectRowAtIndexPathBlock = ^(UITableView *__weak tableView, NSIndexPath *__weak indexPath) {
//        
//        BXGCourseOutlineVideoModel *videoModel = weakSelf.currentPlayVideoModel.superPointModel.videos[indexPath.row];
//        [weakSelf playWithVideoModel:videoModel];
//        
//        //        weakSelf.selectViewVideoModel = weakSelf.selectViewPointModel.videos[indexPath.row];
//        //        [weakSelf.listVC updateCurrentVideoModel:weakSelf.selectViewVideoModel];
//        //        weakSelf.listVC.playBlock(weakSelf.selectViewPointModel,weakSelf.selectViewVideoModel);
//        [weakSelf closeLeftPopView];
//    };
//    
//}
//
//- (void)clickPlayerSpeedBtn:(UIButton *)btn; {
//    
//    [self openLeftPopView:self.selectSpeedTableView andTitle:@"倍速选择"];
//    
//}
//
//- (void)clickPlayerSelectVideoBtn:(UIButton *)btn; {
//    
//    [self openLeftPopView:self.selectVideoTableView andTitle:@"选集"];
//    
//}
//
//- (void)openLeftPopView:(UIView *)view andTitle:(NSString *)title{
//    
//    
//    if(title){
//        
//        self.leftPopViewTitleLabel.text = title;
//    }else {
//        self.leftPopViewTitleLabel.text = @"";
//    }
//    
//    
//    
//    [self.popContentView addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.offset(0);
//    }];
//    
//    CGAffineTransform transform = self.leftPopView.transform;
//    self.leftPopView.transform = CGAffineTransformTranslate( transform, self.leftPopView.bounds.size.width, 0);
//    self.leftPopView.hidden = false;
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        
//        self.leftPopView.transform = CGAffineTransformIdentity;
//    } completion:^(BOOL finished) {
//        
//    }];
//    
//    
//}
//
//- (void)closeLeftPopView{
//    
//    if(!self.leftPopView.hidden) {
//        
//        self.leftPopView.transform = CGAffineTransformIdentity;
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            
//            CGAffineTransform transform = self.leftPopView.transform;
//            self.leftPopView.transform = CGAffineTransformTranslate( transform, self.leftPopView.bounds.size.width, 0);
//            
//        } completion:^(BOOL finished) {
//            self.leftPopView.hidden = true;
//            [self.popContentView.subviews.lastObject removeFromSuperview];
//        }];
//    }
//    
//    
//    ///NSArray *arr = self.popView.subviews;
//    
//}
//
//- (UIView *)installMaskView {
//    
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"播放器-视频占位图"]];
//    
//    return imageView;
//}
//
//- (UIView *)installComponentView {
//    
//    UIView *superView = [UIView new];
//    
//    
//    
//    
//    // - 播放器 头部控件
//    UIView *headerView = [UIView new];
//    self.playerHeaderView = headerView;
//    [superView addSubview:headerView];
//    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.offset(0);
//        make.height.offset(64);
//    }];
//    UIView *headerBGView = [UIButton new];
//    [headerView addSubview:headerBGView];
//    [headerBGView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.offset(0);
//        make.height.offset(64);
//    }];
//    headerBGView.userInteractionEnabled = true;
//    CAGradientLayer *headerViewGradientLayer = [CAGradientLayer layer];
//    headerViewGradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor];
//    headerViewGradientLayer.locations = @[@(0.1)];
//    headerViewGradientLayer.startPoint = CGPointMake(0, 0);
//    headerViewGradientLayer.endPoint = CGPointMake(0, 1);
//    headerViewGradientLayer.frame = CGRectMake(0, 0, 2000, 64);
//    [headerBGView.layer addSublayer:headerViewGradientLayer];
//    
//    
//    
//    
//    
//    
//    UIButton *headerDownloadBtn = [UIButton new];
//    [headerView addSubview:headerDownloadBtn];
//    [headerDownloadBtn addTarget:self action:@selector(clickHeaderDownloadBtn:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [headerDownloadBtn setImage:[UIImage imageNamed:@"播放器-下载"] forState:UIControlStateNormal];
//    
//    [headerDownloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerY.offset(10);
//        make.right.offset(-15);
//        make.width.offset(21);
//        make.height.offset(21);
//    }];
//    
//    
//    BXGLearnedBtn *learnedBtn = [BXGLearnedBtn buttonWithType:UIButtonTypeCustom];
//    //    learnedBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//    //    learnedBtn.layer.borderWidth = 1;
//    //    learnedBtn.layer.cornerRadius = 2;
//    //    learnedBtn.backgroundColor = [UIColor clearColor];
//    //    learnedBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
//    //    [learnedBtn setTitle:@"已学习" forState:UIControlStateNormal];
//    // BXGLearnedBtn.h
//    self.learnedBtn = learnedBtn;
//    [headerView addSubview:learnedBtn];
//    
//    
//    
//    // UIView *view = [[UIView alloc] init];
//    //view.frame = CGRectMake(553, 54, 94, 40);
//    
//    
//    
//    
//    
//    
//    
//    [learnedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerY.offset(10);
//        make.right.equalTo(headerDownloadBtn.mas_left).offset(-15);
//        make.width.offset(53);
//        make.height.offset(22);
//    }];
//    
//    
//    [learnedBtn addTarget:self action:@selector(clickPlayerHeaderLearnedBtn:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    BXGPlayerHeaderBackBtn *backBtn = [BXGPlayerHeaderBackBtn new];
//    [headerView addSubview:backBtn];
//#warning TODO:
//    
//    
//    self.playerHeaderBackBtn = backBtn;
//    
//    [backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.btnTitle = @"";
//    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerY.offset(10);
//        make.left.offset(15);
//        //make.width.offset(100);
//        make.height.equalTo(headerView);
//        make.right.equalTo(learnedBtn.mas_left).offset(-15);
//    }];
//    
//#pragma mark - 底部视图
//    
//    // - 播放器 底部控件
//    UIButton *footerView = [UIButton new]; // 屏蔽到消息响应
//    
//    [superView addSubview:footerView];
//    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.left.right.offset(0);
//        make.height.offset(47);
//    }];
//    
//    // 用于屏蔽交互
//    [footerView addGestureRecognizer:[UITapGestureRecognizer new]];
//    //[footerView addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    // - 底部视图背景层
//    UIView *footerBGView = [UIButton new];
//    
//    [footerView addSubview:footerBGView];
//    [footerBGView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.left.right.offset(0);
//        make.height.offset(47);
//    }];
//    
//    CAGradientLayer *footerBGViewGradientLayer = [CAGradientLayer layer];
//    footerBGViewGradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor, (__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor];
//    footerBGViewGradientLayer.locations = @[@(0.1)];
//    footerBGViewGradientLayer.startPoint = CGPointMake(0, 0);
//    footerBGViewGradientLayer.endPoint = CGPointMake(0, 1);
//    footerBGViewGradientLayer.frame = CGRectMake(0, 0, 2000, 47);
//    [footerBGView.layer addSublayer:footerBGViewGradientLayer];
//    
//    BXGPlayerPlayBtn *playerPlayBtn = [BXGPlayerPlayBtn buttonWithType:UIButtonTypeCustom];
//    self.playerPlayBtn = playerPlayBtn;
//    [playerPlayBtn addTarget:self action:@selector(clickPlayerPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [footerView addSubview: playerPlayBtn];
//    // [playerPlayBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
//    [playerPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.offset(15);
//        make.centerY.offset(0);
//        make.width.height.offset(23);
//    }];
//    
//    
//    
//    
//    UILabel *currentTimeLabel = [UILabel new]; // 封装成一个独立显示Time的label  或者一个分类
//    [footerBGView addSubview: currentTimeLabel];
//    
//    currentTimeLabel.font = [UIFont systemFontOfSize:12];
//    currentTimeLabel.text = @"00:00:20";
//    currentTimeLabel.textColor = [UIColor whiteColor];
//    [currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(playerPlayBtn.mas_right).offset(10);
//        make.height.offset(12 + 2);
//        make.width.offset(32 + 2 + 17 + 5);
//        make.centerY.offset(0);
//        
//    }];
//    
//    BXGPlayerChangeSizeBtn *changeSizeBtn = [BXGPlayerChangeSizeBtn buttonWithType:UIButtonTypeCustom];
//    // [changeSizeBtn setImage:[UIImage imageNamed:@"全屏"] forState:UIControlStateNormal];
//    
//    self.changeSizeBtn = changeSizeBtn;
//    
//    [footerView addSubview: changeSizeBtn];
//    [changeSizeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.right.offset(-15);
//        make.centerY.offset(0);
//        make.width.height.offset(23);
//    }];
//    
//    [changeSizeBtn addTarget:self action:@selector(clickChangeSizeBtn:) forControlEvents:UIControlEventTouchUpInside];
//    
//    __weak typeof (self) weakSelf = self;
//    
//    
//    
//#pragma mark Install Slider
//    
//    // init
//    RWSlider *playSlider = [RWSlider new];
//    
//    // response
//    playSlider.touchDownBlock = ^(UISlider *sender) {
//        
//        [weakSelf.player startScrubbing];
//        weakSelf.isSeeking = true;
//        [weakSelf pauseCurrentVideo];
//    };
//    
//    playSlider.touchUpBlock = ^(UISlider *sender) {
//        
//        float durSec =CMTimeGetSeconds(weakSelf.player.player.currentItem.duration);
//        CGFloat time = sender.value * durSec;
//        [weakSelf.player seekToTime:time];
//        [weakSelf playCurrentVideo];
//        weakSelf.isSeeking = false;
//        [weakSelf.player scrub:time];
//        [weakSelf.player stopScrubbing];
//    };
//    
//    playSlider.valueChangBlock = ^(UISlider *sender, float value) {
//        
//        float durSec =CMTimeGetSeconds(weakSelf.player.player.currentItem.duration);
//        
//        weakSelf.playerCurrentTimeLabel.text = [weakSelf formatSecondsToString:sender.value * durSec];
//        weakSelf.playerDurationLabel.text = [weakSelf formatSecondsToString:durSec];
//    };
//    
//    // addsubview
//    [footerView addSubview: playSlider];
//    
//    // config
//    playSlider.minimumValue = 0.0f;
//    playSlider.maximumValue = 1.0f;
//    playSlider.value = 0.0f;
//    playSlider.continuous = true;
//    [playSlider setThumbImage:[UIImage imageNamed:@"视频进度滑块"] forState:UIControlStateNormal];
//    playSlider.maximumTrackTintColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.5];
//    playSlider.minimumTrackTintColor = [UIColor colorWithRed:56 / 256.0 green:173 / 256.0 blue:255 / 256.0 alpha:1];
//    
//    // interface
//    self.playerSlider = playSlider;
//    
//    // layout
//    [playSlider mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerY.offset(0);
//        make.left.equalTo(currentTimeLabel.mas_right).offset(10);
//    }];
//    
//#pragma mark Install Duration Label
//    
//    UILabel *durationTimeLabel = [UILabel new]; // 封装成一个独立显示Time的label  或者一个分类
//    [footerView addSubview: durationTimeLabel];
//    durationTimeLabel.font = [UIFont systemFontOfSize:12];
//    durationTimeLabel.text = @"00:00:00";
//    durationTimeLabel.textColor = [UIColor whiteColor];
//    self.playerDurationLabel = durationTimeLabel;
//    self.playerCurrentTimeLabel = currentTimeLabel;
//    
//    
//    
//    [durationTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        
//        make.centerY.offset(0);
//        make.height.offset(12 + 2);
//        make.width.offset(32 + 2 + 17 + 5);
//        
//        make.left.equalTo(playSlider.mas_right).offset(10);
//        // make.left.equalTo(playSlider.mas_right).offset(10);
//        
//        // make.right.lessThanOrEqualTo(changeSizeBtn.mas_left).offset(-10);
//        //make.right.lessThanOrEqualTo(changeSizeBtn.mas_left).offset(-10);
//    }];
//    
//    
//    UIView *footerMoreView = [UIView new];
//    [footerView addSubview:footerMoreView];
//    [footerMoreView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.width.offset(0);
//        make.height.equalTo(footerView);
//        make.centerY.offset(0);
//        make.left.equalTo(durationTimeLabel.mas_right).offset(10);
//        make.right.equalTo(changeSizeBtn.mas_left).offset(0);
//    }];
//    self.footerMoreView = footerMoreView;
//    
//    UIButton *selectSpeedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [footerMoreView addSubview: selectSpeedBtn];
//    [selectSpeedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(0);
//        make.centerY.offset(0);
//        //make.width.lessThanOrEqualTo(@50);
//    }];
//    
//    [selectSpeedBtn setTitle:@"1.0倍速" forState:UIControlStateNormal];
//    selectSpeedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    
//    self.selectSpeedBtn = selectSpeedBtn;
//    
//    [selectSpeedBtn addTarget:self action:@selector(clickPlayerSpeedBtn:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *selectVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    
//    [selectVideoBtn setTitle:@"选集" forState:UIControlStateNormal];
//    selectVideoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    
//    [selectVideoBtn addTarget:self action:@selector(clickPlayerSelectVideoBtn:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [footerMoreView addSubview: selectVideoBtn];
//    [selectVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(selectSpeedBtn.mas_right);
//        make.right.offset(-10);
//        make.centerY.offset(0);
//        make.width.equalTo(selectSpeedBtn);
//        //make.width.lessThanOrEqualTo(@50);
//    }];
//    
//    
//    
//    // 2.控件显示层
//    // - header
//    
//    
//    // - 前部控件
//    
//    
//    // - 左部控件
//    
//    
//    
//    // - 右部控件
//    
//    
//    // - 左侧 加锁按钮
//    
//    BXGPlayerLockBtn *playerLockBtn = [BXGPlayerLockBtn new];
//    [superView addSubview:playerLockBtn];
//    [playerLockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerY.offset(0);
//        make.left.offset(15);
//        make.height.width.offset(45);
//    }];
//    
//    self.playerFooterView = footerView;
//    self.playerLockBtn = playerLockBtn;
//    
//#warning TODO: lock
//    
//    [playerLockBtn addTarget:self action:@selector(clickPlayerLock:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    
//    
//    // - 中部 播放按钮
//#warning TODO:
//    //
//    BXGPlayerBigPlayBtn *playerBigPlayBtn = [BXGPlayerBigPlayBtn new];
//    self.playerBigPlayBtn = playerBigPlayBtn;
//    [playerBigPlayBtn addTarget:self action:@selector(clickPlayerPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
//    //    [playerBigPlayBtn setImage:[UIImage imageNamed:@"播放-大"] forState:UIControlStateNormal];
//    
//    [superView addSubview:playerBigPlayBtn];
//    
//    [playerBigPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerY.offset(0);
//        make.centerX.offset(0);
//        make.height.width.offset(62);
//    }];
//    
//    return superView;
//}
//- (void)clickHeaderDownloadBtn:(UIButton *)sender {
//    
//    BXGCourseModel *courseModel = self.courseDetailViewModel.courseModel;
//    BXGCourseOutlinePointModel *pointModel = self.currentPlayVideoModel.superPointModel;
//    BXGCourseOutlineVideoModel *videoModel = self.currentPlayVideoModel;
//    
//    
//    if(!courseModel || !pointModel || !videoModel){
//        
//        NSLog(@"参数异常");
//        return;
//    }
//    
//    
//    [[BXGDownloader shareInstance] startDownloadCourseModel:courseModel pointModel:pointModel withVideoModel:videoModel notifyBlock:^(BXGDownloadBaseModel *downloadModel) {
//        NSString *strProgress = [NSString stringWithFormat:@"%f", downloadModel.progress];
//        NSLog(@"downloadModel. progress=%@", [NSString stringWithFormat:@"%f", downloadModel.progress]);
//        [sender setTitle:strProgress forState:UIControlStateNormal];
//    }];
//}
//
//
//- (void)clickPlayerLock:(BXGPlayerLockBtn *)sender {
//    
//    if(self.isLock) {
//        
//        // 按钮状态
//        sender.condition = BXGPlayerLockBtnTypeNoLocked;
//        
//        // 显示头部控件和底部控件
//        
//        self.playerFooterView.hidden = false;
//        self.playerHeaderView.hidden = false;
//        
//        
//    }else {
//        
//        // 隐藏按钮状态
//        sender.condition = BXGPlayerLockBtnTypeLocked;
//        
//        // 头部控件和底部控件
//        
//        
//        self.playerFooterView.hidden = true;
//        self.playerHeaderView.hidden = true;
//        
//    }
//    self.isLock = !self.isLock;
//    
//}
//
//- (void)clickChangeSizeBtn:(UIButton *)sender {
//    
//    if(self.isMediaScreenFull == true){
//        
//        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
//        self.isMediaScreenFull = false;
//    }else {
//        
//        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
//        self.isMediaScreenFull = true;
//    }
//    
//}
//
//// 请求视频
//
//// 暂停视频
//- (void)playCurrentVideo; {
//    
//    [self.player play];
//}
//- (void)pauseCurrentVideo; {
//    
//    [self.player pause];
//}
//// 播放视频
//
//- (void)clickPlayerPlayBtn:(UIButton *)sender {
//    
//    if(self.player.playing) {
//        
//        if(self.player.player.currentItem && self.player.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
//            
//            [self pauseCurrentVideo];
//            
//        }else {
//            
//            [self cancle];
//        }
//        
//    }else {
//        
//        if(self.player.player.currentItem && self.player.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
//            
//            [self playCurrentVideo];
//            
//        }else {
//            
//            //[self play];
//            
//        }
//    }
//    
//    
//#warning TODO:
//    
//}
//
//- (void)cancle {
//    
//    [self.player pause];
//    [self.player reset];
//    [self.player cancelRequestPlayInfo];
//}
//
////- (void)play {
////
////    __weak typeof(self) weakSelf = self;
////
////    // 更新学习状态
////    [self checkUserStudyState];
////
////    // set player
////    self.isSeeking = false;
////
////    [self.player pause];
////    [self.player reset];
////    [self.player cancelRequestPlayInfo];
////
////    self.player.getPlayUrlsBlock = ^(NSDictionary *playUrls) {
////
////        NSNumber *status = [playUrls objectForKey:@"status"];
////
////        if (status == nil || [status integerValue] != 0) {
////            NSLog(@"审核未通过");
////            return;
////        }
////
////        // 判断是否是VR
////        NSNumber *vrmode =[playUrls objectForKey:@"vrmode"];
////
////        if (vrmode == nil || [vrmode integerValue] != 0) {
////            NSLog(@"审核未通过");
////            return;
////        }
////
////        // 获得最清晰的分辨率的URL
////        NSArray *qualityArray = [playUrls objectForKey:@"qualities"];
////        if(qualityArray == nil || qualityArray.count <= 0){
////
////            NSLog(@"没有视频");
////            return;
////        }
////
////        NSString *urlString = qualityArray.lastObject[@"playurl"];
////        [weakSelf.player setURL:[NSURL URLWithString:urlString]];
////        weakSelf.playerView.player =weakSelf.player;
////        weakSelf.player.delegate =weakSelf;
////        [weakSelf.player setSeekStartTime:0];
////        weakSelf.playerView.player = weakSelf.player;
////
////        [weakSelf.player play];
////    };
////
////    [self.player startRequestPlayInfo];
////
////}
//
//- (void)resumePlay{
//    
//}
//
//#pragma mark - Response
//#warning Response
//- (void)clickPlayerHeaderLearnedBtn:(BXGLearnedBtn *)sender {
//    
//    __weak typeof (self) weakSelf = self;
//    if(!self.currentPlayVideoModel || self.currentPlayVideoModel.study_status.integerValue == BXGStudyStatusFinish){
//        
//        return;
//    }
//    else {
//        
//        BXGConfirmAlertController *alert = [BXGConfirmAlertController confirmWithTitle:@"标记为已学完" message:nil handler:^{
//            
//            // weakSelf.currentPlayVideoModel.study_status = @(BXGStudyStatusFinish);
//            [weakSelf.courseDetailViewModel updateUserStudyStateWithVideoModel:weakSelf.currentPlayVideoModel andState:BXGStudyStatusFinish];
//            sender.condition = BXGLearnedTypeLearned;
//        }];
//        
//        
//        [weakSelf presentViewController:alert animated:true completion:nil];
//        
//    }
//    
//}
//- (void)clickBackBtn:(UIButton *)sender {
//    
//    if(self.isMediaScreenFull){
//        
//        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
//        self.isMediaScreenFull = false;
//        
//    }else {
//        
//        [self.navigationController popViewControllerAnimated:true];
//    }
//}
//
//// -title
//
//// - content
//
//
//// - 当前选择
//
//// - 响应
//
//
//
//// 视频操作
//
//// - 播放视频
//
//// - 暂停视频
//
//// - 倍速
//
//// - 切换进度
//
//// - 切换视频
//
//// - 视频状态
//
//// - HUD
//
//// - 选择清晰度 (没了)
//
//#pragma mark - 播放器控件
//
//
//#pragma mark - 播放器操作
//
//
//
//#pragma mark - SDK Delegate
//
//- (void)videoPlayerView:(DWVideoPlayerView *)videoPlayerView timeDidChange:(CMTime)cmTime;{
//    
//    
//}
//- (void)videoPlayerView:(DWVideoPlayerView *)videoPlayerView loadedTimeRangeDidChange:(float)duration;{}
//- (void)videoPlayerViewPlaybackBufferEmpty:(DWVideoPlayerView *)videoPlayerView;{}
//- (void)videoPlayerViewPlaybackLikelyToKeepUp:(DWVideoPlayerView *)videoPlayerView;{}
//- (void)videoPlayerView:(DWVideoPlayerView *)videoPlayerView didFailWithError:(NSError *)error;{}
//
//// 可播放／播放中
//- (void)videoPlayerIsReadyToPlayVideo:(DWVideoPlayer *)videoPlayer;{
//    
//    self.isSeeking = false;
//    
//    double durSec =CMTimeGetSeconds(self.player.player.currentItem.duration);
//    double switchTime = durSec * self.trackingSeekPercent;
//    
//    if(switchTime > 0 && switchTime <= durSec) {
//        
//        [self.player seekToTime:switchTime];
//        self.trackingSeekPercent = 0;
//    }
//    //
//    //
//    //    _isSwitchVideo =NO;
//    
//}
//
////播放完毕
//- (void)videoPlayerDidReachEnd:(DWVideoPlayer *)videoPlayer;{
//    
//    __weak typeof (self) weakSelf = self;
//    
//    
//    self.isSeeking = false;
//    
//    
//    // 1.更新学习状态为已学完
//    
//    if(self.currentPlayVideoModel) {
//        
//        NSString *videoId = self.currentPlayVideoModel.idx;
//        NSString *courseId = self.courseDetailViewModel.courseModel.course_id;
//        
//        [self saveHistoryWithVideoModel:self.currentPlayVideoModel isEnd:true];
//        
//        //        self.selectViewVideoModel.study_status = @1; // 1为已学习
//        //        [self.courseDetailViewModel updateUserStudyStateToFinishWithVideoId:videoId andCourseId:courseId];
//        
//    }
//    
//    
//    // 2.判断有没有下一个视频
//    
//    if(self.selectViewVideoIndex != NSNotFound && self.currentPlayVideoModel.superPointModel && self.currentPlayVideoModel){
//        
//        NSInteger index = self.selectViewVideoIndex;
//        NSInteger count = self.currentPlayVideoModel.superPointModel.videos.count;
//        
//        if(index + 1 < count) {
//            
//            self.selectViewVideoIndex = index + 1;
//            // - 有继续播
//            
//            // 设置新的index 播放
//            self.currentPlayVideoModel = self.currentPlayVideoModel.superPointModel.videos[self.selectViewVideoIndex];
//            
//            [self playWithVideoModel:self.currentPlayVideoModel];
//            
//            // 更新 课程大纲
//            [self.listVC updateCurrentVideoModel:self.currentPlayVideoModel];
//            
//            // 更新 选集菜单
//            [self.selectVideoTableView reloadData];
//            
//        }else {
//            
//            // 弹出需要下一个
//            BXGCourseOutlinePointModel *nextPointModel = [self.courseDetailViewModel nextOutlinePointModel:self.currentPlayVideoModel.superPointModel];
//            
//            
//            
//            
//            if(nextPointModel) {
//                
//                
//                // 弹出提示框
//                
//                // - YES 跳转到下一个
//                BXGConfirmAlertController *alertVC = [BXGConfirmAlertController confirmWithTitle:@"是否要调到下一个知识点" message:nil handler:^{
//                    
//                    
//                    BXGCourseOutlineVideoModel *nextVideoModel= [weakSelf.courseDetailViewModel firseOutlineVideoModel:nextPointModel];
//                    if(nextVideoModel){
//                        
//                        weakSelf.currentPlayVideoModel.superPointModel = nextPointModel;
//                        weakSelf.currentPlayVideoModel = nextVideoModel;
//                        [weakSelf playVideo:nextVideoModel.video_id];
//                        // 更新 课程大纲
//                        [weakSelf.listVC updateCurrentVideoModel:self.currentPlayVideoModel];
//                        
//                        // 更新 选集菜单
//                        [weakSelf.selectVideoTableView reloadData];
//                        
//                    }else {
//                        
//                        NSLog(@"异常");
//                    }
//                    
//                }];
//                
//                [self presentViewController:alertVC animated:true completion:nil];
//                
//                // - NO 不做处理
//                
//            }
//            
//        }
//    }
//    
//    
//    
//    
//    
//    // 变量: 当前播放的index
//    
//    // 变量: 当前播放的indexCount
//    
//    
//    // - 没有查看下一个点
//    
//    // - 在没有显示无更多视频
//    
//    // 3.移除观看记录
//}
////当前播放时间 已经切换到主线程 可直接更新UI
//- (void)videoPlayer:(DWVideoPlayer *)videoPlayer timeDidChange:(CMTime)cmTime;{
//    
//}
//
////duration 当前缓冲的长度
//- (void)videoPlayer:(DWVideoPlayer *)videoPlayer loadedTimeRangeDidChange:(float)duration;{
//    
//    NSLog(@"%zd",duration);
//}
//
////进行跳转后没数据 即播放卡顿
//- (void)videoPlayerPlaybackBufferEmpty:(DWVideoPlayer *)videoPlayer;{}
//
//// 进行跳转后有数据 能够继续播放
//- (void)videoPlayerPlaybackLikelyToKeepUp:(DWVideoPlayer *)videoPlayer;{}
//
////加载失败
//- (void)videoPlayer:(DWVideoPlayer *)videoPlayer didFailWithError:(NSError *)error;{}
//
//
//#pragma mark - KVO
//#pragma mark---观察者方法 player的播放 暂停属性
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    
//    if (object == self.player) {
//        
//        if ([keyPath isEqualToString:@"playing"]) {
//            
//            BOOL isPlaying =[[change objectForKey:@"new"] boolValue];
//            
//            //播放
//            if (isPlaying) {
//                
//                self.isSeeking = false;
//                self.playerPlayBtn.condition = BXGPlayerPlayBtnTypePlaying;
//                self.playerBigPlayBtn.condition = BXGPlayerBigPlayBtnTypePlaying;
//                
//                
//            }else{
//                //暂停
//                self.playerPlayBtn.condition = BXGPlayerPlayBtnTypeStop;
//                self.playerBigPlayBtn.condition = BXGPlayerBigPlayBtnTypeStop;
//                
//            }
//        }
//        
//    }
//    
//}
//
//#pragma mark - 检测网络状态
//
//
//#pragma mark - 添加监听
//
//- (void)uninstallObserver;{
//    
//    // 播放状态
//    
//    [self.player removeObserver:self forKeyPath:@"playing"];
//    
//    // 通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    
//    // 计数器
//    [self.playerTimer invalidate];
//    self.playerTimer = nil;
//    
//    // 移除监听网络状态
//    [BXGNotificationTool removeObserver:self];
//}
//
//- (void)installObserver;{
//    
//    // 计时器
//    
//    self.playerTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(playerTimerIntervalOperation) userInfo:nil repeats:true];
//    
//    [[NSRunLoop currentRunLoop] addTimer:_playerTimer forMode:NSRunLoopCommonModes];
//    
//    
//    // 设备旋转
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(catchDeviceOrientationChange)
//                                                 name:UIDeviceOrientationDidChangeNotification
//                                               object:nil
//     ];
//    
//    [self.player addObserver:self forKeyPath:@"playing" options:NSKeyValueObservingOptionNew context:nil];
//    
//    // 监听网络状态
//    [BXGNotificationTool addObserverForReachability:self];
//    
//}
//
//
//
@end
