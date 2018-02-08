//
//  BXGMoreMicroCourseVC.m
//  Boxuegu
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMoreMicroCourseVC.h"
#import "BXGTabView.h"
#import "BXGTabViewItem.h"
#import "BXGHomeViewModel.h"
#import "BXGHomeCourseModel.h"
#import "BXGFilterSubjectView.h"
#import "BXGFilterLevelView.h"
#import "BXGFilterContentTypeView.h"
#import "BXGFilterOrderTypeView.h"
#import "ImageTextLayoutView.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "BXGMicroCourseCC.h"
#import "BXGMaskView.h"
#import "UIView+Pop.h"
#import "BXGCourseInfoVC.h"
#import "BXGMainTabBarController.h"

static NSString *BXGMicroCourseCCId = @"BXGMicroCourseCC";

//学科(subject) courseLevel(课程等级:基础) contentType(课程内容:全部, 项目实战) orderType(综合/最新)
@interface BXGMoreMicroCourseVC ()<BXGTabViewProtocol, UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) UICollectionView *detailCollectionView;
@property(nonatomic, strong) BXGHomeViewModel *homeVM;
@property(nonatomic, weak) UIView *curPopView;
@property(nonatomic, weak) BXGTabView *tabView;

@end

@implementation BXGMoreMicroCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_type==BOUTIQUE_MICRO_COURSE_TYPE) {
        self.title = @"精品微课";
        self.pageName = @"更多-精品微课";
    } else if(_type==FREE_MICRO_COURSE_TYPE) {
        self.title = @"免费微课";
        self.pageName = @"更多-免费微课";
    }
    // Do any additional setup after loading the view.
    [self installUI];
    
    [_detailCollectionView registerClass:[BXGMicroCourseCC class]
              forCellWithReuseIdentifier:BXGMicroCourseCCId];
    _homeVM = [BXGHomeViewModel new];
    if(_type == BOUTIQUE_MICRO_COURSE_TYPE) {
        _freeId = [NSNumber numberWithInteger:0];//精品微课
    } else if (_type == FREE_MICRO_COURSE_TYPE) {
        _freeId = [NSNumber numberWithInteger:1];//免费微课
    }

    [self installPullRefresh];
}


-(void)installPullRefresh
{
    __weak typeof(self) weakSelf = self;
//    _detailCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf refreshUI:YES];
//    }];

    [_detailCollectionView bxg_setHeaderRefreshBlock:^{
        [weakSelf refreshUI:YES];
    }];
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.detailCollectionView bxg_setFootterRefreshBlock:^{
        [weakSelf refreshUI:NO];
    }];
//    self.detailCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf refreshUI:NO];
//    }];

    // 马上进入刷新状态
//    [self.detailCollectionView.mj_header beginRefreshing];
    [self.detailCollectionView bxg_beginHeaderRefresh];
    [self.detailCollectionView bxg_endFootterRefreshNoMoreData];
}

-(void)refreshUI:(BOOL)bRefresh
{
    __weak typeof(self) weakSelf = self;
    [_homeVM loadFilterCourseInfoWithRefresh:bRefresh
                              andDirectionId:_directionId
                                andSubjectId:_subjectId
                                    andTagId:_tagId
                                andOrderType:_orderTypeId
                              andCourseLevel:_levelId
                              andContentType:_contentTypeId
                                      isFree:_freeId
                              andFinishBlock:^(BOOL bSuccess, NSError *error) {
        if(bSuccess)
        {
            [weakSelf.detailCollectionView removeMaskView];
            [weakSelf.detailCollectionView reloadData];
        }
        else
        {
            NSLog(@"fail to get note detail data");
        }
        [weakSelf.detailCollectionView  bxg_endHeaderRefresh];
        if(weakSelf.homeVM.bHaveMoreData)
        {
            [weakSelf.detailCollectionView bxg_endFootterRefresh];
        }
        else
        {
            [weakSelf.detailCollectionView bxg_endFootterRefreshNoMoreData];
        }
        if(weakSelf.homeVM.arrMicroFilterData.count == 0)
        {
            if(bRefresh)
            {
                [weakSelf.detailCollectionView installMaskView:BXGButtonMaskViewTypeNoFilterCourse buttonBlock:^{
                    [[BXGBaiduStatistic share] statisticEventString:kBXGStatMoreMicroCourseEventTypeHotCoureseRecommend andLabel:nil];
                    [self.mainViewController pushToHomeRootVC];
                    /*
                    BXGMainTabBarController * tabBarController = (BXGMainTabBarController*)self.view.window.rootViewController;
                    [tabBarController setSelectedIndex:BXGRootNavigationTypeHome];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    //*/
                }];
            }
            else
            {
                [weakSelf.detailCollectionView installMaskView:BXGMaskViewTypeLoadFailed];
            }
        }
    }];
}

- (void)installUI {
    self.view.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
    NSArray *arrString = @[@"学科", @"难度", @"类型", @"综合"];
    NSMutableArray* arrTabViewItems = [NSMutableArray new];
    for(int i=0; i<arrString.count; ++i) {
        UILabel *label = [UILabel new];
        label.font = [UIFont bxg_fontRegularWithSize:15];
        //label.textColor = [UIColor colorWithHex:0x38ADF];//选中
        label.textColor = [UIColor colorWithHex:0x333333];
        label.text = arrString[i];
        ImageTextLayoutView *layoutView = [[ImageTextLayoutView alloc] initImage:[UIImage imageNamed:@"向下"]
                                                                        andLabel:label
                                                              andImageTextLayout:ImageTextLayout_Right_Left
                                                                     andTapBlock:nil];
        BXGTabViewItem *itemView = [[BXGTabViewItem alloc] initWithItemView:layoutView andTag:i andIsOpen:NO andDelegate:self];
        [arrTabViewItems addObject:itemView];
        [layoutView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.offset(0);
        }];
    }
    
    BXGTabView *tabView = [[BXGTabView alloc] initWithItemViews:arrTabViewItems];
    [tabView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tabView];
    [tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(45);
    }];
    _tabView = tabView;
    
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(15, 0, 0, 0);
    UICollectionView *detailCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:detailCollectionView];
    detailCollectionView.delegate = self;
    detailCollectionView.dataSource = self;
    detailCollectionView.backgroundColor = [UIColor whiteColor];
    self.detailCollectionView = detailCollectionView;
    [self.view addSubview:detailCollectionView];
    
    [_detailCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tabView.mas_bottom).offset(9);
        make.left.right.bottom.offset(0);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    if(_curPopView) {
        [_curPopView hideView];
    }
}

#pragma mark BXGTabViewProtocol
//在同一个tab下点击切换
- (void)onSwitchTabViewItem:(BXGTabViewItem*)tabViewItem {
    switch(tabViewItem.tag) {
        case 0:
        {
            if(tabViewItem.bOpen) {
                [self showFilterSubjectView:tabViewItem];
            } else {
                [self adjustTabViewItem:tabViewItem andIsOpen:NO andShowTitle:nil];
                [_curPopView hideView];
            }
        }
            break;
        case 1:
        {
            if(tabViewItem.bOpen) {
                [self showFilterLevelView:tabViewItem];
            } else {
                [self adjustTabViewItem:tabViewItem andIsOpen:NO andShowTitle:nil];
                [_curPopView hideView];
            }
        }
            break;
        case 2:
        {
            if(tabViewItem.bOpen) {
                [self showFilterContentTypeView:tabViewItem];
            } else {
                [self adjustTabViewItem:tabViewItem andIsOpen:NO andShowTitle:nil];
                [_curPopView hideView];
            }
        }
            break;
        case 3:
        {
            if(tabViewItem.bOpen) {
                [self showFilterOrderTypeView:tabViewItem];
            } else {
                [self adjustTabViewItem:tabViewItem andIsOpen:NO andShowTitle:nil];
                [_curPopView hideView];
            }
        }
            break;
    }
}

- (void)showFilterSubjectView:(BXGTabViewItem*)tabViewItem {
    BXGFilterSubjectView *subjectView = [BXGFilterSubjectView new];
    [subjectView loadRequestType:self.type
                  andDirectionId:_directionId
                    andSubjectId:_subjectId
                        andTagId:_tagId];
//    subjectView.resetBlock = ^{
//        RWLog(@"resetBlock");
//        tabViewItem.bOpen = !tabViewItem.bOpen;
//        [self.view.subviews.lastObject removeFromSuperview];
//        [self refreshUI:YES];
//    };
    subjectView.confirmBlock = ^(NSNumber *directionId, NSNumber *subjectId, NSNumber *tagId, NSString *directionName, NSString *subjectName, NSString *tagName) {
        RWLog(@"confirmBlock");
        tabViewItem.bOpen = !tabViewItem.bOpen;
        [_curPopView hideView];
        _directionId = directionId;
        _subjectId = subjectId;
        _tagId = tagId;
        NSString *stringPara = [NSString stringWithFormat:@"(方向:%@, 学科:%@, 分类:%@)", directionName, subjectName, tagName];
        [[BXGBaiduStatistic share] statisticEventString : (_type==BOUTIQUE_MICRO_COURSE_TYPE?kBXGStatMoreMicroCourseEventTypeBoutiqueSujectConfirm : kBXGStatMoreMicroCourseEventTypeFreeSujectConfirm)
                                                andLabel:stringPara];
        [self adjustTabViewItem:tabViewItem andIsOpen:NO andShowTitle:nil];
        [self refreshUI:YES];
    };
    [self adjustTabViewItem:tabViewItem andIsOpen:YES andShowTitle:nil];
    [subjectView showInWindowAndBgAlpha:-1 andCancelBlock:^() {
        tabViewItem.bOpen = !tabViewItem.bOpen;
        [self adjustTabViewItem:tabViewItem andIsOpen:NO andShowTitle:nil];
    } andMaskViewConstraint:^(MASConstraintMaker *make) {
        make.top.equalTo(tabViewItem.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.bottom.offset(0);
    }];
    _curPopView = subjectView;
    [subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tabViewItem.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.bottom.offset(0);
    }];
}

- (void)showFilterLevelView:(BXGTabViewItem*)tabViewItem {
    BXGFilterLevelView *levelView = [[BXGFilterLevelView alloc] initWithDataSource:[BXGFilterLevelView dataSource]];
    levelView.selIndex = _levelId;
    /*
    if(!_levelId) {
        levelView.selIndex = [NSNumber numberWithInteger:0];
    } else {
        levelView.selIndex = [NSNumber numberWithInteger:_levelId.integerValue+1];
    }
     //*/
    levelView.didSelectBlock = ^(NSNumber *numberIndex, NSString *title) {
        NSLog(@"BXGFilterLevelView didSelectBlock");
        tabViewItem.bOpen = !tabViewItem.bOpen;
        [_curPopView hideView];
        if(!_levelId || (_levelId.integerValue!=numberIndex.integerValue) ) {
            _levelId = numberIndex;
            if(numberIndex==nil) {
                [[BXGBaiduStatistic share] statisticEventString:_type==BOUTIQUE_MICRO_COURSE_TYPE?kBXGStatMoreMicroCourseEventTypeBoutiqueLevelAll:kBXGStatMoreMicroCourseEventTypeFreeLevelAll
                                                       andLabel:title];
            } else {
                switch (numberIndex.integerValue) {
                        /*
                         case 0:
                         [[BXGBaiduStatistic share] statisticEventString:_type==BOUTIQUE_MICRO_COURSE_TYPE?kBXGStatMoreMicroCourseEventTypeBoutiqueLevelAll:kBXGStatMoreMicroCourseEventTypeFreeLevelAll
                         andLabel:title];
                         break;
                         //*/
                    case 1:
                        [[BXGBaiduStatistic share] statisticEventString:_type==BOUTIQUE_MICRO_COURSE_TYPE?kBXGStatMoreMicroCourseEventTypeBoutiqueLevelBasic:kBXGStatMoreMicroCourseEventTypeFreeLevelBasic
                                                               andLabel:title];
                        break;
                    case 2:
                        [[BXGBaiduStatistic share] statisticEventString:_type==BOUTIQUE_MICRO_COURSE_TYPE?kBXGStatMoreMicroCourseEventTypeBoutiqueLevelAdvanced:kBXGStatMoreMicroCourseEventTypeFreeLevelAdvanced
                                                               andLabel:title];
                        break;
                    case 3:
                        [[BXGBaiduStatistic share] statisticEventString:_type==BOUTIQUE_MICRO_COURSE_TYPE?kBXGStatMoreMicroCourseEventTypeBoutiqueLevelImprove:kBXGStatMoreMicroCourseEventTypeFreeLevelImprove
                                                               andLabel:title];
                        break;
                    default:
                        break;
                }
            }
            
            [self adjustTabViewItem:tabViewItem andIsOpen:NO andShowTitle:title];
            [self refreshUI:YES];
        }
    };
    [self adjustTabViewItem:tabViewItem andIsOpen:YES andShowTitle:nil];
    [levelView showInWindowAndBgAlpha:-1 andCancelBlock:^() {
        tabViewItem.bOpen = !tabViewItem.bOpen;
        [self adjustTabViewItem:tabViewItem andIsOpen:NO andShowTitle:nil];
    } andMaskViewConstraint:^(MASConstraintMaker *make) {
        make.top.equalTo(tabViewItem.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.bottom.offset(0);
    }];
    _curPopView = levelView;
    [levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tabViewItem.mas_bottom).offset(0);
        make.left.right.offset(0);
        // make.bottom.offset(0);
        make.height.equalTo(@(levelView.dataSource.count*44));
    }];
}

- (void)showFilterContentTypeView:(BXGTabViewItem*)tabViewItem {
    BXGFilterContentTypeView *contentTypeView = [[BXGFilterContentTypeView alloc] initWithDataSource:[BXGFilterContentTypeView dataSource]];
    contentTypeView.selIndex = _contentTypeId;
    contentTypeView.didSelectBlock = ^(NSNumber *numberIndex, NSString* title) {
        NSLog(@"contentTypeView didSelectBlock");
        tabViewItem.bOpen = !tabViewItem.bOpen;
        [_curPopView hideView];
        if(!_contentTypeId || (_contentTypeId.integerValue!=numberIndex.integerValue)) {
            switch (numberIndex.integerValue) {
//                    @property(nonatomic, strong) NSNumber *levelId;课程等级:0-基础 1-进阶 2-提高
//                    @property(nonatomic, strong) NSNumber *contentTypeId;课程内容:0-全部 1-知识点精讲 2-项目实战
//                    @property(nonatomic, strong) NSNumber *orderTypeId; 排序方式:0-综合 1-最新 2-最热
                case 0:
                    [[BXGBaiduStatistic share] statisticEventString:_type==BOUTIQUE_MICRO_COURSE_TYPE?kBXGStatMoreMicroCourseEventTypeBoutiqueContentAll:kBXGStatMoreMicroCourseEventTypeFreeContentAll
                                                           andLabel:title];
                    break;
                case 1:
                    [[BXGBaiduStatistic share] statisticEventString:_type==BOUTIQUE_MICRO_COURSE_TYPE?kBXGStatMoreMicroCourseEventTypeBoutiqueContentIncisive:kBXGStatMoreMicroCourseEventTypeFreeContentIncisive
                                                           andLabel:title];
                    break;
                case 2:
                    [[BXGBaiduStatistic share] statisticEventString:_type==BOUTIQUE_MICRO_COURSE_TYPE?kBXGStatMoreMicroCourseEventTypeBoutiqueContentProjectPractice:kBXGStatMoreMicroCourseEventTypeFreeContentProjectPractice
                                                           andLabel:title];
                    break;
                default:
                    break;
            }
            _contentTypeId = numberIndex;
            [self adjustTabViewItem:tabViewItem andIsOpen:NO andShowTitle:title];
            [self refreshUI:YES];
        }
    };
    [self adjustTabViewItem:tabViewItem andIsOpen:YES andShowTitle:nil];
    [contentTypeView showInWindowAndBgAlpha:-1 andCancelBlock:^() {
        tabViewItem.bOpen = !tabViewItem.bOpen;
        [self adjustTabViewItem:tabViewItem andIsOpen:NO andShowTitle:nil];
    } andMaskViewConstraint:^(MASConstraintMaker *make) {
        make.top.equalTo(tabViewItem.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.bottom.offset(0);
    }];
    _curPopView = contentTypeView;
    [contentTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tabViewItem.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.height.equalTo(@(contentTypeView.dataSource.count*44));
    }];
}

- (void)showFilterOrderTypeView:(BXGTabViewItem*)tabViewItem {
    BXGFilterOrderTypeView *orderTypeView = [[BXGFilterOrderTypeView alloc] initWithDataSource:[BXGFilterOrderTypeView dataSource]];
    orderTypeView.selIndex = _orderTypeId;
    orderTypeView.didSelectBlock = ^(NSNumber *numberIndex, NSString* title) {
        NSLog(@"orderTypeView didSelectBlock");
        tabViewItem.bOpen = !tabViewItem.bOpen;
        [_curPopView hideView];
        if(!_orderTypeId || (_orderTypeId.integerValue!=numberIndex.integerValue)) {
          switch (numberIndex.integerValue) {
                case 0:
                  [[BXGBaiduStatistic share] statisticEventString:_type==BOUTIQUE_MICRO_COURSE_TYPE?kBXGStatMoreMicroCourseEventTypeBoutiqueOrderComprehensive:kBXGStatMoreMicroCourseEventTypeFreeOrderComprehensive
                                                         andLabel:title];
                    break;
                case 1:
                  [[BXGBaiduStatistic share] statisticEventString:_type==BOUTIQUE_MICRO_COURSE_TYPE?kBXGStatMoreMicroCourseEventTypeBoutiqueOrderLatest:kBXGStatMoreMicroCourseEventTypeFreeOrderLatest
                                                         andLabel:title];
                    break;
                case 2:
                  [[BXGBaiduStatistic share] statisticEventString:_type==BOUTIQUE_MICRO_COURSE_TYPE?kBXGStatMoreMicroCourseEventTypeBoutiqueOrderHottest:kBXGStatMoreMicroCourseEventTypeFreeOrderHottest
                                                         andLabel:title];
                    break;
                default:
                    break;
            }
            _orderTypeId = numberIndex;
            [self adjustTabViewItem:tabViewItem andIsOpen:NO andShowTitle:title];
            [self refreshUI:YES];
        }
    };
    [self adjustTabViewItem:tabViewItem andIsOpen:YES andShowTitle:nil];
    [orderTypeView showInWindowAndBgAlpha:-1 andCancelBlock:^() {
        tabViewItem.bOpen = !tabViewItem.bOpen;
        [self adjustTabViewItem:tabViewItem andIsOpen:NO andShowTitle:nil];
    } andMaskViewConstraint:^(MASConstraintMaker *make) {
        make.top.equalTo(tabViewItem.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.bottom.offset(0);
    }];
    _curPopView = orderTypeView;
    [orderTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tabViewItem.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.height.equalTo(@(orderTypeView.dataSource.count*44));
    }];
}

- (void)adjustTabViewItem:(BXGTabViewItem*)tabViewItem andIsOpen:(BOOL)bOpen andShowTitle:(NSString*)title {
    if(bOpen) {
        if ([tabViewItem.subviews.lastObject isKindOfClass:[ImageTextLayoutView class]]) {
            ImageTextLayoutView *imageTextView = tabViewItem.subviews.lastObject;
            [imageTextView setImage:[UIImage imageNamed:@"向上"]];
            [imageTextView setTextColor:[UIColor colorWithHex:0x38ADFF]];
        }
    }
    else {
        if ([tabViewItem.subviews.lastObject isKindOfClass:[ImageTextLayoutView class]]) {
            ImageTextLayoutView *imageTextView = tabViewItem.subviews.lastObject;
            [imageTextView setImage:[UIImage imageNamed:@"向下"]];
            [imageTextView setTextColor:[UIColor colorWithHex:0x333333]];
            if(title) {
                [imageTextView setText:title];
            }
        }
    }
}


//在不同tab下点击切换
- (void)onSelectChangeBeforeItem:(BXGTabViewItem*)beforeItem andCurItem:(BXGTabViewItem*)curItem {
    //NSAssert(beforeItem.bOpen==NO, @"beforeItem state is open");
    NSAssert(curItem.bOpen==YES, @"curItem state isn't open");
    if(beforeItem.bOpen)
    {
        beforeItem.bOpen = !beforeItem.bOpen;
        [self adjustTabViewItem:beforeItem andIsOpen:NO andShowTitle:nil];
        [_curPopView hideView];
    }
    switch (curItem.tag) {
        case 0:
            [self showFilterSubjectView:curItem];
            break;
        case 1:
            [self showFilterLevelView:curItem];
            break;
        case 2:
            [self showFilterContentTypeView:curItem];
            break;
        case 3:
            [self showFilterOrderTypeView:curItem];
            break;
        default:
            break;
    }
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.homeVM.arrMicroFilterData.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.homeVM && self.homeVM.arrMicroFilterData && self.homeVM.arrMicroFilterData.count>indexPath.row) {
        BXGMicroCourseCC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BXGMicroCourseCCId forIndexPath:indexPath];
        BXGHomeCourseModel *model = self.homeVM.arrMicroFilterData[indexPath.row];
        [cell setModel:model andIndex:indexPath.row];
        return cell;
    }
    else {
        return nil;
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retSize = CGSizeZero;
    if(indexPath.section==0) {
        retSize.width = SCREEN_WIDTH/2;
        retSize.height = 10+((retSize.width-15-7.5)*93.0f/165.0f)+6+14+5+12+10;
    }
    return retSize;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    if(self.homeVM && self.homeVM.arrMicroFilterData && self.homeVM.arrMicroFilterData.count>indexPath.row) {
        BXGHomeCourseModel *model = self.homeVM.arrMicroFilterData[indexPath.row];
//        @interface BXGCourseInfoVC : BXGBaseRootVC <BXGCourseInfoFoldable>
//        @property (nonatomic, strong) BXGHomeCourseModel *courseModel;
//        - (instancetype)initWithCourseModel:(BXGHomeCourseModel *)courseModel;
//        @end
        BXGCourseInfoViewModel *courseInfoVM = [[BXGCourseInfoViewModel alloc]initWithCourseModel:model];
        BXGCourseInfoVC *courseInfoVC = [[BXGCourseInfoVC alloc] initWithViewModel:courseInfoVM];
//        BXGCourseInfoVC *courseInfoVC = [[BXGCourseInfoVC alloc] initWithCourseModel:model];
        [self.navigationController pushViewController:courseInfoVC animated:YES];
    }
}

@end
