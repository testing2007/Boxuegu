//
//  BXGDownloadManagerVC.m
//  Demo
//
//  Created by apple on 17/6/10.
//  Copyright © 2017年 com.bokecc.www. All rights reserved.
//

#import "BXGDownloadManagerVC.h"
#import "BXGResourceManager.h"
//#import "BXGSwitchScrollView.h"
#import "RWTab.h"
#import "BXGMaskView.h"
#import "BXGDownloadedVC.h"
#import "BXGDownloadingVC.h"
#import "BXGDownloadManagerDelegate.h"

@interface BXGDownloadManagerVC ()<BXGDownloadManagerDelegate, RWTabDelegate>

@property (strong, nonatomic)RWTab *segmentedControl;
@property (strong, nonatomic)BXGDownloadedVC *downloadedVC;
@property (strong, nonatomic)BXGDownloadingVC *downloadingVC;

@property (strong, nonatomic)UIBarButtonItem *leftBackBarButtonItem;

@end

@implementation BXGDownloadManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // self.view.backgroundColor = [UIColor colorWithRed:245 green:245 blue:245.0];
//    self.view.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    self.title = @"下载管理";
    self.pageName = @"下载管理页";
    
    _leftBackBarButtonItem = self.navigationItem.leftBarButtonItem;
    
    if([[BXGResourceManager shareInstance] dictDownloading].count==0 && [[BXGResourceManager shareInstance] dictDownloaded].count==0)
    {
        return [self reloadEmptyView];
    }
    //return;
    
    _downloadedVC = [BXGDownloadedVC new];
    _downloadingVC = [BXGDownloadingVC new];
    [self addChildViewController:_downloadingVC];
    [self addChildViewController:_downloadedVC];
    
    // self.segmentedControl = [[BXGSwitchScrollView alloc] init];
    _downloadedVC.view.frame = CGRectZero;
    _downloadingVC.view.frame = CGRectZero;
    self.segmentedControl  = [[RWTab alloc] initWithDetailViewArrary:@[_downloadedVC.view, _downloadingVC.view]
                                                       andTitleArray:@[@"已下载", @"正在下载"]
                                                            andCount:2];
    self.segmentedControl.delegate = self;
    
//    [self.segmentedControl setLeft:@"已下载" andView:_downloadedVC.view];
//    [self.segmentedControl setRight:@"正在下载" andView:_downloadingVC.view];
//    [self.segmentedControl addTarget:self action:@selector(segmentedControlAction:)];
    [self.view addSubview:_segmentedControl];
    [self.segmentedControl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(K_NAVIGATION_BAR_OFFSET);
        make.bottom.left.right.offset(0);
    }];
    return ;
}

-(void)dealloc
{
    NSLog(@"DownloadManagerVC dealloc");
}

-(void)viewDidAppear:(BOOL)animated
{
    [self showSelView];
    [super viewDidAppear:animated];
}

-(void)showSelView
{
    NSDictionary *dictDownloaded = [BXGResourceManager shareInstance].dictDownloaded;
    NSDictionary *dictDownloading = [BXGResourceManager shareInstance].dictDownloading;
    if(dictDownloaded && dictDownloaded.count<=0 &&
       dictDownloading && dictDownloading.count<=0)
    {
        return [self reloadEmptyView];
    }
    // [self.view removeMaskView];
    if(self.segmentedControl.selectedSegmentIndex==0)
    {
        if(!_downloadedVC) {
            return ;
        }
        self.navigationItem.rightBarButtonItem = _downloadedVC.rightBarButtonItem;
        self.navigationItem.leftBarButtonItem = _downloadedVC.leftBarButtonItem;
        [self.downloadedVC adjustLayout];
    }
    else
    {
        if(!_downloadingVC) {
            return ;
        }
        self.navigationItem.rightBarButtonItem = _downloadingVC.rightBarButtonItem;
        self.navigationItem.leftBarButtonItem = _downloadingVC.leftBarButtonItem;
        [self.downloadingVC adjustLayout];
    }
}

-(void)reloadEmptyView
{
    if([[BXGResourceManager shareInstance] dictDownloading].count==0 &&
       [[BXGResourceManager shareInstance] dictDownloaded].count==0)
    {
        self.navigationItem.leftBarButtonItem = _leftBackBarButtonItem;
        self.navigationItem.rightBarButtonItem = nil;
        [self.view installMaskView:BXGMaskViewTypeDownloadEmpty andInset:UIEdgeInsetsMake(K_NAVIGATION_BAR_OFFSET, 0, 0, 0)];
    }
    else if([[BXGResourceManager shareInstance] dictDownloading].count==0)
    {
        [self.downloadingVC reloadEmptyView];
    }
    else if([[BXGResourceManager shareInstance] dictDownloaded].count==0)
    {
        [self.downloadedVC reloadEmptyView];
    }
}

-(void)onChangeAction:(RWTab*)tab
{
    [self showSelView];
    return ;
}
/*
- (void)segmentedControlAction:(BXGSwitchScrollView *)segment
{
    [self showSelView];
    return ;
}
//*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- begin BXGDownloadManagerDelegate
-(void)confirmDelete
{
    //用户快速切换 正在下载/已下载 的话,会不会出现问题, 还是要把这个代理方法拆开
    [[BXGBaiduStatistic share] statisticEventString:scyxzsp andParameter:nil];
    BXGAlertController *vc = [BXGAlertController confirmWithTitle:nil message:@"确定要删除视频么?" handler:^{
        if(self.segmentedControl.selectedSegmentIndex==0)
        {
            [self.downloadedVC doConfirmDelete];
        }
        else
        {
            [self.downloadingVC doConfirmDelete];
        }
        [self showSelView];
    }];
    [self presentViewController:vc animated:true completion:nil];
}

-(void)allPause
{
    if(self.segmentedControl.selectedSegmentIndex==1)
    {
        [self.downloadingVC doAllPause];
    }
}

-(void)allStart
{
    if(self.segmentedControl.selectedSegmentIndex==1)
    {
        [self.downloadingVC doAllStart];
    }
}

-(void)downloadCompleted
{
    if(self.segmentedControl.selectedSegmentIndex==1)
    {
        [self.downloadingVC adjustLayout];
    }
    else
    {
        [self.downloadedVC adjustLayout];
    }
}
#pragma mark -- end BXGDownloadManagerDelegate

@end
