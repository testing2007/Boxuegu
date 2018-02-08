//
//  BXGSearchResultView.m
//  Boxuegu
//
//  Created by apple on 2017/12/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGSearchResultView.h"
#import "BXGSearchResultContentCC.h"
#import "BXGSearchViewModel.h"
#import "BXGSearchCourseModel.h"
#import "RWSectionBackgroundFlowLayout.h"
#import "BXGSearchResultHeaderView.h"
#import "BXGCourseInfoViewModel.h"
#import "BXGCourseInfoVC.h"
#import "UIView+Extension.h"

@interface BXGSearchResultView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) BXGSearchResultHeaderView *headerView;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) BXGSearchViewModel *searchVM;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) BXGSearchCourseModel *courseModel;

@end

static NSString *BXGSearchResultContentCCId = @"BXGSearchResultContentCC";
//static NSString *BXGSearchResultHeaderViewId = @"BXGSearchResultHeaderView";

@implementation BXGSearchResultView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor =  [UIColor colorWithHex:0xF5F5F5];//
        self.searchVM = [BXGSearchViewModel new];
        
        [self installUI];
        [self registUI];
    }
    return self;
}


-(void)doSearchByKeyword:(NSString*)keyword {
    _keyword = keyword;
    NSLog(@"search keyword is = %@", keyword);
    [self installPullRefresh];
}

-(void)installPullRefresh
{
    __weak typeof(self) weakSelf = self;
    
    [weakSelf.collectionView bxg_setHeaderRefreshBlock:^{
        [weakSelf refreshUI:YES];
    }];
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [weakSelf.collectionView bxg_setFootterRefreshBlock:^{
        [weakSelf refreshUI:NO];
    }];
    
    [self.collectionView bxg_beginHeaderRefresh];
    [self.collectionView bxg_endFootterRefreshNoMoreData];
}

-(void)refreshUI:(BOOL)bRefresh
{
    __weak typeof(self) weakSelf = self;
    
//    [[BXGHUDTool share] showLoadingHUDWithString:nil];
    [self.collectionView removeMaskView];
    self.headerView.titleLabel.text = @"搜索中...";
    [self.searchVM loadRequestSearchCourseListByRefresh:bRefresh
                                             andKeyword:_keyword
                                         andFinishBlock:^(BOOL bSuccess, NSString *errorMessage, BXGSearchCourseModel *courseModel) {
//                                             [[BXGHUDTool share] closeHUD];
                                             if(bSuccess) {
                                                 weakSelf.courseModel = courseModel;
                                                 if([weakSelf.courseModel.totalCount integerValue]==0) {
                                                     weakSelf.headerView.titleLabel.text = @"共搜索到0个课程";
                                                     [weakSelf.collectionView installMaskView:BXGMaskViewTypeNoSearchInfo];
                                                 } else {
                                                     weakSelf.headerView.titleLabel.text = [NSString stringWithFormat:@"共搜索到%ld个课程", (long)[weakSelf.courseModel.totalCount integerValue]];
                                                     [weakSelf.collectionView reloadData];
                                                 }
                                             } else {
                                                 weakSelf.headerView.titleLabel.text = @"共搜索到0个课程";
                                                 [weakSelf.collectionView installMaskView:BXGMaskViewTypeLoadFailed];
                                             }
                                             
                                             [weakSelf.collectionView bxg_endHeaderRefresh];
                                             if(weakSelf.searchVM.haveMoreCourseModelData)
                                             {
                                                 [weakSelf.collectionView bxg_endFootterRefresh];
                                             }
                                             else
                                             {
                                                 [weakSelf.collectionView bxg_endFootterRefreshNoMoreData];
                                             }
    }];
}

-(void)installUI {
    BXGSearchResultHeaderView *headerView = [[BXGSearchResultHeaderView alloc] init];
    [self addSubview:headerView];
    _headerView = headerView;
    
    RWSectionBackgroundFlowLayout *layout = [[RWSectionBackgroundFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(9, 0, 0, 0);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.equalTo(@40);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(0);
        make.left.right.bottom.offset(0);
    }];
}

-(void)registUI {
    [self.collectionView registerClass:[BXGSearchResultContentCC class] forCellWithReuseIdentifier:BXGSearchResultContentCCId];
//    [self.collectionView registerClass:[BXGSearchResultHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BXGSearchResultHeaderViewId];
}

#pragma mark - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.courseModel.items.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BXGSearchResultContentCC *cell = nil;
    NSMutableArray<BXGHomeCourseModel *> *arrCourseModel = nil;
    if(self.courseModel && self.courseModel.items ) {
        arrCourseModel = self.courseModel.items;
        if(arrCourseModel && indexPath.row<arrCourseModel.count) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:BXGSearchResultContentCCId forIndexPath:indexPath];
            [cell setModel:arrCourseModel[indexPath.row] andKeyword:_keyword];
        }
    }
    
    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    BXGSearchResultHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BXGSearchResultHeaderViewId forIndexPath:indexPath];
//    headerView.titleLabel.text = [NSString stringWithFormat:@"共搜索到%ld个课程", (unsigned long)self.courseModel.items.count];
//    return headerView;
//}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH / 3.4);
    return retSize;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout*)collectionViewLayout
//referenceSizeForHeaderInSection:(NSInteger)section {
//    CGSize retSize = CGSizeMake(SCREEN_WIDTH, 40);
//    return retSize;
//}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
//    @property (nonatomic, strong) NSNumber *courseType;     //课程类型 0-就业课 1-微课
//    @property (nonatomic, strong) NSNumber *isFree;         //是否免费 0-否 1-是
    if(self.courseModel && self.courseModel.items && indexPath.row<self.courseModel.items.count) {
        BXGHomeCourseModel *curCourseModel = self.courseModel.items[indexPath.row];
        if(curCourseModel.courseType.integerValue==0) {
            //就业课
            BXGCourseInfoViewModel *courseInfoVM = [[BXGCourseInfoViewModel alloc]initWithCourseModel:curCourseModel];
            BXGCourseInfoVC *courseInfoVC = [[BXGCourseInfoVC alloc] initWithViewModel:courseInfoVM];
            [self.findOwnerVC.navigationController pushViewController:courseInfoVC animated:YES];
        } else if (curCourseModel.courseType.integerValue==1 && curCourseModel.isFree.integerValue==0) {
            //精品微课
            BXGCourseInfoViewModel *courseInfoVM = [[BXGCourseInfoViewModel alloc]initWithCourseModel:curCourseModel];
            BXGCourseInfoVC *courseInfoVC = [[BXGCourseInfoVC alloc] initWithViewModel:courseInfoVM];
            [self.findOwnerVC.navigationController pushViewController:courseInfoVC animated:YES];
        } else if (curCourseModel.courseType.integerValue==1 && curCourseModel.isFree.integerValue==1) {
            //免费微课
            BXGCourseInfoViewModel *courseInfoVM = [[BXGCourseInfoViewModel alloc]initWithCourseModel:curCourseModel];
            BXGCourseInfoVC *courseInfoVC = [[BXGCourseInfoVC alloc] initWithViewModel:courseInfoVM];
            [self.findOwnerVC.navigationController pushViewController:courseInfoVC animated:YES];
        } else {
            NSAssert(NO, @"data is unsupport");
        }
    }
}

@end
