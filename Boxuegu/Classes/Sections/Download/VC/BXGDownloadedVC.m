//
//  BXGDownloadedVC.m
//  Boxuegu
//
//  Created by apple on 2017/8/3.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGDownloadedVC.h"
#import "DWTableView.h"
#import "BXGDownloadedNoneditBottomView.h"
#import "BXGDownloadedEditBottomView.h"
#import "BXGDownloadedCell.h"
#import "BXGDownloadModel.h"
#import "BXGResourceManager.h"
#import "BXGDownloader.h"
#import "BXGDownloadManagerDelegate.h"
#import "BXGDownloadedCourseVideoSelectPageVC.h"
#import "BXGSwitchScrollView.h"
#import "BXGMaskView.h"
#import "UIBarButtonItem+Common.h"

@interface BXGDownloadedVC ()

@property (strong, nonatomic)DWTableView *downloadedTableView;
@property (strong, nonatomic)BXGDownloadedNoneditBottomView *downloadedNoneditBottomView;
@property (strong, nonatomic)BXGDownloadedEditBottomView *downloadedEditBottomView;
@property (assign, nonatomic)BOOL bEdit;
@property (strong, nonatomic)NSMutableDictionary *dictSelDownloaded;//key=courseId, value=BXGDownloadedRenderModel

@property (strong, nonatomic)UIBarButtonItem *leftDownloadedSelectAllBarButtonItem;
@property (strong, nonatomic)UIBarButtonItem *leftBackBarButtonItem;
@property (strong, nonatomic)UIBarButtonItem *rightEditBarButtonItem;
@property (strong, nonatomic)UIBarButtonItem *rightCancelBarButtonItem;

@end

@implementation BXGDownloadedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
//     self.automaticallyAdjustsScrollViewInsets = NO;
    self.bEdit = NO;
    self.dictSelDownloaded = [NSMutableDictionary new];
    _leftDownloadedSelectAllBarButtonItem = [UIBarButtonItem createBarButtonItemWithTitle:@"全选" withImage:nil withTarget:self withAction:@selector(onSelectAll:)];
    _leftBackBarButtonItem = self.parentViewController.navigationItem.leftBarButtonItem;
    _rightEditBarButtonItem = [UIBarButtonItem createBarButtonItemWithTitle:@"编辑" withImage:nil withTarget:self withAction:@selector(onEdit:)];
    _rightCancelBarButtonItem = [UIBarButtonItem createBarButtonItemWithTitle:@"取消" withImage:nil withTarget:self withAction:@selector(onEdit:)];
    self.navigationItem.rightBarButtonItem = _rightEditBarButtonItem;
//    self.parentViewController.navigationItem.leftBarButtonItem = self.navigationItem.leftBarButtonItem;
//    self.parentViewController.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    
    // 加载下载中tableView 和 下载已完成tableView
    [self loadDownloadedTableView];
    
    self.downloadedEditBottomView = [BXGDownloadedEditBottomView acquireCustomView];
    self.downloadedEditBottomView.delegate = (id<BXGDownloadManagerDelegate>)self.parentViewController;
    self.downloadedNoneditBottomView = [BXGDownloadedNoneditBottomView acquireCustomView];
    
    [self.view addSubview:_downloadedTableView];
    [self.view addSubview:_downloadedEditBottomView];
    [self.view addSubview:_downloadedNoneditBottomView];
    
    //[self adjustLayout];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self adjustLayout];
    [super viewWillAppear:animated];
}

-(void)dealloc
{
    NSLog(@"downloaded dealloc");
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
    if([BXGResourceManager shareInstance].dictDownloaded.count==0)
    {
        self.navigationItem.leftBarButtonItem = _leftBackBarButtonItem;
        self.navigationItem.rightBarButtonItem = nil;
    }
    else if(_bEdit)
    {
        self.navigationItem.leftBarButtonItem = _leftDownloadedSelectAllBarButtonItem;
        self.navigationItem.rightBarButtonItem = _rightCancelBarButtonItem;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = _leftBackBarButtonItem;
        self.navigationItem.rightBarButtonItem = _rightEditBarButtonItem;
    }
}

-(void)adjustLayout
{
    NSDictionary *dictDownloaded = [BXGResourceManager shareInstance].dictDownloaded;
    if(dictDownloaded && dictDownloaded.count==0)
    {
        return [self reloadEmptyView];
    }
    [self.view removeMaskView];
    
    _downloadedTableView.hidden = NO;
    if(_bEdit)
    {
        _downloadedEditBottomView.hidden = NO;
        _downloadedNoneditBottomView.hidden = YES;
        [self.downloadedTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.bottom.offset(-55 - kBottomHeight);
        }];
        [self.downloadedEditBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.downloadedTableView.mas_bottom).offset(0);
            make.left.right.offset(0);
            make.bottom.offset(-kBottomHeight);
            
        }];
    }
    else
    {
        _downloadedEditBottomView.hidden = YES;
        _downloadedNoneditBottomView.hidden = NO;
        [self.downloadedTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.bottom.offset(-25 - kBottomHeight);
        }];
        [self.downloadedNoneditBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.downloadedTableView.mas_bottom).offset(0);
            make.left.right.offset(0);
            make.bottom.offset(-kBottomHeight);
        }];
    }
    
    [self refreshTableViewData];
}

-(void)refreshTableViewData
{
    if(_downloadedTableView)
    {
        [_downloadedTableView reloadData];
    }
}

-(void)onSelectAll:(UIBarButtonItem*)sender
{
    if([sender.title isEqualToString:@"全选"])
    {
        //已下载
        //NSDictionary *dictDownloaded = [BXGResourceManager shareInstance].dictDownloaded;
        NSDictionary *dictDownloadedRender = [BXGResourceManager shareInstance].dictDownloadedRender;
        NSArray *arrDownloaded = dictDownloadedRender.allValues;
        if(arrDownloaded && arrDownloaded.count>0)
        {
            for(BXGDownloadedRenderModel* item in arrDownloaded)
            {
                [_dictSelDownloaded setObject:item forKey:item.courseModel.course_id];
            }
            if(_dictSelDownloaded.count>0)
            {
                [_downloadedEditBottomView setEnableDelete:YES];
            }
            [_downloadedTableView reloadData];
        }
        sender.title = @"全不选";
    }
    else
    {
        [self.dictSelDownloaded removeAllObjects];
        [_downloadedEditBottomView setEnableDelete:NO];
        sender.title = @"全选";
        [_downloadedTableView reloadData];
    }
}

-(void)onEdit:(UIBarButtonItem*)sender
{
    NSLog(@"onEdit");
    UIBarButtonItem* editBarItem = (UIBarButtonItem*)sender;
    if([editBarItem.title isEqualToString:@"编辑"])
    {
        NSDictionary *dictDownloaded = [BXGResourceManager shareInstance].dictDownloaded;
        if(!dictDownloaded || dictDownloaded.count<=0)
        {
            [[BXGHUDTool share] showHUDWithString:@"没有可编辑的资源"];
            return ;
        }
        [_leftDownloadedSelectAllBarButtonItem setTitle:@"全选"];
        self.navigationItem.leftBarButtonItem = _leftDownloadedSelectAllBarButtonItem;
        self.navigationItem.rightBarButtonItem = _rightCancelBarButtonItem;
        //在ios11中, 必须要先将其置为nil, 然后再赋值, 否则第二次切换的时候就会出现变得暗淡
        self.parentViewController.navigationItem.leftBarButtonItem = nil;
        self.parentViewController.navigationItem.rightBarButtonItem = nil;
        self.parentViewController.navigationItem.leftBarButtonItem = _leftDownloadedSelectAllBarButtonItem;
        self.parentViewController.navigationItem.rightBarButtonItem = _rightCancelBarButtonItem;
        _bEdit = YES;
    }
    else
    {
        //之前选中的要给清空
        [self.dictSelDownloaded removeAllObjects];
        self.navigationItem.leftBarButtonItem = _leftBackBarButtonItem;
        self.navigationItem.rightBarButtonItem = _rightEditBarButtonItem;
        //在ios11中, 必须要先将其置为nil, 然后再赋值, 否则第二次切换的时候就会出现变得暗淡
        self.parentViewController.navigationItem.leftBarButtonItem = nil;
        self.parentViewController.navigationItem.rightBarButtonItem = nil;
        self.parentViewController.navigationItem.leftBarButtonItem = _leftBackBarButtonItem;
        self.parentViewController.navigationItem.rightBarButtonItem = _rightEditBarButtonItem;
        _bEdit = NO;
    }
    
    [self adjustLayout];
    
    if(_bEdit)
    {
        NSAssert(self.dictSelDownloaded, @"self.dictSelDownloaded is nil");
        if(self.dictSelDownloaded.count>0)
        {
            [self.downloadedEditBottomView setEnableDelete:YES];
        }
        else
        {
            [self.downloadedEditBottomView setEnableDelete:NO];
        }
    }
}

- (void)loadDownloadedTableView
{
    logdebug(@"self.downloadedTableView.frame: %@", NSStringFromCGRect(self.downloadedTableView.frame));
    
    self.downloadedTableView = [[DWTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.downloadedTableView registerNib:[UINib nibWithNibName:@"BXGDownloadedCell" bundle:nil] forCellReuseIdentifier:@"BXGDownloadedCell"];
    
    _downloadedTableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    _downloadedTableView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
    _downloadedTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    __weak typeof(self) weakSelf = self;
    self.downloadedTableView.tableViewNumberOfRowsInSection = ^NSInteger(UITableView *tableView, NSInteger section) {
        NSDictionary *dictDownloadedRender = [BXGResourceManager shareInstance].dictDownloadedRender;
        NSArray* arrDownloadedRender = dictDownloadedRender.allKeys;
        if(arrDownloadedRender)
        {
            return arrDownloadedRender.count ;
        }
        return 0;
    };
    self.downloadedTableView.tableViewCellForRowAtIndexPath = ^UITableViewCell*(UITableView *tableView, NSIndexPath *indexPath) {
        NSDictionary *dictDownloadedRender = [BXGResourceManager shareInstance].dictDownloadedRender;
        NSArray* arrDownloadedRender = dictDownloadedRender.allKeys;
        static NSString *cellId = @"BXGDownloadedCell";
        BXGDownloadedCell *cell = (BXGDownloadedCell *)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        if(arrDownloadedRender && arrDownloadedRender.count>0)
        {
            NSString *courseId = arrDownloadedRender[indexPath.row];
            BXGDownloadedRenderModel *model = dictDownloadedRender[courseId];
            [cell setupCell:model];
            
            UIImage *imageIcon = [weakSelf getSelectImageById:courseId];
            [cell showSelectImage:imageIcon];
        }
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
        return cell;
    };
    
    self.downloadedTableView.tableViewHeightForRowAtIndexPath = ^CGFloat(UITableView *tableView, NSIndexPath* indexPath) {

        return 76.0f/320.f * [UIScreen mainScreen].bounds.size.width ;
    };
    
    self.downloadedTableView.numberOfSectionsInTableView = ^NSInteger(UITableView *tableView){
        return 1;
    };
    
    self.downloadedTableView.tableViewDidSelectRowAtIndexPath = ^(UITableView *tableView, NSIndexPath *indexPath)
    {
        if(weakSelf.bEdit)
        {
                NSDictionary *dictDownloaded = [BXGResourceManager shareInstance].dictDownloadedRender;
                NSArray* arrDownloaded = dictDownloaded.allKeys;
                NSString *curSelRowKey = arrDownloaded[indexPath.row];
                
                NSArray *arrKeys = weakSelf.dictSelDownloaded.allKeys;//courseId
                if(arrKeys && [arrKeys containsObject:curSelRowKey])
                {
                    [weakSelf.dictSelDownloaded removeObjectForKey:curSelRowKey];
                    [weakSelf.downloadedTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
                else
                {
                    BXGDownloadedRenderModel *model = dictDownloaded[curSelRowKey];
                    [weakSelf.dictSelDownloaded setObject:model forKey:curSelRowKey];
                    [weakSelf.downloadedTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }

            NSArray *arrSelKeys =  weakSelf.dictSelDownloaded.allKeys;
            if(arrSelKeys && arrSelKeys.count>0)
            {
                [weakSelf.downloadedEditBottomView setEnableDelete:YES];
                if(arrSelKeys.count == arrDownloaded.count)
                {
                    [weakSelf.leftDownloadedSelectAllBarButtonItem setTitle:@"全不选"];
                }
                else
                {
                    [weakSelf.leftDownloadedSelectAllBarButtonItem setTitle:@"全选"];
                }
            }
            else
            {
                [weakSelf.leftDownloadedSelectAllBarButtonItem setTitle:@"全选"];
                [weakSelf.downloadedEditBottomView setEnableDelete:NO];
            }
        }
        else
        {
            BXGDownloadedCourseVideoSelectPageVC *videoSelPageVC = [BXGDownloadedCourseVideoSelectPageVC new];
            NSDictionary *dictDownloaded = [BXGResourceManager shareInstance].dictDownloadedRender;
            if(dictDownloaded)
            {
                NSArray<BXGDownloadedRenderModel*> *arrDownloadedRenderModel =  dictDownloaded.allValues;
                if(arrDownloadedRenderModel.count>indexPath.row)
                {
                    BXGDownloadedRenderModel* selDownloadedRenderModel = arrDownloadedRenderModel[indexPath.row];
                    videoSelPageVC.renderModel = selDownloadedRenderModel;
                    [((BXGBaseNaviController*)weakSelf.navigationController) pushViewController:videoSelPageVC
                                                                                       animated:YES
                                                                                     withTarget:weakSelf
                                                                                     backAction:@selector(back)];
                }
            }
        }
    };
    [self.downloadedTableView resetDelegate];
}

-(void)back
{
    [self refreshTableViewData];
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIImage*)getSelectImageById:(NSString*)keyId
{
    if(_bEdit)
    {
        UIImage* retImage=nil;
        NSArray* arrKeys = self.dictSelDownloaded.allKeys;
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
    [self.view installMaskView:BXGMaskViewTypeDownloadedEmpty];
}

-(void)doConfirmDelete
{
    if(self.dictSelDownloaded && self.dictSelDownloaded.count<=0)
    {
        return ;
    }
    //已下载, 确认删除
    [[BXGResourceManager shareInstance] removeDownloadedCourses:self.dictSelDownloaded.allValues];
    [self.dictSelDownloaded removeAllObjects];
    // _seledTotalSpace = 0;
    [self.downloadedTableView reloadData];
    if([BXGResourceManager shareInstance].dictDownloadedRender.count==0)
    {
        [_downloadedEditBottomView setEnableDelete:NO];
    }
    /*
    if([[BXGResourceManager shareInstance] dictDownloaded].count==0)
    {
        return [self reloadEmptyView];
    }
     //*/
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
