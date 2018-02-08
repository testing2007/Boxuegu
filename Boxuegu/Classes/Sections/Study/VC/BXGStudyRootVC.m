//
//  BXGStudyRootVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/2.
//  Copyright © 2017年 itcast. All rights reserved.
//

// View Controller
#import "BXGStudyRootVC.h"
#import "BXGStudyProCourseVC.h"
#import "BXGUserLoginVC.h"
#import "BXGDownloadManagerVC.h"
#import "BXGMeLearnedHistoryVC.h"
#import "BXGMeMyMessageVC.h"
#import "BXGConstruePlanVC.h"

// View
#import "BXGCourseHorizentalCCell.h"
#import "BXGStudyRootMiniCourseCCell.h"
#import "BXGStudyRootSectionBGReusableView.h"
#import "BXGStudyRecentFloatTipView.h"

// View Model
#import "BXGCourseDetailViewModel.h"

// Lib
#import "MJRefresh.h"
#import "BXGMaskView.h"
#import "BXGMessageTool.h"
#import "BXGHistoryTable.h"


#import "BXGBasePlayerVC.h"
#import "BXGMiniCoursePlayerContentVC.h"
#import "BXGProCoursePlayerContentVC.h"
#import "RWCommonFunction.h"

#import "BXGLearnStatusTable.h"
#import "BXGBaseNaviController.h"
#import "RWBadgeView.h"

@interface  MenuCollectionViewFlowLayout: UICollectionViewFlowLayout

@property (strong, nonatomic) NSMutableArray *itemAttributes;
@end

@implementation  MenuCollectionViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.itemAttributes = [NSMutableArray new];
    id<UICollectionViewDelegateFlowLayout> delegate = (id)self.collectionView.delegate;
    NSInteger numberOFSection = self.collectionView.numberOfSections;
    for(NSInteger i = 0; i < numberOFSection; i++) {
        
        NSInteger section = i;
        NSInteger numberOfItem = [self.collectionView numberOfItemsInSection:section];
        if(numberOfItem <= 0){
            
            continue;
        }
        NSInteger lastIndex = [self.collectionView numberOfItemsInSection:section] - 1;
        
        if(lastIndex < 0) {
            
            lastIndex = 0;
        }
        
        UICollectionViewLayoutAttributes *firstItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        UICollectionViewLayoutAttributes *lastItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:lastIndex inSection:section]];
        UIEdgeInsets sectionInset = self.sectionInset;
        if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
            sectionInset = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        CGRect frame = CGRectUnion(firstItem.frame, lastItem.frame);
        frame.origin.x -= sectionInset.left;
        frame.origin.y -= sectionInset.top;
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
        {
            frame.size.width += sectionInset.left + sectionInset.right;
            frame.size.height = self.collectionView.frame.size.height;
        }
        else
        {
            frame.size.width = self.collectionView.frame.size.width;
        }
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"BXGStudyRootSectionBGReusableView" withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        attributes.zIndex = -1;
        attributes.frame = frame;
        [self.itemAttributes addObject:attributes];
    }
    [self registerNib:[UINib nibWithNibName:@"BXGStudyRootSectionBGReusableView" bundle:nil] forDecorationViewOfKind:@"BXGStudyRootSectionBGReusableView"];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *attributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    
    for (UICollectionViewLayoutAttributes *attribute in self.itemAttributes)
    {
        if (!CGRectIntersectsRect(rect, attribute.frame))
            continue;
        
        [attributes addObject:attribute];
    }
    
    return attributes;
}
@end

@interface  MenuSectionHeader:UICollectionReusableView
@property (nonatomic, copy) NSString *cellTitle;
@property (nonatomic, weak) UILabel *cellTitleLabel;

@end

@implementation  MenuSectionHeader

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame]; {
        
        [self installUI];
    }
    return self;
}
- (void)setCellTitle:(NSString *)cellTitle {
    
    _cellTitle = cellTitle;
    self.cellTitleLabel.text = cellTitle;
}

- (void)installUI {
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    UIView *markView = [UIView new];
    markView.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    markView.layer.cornerRadius = 1;
    
    [self addSubview: markView];
    [markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(2);
        make.height.offset(15);
        make.left.offset(15);
        make.centerY.offset(0);
        
    }];
    
    UILabel *cellTitleLabel = [UILabel new];
    self.cellTitleLabel = cellTitleLabel;
    cellTitleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    cellTitleLabel.textColor = [UIColor colorWithHex:0x333333];
    [self addSubview: cellTitleLabel];
    
    [cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(markView).offset(5);
        make.centerY.offset(0);
        make.right.offset(-15);
        make.height.equalTo(self);
    }];
}


@end
@interface BXGStudyRootVC () <UICollectionViewDataSource, UICollectionViewDelegate,BXGNotificationDelegate>
@property (nonatomic, strong) BXGStudyViewModel *viewModel;
@property (nonatomic, weak) UICollectionView *menuView;
@property (nonatomic, strong) BXGStudyRecentFloatTipView *recentView;
@property (nonatomic, strong) NSDate *recentViewStayDate;
//@property (nonatomic, strong) NSTimer *intervalTimer;

@property (nonatomic, weak) RWBadgeView *badgeView;
@property (nonatomic, weak) UIBarButtonItem *messagBarButtonItem;

// data source
@property (nonatomic, strong) NSArray *procourseModelArray;
@property (nonatomic, strong) NSArray *minicourseModelArray;

@property (nonatomic, weak) UIView *spTopView;
@property (nonatomic, assign) BOOL isNeedRefresh;
@end

@implementation BXGStudyRootVC

#pragma mark Init Dealloc

- (instancetype)init {
    self = [super init];
    if(self) {
        [self installObservers];
    }
    return self;
}

- (void)dealloc{
    
    [self uninstallObservers];
}

#pragma mark - Getter Setter
- (BXGStudyViewModel *)viewModel {
    
    if(!_viewModel) {
        _viewModel = [BXGStudyViewModel share];
    }
    return _viewModel;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"课程";
    self.pageName = @"课程页";
    
    [self installUI];
    [self installNavigationBar];
    

    // 获取当前网络状态
    BXGReachabilityStatus status = [[BXGNetWorkTool sharedTool] getReachState];

     // 获取用户当前状态
    if([BXGUserDefaults share].userModel){

        [BXGNotificationTool postNotificationForUserLogin:true];
    }
    
    if(status == BXGReachabilityStatusReachabilityStatusNotReachable) {
        
        [self.view installMaskView:BXGMaskViewTypeNoNetwork andInset:UIEdgeInsetsMake(64, 0, 0, 0)] ;
    }else {
        
        [self.view removeMaskView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak typeof (self) weakSelf = self;
    
    if([BXGUserDefaults share].userModel) {
        
        [weakSelf.view removeMaskView];
        if(self.isNeedRefresh) {
            [self.menuView bxg_beginHeaderRefresh];
            self.isNeedRefresh = false;
        }
    }else {
        [self.view installMaskView:BXGButtonMaskViewTypeNoLogin andInset:UIEdgeInsetsMake(K_NAVIGATION_BAR_OFFSET, 0, 0, 0) buttonBlock:^{
            BXGUserLoginVC *loginVC = [BXGUserLoginVC new];
            BXGBaseNaviController *nav = [[BXGBaseNaviController alloc]initWithRootViewController:loginVC];
            [weakSelf presentViewController:nav animated:true completion:nil];
        }];
    }
    
//    weakSelf.intervalTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(intervalTimerOperation:) userInfo:nil repeats:true];
//    [[NSRunLoop currentRunLoop] addTimer:self.intervalTimer forMode:NSRunLoopCommonModes];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    if([BXGUserDefaults share].userModel){
         [self.recentView setHidden:YES];
    }

//    [self.intervalTimer invalidate];
//    self.intervalTimer = nil;
}

//- (void)intervalTimerOperation:(NSTimer *)sender
//{
//    if(self.recentViewStayDate.timeIntervalSinceNow < -5)
//    {
//        [self closeRecentView];
//        [sender invalidate];
//    }
//}

//- (void)closeRecentView {
//
//    __weak typeof (self) weakSelf = self;
//    [UIView animateWithDuration:0.3 animations:^{
//
//        [weakSelf.recentView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.offset(0);
//        }];
//        [weakSelf.view layoutIfNeeded];
//    }];
//}

#pragma mark - Observer

- (void)installObservers
{
    [BXGNotificationTool addObserverForUserLogin:self];
    [BXGNotificationTool addObserverForNewMessageCount:self];
    [BXGNotificationTool addObserverForReachability:self];
    
}

- (void)uninstallObservers
{
    [BXGNotificationTool removeObserver:self];
}

#pragma mark - Install UI

- (void)installNavigationBar
{
    [super installNavigationBar];
    //  左边导航栏
//    UILabel *label = [UILabel new];
//    label.font = [UIFont bxg_fontRegularWithSize:18];
//    label.textColor = [UIColor whiteColor];
//    label.text = @"学习中心";
//    [label sizeToFit];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:label];
    
    // 右边导航栏
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
    //    viewRecordBarElement.size = CGSizeMake(18+4, 18+4);
    viewRecordBarElement.size = CGSizeMake(RWAutoFontSize(24), RWAutoFontSize(24));
    viewRecordBarElement.tintColor = [UIColor whiteColor];
    
    BarElement *messageBarElement = [BarElement new];
    messageBarElement.target = self;
    messageBarElement.sel = @selector(operationMessage);
    messageBarElement.imageName = @"导航栏-我的消息";
    
    BarElement *construeBarElement = [BarElement new];
    construeBarElement.target = self;
    construeBarElement.sel = @selector(operationConstrue);
    construeBarElement.imageName = @"导航栏-直播";
    construeBarElement.size = CGSizeMake(RWAutoFontSize(24), RWAutoFontSize(24));
    construeBarElement.tintColor = [UIColor whiteColor];
    
    
    
    // messageBarElement.size = CGSizeMake(18+4 + 4, 18+4 + 4);
    messageBarElement.size = CGSizeMake(RWAutoFontSize(24), RWAutoFontSize(24));
    messageBarElement.tintColor = [UIColor whiteColor];
    
    BXGBaseNaviController *navi = (BXGBaseNaviController*)self.navigationController;
    NSArray *arrRightBarItems = [navi createNaviBarItemsWithBarElements:@[downloadBarElement,
                                                                           viewRecordBarElement]
                                                         andBarItemSpace:15];
    
    NSArray *arrLeftBarItems = [navi createNaviBarItemsWithBarElements:@[messageBarElement] andBarItemSpace:15];
    if(self.procourseModelArray.count > 0){
        arrLeftBarItems =  [navi createNaviBarItemsWithBarElements:@[construeBarElement,
                                                                              messageBarElement]
                                                            andBarItemSpace:15];
    }
    
    self.navigationItem.leftBarButtonItems = arrLeftBarItems;
    self.navigationItem.rightBarButtonItems = arrRightBarItems;
    _messagBarButtonItem = arrLeftBarItems[0];
    _messagBarButtonItem.customView.clipsToBounds = NO;
    RWBadgeView *badgeView = [RWBadgeView new];
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

- (void)refresh {
    self.isNeedRefresh = true;
//    [self.menuView bxg_beginHeaderRefresh];
}

- (void)installUI {
    
    __weak typeof (self) weakSelf = self;
    
    UIView *spView = [UIView new];
    [self.view addSubview:spView];
    _spTopView = spView;
    spView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.top.equalTo(self.recentView.mas_bottom);
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.right.offset(0);
        make.height.offset(9);
    }];
    
//    self.recentView.closeTipViewBlock = ^{
//        [weakSelf.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(weakSelf.spTopView.mas_bottom);
//        }];
//    };
    MenuCollectionViewFlowLayout *flowLayout = [MenuCollectionViewFlowLayout new];
    
    UICollectionView *menuView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
//    menuView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf loadData];
//    }];
    [menuView bxg_setHeaderRefreshBlock:^{
        [weakSelf loadData];
    }];
    
    self.menuView = menuView;
    menuView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    menuView.dataSource = self;
    menuView.delegate = self;
    [menuView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [menuView registerNib:[UINib nibWithNibName:@"BXGStudyRootMiniCourseCCell" bundle:nil] forCellWithReuseIdentifier:@"BXGStudyRootMiniCourseCCell"];
    [menuView registerNib:[UINib nibWithNibName:@"BXGCourseHorizentalCCell" bundle:nil] forCellWithReuseIdentifier:@"BXGCourseHorizentalCCell"];
    
    
    [menuView registerClass:[MenuSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MenuSectionHeader"];
    
    [self.view addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.recentView.mas_bottom);
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.right.offset(0);
        // make.bottom.offset(-47);
        make.bottom.offset(0);
    }];
    
    self.recentView = [BXGStudyRecentFloatTipView new];
    [self.view addSubview:self.recentView];
    [self.recentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(menuView.mas_top);
        make.left.right.offset(0);
        make.height.equalTo(@38);
    }];
    self.recentView.hidden = YES;
    
    // response
    self.recentView.touchUpInsideBlock = ^(BXGBasePlayerVC *playerVC) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController pushViewController:playerVC animated:true];
        });
    };
}

#pragma mark - Data

- (void)loadData {

    __weak typeof (self) weakSelf = self;
    [weakSelf.menuView removeMaskView];
    

    
    if([BXGUserDefaults share].userModel) {
    
        [weakSelf.viewModel loadAppCourseFinished:^(BOOL succeed,
                                                NSArray * _Nullable procourseModelArray,
                                                NSArray * _Nullable minicourseModelArray,
                                                NSString * _Nullable message) {
            
            [weakSelf.menuView removeMaskView];
            weakSelf.procourseModelArray = procourseModelArray;
            weakSelf.minicourseModelArray = minicourseModelArray;
            [weakSelf installNavigationBar];
            if(succeed){
                
                if(weakSelf.procourseModelArray.count <= 0 && weakSelf.minicourseModelArray.count <= 0) {
                    
                    // 添加学习中心为空 Mask View
                    [weakSelf.menuView installMaskView:BXGMaskViewTypeStudyCenterEmpty];
                }
                [weakSelf.menuView reloadData];
            }else {
                
                // 加载失败
                
                // 添加加载失败 Mask View
                [weakSelf.menuView installMaskView:BXGMaskViewTypeLoadFailed];
                
            }
            [weakSelf.menuView bxg_endHeaderRefresh];
            
        }];
    }else {
    
        [weakSelf.menuView bxg_endHeaderRefresh];
        [weakSelf.menuView installMaskView:BXGMaskViewTypeNoLogin];
        [weakSelf presentViewController:[[BXGBaseNaviController alloc]initWithRootViewController:[[BXGUserLoginVC alloc]init]] animated:true completion:nil];
        
    }
    
}

#pragma mark - Collection View Delegate DataSourse

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    __weak typeof (self) weakSelf = self;
    if(indexPath.section == 0){
        
        // 点击职业课跳转到课程详情
        BXGProCoursePlanViewModel *viewModel = [BXGProCoursePlanViewModel viewModelWithModel:weakSelf.procourseModelArray[indexPath.row]];
        BXGStudyProCourseVC *proCourseDetailVC = [[BXGStudyProCourseVC alloc]initWithCourseDetailViewModel:viewModel];
        [self.navigationController pushViewController:proCourseDetailVC animated:true];
    }else {
        
        // 点击微课跳转到课程大纲
        
        BXGCourseModel *courseModel = weakSelf.minicourseModelArray[indexPath.row];
        BXGHistoryModel *historyModel = [[BXGHistoryTable new] searchLastHistoryWithCourseId:courseModel.course_id];
        BXGMiniCoursePlayerContentVC *miniContentVC = [[BXGMiniCoursePlayerContentVC alloc]initWithCourseModel:courseModel];
        
        BXGBasePlayerVC *playerVC = [[BXGBasePlayerVC alloc]initWithCourseModel:courseModel ContentVC:miniContentVC];
        [playerVC autoPlayWithPointId:historyModel.dian_id andVideoId:historyModel.video_id];
        [self.navigationController pushViewController:playerVC animated:true];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;{
    
    MenuSectionHeader *reuableHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MenuSectionHeader" forIndexPath:indexPath];
    
    if(indexPath.section == 0){
        
        reuableHeaderView.cellTitle = @"我的就业课";
        
    }else {
        
        reuableHeaderView.cellTitle = @"我的微课";
    }
    
    return reuableHeaderView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(section == 0){
        
        return self.procourseModelArray.count;
        
    }else {
        
        return self.minicourseModelArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0) {
        
        BXGCourseHorizentalCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BXGCourseHorizentalCCell" forIndexPath:indexPath];
        cell.model = self.procourseModelArray[indexPath.row];
        return cell;
        
    }else {
        
        BXGStudyRootMiniCourseCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BXGStudyRootMiniCourseCCell" forIndexPath:indexPath];
        cell.model = self.minicourseModelArray[indexPath.row];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath; {
    
    if(indexPath.section == 0) {
        
        return CGSizeMake(collectionView.bounds.size.width, (collectionView.bounds.size.width) / 3.4);
        
    }else {
        
        return CGSizeMake((collectionView.bounds.size.width - 45) /2  , (collectionView.bounds.size.width) / 3.5 + 40 + 3 );
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section; {
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section; {
    
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section == 0 )
    {
        if(self.procourseModelArray.count == 0)
        {
            return CGSizeMake(collectionView.bounds.size.width, 0);
        }
        
    }
    else if(section == 1 )
    {
        if(self.minicourseModelArray.count == 0)
        {
            return CGSizeMake(collectionView.bounds.size.width, 0);
        }
    }
    
    return CGSizeMake(collectionView.bounds.size.width, 46);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    if(section == 0)
    {
        if(self.procourseModelArray.count == 0)
        {
            return UIEdgeInsetsMake(0, 0, 0, 0);
            //return CGSizeMake(collectionView.bounds.size.width, 0);
        }else {
            
            return UIEdgeInsetsMake(0, 0, 9, 0);
        }
        // return UIEdgeInsetsMake(0, 0, 9, 0);
    }
    else
    {
        return UIEdgeInsetsMake(0, 15, 9, 15);
    }
    
}
#pragma mark - Response

- (void)operationDownload
{
    RWLog(@"跳转到下载");
    [[BXGBaiduStatistic share] statisticEventString:kBXGStatCategoryEventTypeDownload andParameter:nil];
    BXGDownloadManagerVC *vc = [BXGDownloadManagerVC new];
    [self.navigationController pushViewController:vc animated:true needLogin:true];
}

- (void)operationViewRecord
{
    RWLog(@"跳转到观看记录");
    [[BXGBaiduStatistic share] statisticEventString:kBXGStatCategoryEventTypeHistory andParameter:nil];
    BXGMeLearnedHistoryVC *vc = [BXGMeLearnedHistoryVC new];
    [self.navigationController pushViewController:vc animated:true needLogin:true];
}

- (void)operationMessage
{
    RWLog(@"跳转到我的消息");
    [[BXGBaiduStatistic share] statisticEventString:kBXGStatCategoryEventTypeMessage andParameter:nil];
    BXGMeMyMessageVC *vc = [BXGMeMyMessageVC new];
    [self.navigationController pushViewController:vc animated:true needLogin:true];
}

- (void)operationConstrue
{
    // [[BXGBaiduStatistic share] statisticEventString:kBXGStatCategoryEventTypeMessage andParameter:nil];
    BXGConstruePlanVC *vc = [BXGConstruePlanVC new];
    [self.navigationController pushViewController:vc animated:true needLogin:true];
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

/// 监听用户登录
- (void)catchUserLoginNotificationWith:(BOOL)isLogin
{
    __weak typeof (self) weakSelf = self;
    
    if(isLogin)
    {
        [weakSelf.menuView bxg_beginHeaderRefresh];
        [self.recentView loadContent:nil];
    }else {
        weakSelf.recentView.model = nil;
        weakSelf.procourseModelArray = nil;
        weakSelf.minicourseModelArray = nil;
        [weakSelf.menuView reloadData];
    }
}

/// 监听网络状态
- (void)catchRechbility:(BXGReachabilityStatus)status {
    
    if(status == BXGReachabilityStatusReachabilityStatusNotReachable) {
        [self.view installMaskView:BXGMaskViewTypeNoNetwork andInset:UIEdgeInsetsMake(K_NAVIGATION_BAR_OFFSET, 0, 0, 0)];
        
    }else {
        [self.view removeMaskView];
        [self.menuView bxg_beginHeaderRefresh];
        [self.viewModel requestUpdateOfflineStudyStatusWithFinished:nil];
    }
}
@end
