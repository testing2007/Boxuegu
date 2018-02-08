//
//  BXGCommunitySquareVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/28.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommunitySquareVC.h"

#import "RWTabDetailView.h"
#import "BXGSquareTabTitleCCell.h"
#import "BXGSquareViewModel.h"
#import "BXGSquareContentVC.h"

#import "BXGPraisePersonVC.h"
#import "BXGMaskView.h"
#import "RWDeviceInfo.h"
static NSString *squareTabTitleCCellId = @"BXGSquareTabTitleCCell";
@interface BXGCommunitySquareVC() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) BXGSquareViewModel *viewModel;
@property (nonatomic, strong) UICollectionView *tabTitleCV;
@property (nonatomic, assign) NSInteger tabTitleIndex;
@property (nonatomic, strong) NSArray <BXGPostTopicModel*>*topicModelArray;
@property (nonatomic, strong) RWTabDetailView *tabDetailView;
@property (nonatomic, strong) NSMutableArray <BXGSquareContentVC*> *squareContentVCArray;

@end


@implementation BXGCommunitySquareVC

- (NSMutableArray<BXGSquareContentVC *> *)squareContentVCArray {
 
    if(_squareContentVCArray == nil) {
    
        _squareContentVCArray = [NSMutableArray new];
    }
    return _squareContentVCArray;
}
- (BXGSquareViewModel *)viewModel {

    if(_viewModel == nil) {
    
        _viewModel = [BXGSquareViewModel new];
    }
    return _viewModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self installUI];
    [self loadData];
    
    _tabTitleIndex = 0;
    [self.view installLoadingMaskView];
}

- (void)installUI{

    Weak(weakSelf);
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    // *** Tab Title
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    if([RWDeviceInfo deviceScreenType] == RWDeviceScreenTypePlus) {
    
        flowLayout.minimumLineSpacing = 30;
        flowLayout.minimumInteritemSpacing = 30;
        // flowLayout.itemSize = CGSizeMake((self.view.bounds.size.width -20) / 4, 43);
    }else{
        
        
        flowLayout.minimumLineSpacing = 15;
        flowLayout.minimumInteritemSpacing = 15;
        
        // flowLayout.itemSize = CGSizeMake((self.view.bounds.size.width -20) / 5, 43);
    }
    
//    flowLayout.estimatedItemSize = CGSizeMake(100, 43);
    flowLayout.estimatedItemSize = CGSizeMake(100, 43);
    
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *tabTitleCV = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
  
    
     tabTitleCV.backgroundColor = [UIColor whiteColor];
    tabTitleCV.dataSource = self;
    tabTitleCV.delegate = self;
    [self.view addSubview:tabTitleCV];
    tabTitleCV.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tabTitleCV.alwaysBounceHorizontal = true;
    
    [tabTitleCV registerClass:[BXGSquareTabTitleCCell class] forCellWithReuseIdentifier:squareTabTitleCCellId];
    tabTitleCV.showsVerticalScrollIndicator = false;
    tabTitleCV.showsHorizontalScrollIndicator = false;
    // *** Sp View
    UIView *spView = [UIView new];
    spView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [self.view addSubview:spView];

    // *** Tab Detail
    RWTabDetailView *tabDetailView = [RWTabDetailView new];
    [self.view addSubview:tabDetailView];
    

    tabDetailView.showsHorizontalScrollIndicator = false;
    tabDetailView.pagingEnabled = true;
    tabDetailView.bounces = false;
    
    tabDetailView.indexChangedBlock = ^(UIView *detailView, NSInteger index) {
        
        weakSelf.tabTitleIndex = index;
        [weakSelf.tabTitleCV selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:true scrollPosition:UICollectionViewScrollPositionRight];
        [weakSelf.tabTitleCV reloadData];
        
    };
    
    
    // *** Layout
    
    [tabDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spView.mas_bottom);
        make.left.right.offset(0);
        make.bottom.offset(0);
    }];
    
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(tabTitleCV.mas_bottom);
        make.left.right.offset(0);
        make.height.offset(9);
    }];
    
    [tabTitleCV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.top.offset(0);
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(43);
    }];
    
    // *** Interface
    self.tabTitleCV = tabTitleCV;
    self.tabDetailView = tabDetailView;
}

- (void)loadData {

    __weak typeof (self) weakSelf = self;
    [self.viewModel loadPostTopicListWithFinished:^(NSArray<BXGPostTopicModel *> *topicModelArray) {
        
        [weakSelf.view removeMaskView];
        
        if(topicModelArray && topicModelArray.count > 0) {
        
            
        }else {
            [weakSelf.view installMaskView:BXGButtonMaskViewTypeLoadFailed buttonBlock:^{
                [weakSelf.view installLoadingMaskView];
                [weakSelf loadData];
            }];
        }
        
        
        weakSelf.topicModelArray = topicModelArray;
        [weakSelf.tabTitleCV reloadData];
        NSInteger count = [weakSelf.tabTitleCV numberOfItemsInSection:0];
        if(count > 0) {
        
            [weakSelf.tabTitleCV selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:false scrollPosition:UICollectionViewScrollPositionNone];
        }
        // 删除之前
        for (NSInteger i = 0; i < weakSelf.squareContentVCArray.count; i++) {
        
            [weakSelf.squareContentVCArray[i] removeFromParentViewController];
        }
        
        [weakSelf.squareContentVCArray removeAllObjects];
        
        // 创建detail view
        for(NSInteger i = 0; i < topicModelArray.count; i++) {
        
            BXGSquareContentVC *sqContentVC = [[BXGSquareContentVC alloc]initWithTopicModel:topicModelArray[i]];
            [weakSelf.squareContentVCArray addObject:sqContentVC];
        }
    
        NSMutableArray <UIView *>*viewArray = [NSMutableArray new];
        for(NSInteger i = 0; i < self.squareContentVCArray.count; i++) {
        
            [viewArray addObject:weakSelf.squareContentVCArray[i].view];
            [self addChildViewController:weakSelf.squareContentVCArray[i]];
        }
        
        weakSelf.tabDetailView.detailViews = viewArray;
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    BXGSquareTabTitleCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:squareTabTitleCCellId forIndexPath:indexPath];
    if(_tabTitleIndex == indexPath.item) {
    
        cell.isActive = true;
    }else {
        
        cell.isActive = false;
    }
    cell.cellTitle = self.topicModelArray[indexPath.item].name;
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.topicModelArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    [self.tabTitleCV selectItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSection:0] animated:true scrollPosition:UICollectionViewScrollPositionRight];
    self.tabDetailView.currentIndex = indexPath.item;
    _tabTitleIndex = indexPath.item;
    [collectionView reloadData];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}
@end
