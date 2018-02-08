//
//  BXGDownloadedCourseVideoSelectPageVC.m
//  Boxuegu
//
//  Created by apple on 2017/6/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGDownloadedCourseVideoSelectPageVC.h"
#import "BXGDownloadedCourseVideoSelectPageCell.h"
#import "BXGDownloadSelectHeaderView.h"
#import "RWMultiTableView.h"
#import "BXGCourseModel.h"
#import "BXGCourseOutlinePointModel.h"
#import "BXGCourseOutlineVideoModel.h"
#import "RWMultiTableView.h"

#import "BXGDownloadInfoView.h"
#import "BXGAlertController.h"
#import "BXGDownloadManagerDelegate.h"
#import "BXGDownloadModel.h"
#import "BXGDownloadedEditBottomView.h"
#import "BXGResourceManager.h"
#import "UIBarButtonItem+Common.h"
#import "BXGBasePlayerVC.h"
#import "BXGStudyChapterHeaderView.h"

@interface BXGDownloadedCourseVideoSelectPageVC ()<BXGDownloadManagerDelegate>
//@property(nonatomic, strong) BXGCourseModel *courseMode;
@property(nonatomic, strong) RWMultiTableView *multiTableView;
@property(nonatomic, strong) BXGDownloadedEditBottomView *downloadInfoRootView;//暂时先这样
@property(nonatomic, assign) BOOL bEdit;
@property(nonatomic, strong) NSMutableDictionary *dictSelect;

@property (strong, nonatomic)UIBarButtonItem *leftSelectAllBarButtonItem;
@property (strong, nonatomic)UIBarButtonItem *leftBackBarButtonItem;
@property (strong, nonatomic)UIBarButtonItem *rightEditBarButtonItem;
@property (strong, nonatomic)UIBarButtonItem *rightCancelBarButtonItem;
@end

@implementation BXGDownloadedCourseVideoSelectPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _renderModel.courseModel.course_name;// @"下载管理";
    self.view.backgroundColor = [UIColor colorWithRed:245 green:245 blue:245];
    _leftSelectAllBarButtonItem = [UIBarButtonItem createBarButtonItemWithTitle:@"全选" withImage:nil withTarget:self withAction:@selector(onSelectAll:)];
    _leftBackBarButtonItem = self.navigationItem.leftBarButtonItem;
    _rightEditBarButtonItem = [UIBarButtonItem createBarButtonItemWithTitle:@"编辑" withImage:nil withTarget:self withAction:@selector(onEdit:)];
    _rightCancelBarButtonItem = [UIBarButtonItem createBarButtonItemWithTitle:@"取消" withImage:nil withTarget:self withAction:@selector(onEdit:)];
    self.navigationItem.rightBarButtonItem = _rightEditBarButtonItem;
    
    self.bEdit =  NO;
    self.dictSelect = [NSMutableDictionary new];
    
    
    _multiTableView = [RWMultiTableView new];
    _multiTableView.tableFooterView = [[UIView alloc] init];
    
    [_multiTableView registerClass:[BXGStudyChapterHeaderView class] forHeaderFooterViewReuseIdentifier:@"BXGDownloadedSubItemSelectHeaderSection"];
    [_multiTableView registerNib:[UINib nibWithNibName:@"BXGDownloadedCourseVideoSelectPageCell" bundle:nil] forCellReuseIdentifier:@"BXGDownloadedCourseVideoSelectPageCell"];
    
    // 设置根模型数组(每个元素对应每个Section的根模型)
    __weak typeof(BXGDownloadedCourseVideoSelectPageVC) *weakSelf = self;
    _multiTableView.rootModelForTableViewBlock = ^NSArray *(UITableView *tableView) {
        if(weakSelf.renderModel)
        {
            return weakSelf.renderModel.arrPointModel;
        }
        else
        {
            return [NSArray new];
        }
//        return weakSelf.renderModel.arrPointModel;
    };
    // 设置子模型数组(根据父模型寻找子模型)
    _multiTableView.subModelsForTableViewBlock = ^NSArray *(UITableView *tableView, NSInteger section, RWMultiItem *parentItem) {
        if([parentItem.model isKindOfClass:[BXGCourseOutlinePointModel class]]) {
            BXGCourseOutlinePointModel *sup = (BXGCourseOutlinePointModel *)parentItem.model;
            return sup.videos;
//            NSMutableArray<BXGCourseOutlineVideoModel*> *arrDownloadedVideoModel = [NSMutableArray new];
//            for(BXGCourseOutlineVideoModel* videoModelItem in sup.videos)
//            {
//                for(BXGDownloadBaseModel* baseModelItem in weakSelf.renderModel.arrDownloadModel)
//                {
//                    if([videoModelItem.idx isEqualToString:baseModelItem.videoModel.idx])
//                    {
//                        [arrDownloadedVideoModel addObject:videoModelItem];
//                    }
//                }
//            }
//            return arrDownloadedVideoModel;
        }else {
            
            return nil;
        }
    };
    _multiTableView.cellForRowBlock = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, RWMultiItem *item) {
        static NSString *cellId = @"BXGDownloadedCourseVideoSelectPageCell";
        BXGDownloadedCourseVideoSelectPageCell *cell = (BXGDownloadedCourseVideoSelectPageCell*)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        BXGCourseOutlineVideoModel *subModel = (BXGCourseOutlineVideoModel *)item.model;
        [cell setupCell:subModel];
        UIImage *imageIcon = [weakSelf getSelectImageById:subModel.idx];
        [cell showSelectImage:imageIcon];

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
    _multiTableView.viewForHeaderInSectionBlock = ^UIView *(RWMultiTableView *tableView, NSInteger section, RWMultiItem *item) {
        BXGStudyChapterHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BXGDownloadedSubItemSelectHeaderSection"];
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
                NSArray *arrKeys = weakSelf.dictSelect.allKeys;
                BXGCourseOutlineVideoModel *selVideoModel =  item.model;
                if(arrKeys && [arrKeys containsObject:selVideoModel.idx])
                {
                    [weakSelf.dictSelect removeObjectForKey:selVideoModel.idx];
                    [weakSelf.multiTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
                else
                {
                    [weakSelf.dictSelect setObject:selVideoModel forKey:selVideoModel.idx];
                    [weakSelf.multiTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
//                BXGCourseOutlineVideoModel *selVideoModel =  item.model;
//                NSString* selItemVideoIdx = selVideoModel.idx;
//                NSArray *arrKeys = weakSelf.dictSelect.allKeys;
//                if(arrKeys)
//                {
//                    BOOL bFound=NO;
//                    for(BXGDownloadBaseModel *baseModelItem in weakSelf.renderModel.arrDownloadModel)
//                    {
//                        if([arrKeys containsObject:baseModelItem.videoModel.idx] &&
//                           [selItemVideoIdx isEqualToString:baseModelItem.videoModel.idx])
//                        {
//                            [weakSelf.dictSelect removeObjectForKey:baseModelItem.videoModel.idx];
//                            [weakSelf.multiTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                            bFound = YES;
//                            break;
//                        }
//                    }
//                    if(!bFound)
//                    {
//                        for(BXGDownloadBaseModel *baseModelItem in weakSelf.renderModel.arrDownloadModel)
//                        {
//                            if([selItemVideoIdx isEqualToString:baseModelItem.videoModel.idx])
//                            {
//                                [weakSelf.dictSelect setObject:baseModelItem forKey:baseModelItem.videoModel.idx];
//                                [weakSelf.multiTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                                break;
//                            }
//                        }
//                    }
//                }
//                else
//                {
//                    for(BXGDownloadBaseModel *baseModelItem in weakSelf.renderModel.arrDownloadModel)
//                    {
//                        if([selItemVideoIdx isEqualToString:baseModelItem.videoModel.idx])
//                        {
//                            [weakSelf.dictSelect setObject:baseModelItem forKey:baseModelItem.videoModel.idx];
//                            [weakSelf.multiTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                            break;
//                        }
//                    }
//                }
                
//
////                videoModel.superPointModel = (BXGCourseOutlinePointModel*)item.superitem.model;
//                if(arrKeys && [arrKeys containsObject:videoModel.idx])
//                {
//                    [weakSelf.dictSelect removeObjectForKey:videoModel.idx];
//                    [weakSelf.multiTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                }
//                else{
//                    [weakSelf.dictSelect setObject:item forKey:videoModel.idx];
////                    [weakSelf.dictSelect setObject:videoModel forKey:videoModel.idx];
//                    [weakSelf.multiTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                }
                
                arrKeys =  weakSelf.dictSelect.allKeys;
                if(arrKeys && arrKeys.count>0)
                {
                    [weakSelf.downloadInfoRootView setEnableDelete:YES];
                }
                else
                {
                    [weakSelf.downloadInfoRootView setEnableDelete:NO];
                }
            }
        }
        else
        {
            BXGCourseOutlineVideoModel *videoModel =  item.model;
//            NSString *filePath = [[BXGResourceManager shareInstance] downloadFilePathByVideoIdx:videoModel.idx];
            BXGBasePlayerVC *offlinePlayerVC = [[BXGBasePlayerVC alloc] initWithVideoModel:videoModel andCourseModel:weakSelf.renderModel.courseModel];
            [weakSelf.navigationController pushViewController:offlinePlayerVC animated:YES];
            NSLog(@"didSelectRow: name=%@, idx=%@, vid=%@", videoModel.name, videoModel.idx, videoModel.video_id);
        }
    };
    
    [self.view addSubview:_multiTableView];
    // 设置完代理后调用这个初始化方法
    [_multiTableView installDataSourse];
    [_multiTableView openAllSection];
    _multiTableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    _multiTableView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
    
    _downloadInfoRootView = [BXGDownloadedEditBottomView acquireCustomView];
    [self.view addSubview:_downloadInfoRootView];
    _downloadInfoRootView.delegate = self;
    

    [self adjustLayout];
}

-(void)adjustLayout
{
    if(_bEdit)
    {
        _downloadInfoRootView.hidden = NO;
    }
    else
    {
        _downloadInfoRootView.hidden = YES;
    }
    if(_downloadInfoRootView.hidden)
    {
        [_multiTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(K_NAVIGATION_BAR_OFFSET);
            make.left.right.mas_offset(0);
            make.bottom.offset(0 - kBottomHeight);
        }];
    }
    else
    {
        [_multiTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(K_NAVIGATION_BAR_OFFSET);
            make.left.right.mas_offset(0);
            make.bottom.offset(-56 - kBottomHeight);
        }];

        if(!self.dictSelect || self.dictSelect.count<=0)
        {
            [_downloadInfoRootView setEnableDelete:NO];
        }
        else
        {
            [_downloadInfoRootView setEnableDelete:YES];
        }
    }
    
    [_downloadInfoRootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_multiTableView.mas_bottom).offset(0);//mas_offset(0);
        make.left.right.offset(0);
        make.bottom.offset(-kBottomHeight);
    }];
}

-(UIImage*)getSelectImageById:(NSString*)keyId
{
    if(_bEdit)
    {
        UIImage* retImage=nil;
        NSArray* arrKeys;
        arrKeys = self.dictSelect.allKeys;
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

#pragma mark begin BXGDownloadManagerDelegate

//-(void)removeSubItemInfo:(BXGCourseOutlineVideoModel*)videoModel withVideoIdx:(NSString*)videoIdx
//{
////    if(videoModel && videoModel.superPointModel && videoModel.superPointModel.videos)
////    {
////        NSMutableArray<BXGCourseOutlineVideoModel*> *arrMutableVideoModels = [[NSMutableArray alloc] initWithArray: videoModel.superPointModel.videos];
////        if(arrMutableVideoModels)
////        {
////            for(BXGCourseOutlineVideoModel* item in arrMutableVideoModels)
////            {
////                if([videoIdx isEqualToString:item.idx])
////                {
////                    [arrMutableVideoModels removeObject:item];
////                    break;
////                }
////            }
////            if(arrMutableVideoModels && arrMutableVideoModels.count==0)
////            {
////                if([self.renderModel.arrPointModel containsObject:videoModel.superPointModel])
////                {
////                    [self.renderModel.arrPointModel removeObject:videoModel.superPointModel];
////                }
////            }
////            else
////            {
////                videoModel.superPointModel.videos = [NSArray arrayWithArray:arrMutableVideoModels];
////            }
////        }
////    }
//    
//    if(videoModel)
//    {
//        for(BXGDownloadBaseModel* baseModelItem in self.renderModel.arrDownloadModel)
//        {
//            if([baseModelItem.videoModel.idx isEqualToString:videoModel.idx])
//            {
//                [self.renderModel.arrDownloadModel removeObject:baseModelItem];
//                break;
//            }
//        }
//    }
//    
//    
//}

-(void)confirmDelete
{
    if(self.dictSelect && self.dictSelect.count>0)
    {
        // 1.进行清理缓存操作
        __weak typeof (self) weakSelf = self;
        BXGAlertController *vc = [BXGAlertController confirmWithTitle:nil message:@"确定要删除视频么?" handler:^{
            if(weakSelf.dictSelect)
            {
//                NSArray *arrSelValues = weakSelf.dictSelect.allValues;
//                for(BXGDownloadBaseModel* selItem in arrSelValues)
//                {
//                    if([weakSelf.renderModel.arrDownloadModel containsObject:selItem])
//                    {
//                        [weakSelf.renderModel.arrDownloadModel removeObject:selItem];
//                    }
//                    //查询点下面是否还有视频
//                    NSInteger section = -1;
//                    BXGCourseOutlinePointModel *deletePoint = nil;
//                    for(BXGCourseOutlinePointModel *pointItem in weakSelf.renderModel.arrPointModel)
//                    {
//                        //查询要删除视频所在的点
//                        section++;
//                        if([pointItem.idx isEqualToString:selItem.pointId])
//                        {
//                            deletePoint = pointItem;
//                            break;
//                        }
//                    }
//                    if(section!=-1)
//                    {
//                        //删除多级tableView数据源
//                        if(section<self.multiTableView.sectionDataSourseArray.count)
//                        {
//                            RWMultiDataSourse *dataSource = (RWMultiDataSourse*)(weakSelf.multiTableView.sectionDataSourseArray[section]);
//                            NSArray* arrCurrentItems =  dataSource.currentItems;
//                            for(RWMultiItem* item in arrCurrentItems)
//                            {
//                                BXGCourseOutlineVideoModel* itemVideoModel = (BXGCourseOutlineVideoModel*)item.model;
//                                if([itemVideoModel.idx isEqualToString:selItem.videoModel.idx])
//                                {
//                                    [dataSource removeItem:item];
//                                    break;
//                                }
//                            }
//                        }
//                    }
//                    //看是否删除点信息
//                    if(deletePoint && deletePoint.videos)
//                    {
//                        if(deletePoint.videos.count==1)
//                        {
//                            //如果这个点下面就这一个视频,那么就直接删除这个点
//                            NSMutableArray* arrPointModel = weakSelf.renderModel.arrPointModel;
//                            if(arrPointModel)
//                            {
//                                [arrPointModel removeObject:deletePoint];
//                            }
//                        }
//                        else
//                        {
//                            NSMutableArray *videosInPoint = [NSMutableArray arrayWithArray:deletePoint.videos];
//                            for(BXGCourseOutlineVideoModel *deleteVideoItem in videosInPoint)
//                            {
//                                if([deleteVideoItem.idx isEqualToString:selItem.videoModel.idx])
//                                {
//                                    [videosInPoint removeObject:deleteVideoItem];
//                                    break;
//                                }
//                            }
//                            deletePoint.videos = [NSArray arrayWithArray:videosInPoint];
//                        }
//                    }
//                    
//                    //删除数据库/本地文件等信息
//                    [[BXGResourceManager shareInstance] removeDownloadedVideoIdx:selItem.videoModel.idx];
//                }
   
                NSArray *arrSelValues = weakSelf.dictSelect.allValues;
                for(BXGCourseOutlineVideoModel* selItem in arrSelValues)
                {
//                    NSInteger section = -1;
//                    BXGCourseOutlinePointModel *deletePoint = nil;
//                    for(BXGCourseOutlinePointModel *pointItem in weakSelf.renderModel.arrPointModel)
//                    {
//                        //查询要删除视频所在的点
//                        section++;
//                        if([pointItem.idx isEqualToString:selItem.superPointModel.idx])
//                        {
//                            deletePoint = pointItem;
//                            break;
//                        }
//                    }
//                    if(section!=-1)
//                    {
//                        //删除多级tableView数据源
//                        if(section<self.multiTableView.sectionDataSourseArray.count)
//                        {
//                            RWMultiDataSourse *dataSource = (RWMultiDataSourse*)(weakSelf.multiTableView.sectionDataSourseArray[section]);
//                            NSArray* arrCurrentItems =  dataSource.currentItems;
//                            for(RWMultiItem* item in arrCurrentItems)
//                            {
//                                BXGCourseOutlineVideoModel* itemVideoModel = (BXGCourseOutlineVideoModel*)item.model;
//                                if([itemVideoModel.idx isEqualToString:selItem.idx])
//                                {
//                                    [dataSource removeItem:item];
//                                    break;
//                                }
//                            }
//                        }
//                    }
//                    //删除下载基本信息
//                    for(BXGDownloadBaseModel* baseItem in weakSelf.renderModel.arrDownloadModel)
//                    {
//                        if([selItem.idx isEqualToString:baseItem.videoModel.idx])
//                        {
//                            [weakSelf.renderModel.arrDownloadModel removeObject:baseItem];
//                            break;
//                        }
//                    }
//                    //看是否删除点信息
//                    if(deletePoint && deletePoint.videos)
//                    {
//                        if(deletePoint.videos.count==1)
//                        {
//                            //如果这个点下面就这一个视频,那么就直接删除这个点
//                            NSMutableArray* arrPointModel = weakSelf.renderModel.arrPointModel;
//                            if(arrPointModel)
//                            {
//                                [arrPointModel removeObject:deletePoint];
//                            }
//                        }
//                        else
//                        {
//                            NSMutableArray *videosInPoint = [NSMutableArray arrayWithArray:deletePoint.videos];
//                            for(BXGCourseOutlineVideoModel *deleteVideoItem in videosInPoint)
//                            {
//                                if([deleteVideoItem.idx isEqualToString:selItem.idx])
//                                {
//                                    [videosInPoint removeObject:deleteVideoItem];
//                                    break;
//                                }
//                            }
//                            deletePoint.videos = [NSArray arrayWithArray:videosInPoint];
//                        }
//                    }
                    //删除数据库/本地文件等信息
                    [[BXGResourceManager shareInstance] removeDownloadedVideoIdx:selItem.idx];
                }
                
                [[BXGResourceManager shareInstance] updateDownloadedRenderInfo];
                
                NSDictionary *dictdownloadedRender = [[BXGResourceManager shareInstance] dictDownloadedRender];
                if(dictdownloadedRender && dictdownloadedRender.count>0)
                {
                    NSArray* arrKeys = dictdownloadedRender.allKeys;
                    if(arrKeys && [arrKeys containsObject:weakSelf.renderModel.courseModel.course_id])
                    {
                        weakSelf.renderModel = dictdownloadedRender[weakSelf.renderModel.courseModel.course_id];
                    }
                    else
                    {
                        weakSelf.renderModel = nil;
                    }
                }
                else
                {
                    weakSelf.renderModel = nil;
                }
                
                [weakSelf.multiTableView installDataSourse];
                [weakSelf.multiTableView openAllSection];
                
                [weakSelf.dictSelect removeAllObjects];
                //        [self.multiTableView multiTableViewReloadData];
                [weakSelf.multiTableView reloadData];
                
                if(weakSelf.renderModel==nil ||
                   weakSelf.renderModel.arrDownloadModel==nil ||
                   (weakSelf.renderModel.arrDownloadModel&&weakSelf.renderModel.arrDownloadModel.count==0))
                {
                    [weakSelf.downloadInfoRootView setEnableDelete:NO];
                    [weakSelf.navigationController popViewControllerAnimated:YES];//全部删除完成后,回退上上一界面
                }
            }
        }];
        [self presentViewController:vc animated:true completion:nil];
        
   
    }
}
#pragma mark end BXGDownloadManagerDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onSelectAll:(UIBarButtonItem*)sender
{
    NSLog(@"onSelectAll");
    if([sender.title isEqualToString:@"全选"])
    {
        for(BXGCourseOutlinePointModel* pointItem in _renderModel.arrPointModel)
        {
            for(BXGCourseOutlineVideoModel* videoItem in pointItem.videos)
            {
                [self.dictSelect setObject:videoItem forKey:videoItem.idx];
            }
        }

        if(self.dictSelect && self.dictSelect.count>0)
        {
            [_downloadInfoRootView setEnableDelete:YES];
        }
        [self.multiTableView reloadData];
        sender.title = @"全不选";
    }
    else
    {
        [self.dictSelect removeAllObjects];
        [_downloadInfoRootView setEnableDelete:NO];
        sender.title = @"全选";
        [self.multiTableView reloadData];
    }
}

-(void)dealloc
{
    NSLog(@"dealloc");
}

-(void)onEdit:(UIBarButtonItem*)sender
{
    NSLog(@"onEdit");
    UIBarButtonItem* editBarItem = (UIBarButtonItem*)sender;
    if([editBarItem.title isEqualToString:@"编辑"])
    {
        _bEdit = YES;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = _leftSelectAllBarButtonItem;
        self.navigationItem.rightBarButtonItem = _rightCancelBarButtonItem;
    }
    else
    {
        //之前选中的要给清空
        [self.dictSelect removeAllObjects];
        
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = _leftBackBarButtonItem;
        self.navigationItem.rightBarButtonItem = _rightEditBarButtonItem;
        _bEdit = NO;
    }
    [self adjustLayout];
    [_multiTableView reloadData];
}


@end
