//
//  BXGSquareContentVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGSquareContentVC.h"
#import "BXGSquareContentCCell.h"
#import "MJRefresh.h"
#import "BXGSquareTopicViewModel.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "BXGPostDetailVC.h"
#import "RWSectionBackgroundFlowLayout.h"
#import "BXGMaskView.h"
#import "RWDeviceInfo.h"

static NSString *squareContentCCellId = @"BXGSquareContentCCell";
@interface BXGSquareContentVC () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) BXGPostTopicModel *topicModel;
@property (nonatomic, strong) BXGSquareTopicViewModel *viewModel;
@property (nonatomic, strong) NSArray *postListArray;
@property (nonatomic, strong) UICollectionView *contentView;
@end

@implementation BXGSquareContentVC

- (instancetype)initWithTopicModel:(BXGPostTopicModel *)topicModel; {

    self = [super init];
    if(self) {
    
        self.topicModel = topicModel;
        self.viewModel = [[BXGSquareTopicViewModel alloc]initWithTopicId:topicModel.idx];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Weak(weakSelf);
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //RWSectionBackgroundFlowLayout *flowLayout = [RWSectionBackgroundFlowLayout new];
    UICollectionViewLeftAlignedLayout *flowLayout = [UICollectionViewLeftAlignedLayout new];
//     UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    // )
    
    
    flowLayout.itemSize = CGSizeMake((self.view.frame.size.width) / 2, (self.view.frame.size.width) / 2 + 60);
    // flowLayout.estimatedItemSize = CGSizeMake((self.view.frame.size.width - 50) / 2, 1);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    // flowLayout.scrollDirection =
    UICollectionView *contentView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.view addSubview:contentView];
    contentView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    contentView.dataSource = self;
    contentView.delegate = self;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    
    contentView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    ;
    self.contentView = contentView;
    
//    contentView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//        [weakSelf loadDataWithIsReflesh:true];
//    }];
    
    [contentView bxg_setHeaderRefreshBlock:^{
         [weakSelf loadDataWithIsReflesh:true];
    }];
    
    [contentView bxg_setFootterRefreshBlock:^{
        [weakSelf loadDataWithIsReflesh:false];
    }];
//    contentView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf loadDataWithIsReflesh:false];
//    }];
    // contentView.ali
    
//    [contentView registerNib:[UINib nibWithNibName:@"BXGSquareContentCCell" bundle:nil] forCellWithReuseIdentifier:squareContentCCellId];
    [contentView registerClass:[BXGSquareContentCCell class] forCellWithReuseIdentifier:squareContentCCellId];
    
    
    [self.view installLoadingMaskView];
    [weakSelf loadDataWithIsReflesh:true];
}

- (void)loadDataWithIsReflesh:(BOOL)isReflesh {
    
    __weak typeof (self) weakSelf = self;
    [self.viewModel requstIsBannedFinishedBlock:nil isRefresh:YES];
    
    [self.viewModel loadPostListWithTopicId:self.topicModel.idx isReflesh:isReflesh andFinished:^(NSArray *modelArray, BOOL isNoMore) {
        
        [weakSelf.view removeMaskView];
        [weakSelf.contentView removeMaskView];
        if(modelArray){
            
            if(modelArray.count > 0) {
                
            }else {
                [weakSelf.contentView installMaskView:BXGMaskViewTypeNoTopicPage];
            }
            
        } else {
            
            [weakSelf.contentView installMaskView:BXGMaskViewTypeLoadFailed];
        }
        
        weakSelf.postListArray = modelArray;
        
        if(isNoMore){
            
            [weakSelf.contentView bxg_endFootterRefreshNoMoreData];
        }else {
            
            [weakSelf.contentView bxg_endFootterRefresh];
        }
        [weakSelf.contentView bxg_endHeaderRefresh];
        [weakSelf.contentView reloadData];
    }];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    Weak(weakSelf)
    return weakSelf.postListArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Weak(weakSelf)
    
    BXGSquareContentCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:squareContentCCellId forIndexPath:indexPath];
    cell.model = weakSelf.postListArray[indexPath.item];
    cell.isLeft = !(indexPath.row % 2);

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    BXGPostDetailVC *postDetailVC = [BXGPostDetailVC new];
    postDetailVC.model = self.postListArray[indexPath.item];
    [self.navigationController pushViewController:postDetailVC animated:true];
}

@end
