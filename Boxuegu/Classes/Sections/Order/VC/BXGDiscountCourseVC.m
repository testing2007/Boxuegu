//
//  BXGDiscountCourseVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/16.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGDiscountCourseVC.h"
#import "BXGCourseInfoVC.h"
#import "BXGCareerCourseCC.h"
#import "BXGDiscountCourseViewModel.h"
#import "BXGCourseInfoVC.h"

static NSString *BXGCareerCourseCCId = @"BXGCareerCourseCC";

@interface BXGDiscountCourseVC () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) BXGDiscountCourseViewModel *viewModel;
@property(nonatomic, weak) UICollectionView *collectionView;
//@property(nonatomic, strong) BXGHomeViewModel *courseVM;
@property(nonatomic, strong) NSArray<BXGHomeCourseModel*> *courseModel;
@end

@implementation BXGDiscountCourseVC
- (instancetype)initWithDiscountCourseViewModel:(BXGDiscountCourseViewModel *)viewModel; {
    self = [super init];
    if(self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠课程";
    [self installUI];
    [self installPullRefresh];
}
- (IBAction)onClickCourseInfoBtn:(id)sender {
    BXGCourseInfoVC *vc = [BXGCourseInfoVC new];
    [self.navigationController pushViewController:vc animated:true];
}

-(void)installPullRefresh
{
    
    __weak typeof(self) weakSelf = self;
    
    [_collectionView bxg_setHeaderRefreshBlock:^{
        [weakSelf updateListWithIsRefresh:true];
    }];
    
//    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf updateListWithIsRefresh:true];
//    }];
    
    // 马上进入刷新状态
//    [self.collectionView.mj_header beginRefreshing];
    [self.collectionView bxg_beginHeaderRefresh];
}

- (void)updateListWithIsRefresh:(BOOL)isRefresh; {
    __weak typeof(self) weakSelf = self;
    [self.viewModel loadWithIsRefresh:true andFinished:^(NSArray<BXGHomeCourseModel *> *models) {
        [weakSelf.collectionView removeMaskView];
        [weakSelf.collectionView bxg_endHeaderRefresh];
        weakSelf.courseModel = models;
        [weakSelf.collectionView reloadData];
        
        if(models == nil) {
            // 失败
            [weakSelf.collectionView installMaskView:BXGMaskViewTypeLoadFailed];
            return;
        }
        if(models.count == 0) {
            [weakSelf.collectionView installMaskView:BXGMaskViewTypeNoData];
            return;
        }
    }];
}

-(void)installUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(15, 0, 0, 0);
    //layout.estimatedItemSize = CGSizeMake(SCREEN_WIDTH, 120);
    //layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 50);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    collectionView.delegate = self;
    collectionView.dataSource = self;

    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    [_collectionView registerClass:[BXGCareerCourseCC class]
        forCellWithReuseIdentifier:BXGCareerCourseCCId];
    
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(K_NAVIGATION_BAR_OFFSET + 9);
        make.left.bottom.right.offset(0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.courseModel.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    BXGCareerCourseCC *cc = [collectionView dequeueReusableCellWithReuseIdentifier:BXGCareerCourseCCId forIndexPath:indexPath];
    BXGHomeCourseModel *model = self.courseModel[indexPath.row];
    [cc setModel:model];
    cell = cc;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retSize = CGSizeZero;
    retSize.width = SCREEN_WIDTH;
    retSize.height = SCREEN_WIDTH / 3.4;// 93+10*2;
    return retSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    if(self.courseModel && indexPath.row<self.courseModel.count) {
        BXGHomeCourseModel *model = self.courseModel[indexPath.row];
        
        BXGCourseInfoViewModel *courseInfoVM = [[BXGCourseInfoViewModel alloc]initWithCourseModel:model];
        BXGCourseInfoVC *courseInfo = [[BXGCourseInfoVC alloc] initWithViewModel:courseInfoVM];
        [self.navigationController pushViewController:courseInfo animated:YES];
    }
}
@end
