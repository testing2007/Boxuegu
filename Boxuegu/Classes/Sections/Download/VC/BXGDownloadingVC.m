//
//  BXGDownloadingVC.m
//  Boxuegu
//
//  Created by apple on 2017/8/3.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGDownloadingVC.h"
#import "DWTableView.h"
#import "BXGDownloadingNoneditBottomView.h"
#import "BXGDownloadingEditBottomView.h"
#import "BXGDownloadingCell.h"
#import "BXGDownloadModel.h"
#import "BXGResourceManager.h"
#import "BXGDownloader.h"
#import "BXGDownloadManagerDelegate.h"
#import "BXGDownloadedCourseVideoSelectPageVC.h"
#import "BXGSwitchScrollView.h"
#import "BXGMaskView.h"
#import "UIBarButtonItem+Common.h"

@interface BXGDownloadingVC ()

@property (strong, nonatomic)DWTableView *downloadingTableView;
@property (strong, nonatomic)BXGDownloadingNoneditBottomView *downloadingNoneditBottomView;
@property (strong, nonatomic)BXGDownloadingEditBottomView *downloadingEditBottomView;
@property (assign, nonatomic)BOOL bEdit;
@property (strong, nonatomic)NSMutableDictionary *dictSelDownloading;//key=videoIdx, value=BXGDownloadModel

@property (strong, nonatomic)UIBarButtonItem *leftDownloadingSelectAllBarButtonItem;
@property (strong, nonatomic)UIBarButtonItem *leftBackBarButtonItem;
@property (strong, nonatomic)UIBarButtonItem *rightEditBarButtonItem;
@property (strong, nonatomic)UIBarButtonItem *rightCancelBarButtonItem;

@end

@implementation BXGDownloadingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    // Do any additional setup after loading the view.
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.bEdit = NO;
    self.dictSelDownloading = [NSMutableDictionary new];
    _leftDownloadingSelectAllBarButtonItem = [UIBarButtonItem createBarButtonItemWithTitle:@"全选" withImage:nil withTarget:self withAction:@selector(onSelectAll:)];
    _leftBackBarButtonItem = self.parentViewController.navigationItem.leftBarButtonItem;
    _rightEditBarButtonItem = [UIBarButtonItem createBarButtonItemWithTitle:@"编辑" withImage:nil withTarget:self withAction:@selector(onEdit:)];
    _rightCancelBarButtonItem = [UIBarButtonItem createBarButtonItemWithTitle:@"取消" withImage:nil withTarget:self withAction:@selector(onEdit:)];
    self.navigationItem.rightBarButtonItem = _rightEditBarButtonItem;
//    self.parentViewController.navigationItem.leftBarButtonItem = self.navigationItem.leftBarButtonItem;
//    self.parentViewController.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    
    // 加载下载中tableView 和 下载已完成tableView
    [self loadDownloadingTableView];
    
    self.downloadingEditBottomView = [BXGDownloadingEditBottomView acquireCustomView];
    self.downloadingEditBottomView.delegate = self.parentViewController;
    self.downloadingNoneditBottomView = [BXGDownloadingNoneditBottomView acquireCustomView];
    self.downloadingNoneditBottomView.delegate = self.parentViewController;
    
    [self.view addSubview:_downloadingTableView];
    [self.view addSubview:_downloadingEditBottomView];
    [self.view addSubview:_downloadingNoneditBottomView];

    //[self adjustLayout];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self adjustLayout];
    [super viewWillAppear:animated];
}

- (void)loadDownloadingTableView
{
    self.downloadingTableView = [[DWTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.downloadingTableView registerNib:[UINib nibWithNibName:@"BXGDownloadingCell" bundle:nil] forCellReuseIdentifier:@"BXGDownloadingCell"];
    
    _downloadingTableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    _downloadingTableView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
    _downloadingTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    __weak typeof(self) weakSelf = self;
    //    __block BOOL bRefreshEmpty = NO;
    self.downloadingTableView.tableViewNumberOfRowsInSection = ^NSInteger(UITableView *tableView, NSInteger section) {
        NSInteger nCount = 0;
        NSDictionary *dictDownloading = [BXGResourceManager shareInstance].dictDownloading;
        NSArray* arrDownloading = dictDownloading.allKeys;
        if(arrDownloading)
        {
            nCount = arrDownloading.count ;
        }
        //        if(nCount==0)
        //        {
        //            bRefreshEmpty = YES;
        //            nCount = 20;//返回最够大,以覆盖一页大小,防止下载完成后,正在下载数据源为空,不能刷新界面的情况.
        //        }
        NSLog(@"self.downloadingTableView.tableViewNumberOfRowsInSection=%ld", nCount);
        return nCount;
        //        return 100;
    };
    self.downloadingTableView.tableViewCellForRowAtIndexPath = ^UITableViewCell*(UITableView *tableView, NSIndexPath *indexPath) {
        NSDictionary *dictDownloading = [BXGResourceManager shareInstance].dictDownloading;
        NSArray* arrDownloading = dictDownloading.allKeys;
        static NSString *cellId = @"BXGDownloadingCell";
        BXGDownloadingCell *cell = (BXGDownloadingCell *)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        if(arrDownloading && arrDownloading.count>0 && indexPath.row<arrDownloading.count)
        {
            NSString *videoIdxKey = arrDownloading[indexPath.row];
            BXGDownloadModel *model = dictDownloading[videoIdxKey];
            [cell setupCell:model withIndexPath:indexPath];
            
            UIImage *imageIcon = [weakSelf getSelectImageById:videoIdxKey];
            [cell showSelectImage:imageIcon];
        }
        cell.delegate = (id<BXGDownloadManagerDelegate>)(weakSelf.parentViewController);
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
        return cell;
    };
    
    self.downloadingTableView.tableViewHeightForRowAtIndexPath = ^CGFloat(UITableView *tableView, NSIndexPath* indexPath) {
        return 76.0f;
    };
    
    self.downloadingTableView.numberOfSectionsInTableView = ^NSInteger(UITableView *tableView){
        return 1;
    };
    
    self.downloadingTableView.tableViewWillDisplayCellForRowAtIndexPath = ^(UITableView* tableView, UITableViewCell* cell, NSIndexPath* indexPath)
    {
        BXGDownloadingCell *downloadingCell = (BXGDownloadingCell*)cell;
        if(downloadingCell!=nil)
        {
            BXGDownloadModel* downloadModelItem = downloadingCell.model;
            if(downloadModelItem!=nil && !downloadingCell.bRegister)
            {
                [downloadModelItem.downloadBaseModel addObserver:cell
                                                      forKeyPath:@"state"
                                                         options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
                                                         context:nil];
                [downloadModelItem.downloadBaseModel addObserver:cell
                                                      forKeyPath:@"totalBytesWritten"
                                                         options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
                                                         context:nil];
                downloadingCell.bRegister = YES;
            }
        }
    };
    self.downloadingTableView.tablViewDidEndDisplayingCellForRowAtIndexPath = ^(UITableView* tableView, UITableViewCell* cell, NSIndexPath* indexPath)
    {
        BXGDownloadingCell *downloadingCell = (BXGDownloadingCell*)cell;
        if(downloadingCell!=nil)
        {
            BXGDownloadModel* downloadModelItem = downloadingCell.model;
            if(downloadModelItem!=nil && downloadingCell.bRegister)
            {
                [downloadModelItem.downloadBaseModel removeObserver:cell forKeyPath:@"state"];
                [downloadModelItem.downloadBaseModel removeObserver:cell forKeyPath:@"totalBytesWritten"];
                downloadingCell.bRegister = NO;
            }
        }
    };
    
    self.downloadingTableView.tableViewDidSelectRowAtIndexPath = ^(UITableView *tableView, NSIndexPath *indexPath)
    {
        if(weakSelf.bEdit)
        {
            if(weakSelf.dictSelDownloading)
            {
                NSDictionary *dictDownloading = [BXGResourceManager shareInstance].dictDownloading;
                NSArray* arrDownloading = dictDownloading.allKeys;
                NSString *curSelRowKey = arrDownloading[indexPath.row];
                
                NSArray *arrKeys = weakSelf.dictSelDownloading.allKeys;
                if(arrKeys && [arrKeys containsObject:curSelRowKey])
                {
                    [weakSelf.dictSelDownloading removeObjectForKey:curSelRowKey];
                    [weakSelf.downloadingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
                else
                {
                    BXGDownloadModel *model = dictDownloading[curSelRowKey];
                    [weakSelf.dictSelDownloading setObject:model forKey:curSelRowKey];
                    [weakSelf.downloadingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
                NSArray *arrSelKeys =  weakSelf.dictSelDownloading.allKeys;
                if(arrSelKeys && arrSelKeys.count>0)
                {
                    [weakSelf.downloadingEditBottomView setEnableDelete:YES];
                    
                    if(arrSelKeys.count == arrDownloading.count)
                    {
                        [weakSelf.leftDownloadingSelectAllBarButtonItem setTitle:@"全不选"];
                    }
                    else
                    {
                        [weakSelf.leftDownloadingSelectAllBarButtonItem setTitle:@"全选"];
                    }
                }
                else
                {
                    [weakSelf.leftDownloadingSelectAllBarButtonItem setTitle:@"全选"];
                    [weakSelf.downloadingEditBottomView setEnableDelete:NO];
                }
            }
        }
    };
    [self.downloadingTableView resetDelegate];
}

-(UIImage*)getSelectImageById:(NSString*)keyId
{
    if(_bEdit)
    {
        UIImage* retImage=nil;
        NSArray* arrKeys = self.dictSelDownloading.allKeys;
        if(arrKeys && arrKeys.count>0 && [arrKeys containsObject:keyId])
        {
            retImage = [UIImage imageNamed:@"多选-选中"];
        }
        else
        {
            retImage = [UIImage imageNamed:@"多选-未选中"];
        }
        return retImage;
    }
    return nil;
}

-(void)dealloc
{
    NSArray *cells = [self.downloadingTableView visibleCells];
    for(int i=0; i<cells.count; ++i)
    {
        BXGDownloadingCell *cell = (BXGDownloadingCell*)cells[i];
        if(cell.bRegister)
        {
            [cell.model.downloadBaseModel removeObserver:cell forKeyPath:@"state"];
            [cell.model.downloadBaseModel removeObserver:cell forKeyPath:@"totalBytesWritten"];
            cell.bRegister =  NO;
        }
    }
    NSLog(@"BXGDownloadingVC dealloc");
}

-(void)adjustLayout
{
    NSDictionary *dictDownloading = [BXGResourceManager shareInstance].dictDownloading;
    if(dictDownloading && dictDownloading.count==0)
    {
        return [self reloadEmptyView];
    }
    
    _downloadingTableView.hidden = NO;
    _downloadingEditBottomView.hidden = NO;
    _downloadingNoneditBottomView.hidden = NO;
    if(_bEdit)
    {
        _downloadingEditBottomView.hidden = NO;
        _downloadingNoneditBottomView.hidden = YES;
        
        [self.downloadingTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.bottom.offset(-55 - kBottomHeight);
        }];
        [self.downloadingEditBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.downloadingTableView.mas_bottom).offset(0);
            make.left.right.offset(0);
            make.bottom.offset(-kBottomHeight);
        }];
    }
    else
    {
        _downloadingEditBottomView.hidden = YES;
        _downloadingNoneditBottomView.hidden = NO;
        [self.downloadingTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.bottom.offset(-55 - kBottomHeight);
        }];
        [self.downloadingNoneditBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.downloadingTableView.mas_bottom).offset(0);
            make.left.right.offset(0);
            make.bottom.offset(-kBottomHeight);
        }];
    }
    [self refreshTableViewData];
}

-(void)refreshTableViewData
{
    if(_downloadingTableView)
    {
        [_downloadingTableView reloadData];
    }
}

-(void)onSelectAll:(UIBarButtonItem*)sender
{
    //[self restorePrevBarButtonItemStatus];
    
    NSLog(@"BXGDownloadManagerVC onSelectAll");
    NSAssert(_bEdit, @"current page does lie in edit mode");
    
    if([sender.title isEqualToString:@"全选"])
    {
        NSDictionary *dictDownloading = [BXGResourceManager shareInstance].dictDownloading;
        NSArray *arrDownloading = dictDownloading.allValues;
        if(arrDownloading && arrDownloading.count>0)
        {
            for(BXGDownloadModel* item in arrDownloading)
            {
                [_dictSelDownloading setObject:item forKey:item.downloadBaseModel.videoModel.idx];
            }
            if(_dictSelDownloading.count>0)
            {
                [_downloadingEditBottomView setEnableDelete:YES];
            }
            [_downloadingTableView reloadData];
        }
        sender.title = @"全不选";
    }
    else
    {
        [self.dictSelDownloading removeAllObjects];
        [_downloadingEditBottomView setEnableDelete:NO];
        sender.title = @"全选";
        [_downloadingTableView reloadData];
    }
    
    //[self recordPrevBarButtonItemStatus];
}

-(void)onEdit:(UIBarButtonItem*)sender
{
    NSLog(@"onEdit");
    
    //[self restorePrevBarButtonItemStatus];
    
    UIBarButtonItem* editBarItem = (UIBarButtonItem*)sender;
    if([editBarItem.title isEqualToString:@"编辑"])
    {
        NSDictionary *dictDownloading = [BXGResourceManager shareInstance].dictDownloading;
        if(!dictDownloading || dictDownloading.count<=0)
        {
            [[BXGHUDTool share] showHUDWithString:@"没有可编辑的资源"];
            return ;
        }
        [_leftDownloadingSelectAllBarButtonItem setTitle:@"全选"];
        self.navigationItem.leftBarButtonItem = _leftDownloadingSelectAllBarButtonItem;
        self.navigationItem.rightBarButtonItem = _rightCancelBarButtonItem;
        //在ios11中, 必须要先将其置为nil, 然后再赋值, 否则第二次切换的时候就会出现变得暗淡
        self.parentViewController.navigationItem.leftBarButtonItem = nil;
        self.parentViewController.navigationItem.rightBarButtonItem = nil;
        self.parentViewController.navigationItem.leftBarButtonItem = _leftDownloadingSelectAllBarButtonItem;
        self.parentViewController.navigationItem.rightBarButtonItem = _rightCancelBarButtonItem;
        _bEdit = YES;
    }
    else
    {
        [self.dictSelDownloading removeAllObjects];
        self.navigationItem.leftBarButtonItem = _leftBackBarButtonItem;
        self.navigationItem.rightBarButtonItem = _rightEditBarButtonItem;
        //在ios11中, 必须要先将其置为nil, 然后再赋值, 否则第二次切换的时候就会出现变得暗淡
        self.parentViewController.navigationItem.leftBarButtonItem = nil;
        self.parentViewController.navigationItem.rightBarButtonItem = nil;
        self.parentViewController.navigationItem.leftBarButtonItem = _leftBackBarButtonItem;
        self.parentViewController.navigationItem.rightBarButtonItem = _rightEditBarButtonItem;
        _bEdit = NO;
    }
    if(_bEdit)
    {
        [[BXGDownloader shareInstance] suspendAllDownload];//暂停所有正在执行的下载
    }
    
    //[self recordPrevBarButtonItemStatus];
    
    [self adjustLayout];
    
    if(_bEdit)
    {
        NSAssert(self.dictSelDownloading, @"self.dictSelDownloading is nil");
        if(self.dictSelDownloading.count>0)
        {
            [self.downloadingEditBottomView setEnableDelete:YES];
        }
        else
        {
            [self.downloadingEditBottomView setEnableDelete:NO];
        }
    }
}

-(UIBarButtonItem*)rightBarButtonItem
{
    [self handleBarButtonItem];
    return self.navigationItem.rightBarButtonItem;
}

-(UIBarButtonItem*)leftBarButtonItem
{
    [self handleBarButtonItem];
    return self.navigationItem.leftBarButtonItem;
}

-(void)handleBarButtonItem
{
    if([BXGResourceManager shareInstance].dictDownloading.count==0)
    {
        self.navigationItem.leftBarButtonItem = _leftBackBarButtonItem;
        self.navigationItem.rightBarButtonItem = nil;
    }
    else if(_bEdit)
    {
        self.navigationItem.leftBarButtonItem = _leftDownloadingSelectAllBarButtonItem;
        self.navigationItem.rightBarButtonItem = _rightCancelBarButtonItem;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = _leftBackBarButtonItem;
        self.navigationItem.rightBarButtonItem = _rightEditBarButtonItem;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadEmptyView
{
    self.navigationItem.leftBarButtonItem = _leftBackBarButtonItem;
    self.navigationItem.rightBarButtonItem = nil;
//    self.parentViewController.navigationItem.leftBarButtonItem = self.navigationItem.leftBarButtonItem;
//    self.parentViewController.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    _bEdit = NO;
    [self.view installMaskView:BXGMaskViewTypeDownloadingEmpty];
    //    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.top.left.right.bottom.offset(0);
    //    }];
}

-(void)doConfirmDelete
{
        if(self.dictSelDownloading && self.dictSelDownloading.count<=0)
        {
            return ;
        }
    //正在下载, 确认删除
    [[BXGDownloader shareInstance] removeDownloadingVideos:self.dictSelDownloading.allValues];
    [self.dictSelDownloading removeAllObjects];
    //        _seledTotalSpace = 0;
    [self.downloadingTableView reloadData];
    if([BXGResourceManager shareInstance].dictDownloading.count==0)
    {
        [_downloadingEditBottomView setEnableDelete:NO];
    }
    /*
    if([[BXGResourceManager shareInstance] dictDownloading].count==0)
    {
        //            self.navigationItem.leftBarButtonItem = _leftBackBarButtonItem;
        //            self.navigationItem.rightBarButtonItem = [UIBarButtonItem new];
        //            _bEdit = NO;
        return [self reloadEmptyView];
    }
    
    //用户快速切换 正在下载/已下载 的话,会不会出现问题, 还是要把这个代理方法拆开
    BXGConfirmAlertController *vc = [BXGConfirmAlertController confirmWithTitle:nil message:@"确定要删除视频么?" handler:^{
    }];
    [self presentViewController:vc animated:true completion:nil];
     //*/
}

-(void)doAllPause
{
    //检测无网络情况
    BXGReachabilityStatus status= [[BXGNetWorkTool sharedTool] getReachState];
    if(status == BXGReachabilityStatusReachabilityStatusNotReachable) {
        [[BXGHUDTool share]showHUDWithString:kBXGToastNonNetworkTip];
        return ;
    }
    
    //正在下载 非编辑模式下: 全部暂停
    if(!_bEdit)
    {
        static NSTimeInterval preTimeInterval = 0;
        NSTimeInterval curTimeInterval =  [NSDate date].timeIntervalSince1970;
        if(preTimeInterval==0 || curTimeInterval-preTimeInterval>0.2)
        {
            preTimeInterval = curTimeInterval;
            [[BXGDownloader shareInstance] suspendAllDownload];
        }
    }
}

-(void)doAllStart
{
    //检测无网络情况
    BXGReachabilityStatus status= [[BXGNetWorkTool sharedTool] getReachState];
    if(status == BXGReachabilityStatusReachabilityStatusNotReachable) {
        [[BXGHUDTool share]showHUDWithString:kBXGToastNonNetworkTip];
        return ;
    }
    
    //正在下载 非编辑模式下: 全部开始
    if(!_bEdit)
    {
        static NSTimeInterval preTimeInterval = 0;
        NSTimeInterval curTimeInterval =  [NSDate date].timeIntervalSince1970;
        if(preTimeInterval==0 || curTimeInterval-preTimeInterval>0.2)
        {
            preTimeInterval = curTimeInterval;
            [[BXGDownloader shareInstance] startAllDownload];
        }
    }
}
#pragma mark -- end BXGDownloadManagerDelegate

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
