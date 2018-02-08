//
//  BXGCourseInfoVC.m
//  Boxuegu
//
//  Created by RW on 2017/10/10.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseInfoVC.h"

#import "BXGSampleCoursePlayer.h"
#import "BXGOrderFillOrderVC.h"
#import "RWTabView.h"
#import "RWTabDetailView.h"
#import "BXGCourseInfoDetailVC.h"
#import "BXGCourseInfoQAVC.h"
#import "BXGCourseInfoOutlineVC.h"
//#import "BXGCourseInfoViewModel.h"
#import "BXGCourseInfoLecturerVC.h"

#import "MOPopWindow.h"
#import "BXGConsultCommitView.h"
#import "BXGTryCoursePlayerContentVC.h"
#import "BXGBasePlayerVC.h"
#import "BXGCourseInfoBottomTabView.h"
#import "UIView+Extension.h"
#import "BXGStudyProCourseVC.h"
#import "BXGMiniCoursePlayerContentVC.h"
#import "BXGProCoursePlayerContentVC.h"
#import "BXGCourseInfoOutlineViewModel.h"
#import "BXGCourseInfoLecturerViewModel.h"
#import "BXGOrderHelper.h"
#import "BXGConsultCommitViewModel.h"
// 评论
#import "BXGCourseDetailCriticizedViewModel.h"
#import "BXGCourseStudentCriticizedView.h"

#import "BXGOrderFreeCoursePopVC.h"
#import "BXGMainTabBarController.h"
#import "BXGPayManager.h"

@interface BXGCourseInfoVC () <UITabBarDelegate,UIScrollViewDelegate>
/// Content View
@property (nonatomic, strong) UIScrollView *scrollView;
/// 是否折叠
@property (nonatomic, assign) BOOL isFlod;
/// 透明
@property (nonatomic, weak) UIView *headImgV;
@property (nonatomic, strong) BXGCourseInfoViewModel *viewModel;
@property (nonatomic, strong) BXGCourseInfoOutlineVC *outlineVC;
@property (nonatomic, strong) BXGCourseInfoLecturerVC * lecturerVC;

@property (nonatomic, assign) BOOL isStop;
@property (nonatomic, assign) BOOL isLoaded;

@property (nonatomic, strong) BXGPayManager *payManager;

// -- View

/// 评论页
@property (nonatomic, strong) BXGCourseStudentCriticizedView *criticizedView;
/// 底部浮框
@property (nonatomic, weak) BXGCourseInfoBottomTabView *bottomTabView;
@end

@implementation BXGCourseInfoVC

#pragma mark - Interface

- (instancetype)initWithViewModel:(BXGCourseInfoViewModel *)viewModel {
    self = [super init];
    if(self) {
        _viewModel = viewModel;
        _payManager = [BXGPayManager new];
        _payManager.delegate = self;
    }
    return self;
}
#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.delegate = self;
    self.scrollView = scrollView;
    self.scrollView.bounces = false;
    self.scrollView.scrollEnabled = false;
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    [self.view addSubview:scrollView];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.offset(0);
        make.bottom.offset(0);
    }];
    //
    UIImageView *headImage = [UIImageView new];
    
    if(self.viewModel.courseModel.courseImg.length > 0) {
        [headImage sd_setImageWithURL:[NSURL URLWithString:self.viewModel.courseModel.courseImg] placeholderImage:[UIImage imageNamed:@"默认加载图"]];
    } else {
        [headImage setImage:[UIImage imageNamed:@"默认加载图"]];
    }
    [self.scrollView addSubview:headImage];
    
    self.headImgV = headImage;
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.width.equalTo(self.scrollView.mas_width);
        make.height.equalTo(headImage.mas_width).multipliedBy(422.0 / 750.0);
    }];
    [headImage layoutIfNeeded];
    
    
    
    // TODO: 设置 Page Name
    if(self.viewModel.courseModel) {
        // 0-就业课 1-微课
        if(self.viewModel.courseModel.courseType.integerValue) {
            // 微课
            if(self.viewModel.courseModel.isFree.integerValue) {
                // 免费
                self.pageName = @"免费微课展示页";
            }else{
                // 精品微课
                self.pageName = @"精品微课展示页";
            }
        }else{
            // 就业课
            self.pageName = @"就业课展示页";
        }
    }else {
        self.pageName = @"就业课展示页";
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navibackgroundView.backgroundColor = [UIColor whiteColor];
     [self loadData];
}

#pragma mark - getter / setter

#pragma mark - UI

- (void)installUI {
    Weak(weakSelf);
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.offset(0);
//        make.bottom.offset(0);
    }];
//    UIScrollView *scrollView = self.scrollView;
    
    BXGCourseInfoBottomTabView *bottomTabView = [BXGCourseInfoBottomTabView new];
    bottomTabView.didSelectedBtn = ^(BXGCourseInfoBottomTabResponseType type) {
        switch (type) {

            case BXGCourseInfoBottomTabResponseTypeSample:
                [weakSelf toSampleCourse];
                break;
            case BXGCourseInfoBottomTabResponseTypeConsult:
                [weakSelf showConsult];
                break;
            case BXGCourseInfoBottomTabResponseTypeLearn:
                [weakSelf toCourseDetail];
                break;
            case BXGCourseInfoBottomTabResponseTypeOrder:
                [weakSelf onClickOrder];
                break;
        }
    };
    [self.view addSubview:bottomTabView];
    self.bottomTabView = bottomTabView;
    UIView *spView = [UIView new];
    spView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [self.view addSubview:spView];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.scrollView.mas_bottom);
        make.height.offset(kBottomTabbarViewSpHeight);
    }];
    [bottomTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spView).offset(0);
        make.height.offset(kBottomTabbarViewHeight);
        make.bottom.offset(-kBottomHeight);
        make.left.right.offset(0);
    }];
    
    UIImageView *headImage = self.headImgV;
    if(self.viewModel.courseModel.courseImg.length > 0) {
        [headImage sd_setImageWithURL:[NSURL URLWithString:self.viewModel.courseModel.courseImg] placeholderImage:[UIImage imageNamed:@"默认加载图"]];
    } else {
        [headImage setImage:[UIImage imageNamed:@"默认加载图"]];
    }
//    [self.scrollView addSubview:headImage];
    
//    self.headImgV = headImage;
//    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.offset(0);
//        make.width.equalTo(self.scrollView.mas_width);
//        make.height.equalTo(headImage.mas_width).multipliedBy(422.0 / 750.0);
//    }];
//    [headImage layoutIfNeeded];

    NSMutableArray *tabTitles = [NSMutableArray new];
    NSMutableArray *tabViews = [NSMutableArray new];
    
    // 详情 Detail 模块
    BXGCourseInfoDetailVC *detailVC = [[BXGCourseInfoDetailVC alloc]initWithCourseId:self.viewModel.courseId];
    [self addChildViewController:detailVC];
    detailVC.foldDelegate = self;
    [tabViews addObject:detailVC.view];
    [tabTitles addObject:@"详情"];
    
    // 大纲 Outline 模块
    BXGCourseInfoOutlineViewModel *outlineVM = [[BXGCourseInfoOutlineViewModel alloc]initWithCourseId:self.viewModel.courseId];
    BXGCourseInfoOutlineVC *outlineVC = [[BXGCourseInfoOutlineVC alloc]initWithViewModel:outlineVM];
    [self addChildViewController:outlineVC];
    self.outlineVC = outlineVC;
    outlineVC.foldDelegate = self;
    [tabViews addObject:outlineVC.view];
    [tabTitles addObject:@"大纲"];
    
    // 讲师 Lecturer 模块
    BXGCourseInfoLecturerViewModel *lecturerVM = [[BXGCourseInfoLecturerViewModel alloc]initWithCourseId:self.viewModel.courseId];
    BXGCourseInfoLecturerVC * lecturerVC = [[BXGCourseInfoLecturerVC alloc]initWithViewModel:lecturerVM];;
    [self addChildViewController:lecturerVC];
    self.lecturerVC = lecturerVC;
    lecturerVC.foldDelegate = self;
    [tabViews addObject:lecturerVC.view];
    [tabTitles addObject:@"讲师"];
    
    // 评论 Criticized 模块 非免费微课时显示
    if(!(self.viewModel.courseModel.courseType.integerValue != 0 && self.viewModel.courseModel.isFree.integerValue == 1)) {
        BXGCourseDetailCriticizedViewModel *criticizedVM = [[BXGCourseDetailCriticizedViewModel alloc]initWithCourseId:self.viewModel.courseId];
        BXGCourseStudentCriticizedView *criticizedView = [[BXGCourseStudentCriticizedView alloc]initWithViewModel:criticizedVM];;
        self.criticizedView = criticizedView;
        criticizedView.foldDelegate = self;
        criticizedView.footerReflashEnabled = true;
        [tabViews addObject:criticizedView];
        [tabTitles addObject:@"评论"];
    }
    
    // 问答 Q&A 模块 非就业课时显示
    if(self.viewModel.courseModel.courseType.integerValue != 0) {
        // 判断 "非就业课"
        BXGCourseInfoQAVC *qaVC = [[BXGCourseInfoQAVC alloc]initWithCourseId:self.viewModel.courseId];
        [self addChildViewController:qaVC];
        qaVC.foldDelegate = self;
//        self.lecturerVC.foldDelegate = self;
        [tabViews addObject:qaVC.view];
        [tabTitles addObject:@"Q&A"];
    }
    
    // Tab View
    RWTabView *tabView = [[RWTabView alloc]initWithTitles:tabTitles andDetailViews:tabViews];
    tabView.DidChangedIndex = ^(RWTabView *tab, NSInteger index, NSString *title, UIView *view) {
        if(weakSelf.viewModel.courseModel) {
            
            if([title isEqualToString:@"详情"]) {
                // 0-就业课 1-微课
                if(weakSelf.viewModel.courseModel.courseType.integerValue) {
                    // 微课
                    if(weakSelf.viewModel.courseModel.isFree.integerValue) {
                        // 免费
                        [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoFreeCourseEventTypeDetail andLabel:nil];
                    }else{
                        // 精品微课
                        [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoMiniCourseEventTypeDetail andLabel:nil];
                    }
                }else{
                    // 就业课
                    [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoProCourseEventTypeDetail andLabel:nil];
                }
            }
            if([title isEqualToString:@"大纲"]) {
                // 0-就业课 1-微课
                if(weakSelf.viewModel.courseModel.courseType.integerValue) {
                    // 微课
                    if(weakSelf.viewModel.courseModel.isFree.integerValue) {
                        // 免费
                        [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoFreeCourseEventTypeOutline andLabel:nil];
                    }else{
                        // 精品微课
                        [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoMiniCourseEventTypeOutline andLabel:nil];
                    }
                }else{
                    // 就业课
                    [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoProCourseEventTypeOutline andLabel:nil];
                }
            }
            if([title isEqualToString:@"讲师"]) {
                // 0-就业课 1-微课
                if(weakSelf.viewModel.courseModel.courseType.integerValue) {
                    // 微课
                    if(weakSelf.viewModel.courseModel.isFree.integerValue) {
                        // 免费
                        [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoFreeCourseEventTypeLecturer andLabel:nil];
                    }else{
                        // 精品微课
                        [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoMiniCourseEventTypeLecturer andLabel:nil];
                    }
                }else{
                    // 就业课
                    [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoProCourseEventTypeLecturer andLabel:nil];
                }
            }
            if([title isEqualToString:@"评论"]) {
                // 0-就业课 1-微课
                if(weakSelf.viewModel.courseModel.courseType.integerValue) {
                    // 微课
                    if(weakSelf.viewModel.courseModel.isFree.integerValue) {
                        // 免费
//                        [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoFreeCourseEventType andLabel:nil];
                    }else{
                        // 精品微课
                        [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoMiniCourseEventTypeComment andLabel:nil];
                    }
                }else{
                    // 就业课
                    [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoProCourseEventTypeComment andLabel:nil];
                }
            }
            if([title isEqualToString:@"Q&A"]) {
                // 0-就业课 1-微课
                if(weakSelf.viewModel.courseModel.courseType.integerValue) {
                    // 微课
                    if(weakSelf.viewModel.courseModel.isFree.integerValue) {
                        // 免费
                        [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoFreeCourseEventTypeQA andLabel:nil];
                    }else{
                        // 精品微课
                        [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoMiniCourseEventTypeQA andLabel:nil];
                    }
                }else{
                    // 就业课
//                    [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoProCourseEventTypeQA andLabel:nil];
                }
            }
            
            
        }
    };
    [self.scrollView addSubview:tabView];
    [tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.equalTo(headImage);
        make.top.equalTo(headImage.mas_bottom);
        make.height.equalTo(self.scrollView.mas_height).offset(-K_NAVIGATION_BAR_OFFSET +(kBottomHeight));
        make.bottom.offset(0);
    }];
}

#pragma mark - Delegate
- (void)checkFoldWithScrollView:(UIScrollView *)scrollView {
    Weak(weakSelf);
    if(scrollView.contentOffset.y < 0){
        if(self.isFlod) {
            [weakSelf.scrollView setContentOffset:CGPointMake(0, 0) animated:true];
        }
        self.isFlod = false;
    }else if (scrollView.contentOffset.y > 0){
        if(!self.isFlod) {
            self.isFlod = true;
            [weakSelf.scrollView setContentOffset:CGPointMake(0, self.headImgV.frame.size.height - K_NAVIGATION_BAR_OFFSET) animated:true];
        }
    }
}

- (void)loadData {
    Weak(weakSelf);
    if(self.isLoaded) {
        [[BXGHUDTool share] showLoadingHUDWithString:nil];
    }else {
        [weakSelf.view installLoadingMaskViewWithInset:UIEdgeInsetsMake(0 + K_NAVIGATION_BAR_OFFSET +  weakSelf.headImgV.frame.size.height, 0, 0, 0)];
    }
    
    [self.viewModel loadCourseInfoDetailWithRefresh:true Finished:^(BXGHomeCourseModel *courseModel) {
        BXGCourseInfoBottomTabType tabType = BXGCourseInfoBottomTabTypeApply;
        [weakSelf.view removeMaskView];
        [[BXGHUDTool share] closeHUD];
        if(courseModel) {
            if(courseModel.isApply && courseModel.isApply.boolValue) {
                tabType = BXGCourseInfoBottomTabTypeApply;
            }else {
                if(weakSelf.viewModel.courseModel.courseType.integerValue == 0) { // 就业课
                    tabType = BXGCourseInfoBottomTabTypeProCourse;
                } else { // if (self.courseModel.courseType == 1) // 微课
                    if(courseModel.isFree.boolValue){
                        tabType = BXGCourseInfoBottomTabTypeFreeCourse;
                    }else {
                        tabType = BXGCourseInfoBottomTabTypeMiniCourse;
                    }
                }
            }
            if(weakSelf.isLoaded == false) {
                weakSelf.isLoaded = true;
                [weakSelf installUI];
            }
        } else {
            [weakSelf.view installMaskView:BXGButtonMaskViewTypeLoadFailed andInset:UIEdgeInsetsMake(0 + K_NAVIGATION_BAR_OFFSET +  weakSelf.headImgV.frame.size.height, 0, 0, 0) buttonBlock:^{
                [weakSelf loadData];
            }];
        }
        weakSelf.bottomTabView.type = tabType;
    }];
    
//    [self.viewModel loadCourseInfoDetailWithRefresh:true Finished:^(BXGHomeCourseModel *courseModel, BXGCourseInfoApplyType type) {
//        [weakSelf.view installMaskView:BXGMaskViewTypeLoading];
//        if(type != BXGCourseInfoApplyTypeNone && courseModel) {
//            // 成功可以开始加载
//            BXGCourseInfoBottomTabType tabType;
//            if(type == BXGCourseInfoApplyTypeApplied) {
//                tabType = BXGCourseInfoBottomTabTypeApply;
//            }else {
//                if(self.viewModel.courseModel.courseType.integerValue == 0) { // 就业课
//                    tabType = BXGCourseInfoBottomTabTypeProCourse;
//                } else { // if (self.courseModel.courseType == 1) // 微课
//                    if(self.viewModel.courseModel.isFree.boolValue){
//                        tabType = BXGCourseInfoBottomTabTypeFreeCourse;
//                    }else {
//                        tabType = BXGCourseInfoBottomTabTypeMiniCourse;
//                    }
//                }
//            }
//            [self installUI];
//            weakSelf.bottomTabView.type = tabType;
//
//            [weakSelf.view removeMaskView];
//        }else {
//            // 失败
//            [weakSelf.view installMaskView:BXGMaskViewTypeLoadFailed];
//        }
//    }];
}

#pragma mark - Flod Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.bounds.size.height + scrollView.contentOffset.y == scrollView.contentSize.height) {
        self.isStop = true;
    }else  {
        self.isStop = false;
    }
}

#pragma mark - Funtion
// 试学
- (void)toSampleCourse {
    Weak(weakSelf);
    // 统计
    if(self.viewModel.courseModel) {
        // 0-就业课 1-微课
        if(self.viewModel.courseModel.courseType.integerValue) {
            // 微课
            if(self.viewModel.courseModel.isFree.integerValue) {
                // 免费
//                [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoFreeCourseEventType andLabel:nil];
            }else{
                // 精品微课
                [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoMiniCourseEventTypeTryLearn andLabel:nil];
            }
        }else{
            // 就业课
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoProCourseEventTypeTryLearn andLabel:nil];
        }
    }
    
    [self checkSampleBlock:^{
        BXGTryCoursePlayerContentVC *miniContentVC = [[BXGTryCoursePlayerContentVC alloc]initWithCourseModel:self.viewModel.courseModel andCourseType:self.viewModel.courseModel.courseType.integerValue];
        BXGBasePlayerVC *playerVC = [[BXGBasePlayerVC alloc]initWithCourseId:self.viewModel.courseId andContentVC:miniContentVC andPlayType:BXGCoursePlayTypeSampleCourse];
        [weakSelf.navigationController pushViewController:playerVC animated:true needLogin:true];
    }];

}
/// 显示咨询
- (void)showConsult {
    
    // 统计
    if(self.viewModel.courseModel) {
        // 0-就业课 1-微课
        if(self.viewModel.courseModel.courseType.integerValue) {
            // 微课
            if(self.viewModel.courseModel.isFree.integerValue) {
                // 免费
            }else{
                // 精品微课
            }
        }else{
            // 就业课
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoProCourseEventTypeConsult andLabel:nil];
        }
    }
    
    BXGConsultCommitViewModel *consultVM = [[BXGConsultCommitViewModel alloc]initWithSubjectId:self.viewModel.courseModel.subjectId.stringValue andCourseName:self.viewModel.courseModel.courseName];
    
    UIView *cview = [[BXGConsultCommitView alloc]initWithViewModel:consultVM];
    [self rw_presentContentView:cview restrainBlock:^(UIView *view) {
        [view addSubview:cview];
        [cview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.offset(0);
        }];
    } tapMaskBlock:^{
        [self disablesAutomaticKeyboardDismissal];
    } completion:^{
    }andShouldAutorotate:FALSE];
}
/// 调转到订单页

- (void)onClickOrder {
    Weak(weakSelf);
    
    // 统计
    if(self.viewModel.courseModel) {
        // 0-就业课 1-微课
        if(self.viewModel.courseModel.courseType.integerValue) {
            // 微课
            if(self.viewModel.courseModel.isFree.integerValue) {
                // 免费
                [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoFreeCourseEventTypeFillOrder andLabel:nil];
            }else{
                // 精品微课
                [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoMiniCourseEventTypeFillOrder andLabel:nil];
            }
        }else{
            // 就业课
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoProCourseEventTypeFillOrder andLabel:nil];
        }
    }
    
    [self checkCourseExistVideosWithExistBlock:^{
        [weakSelf toOrder];
    }];
}



/// 显示免费订单
- (void)showfreeOrder {
}

/// 跳转到播放页面
- (void)toCourseDetail {
    
    // 统计
    if(self.viewModel.courseModel) {
        // 0-就业课 1-微课
        if(self.viewModel.courseModel.courseType.integerValue) {
            // 微课
            if(self.viewModel.courseModel.isFree.integerValue) {
                // 免费
                [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoFreeCourseEventTypeStudy andLabel:nil];
            }else{
                // 精品微课
                [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoMiniCourseEventTypeStudy andLabel:nil];
            }
        }else{
            // 就业课
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoProCourseEventTypeStudy andLabel:nil];
        }
    }
    
    BXGCourseModel *studyCourseModel = [BXGCourseModel new];
    studyCourseModel.course_id = self.viewModel.courseId;
    studyCourseModel.course_name = self.viewModel.courseModel.courseName;
    if([self.viewModel.courseModel.courseType isEqual:@(0)]) { // 就业课
        // 点击职业课跳转到课程详情
        BXGProCoursePlanViewModel *viewModel = [BXGProCoursePlanViewModel viewModelWithModel:studyCourseModel];
        BXGStudyProCourseVC *proCourseDetailVC = [[BXGStudyProCourseVC alloc]initWithCourseDetailViewModel:viewModel];
        [self.navigationController pushViewController:proCourseDetailVC animated:true needLogin:true];
        
    } else { // if (self.courseModel.courseType == 1) // 微课
        // 获得
        BXGMiniCoursePlayerContentVC *miniPlayerContentVC = [[BXGMiniCoursePlayerContentVC alloc]initWithCourseModel:studyCourseModel];
        BXGBasePlayerVC *player = [[BXGBasePlayerVC alloc]initWithCourseId:self.viewModel.courseId andContentVC:miniPlayerContentVC andPlayType:0];
        [self.navigationController pushViewController:player animated:true needLogin:true];
    }
}
#pragma mark - Check
- (void)toOrder {
    
    if(self.viewModel.courseModel.courseType.integerValue == 1 && self.viewModel.courseModel.isFree.boolValue == true) {
        // 判断是否是免费微课
        Weak(weakSelf);
        BXGOrderFreeCoursePopVC *vc = [BXGOrderFreeCoursePopVC new];
        vc.courseModel = self.viewModel.courseModel;
        
        vc.clickAcceptBtnBlock = ^{
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoFreeCourseEventTypeFillOrder andLabel:nil];
            [weakSelf dismissViewControllerAnimated:true completion:^{
                [[BXGHUDTool share] showLoadingHUDWithString:@"正在加载"];//todo#
                [_payManager loadSaveOrderWithFreeCourseId:self.viewModel.courseId andFinishBlock:^(BXGOrderStatusType status, NSString *msg , BXGOrderPayBaseModel* payModel) {
                    if(BXGSaveOrderStatusTypeFreeCourse == status) {
                        //                        [[BXGHUDTool share] showHUDWithString:@"报名成功"];
                        //                        [weakSelf toCourseDetail];
                        //                        [weakSelf dismissViewControllerAnimated:true completion:nil];
                    }else{
                        [[BXGHUDTool share] showHUDWithString:msg];
                        //                        [weakSelf dismissViewControllerAnimated:true completion:nil];
                    }
                }];
            }];
        };
        
        vc.clickCancleBtnBlock = ^{
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoFreeCourseEventTypeCancle andLabel:nil];
        };
        
        [self mo_presentViewController:vc option:Center completion:nil];
        
    } else {
        BXGOrderFillOrderVC *vc = [BXGOrderFillOrderVC new];
        NSMutableArray *mutableArr = [NSMutableArray new];
        NSString *strCourseId = self.viewModel.courseId;
        [mutableArr addObject:strCourseId];
        vc.arrCourseId = [NSArray arrayWithArray:mutableArr];
        [self.navigationController pushViewController:vc animated:true];
    }
}

- (void)checkSampleBlock:(void(^)())sampleBlock {
    Weak(weakSelf);
    if(self.viewModel.courseModel) {
        
        if([[BXGUserCenter share] checkSignInWithViewController:self]) {
            
            if(weakSelf.viewModel.courseModel.existTry && weakSelf.viewModel.courseModel.existTry.boolValue == true) {
                if(sampleBlock){
                    sampleBlock();
                }
            }else {
                [[BXGHUDTool share] showHUDWithString:@"该课程没有试学视频"];
                
            }
            
//            [weakSelf.viewModel checkCourseExistVideos:self.viewModel.courseId andFinished:^(BOOL isExist, NSString *msg) {
//                [[BXGHUDTool share] closeHUD];
//                if(isExist) {
//
//                }else {
//
//                }
//            }];
        }
    }
}
- (void)checkCourseExistVideosWithExistBlock:(void(^)())existBlock {
    Weak(weakSelf);
    if(self.viewModel.courseModel) {
        if([[BXGUserCenter share] checkSignInWithViewController:self]) {
            
            if(self.viewModel.courseModel.useStart && self.viewModel.courseModel.useStart.integerValue == 1) {
                [[BXGHUDTool share] showHUDWithString:@"请到web端，报名并参加入学测试！"];
                return;
            }
            
            [[BXGHUDTool share] showLoadingHUDWithString:nil];
            [weakSelf.viewModel checkCourseExistVideos:self.viewModel.courseId andFinished:^(BOOL isExist, NSString *msg) {
                [[BXGHUDTool share] closeHUD];
                if(isExist) {
                    if(existBlock){
                        existBlock();
                    }
                }else {
                    [[BXGHUDTool share] showHUDWithString:msg];
                }
            }];
        }
    }
}
@end
