//
//  BXGHomeRootVC.m
//  Boxuegu
//
//  Created by apple on 2017/10/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGHomeRootVC.h"
#import "RWBadgeView.h"
#import "RWCommonFunction.h"
#import "BXGCareerCourseCC.h"
#import "BXGMicroCourseCC.h"
#import "BXGHomeHeaderView.h"
#import "BXGDownloadManagerVC.h"
#import "BXGMeLearnedHistoryVC.h"
#import "BXGMeMyMessageVC.h"
#import "BXGMessageTool.h"
#import "BXGMoreCareerCourseVC.h"
#import "BXGMoreMicroCourseVC.h"
#import "BXGHome.h"
#import "BXGBannerCC.h"
#import "BXGHomeViewModel.h"
#import "BXGHomeCourseListModel.h"
#import "BXGMoreCareerCourseVC.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "BXGCourseInfoVC.h"
#import "BXGTopicVC.h"
#import "BXGStudyRecentFloatTipView.h"
#import "BXGBasePlayerVC.h"
#import "BXGStudyProCoursePlanVC.h"
#import "RWSectionBackgroundFlowLayout.h"
#import "BXGSearchVC.h"

#define kBXGEventHomeRootVCOnClickBanner

@interface BXGHomeRootVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BXGNotificationDelegate>
@property (nonatomic, weak) UICollectionView *homeCollectionView;
@property (nonatomic, weak) RWBadgeView *badgeView;
@property (nonatomic, weak) UIBarButtonItem *messagBarButtonItem;
@property (nonatomic, strong) BXGHomeViewModel *homeVM;
@property (nonatomic, strong) BXGHomeCourseListModel *courseListModel;
@property (nonatomic, strong) NSArray<BXGBannerModel *> *arrBannerModel;
@property (nonatomic, strong) BXGStudyRecentFloatTipView *recentView;
@property (nonatomic, strong) BXGStudyProCoursePlanVC *proCourseVC;
@end

static NSString *BXGBannerCCId = @"BXGBannerCC";
static NSString *BXGCareerCourseCCId = @"BXGCareerCourseCC";
static NSString *BXGMicroCourseCCId = @"BXGMicroCourseCC";
static NSString *BXGHomeHeaderViewId = @"BXGHomeHeaderView";

@implementation BXGHomeRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加首页标题
    self.pageName = @"首页";
    [self  installObservers];
    
    BXGStudyProCoursePlanVC *vc = [BXGStudyProCoursePlanVC new];
    self.proCourseVC = vc;
    
    [self installNavigationBarItem];
    [self installUI];
    
    // 获取用户当前状态
    if([BXGUserDefaults share].userModel){
        
        [BXGNotificationTool postNotificationForUserLogin:true];
    }
    //获取信息
    _homeVM =[BXGHomeViewModel new];
    [self installPullRefresh];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.recentView closeTipView];
}

-(void)dealloc {
    [self uninstallObservers];
}

- (void)installObservers
{
    [BXGNotificationTool addObserverForUserLogin:self];
    [BXGNotificationTool addObserverForNewMessageCount:self];
}

- (void)uninstallObservers
{
    [BXGNotificationTool removeObserver:self];
}

- (void)catchUserLoginNotificationWith:(BOOL)isLogin {
    if(isLogin) {
        [self.recentView loadContent:nil];
    } else {
        self.recentView.model = nil;
    }
}

-(void)installPullRefresh
{
    __weak typeof(self) weakSelf = self;
    [_homeCollectionView bxg_setHeaderRefreshBlock:^{
        [weakSelf refreshUI];
    }];
    // 马上进入刷新状态
    [self.homeCollectionView bxg_beginHeaderRefresh];
}

-(void)refreshUI
{
    __weak typeof (self) weakSelf = self;
    __block BOOL bRequestSuccess = YES;
    _courseListModel = nil;
    _arrBannerModel = nil;

    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建一个信号量为0的信号(红灯)
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);

        [_homeVM loadCourseInfoFinished:^(BOOL bSuccess, BXGHomeCourseListModel *courseListModel) {
            [weakSelf.homeCollectionView bxg_endHeaderRefresh];
            if(bSuccess) {
                weakSelf.courseListModel = courseListModel;
                bRequestSuccess &= YES;
            } else {
//                [weakSelf.homeCollectionView installMaskView:BXGMaskViewTypeLoadFailed];
                bRequestSuccess &= NO;
            }

            // 使信号的信号量+1，这里的信号量本来为0，+1信号量为1(绿灯)
            dispatch_semaphore_signal(sema);
            RWLog(@"####wait 1");
        }];

        // 开启信号等待，设置等待时间为永久，直到信号的信号量大于等于1（绿灯）
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });

    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建一个信号量为0的信号(红灯)
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);


        [_homeVM loadBannerFinished:^(BOOL bSuccess, NSArray<BXGBannerModel *> *arrBannerModel) {
            [weakSelf.homeCollectionView  bxg_endHeaderRefresh];
            if(bSuccess ){
                weakSelf.arrBannerModel = arrBannerModel;
                bRequestSuccess &= YES;
            } else {
//                [weakSelf.homeCollectionView installMaskView:BXGMaskViewTypeLoadFailed];
                bRequestSuccess &= NO;
            }
            
            // 使信号的信号量+1，这里的信号量本来为0，+1信号量为1(绿灯)
            dispatch_semaphore_signal(sema);
            RWLog(@"####wait 2");
        }];
        
        // 开启信号等待，设置等待时间为永久，直到信号的信号量大于等于1（绿灯）
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        RWLog(@"####刷新界面等在主线程的操作");
        if(!bRequestSuccess) {
            [weakSelf.homeCollectionView installMaskView:BXGMaskViewTypeLoadFailed];
            weakSelf.courseListModel = nil;
            weakSelf.arrBannerModel = nil;
        } else {
            [weakSelf.homeCollectionView removeMaskView];
        }
        [weakSelf.homeCollectionView reloadData];
    });
}

- (void)installNavigationBarItem
{
    [super installNavigationBar];

    // 导航栏
    BarElement *downloadBarElement = [BarElement new];
    downloadBarElement.target = self;
    downloadBarElement.sel = @selector(operationDownload);
    downloadBarElement.imageName = @"导航栏-下载";
    downloadBarElement.size = CGSizeMake(RWAutoFontSize(24), RWAutoFontSize(24));
    downloadBarElement.tintColor = [UIColor whiteColor];
    
    BarElement *viewRecordBarElement = [BarElement new];
    viewRecordBarElement.target = self;
    viewRecordBarElement.sel = @selector(operationViewRecord);
    viewRecordBarElement.imageName = @"导航栏-观看记录";
    viewRecordBarElement.size = CGSizeMake(RWAutoFontSize(24), RWAutoFontSize(24));
    viewRecordBarElement.tintColor = [UIColor whiteColor];
    
    BXGBaseNaviController *navi = (BXGBaseNaviController*)self.navigationController;
    NSArray *arrRightBarItems = [navi createNaviBarItemsWithBarElements:@[downloadBarElement,
                                                                           viewRecordBarElement]
                                                         andBarItemSpace:15];

    BarElement *messageBarElement = [BarElement new];
    messageBarElement.target = self;
    messageBarElement.sel = @selector(operationMessage);
    messageBarElement.imageName = @"导航栏-我的消息";
    messageBarElement.size = CGSizeMake(RWAutoFontSize(24), RWAutoFontSize(24));
    messageBarElement.tintColor = [UIColor whiteColor];
    BarElement *searchBarElement = [BarElement new];
    searchBarElement.target = self;
    searchBarElement.sel = @selector(operationSearch);
    searchBarElement.imageName = @"导航栏-搜索";
    searchBarElement.size = CGSizeMake(RWAutoFontSize(24), RWAutoFontSize(24));
    searchBarElement.tintColor = [UIColor whiteColor];

    NSArray *arrLeftBarItems =  [navi createNaviBarItemsWithBarElements:@[searchBarElement,
                                                                          messageBarElement]
                                                         andBarItemSpace:15];
        self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    _messagBarButtonItem = arrLeftBarItems[0];
    _messagBarButtonItem.customView.clipsToBounds = NO;
    RWBadgeView *badgeView = [RWBadgeView new];
    self.badgeView = badgeView;
    [_messagBarButtonItem.customView addSubview:badgeView];
    badgeView.badgeFontSize = 10;
    badgeView.badgeNumber = [BXGMessageTool share].countOfNewMessage;
    badgeView.userInteractionEnabled = NO;
    [badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(-5);
        make.right.offset(6);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    _badgeView = badgeView;
}

- (void)installUI {
    __weak typeof (self) weakSelf = self;
    
    RWSectionBackgroundFlowLayout *layout = [[RWSectionBackgroundFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 9, 0);
    UICollectionView *homeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    homeCollectionView.delegate = self;
    homeCollectionView.dataSource = self;
    homeCollectionView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    self.homeCollectionView = homeCollectionView;
    [self.view addSubview:homeCollectionView];
    
    self.recentView = [BXGStudyRecentFloatTipView new];
    [self.view addSubview:self.recentView];
    
    self.recentView.touchUpInsideBlock = ^(BXGBasePlayerVC *playerVC) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.navigationController pushViewController:playerVC animated:true];
        });
    };
    self.recentView.closeTipViewBlock = ^{
        [weakSelf.proCourseVC updateLayout];
    };
    
    [_homeCollectionView registerClass:[BXGBannerCC class] forCellWithReuseIdentifier:BXGBannerCCId];
    [_homeCollectionView registerClass:[BXGCareerCourseCC class]
            forCellWithReuseIdentifier:BXGCareerCourseCCId];
    [_homeCollectionView registerClass:[BXGMicroCourseCC class]
            forCellWithReuseIdentifier:BXGMicroCourseCCId];
    [_homeCollectionView registerClass:[BXGHomeHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:BXGHomeHeaderViewId];
    
    [homeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.recentView.mas_bottom).offset(0);
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.right.bottom.offset(0);
    }];
    
    [self.recentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.right.offset(0);
        make.height.equalTo(@38);
    }];
    self.recentView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification
/// 监听消息接收
- (void)catchNewMessageCount:(NSInteger)count
{
    if(count > 0)
    {
        self.badgeView.badgeNumber = count;
    }
    else
    {
        self.badgeView.badgeNumber = 0;
    }
}

#pragma mark - Operation
- (void)operationDownload
{
    RWLog(@"跳转到下载");
    [[BXGBaiduStatistic share] statisticEventString:kBXGStatHomeRootEventTypeDownload andLabel:nil];
//    [[BXGBaiduStatistic share] statisticEventString:xzgl_icon_08 andParameter:nil];
    BXGDownloadManagerVC *vc = [BXGDownloadManagerVC new];
    [self.navigationController pushViewController:vc animated:true needLogin:true];
}

- (void)operationViewRecord
{
    RWLog(@"跳转到观看记录");
    [[BXGBaiduStatistic share] statisticEventString:kBXGStatHomeRootEventTypeLearnHistory andLabel:nil];
//    [[BXGBaiduStatistic share] statisticEventString:gkjl_icon_10 andParameter:nil];
    BXGMeLearnedHistoryVC *vc = [BXGMeLearnedHistoryVC new];
    [self.navigationController pushViewController:vc animated:true needLogin:true];
}

- (void)operationMessage
{
    RWLog(@"跳转到我的消息");
    [[BXGBaiduStatistic share] statisticEventString:kBXGStatHomeRootEventTypeMyMessage andLabel:nil];
//    [[BXGBaiduStatistic shaxre] statisticEventString:xx_icon_11 andParameter:nil];
    BXGMeMyMessageVC *vc = [BXGMeMyMessageVC new];
    [self.navigationController pushViewController:vc animated:true needLogin:true];
}

- (void)operationSearch {
    RWLog(@"跳转到搜索");
    [[BXGBaiduStatistic share] statisticEventString:kBXGStatSearchEventTypeIntoSearchPage andLabel:@"首页"];
    BXGSearchVC *vc = [BXGSearchVC new];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //    [self.navigationController pushViewController:vc animated:true needLogin:false];
    BXGBaseNaviController *nav = [[BXGBaseNaviController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger nCount = 0;
    
    switch (section) {
        case 0:
            nCount = 1; 
            break;
        case 1:
            nCount = self.courseListModel.careerCourse.count;
            break;
        case 2:
            nCount = self.courseListModel.boutiqueMicroCourse.count;
            break;
        case 3:
            nCount = self.courseListModel.freeMicroCourse.count;
            break;
        default:
            break;
    }
    return nCount;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    if (indexPath.section==0) {
        Weak(weakSelf);
        BXGBannerCC *cc = [collectionView dequeueReusableCellWithReuseIdentifier:BXGBannerCCId forIndexPath:indexPath];
        [cc setModel:_arrBannerModel andTapBlock:^(NSInteger tag) {
            if(weakSelf.arrBannerModel && tag<weakSelf.arrBannerModel.count) {
                BXGBannerModel *model = weakSelf.arrBannerModel[tag];
                // TODO: 添加统计
                [[BXGBaiduStatistic share] statisticEventString:kBXGStatHomeRootEventTypeBanner andLabel:model.name];
                if(model.type.integerValue == 0) {
                    //课程详情
                    BXGCourseInfoViewModel *courseInfoVM = [[BXGCourseInfoViewModel alloc]initWithCourseId:model.courseId];
                    BXGCourseInfoVC *courseInfoVC = [[BXGCourseInfoVC alloc] initWithViewModel:courseInfoVM];
                    [weakSelf.navigationController pushViewController:courseInfoVC animated:YES];
                } else {
                    //专题活动
                    if(model.imgHref) {
                        BXGTopicVC *vc = [BXGTopicVC new];
                        vc.urlString = [NSURL URLWithString:model.imgHref];
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }
                }
            }
        }];
        cell = cc;
    } else if(indexPath.section==1) {
        BXGCareerCourseCC *cc = [collectionView dequeueReusableCellWithReuseIdentifier:BXGCareerCourseCCId forIndexPath:indexPath];
        BXGHomeCourseModel *model = self.courseListModel.careerCourse[indexPath.row];
//        NSAssert(model.courseType.integerValue==0, @"the course isn't belong to career course type");
        [cc setModel:model];
        cell = cc;
    } else if (indexPath.section==2) {
        BXGMicroCourseCC *cc = [collectionView dequeueReusableCellWithReuseIdentifier:BXGMicroCourseCCId forIndexPath:indexPath];
        BXGHomeCourseModel *model = self.courseListModel.boutiqueMicroCourse[indexPath.row];
//        NSAssert((model.courseType.integerValue==1&&model.isFree.integerValue==0), @"the course isn't belong to boutique microcourse type");
        [cc setModel:model andIndex:indexPath.row];
        cell = cc;
    } else if (indexPath.section==3) {
        BXGMicroCourseCC *cc = [collectionView dequeueReusableCellWithReuseIdentifier:BXGMicroCourseCCId forIndexPath:indexPath];
        BXGHomeCourseModel *model = self.courseListModel.freeMicroCourse[indexPath.row];
//        NSAssert((model.courseType.integerValue==1&&model.isFree.integerValue==1), @"the course isn't belong to free microcourse type");
        [cc setModel:model andIndex:indexPath.row];
        cell = cc;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView; {
    int nSection = 0;
    //if( /*bannerModel*/)
    if(1)
        nSection += 1;
    if(_courseListModel)
        nSection += 3;
    return nSection;
}
// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    BXGHomeHeaderView *headerTitleView = nil;
    switch(indexPath.section) {
        case 1:
            headerTitleView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                 withReuseIdentifier:BXGHomeHeaderViewId
                                                                        forIndexPath:indexPath];
            headerTitleView.titleLabel.text = @"就业班";
            headerTitleView.type = CAREER_COURSE_TYPE;
            [headerTitleView setBackgroundColor:[UIColor colorWithHex:0xFFFFFF]];
            break;
        case 2:
            headerTitleView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                 withReuseIdentifier:BXGHomeHeaderViewId
                                                                        forIndexPath:indexPath];
            headerTitleView.titleLabel.text = @"精品微课";
            headerTitleView.type = BOUTIQUE_MICRO_COURSE_TYPE;
            [headerTitleView setBackgroundColor:[UIColor colorWithHex:0xFFFFFF]];
            break;
        case 3:
            headerTitleView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                 withReuseIdentifier:BXGHomeHeaderViewId
                                                                        forIndexPath:indexPath];
            headerTitleView.titleLabel.text = @"免费微课";
            headerTitleView.type = FREE_MICRO_COURSE_TYPE;
            [headerTitleView setBackgroundColor:[UIColor colorWithHex:0xFFFFFF]];
            break;
        default:
            break;
    }
    if(headerTitleView) {
        headerTitleView.moreBlock = ^(int type) {
            switch (type) {
                case CAREER_COURSE_TYPE:
                {
                    [[BXGBaiduStatistic share] statisticEventString:kBXGStatHomeRootEventTypeMoreCaareerCourse andLabel:nil];
                    BXGMoreCareerCourseVC *vc = [BXGMoreCareerCourseVC new];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case BOUTIQUE_MICRO_COURSE_TYPE:
                {
                    [[BXGBaiduStatistic share] statisticEventString:kBXGStatHomeRootEventTypeMoreMiniCourse andLabel:nil];
                    BXGMoreMicroCourseVC *vc = [BXGMoreMicroCourseVC new];
                    vc.type = type;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case FREE_MICRO_COURSE_TYPE:
                {
                    [[BXGBaiduStatistic share] statisticEventString:kBXGStatHomeRootEventTypeMoreFreeCourse andLabel:nil];
                    BXGMoreMicroCourseVC *vc = [BXGMoreMicroCourseVC new];
                    vc.type = type;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;

                default:
                    NSAssert(FALSE, @"couldn't happen");
                    break;
            }
        };
    }
    return headerTitleView;
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retSize = CGSizeZero;
    if(indexPath.section==0) {
        retSize.width = SCREEN_WIDTH;
        if(!_arrBannerModel || _arrBannerModel.count==0) {
            retSize.height = 1;
        } else {
            retSize.height = SCREEN_WIDTH * 300.0/750.0;
        }
    } else if(indexPath.section==1) {
        retSize.width = SCREEN_WIDTH;
        retSize.height = SCREEN_WIDTH / 3.4;
    } else if(indexPath.section==2) {
        retSize.width = SCREEN_WIDTH / 2.0;
        retSize.height = ((retSize.width-15-7.5)*93.0f/165.0f)+6+14+5+12+20;
    } else if(indexPath.section==3) {
        retSize.width = SCREEN_WIDTH / 2.0;
        retSize.height = ((retSize.width-15-7.5)*93.0f/165.0f)+6+14+5+12+20;
    }
    return retSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize retSize = CGSizeZero;
    if(section==0) {
        retSize = CGSizeZero;
    } else {
        retSize = CGSizeMake(SCREEN_WIDTH, 48);
    }
    return retSize;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    switch(indexPath.section) {
        case 0:
            break;
        case 1: //就业班
        {
            BXGCourseInfoViewModel *courseInfoVM = [[BXGCourseInfoViewModel alloc]initWithCourseModel:self.courseListModel.careerCourse[indexPath.row]];
            BXGCourseInfoVC *courseInfoVC = [[BXGCourseInfoVC alloc] initWithViewModel:courseInfoVM];
            [self.navigationController pushViewController:courseInfoVC animated:YES];
        }
            break;
        case 2: //精品微课
        {
            BXGCourseInfoViewModel *courseInfoVM = [[BXGCourseInfoViewModel alloc]initWithCourseModel:self.courseListModel.boutiqueMicroCourse[indexPath.row]];
            BXGCourseInfoVC *courseInfoVC = [[BXGCourseInfoVC alloc] initWithViewModel:courseInfoVM];
            [self.navigationController pushViewController:courseInfoVC animated:YES];
        }
            break;
        case 3: //免费微课
        {
            BXGCourseInfoViewModel *courseInfoVM = [[BXGCourseInfoViewModel alloc]initWithCourseModel:self.courseListModel.freeMicroCourse[indexPath.row]];
            BXGCourseInfoVC *courseInfoVC = [[BXGCourseInfoVC alloc] initWithViewModel:courseInfoVM];
            [self.navigationController pushViewController:courseInfoVC animated:YES];
        }
            break;
        default:
            NSAssert(NO, @"There is not existence for the section");
            break;
    }
}
@end
