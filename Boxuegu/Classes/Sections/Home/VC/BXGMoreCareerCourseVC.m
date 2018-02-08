//
//  BXGMoreCareerCourseVC.m
//  Boxuegu
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMoreCareerCourseVC.h"
#import "BXGCourseInfoVC.h"
#import "BXGHomeViewModel.h"
#import "BXGHomeCourseListModel.h"
#import "BXGHomeCourseModel.h"
#import "BXGCareerCourseCC.h"
#import "BXGCourseInfoVC.h"
#import "BXGCourseInfoViewModel.h"

static NSString *BXGCareerCourseCCId = @"BXGCareerCourseCC";

@interface BXGMoreCareerCourseVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, weak) UICollectionView *collectionView;
@property(nonatomic, strong) BXGHomeViewModel *courseVM;
@property(nonatomic, strong) NSArray<BXGHomeCourseModel*> *courseModel;

@end

@implementation BXGMoreCareerCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"就业班";
    self.pageName = @"更多-就业课";
    _courseVM = [BXGHomeViewModel new];
    
    [self installUI];
    
    [self installPullRefresh];
}

-(void)installPullRefresh
{
    __weak typeof(self) weakSelf = self;
    [_collectionView bxg_setHeaderRefreshBlock:^{
        [weakSelf refreshUI];
    }];
    
    // 马上进入刷新状态
    [self.collectionView bxg_beginHeaderRefresh];
}

-(void)refreshUI
{
    __weak typeof(self) weakSelf = self;
    self.courseModel = nil;
    [_courseVM loadMoreCareerCourseFinished:^(BOOL bSuccess, NSArray<BXGHomeCourseModel *> *arrCourseModel) {
        [weakSelf.collectionView bxg_endHeaderRefresh];
        
        if(bSuccess) {
            [weakSelf.collectionView removeMaskView];
            weakSelf.courseModel = arrCourseModel;
            if(weakSelf.courseModel.count==0) {
                [weakSelf.collectionView installMaskView:BXGMaskViewTypeNoData];
            }
        } else {
            [weakSelf.collectionView installMaskView:BXGMaskViewTypeLoadFailed];
        }
        [weakSelf.collectionView reloadData];
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
        make.top.offset(K_NAVIGATION_BAR_OFFSET+9);
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
