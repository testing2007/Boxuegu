//
//  BXGDownloadSelectPageVC.m
//  Boxuegu
//
//  Created by apple on 2017/6/16.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGDownloadSelectPageVC.h"
#import "BXGCourseModel.h"
#import "BXGCourseOutlinePointModel.h"
#import "BXGCourseOutlineVideoModel.h"
//#import "BXGDownloadSelectHeaderView.h"
#import "BXGStudyChapterHeaderView.h"
#import "BXGDownloadSelectCell.h"
#import "RWMultiTableView.h"
#import "BXGDownloadInfoView.h"
#import "BXGDownloader.h"
#import "BXGDownloadManagerDelegate.h"

@interface BXGDownloadSelectPageVC ()<BXGDownloadManagerDelegate>
@property(nonatomic, strong) BXGCourseModel *courseModel;
@property(nonatomic, strong) BXGCourseOutlinePointModel *pointModel;
@property(nonatomic, strong) RWMultiTableView *multiTableView;
@property(nonatomic, strong) BXGDownloadInfoView *downloadInfoRootView;
@property(nonatomic, assign) BOOL bEdit;
@property(nonatomic, strong) NSMutableDictionary *dictSelect;
@end

@implementation BXGDownloadSelectPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下载";
    self.view.backgroundColor = [UIColor colorWithRed:245 green:245 blue:245];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightEditBarItem = [[UIBarButtonItem alloc] initWithTitle:@"全选"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(onSelectAll:)];
    rightEditBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightEditBarItem;
    
    self.bEdit =  YES;
    self.dictSelect = [NSMutableDictionary new];
    
    
    _multiTableView = [RWMultiTableView new];
    _multiTableView.tableFooterView = [[UIView alloc] init];
    
//    [_multiTableView registerClass:[BXGDownloadSelectHeaderView class] forHeaderFooterViewReuseIdentifier:@"BXGDownloadSelectHeaderView"];
    [_multiTableView registerClass:[BXGStudyChapterHeaderView class] forHeaderFooterViewReuseIdentifier:@"BXGDownloadSelectHeaderSection"];
    // 设置根模型数组(每个元素对应每个Section的根模型)
    __weak typeof(BXGDownloadSelectPageVC) *weakSelf = self;
    _multiTableView.rootModelForTableViewBlock = ^NSArray *(UITableView *tableView) {
        return @[weakSelf.pointModel];
    };
    
    // 设置子模型数组(根据父模型寻找子模型)
    _multiTableView.subModelsForTableViewBlock = ^NSArray *(UITableView *tableView, NSInteger section, RWMultiItem *parentItem) {
        
        if([parentItem.model isKindOfClass:[BXGCourseOutlinePointModel class]]) {
            
            BXGCourseOutlinePointModel *sup = (BXGCourseOutlinePointModel *)parentItem.model;
            return sup.videos;
        }else {
            
            return nil;
        }
    };
    
    _multiTableView.cellForRowBlock = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, RWMultiItem *item) {
        static NSString *cellId = @"BXGDownloadSelectCell";
        BXGDownloadSelectCell *cell = [[BXGDownloadSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId bEditMode:weakSelf.bEdit];
        BXGCourseOutlineVideoModel *sub = (BXGCourseOutlineVideoModel *)item.model;
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item.tag inSection:section];
        UIImage *imageIcon = [weakSelf getSelectImageById:sub.idx];
        [cell showSelectImage:imageIcon];
        cell.txtLabel.text = sub.name;
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        return cell;
    };
    
    _multiTableView.heightForHeaderInSectionBlock = ^CGFloat(UITableView *tableView, NSInteger section) {
        return 44;
    };
    _multiTableView.heightForRowBlock = ^CGFloat(UITableView *tableView, NSInteger section, RWMultiItem *item) {
        return 44;
    };
//    _multiTableView.viewForHeaderInSectionBlock = ^UIView *(UITableView *tableView, NSInteger section, RWMultiItem *item) {
//        static NSString *headerId;
//        headerId = @"BXGStudyChapterHeaderView";
////        BXGDownloadSelectHeaderView *headerView = (BXGDownloadSelectHeaderView*)[weakSelf.multiTableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
//        BXGStudyChapterHeaderView *headerView = (BXGStudyChapterHeaderView*)[weakSelf.multiTableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
//        headerView.contentView.backgroundColor = [UIColor colorWithRed:247/255.0f green:249/255.0f blue:252/255.0f alpha:1];
//        if(headerView==nil)
//        {
//            headerView = [[BXGDownloadSelectHeaderView alloc] initWithReuseIdentifier:headerId];
//        }
//        BXGCourseOutlinePointModel* pointModel = (BXGCourseOutlinePointModel*)item.model;
//        headerView.textLabel.text = pointModel.name;
//        return headerView;
//    };
//    
    _multiTableView.viewForHeaderInSectionBlock = ^UIView *(RWMultiTableView *tableView, NSInteger section, RWMultiItem *item) {
        
        BXGStudyChapterHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BXGDownloadSelectHeaderSection"];
        
        if([item.model isKindOfClass:[BXGCourseOutlinePointModel class]]) {
            
            BXGCourseOutlinePointModel *pointModel = (BXGCourseOutlinePointModel *)item.model;
            view.title = pointModel.name;
            view.isOpen = item.isOpen;
        }
        return view;
    };
    
    _multiTableView.didSelectHeaderViewAtSectionBlock = ^(UITableView *tableView, NSInteger section, RWMultiItem *item) {
        
        RWMultiTableView *tb = (RWMultiTableView *)tableView;
        if(item.isOpen) {
            
            [tb closeSection:section];
            
        }else {
            
            [tb openSection:section];
        }
        
        [tableView reloadData];
    };
    
    _multiTableView.didSelectRowBlock = ^(UITableView *tableView, NSIndexPath* indexPath, RWMultiItem *item) {
        if(weakSelf.bEdit)
        {
            if(weakSelf.dictSelect)
            {
                NSString* curSelVideoIdx = ((BXGCourseOutlineVideoModel*)item.model).idx;
                NSArray* arrKeys = weakSelf.dictSelect.allKeys;
                if(arrKeys && [arrKeys containsObject:curSelVideoIdx])
                {
                    [weakSelf.dictSelect removeObjectForKey:curSelVideoIdx];
                    [weakSelf.multiTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
                else{
                    [weakSelf.dictSelect setObject:item forKey:curSelVideoIdx];
                    [weakSelf.multiTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
                arrKeys =  weakSelf.dictSelect.allKeys;
                if(arrKeys && arrKeys.count>0)
                {
                    [weakSelf.downloadInfoRootView setEnableDownload:YES];
                    
                    if(arrKeys.count ==  ((BXGCourseOutlinePointModel*)(item.superitem.model)).videos.count)
                    {
                        weakSelf.navigationItem.rightBarButtonItem.title = @"全不选";
                    }
                    else
                    {
                        weakSelf.navigationItem.rightBarButtonItem.title = @"全选";
                    }
                }
                else
                {
                    weakSelf.navigationItem.rightBarButtonItem.title = @"全选";
                    [weakSelf.downloadInfoRootView setEnableDownload:NO];
                }
            }
        }
    };
    
    [self.view addSubview:_multiTableView];
    // 设置完代理后调用这个初始化方法
    [_multiTableView installDataSourse];
    [_multiTableView openAllSection];
    
    _downloadInfoRootView = [BXGDownloadInfoView acquireCustomView];
    [self.view addSubview:_downloadInfoRootView];
    _downloadInfoRootView.delegate = self;
    
//    UIView *spView = [UIView new];
//    [self.view addSubview:spView];
//    spView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
//    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(64);
//        make.left.right.offset(0);
//        make.height.offset(9);
//    }];
//    
    [_multiTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(K_NAVIGATION_BAR_OFFSET);
        make.left.mas_offset(0);
        make.width.mas_equalTo(self.view.frame.size.width);
        make.height.mas_equalTo(self.view.frame.size.height-56-K_NAVIGATION_BAR_OFFSET-kBottomHeight); //因为底部显示高度为56, 所以这里偏移量是56
    }];

    _multiTableView.backgroundColor = [UIColor colorWithRed:245 green:245 blue:245.0];
    _multiTableView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
    
    [_downloadInfoRootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_multiTableView.mas_bottom).offset(0);//mas_offset(0);
        make.left.mas_offset(0);
        make.width.mas_equalTo(self.view.frame.size.width);
        make.height.mas_equalTo(56);
    }];
    
//    _downloadInfoRootView.backgroundColor = [UIColor greenColor];
}

#pragma mark begin BXGDownloadManagerDelegate
-(void)confirmDownload
{
    [[BXGBaiduStatistic share] statisticEventString:xzymxz_30 andParameter:nil];
    if(_dictSelect)
    {
        NSArray* arrSelect = _dictSelect.allValues;
        NSMutableArray* arrVideoModel = [NSMutableArray new];
        if(arrSelect && arrSelect.count>0)
        {
            for(RWMultiItem* item in arrSelect)
            {
                BXGCourseOutlineVideoModel* model = (BXGCourseOutlineVideoModel*)item.model;
                [arrVideoModel addObject:model];
            }
        }
        //检测是否用的是 3G/4G 网络下载
        if(arrVideoModel && arrVideoModel.count>0)
        {
            if([[BXGUserDefaults share] isAllowCellularDownload])
            {
                [self executeAddDownloadTask:arrVideoModel];
            }
            else if([[BXGNetWorkTool sharedTool] getReachState] == BXGReachabilityStatusReachabilityStatusReachableViaWWAN)
            {
                BXGAlertController *vc = [BXGAlertController confirmWithTitle:nil message:kBXGToastUseCellularDownloadVideo handler:^{
                    [[BXGUserDefaults share] setIsAllowCellularDownload:YES];
                    [self executeAddDownloadTask:arrVideoModel];
                }];
                [self presentViewController:vc animated:true completion:nil];
            }
            else
            {
                [self executeAddDownloadTask:arrVideoModel];
            }
        }
    }
    else
    {
        NSAssert(NO, @"have no any choice, can't execute download");
    }
}

-(void)executeAddDownloadTask:(NSArray*)arrVideoModel
{
    [[BXGDownloader shareInstance] addDownloadCourseModel:_courseModel
                                               pointModel:_pointModel
                                          withVideoModels:arrVideoModel];
    [((BXGBaseNaviController*)self.navigationController) popViewControllerAnimated:YES completion:^{
        [[BXGHUDTool share] showHUDWithString:kBXGToastDownloadTip];
    }];
}
#pragma mark end BXGDownloadManagerDelegate

-(UIImage*)getSelectImageById:(NSString*)keyId
{
    if(_bEdit)
    {
        UIImage* retImage=nil;
        NSArray* arrKeys = _dictSelect.allKeys;
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

-(void)enterDownloadSelectPageWithCourseModel:(BXGCourseModel*)courseModel
                                   pointModel:(BXGCourseOutlinePointModel*)pointModel
{
    self.courseModel =  courseModel;
    self.pointModel = pointModel;
}

-(void)onSelectAll:(UIBarButtonItem*)sender
{
    NSLog(@"onSelectAll");
    if([sender.title isEqualToString:@"全选"])
    {
        NSArray *arrData = _pointModel.videos;
        if(arrData && arrData.count>0)
        {
            for (BXGCourseOutlineVideoModel* videoModelItem in arrData) {
                RWMultiItem* item = [[RWMultiItem alloc] init];
                item.model = videoModelItem;
                [self.dictSelect setObject:item forKey:videoModelItem.idx];
            }
            
            if(self.dictSelect && self.dictSelect.count>0)
            {
                [_downloadInfoRootView setEnableDownload:YES];
            }
            [self.multiTableView reloadData];
        }
        sender.title = @"全不选";
    }
    else
    {
        [self.dictSelect removeAllObjects];
        [_downloadInfoRootView setEnableDownload:NO];
        sender.title = @"全选";
        [self.multiTableView reloadData];
    }
}

-(void)onEdit:(UIBarButtonItem*)sender
{
    NSLog(@"onEdit");
    UIBarButtonItem* editBarItem = (UIBarButtonItem*)sender;
    if([editBarItem.title isEqualToString:@"编辑"])
    {
        editBarItem.title = @"取消";
        _bEdit = YES;
    }
    else
    {
        editBarItem.title = @"编辑";
        _bEdit = NO;
    }
    [_multiTableView reloadData];
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
