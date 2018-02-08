#pragma mark - Import
// 控制器
#import "BXGStudyProCourseVC.h"
#import "BXGStudyProCoursePlanVC.h"


#import "BXGStudyConstruePopVC.h"
#import "BXGBaseNaviController.h"
#import "BXGUserLoginVC.h"
// 控件
#import "DWPlayerTableViewCell.h"
#import "BXGStudySelectCourseBtn.h"
//#import "BXGStudyProgressView.h"
#import "UIView+Extension.h"

// 模型
#import "BXGProCourseModel.h"

#import "BXGStudyLearningProgressView.h"
#import "BXGHistoryTable.h"

#import "BXGStudyRecentFloatTipView.h"

#import "MOPopWindow.h"
#import "RWDeviceInfo.h"

#import "BXGMaskView.h"


#import "RWTab.h"
#import "UIExtTableView.h"
#import "RWMultiTableView.h"
#import "BXGCourseOutlineChapterModel.h"
#import "BXGStudyChapterHeaderView.h"

#import "BXGBasePlayerVC.h"
#import "BXGProCoursePlayerContentVC.h"

//#import "BXGCourseModal.h"//for testing

#define k_HORIZONTAL_MINIMUM_MARGIN 8
#define kTopTagViewHeight 100
#define kTabBarBottomMargin 49

// 配置数据

#define kRecentViewHeight 38

#import "BXGProCoursePlayerContentVC.h"
#import "BXGMiniCoursePlayerContentVC.h"
#import "BXGBasePlayerVC.h"
#import "RWTabView.h"

#import "BXGStudyProCourseFloatTipView.h"

#pragma mark - Outline Section Cell
@interface BXGOutlineSectionCell : UITableViewCell
@property (nonatomic, strong) BXGCourseOutlineSectionModel *model;
@property (nonatomic, assign) BOOL isFirstCell;
@property (nonatomic, assign) BOOL isLastCell;

@property (nonatomic, weak) UIImageView *cellImageView;
@property (nonatomic, weak) UILabel *cellTitleLabel;
@property (nonatomic, weak) UILabel *cellSubFirstLabel;
@property (nonatomic, weak) UILabel *cellSubSecondLabel;
@property (nonatomic, weak) UIButton *cellBtn;
@end

@implementation BXGOutlineSectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self installUI];
    }
    return self;
}

- (void)installUI
{
    self.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    // create
    UIImageView *cellImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"学习中心-就业课-课程大纲"]];
    UILabel *cellTitleLabel = [UILabel new];
    UILabel *cellSubFirstLabel = [UILabel new];
    UILabel *cellSubSecondLabel = [UILabel new];
    UIButton *cellBtn = [UIButton buttonWithType:0];
    cellBtn.enabled = false;
    
    // add subview
    [self addSubview:cellImageView];
    [self addSubview:cellTitleLabel];
    [self addSubview:cellSubFirstLabel];
    [self addSubview:cellSubSecondLabel];
    [self addSubview:cellBtn];
    
    // constrainsts
    [cellImageView sizeToFit];
    [cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.offset(10);
        make.bottom.offset(-10);
        make.left.offset(15);
        make.centerY.offset(0);
        make.width.offset(cellImageView.bounds.size.width);
        make.height.offset(cellImageView.bounds.size.height);
    }];
    
    [cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cellImageView).offset(-3);
        make.left.equalTo(cellImageView.mas_right).offset(10);
        make.right.equalTo(cellBtn.mas_left).offset(-15);
        // 左边最大
    }];
    
    
    [cellSubFirstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(cellImageView).offset(3);
        make.left.equalTo(cellTitleLabel);
        
    }];
    
    [cellSubFirstLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [cellSubSecondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(cellSubFirstLabel);
        make.left.equalTo(cellSubFirstLabel.mas_right).offset(15);
        make.right.equalTo(cellBtn.mas_left).offset(-15);
    }];

    [cellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(0);
        make.width.offset(47);
        make.height.offset(21);
    }];
    
    // setting
    cellTitleLabel.font = [UIFont bxg_fontRegularWithSize:15];
    cellTitleLabel.textColor = [UIColor colorWithHex:0x333333];
    cellSubFirstLabel.font = [UIFont bxg_fontRegularWithSize:13];
    cellSubFirstLabel.textColor = [UIColor colorWithHex:0x999999];
    cellSubSecondLabel.font = [UIFont bxg_fontRegularWithSize:13];
    cellSubSecondLabel.textColor = [UIColor colorWithHex:0x999999];
    cellImageView.contentMode = UIViewContentModeScaleAspectFit;
    cellBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:13];
    [cellBtn setTitle:@"学习" forState:UIControlStateNormal];
    [cellBtn setTitleColor: [UIColor colorWithHex:0x38ADFF] forState:UIControlStateNormal];
    cellBtn.layer.cornerRadius = 20.0 / 2;
    cellBtn.layer.borderWidth = 1;
    cellBtn.layer.borderColor = [UIColor colorWithHex:0x38ADFF].CGColor;

    self.cellImageView = cellImageView;
    self.cellTitleLabel = cellTitleLabel;
    self.cellSubFirstLabel = cellSubFirstLabel;
    self.cellSubSecondLabel = cellSubSecondLabel;
    self.cellBtn = cellBtn;
}

- (void)setModel:(BXGCourseOutlineSectionModel *)model {

    _model = model;

    if(!model)
    {
        return;
    }
    
    if(model.name)
    {
        self.cellTitleLabel.text = model.name;
    }else
    {
        self.cellTitleLabel.text = @"";
    }

    if(model.videoCount) {
    
        self.cellSubFirstLabel.text = [NSString stringWithFormat:@"共%@课时",model.videoCount];
    }else {
    
        self.cellSubFirstLabel.text = [NSString stringWithFormat:@"共0课时"];
    }
    
    if(model.learndCount) {
        
        self.cellSubSecondLabel.text =[NSString stringWithFormat:@"已学习%@课时",model.learndCount];
    }else {
        
        self.cellSubSecondLabel.text= [NSString stringWithFormat:@"已学习0课时"];
    }
    
}

- (void)setIsFirstCell:(BOOL)isFirstCell {

    _isFirstCell = isFirstCell;
    if(isFirstCell) {
    
        [self.cellImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset(20);
        }];
    }else {
    
        [self.cellImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
        }];

    }
}

- (void)setIsLastCell:(BOOL)isLastCell {

    if(isLastCell) {
    
        [self.cellImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-20);
        }];
        
    }else {
    
        [self.cellImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-10);
        }];
    }
}

@end


@interface BXGStudyProCourseVC () <UINavigationControllerDelegate, BXGNotificationDelegate>

@property (nonatomic, weak) UIView *maskForNoRechbilityView;

@property (weak, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSArray *videoIds;
@property (weak, nonatomic)UIScrollView *detailScrollView;
@property (weak, nonatomic)UIButton *professionalCourceBtn;
@property (weak, nonatomic)UIButton *miniCourceBtn;

@property (weak, nonatomic)UIButton *processBtn;
@property (weak, nonatomic)UILabel *recentLabel;
@property (weak, nonatomic)UILabel *markLabel;
@property (weak, nonatomic)UILabel *startMarkLabel;
@property (weak, nonatomic)UIView *courceArrowView;
@property (strong, nonatomic)BXGStudyProCourseFloatTipView *recentView;

@property (nonatomic, weak) UIView *loadFailedMaskView;
@property (weak, nonatomic)UIView *maskView;

//@property (nonatomic, weak)BXGStudyProgressView *studyProgressView;

@property (nonatomic, strong) RWMultiItem *currentSelectItem;
@property (nonatomic, assign) CGPoint currentContentOffset;
/**
 最近学习内容(注:要替换成模型)
 */
@property (copy, nonatomic) NSString *recentStudyString;
@property (strong, nonatomic) BXGStudyProCoursePlanVC *proCourseVC;


// @property (nonatomic, strong) BXGStudyViewModel *viewModel;

//@property (nonatomic, strong) BXGCourseModal *modal;//for testing




@property (nonatomic, weak) BXGStudyLearningProgressView *progressView;

// 最近学习
//@property (nonatomic, strong) NSDate *recentViewStayDate;
//@property (nonatomic, strong) NSTimer *intervalTimer;


// 接口
@property (nonatomic, weak) UIView *proCoursePlanView;
@property (nonatomic, weak) RWMultiTableView *proCourseOutlineView;

@property (nonatomic, strong) NSArray *proCourseChapterArray;
@property (nonatomic, strong) NSArray *chaperArray;

//

@property (nonatomic, assign) BOOL isFirstLoad;
@end

@implementation BXGStudyProCourseVC

#pragma mark - Init

- (instancetype)initWithCourseDetailViewModel:(BXGProCoursePlanViewModel *)viewModel; {
    
    self = [super init];
    if(self){
        
        // 初始化参数
        self.hidesBottomBarWhenPushed = true;
        self.viewModel = viewModel;
    }
    return self;
}

- (void)dealloc {}

#pragma mark - Getter Setter

- (void)setViewModel:(BXGProCoursePlanViewModel *)viewModel {

    _viewModel = viewModel;
    if(_viewModel){
        
        //    TODO INIT
    }
}

// 最近学习逻辑判断
-(void)setRecentStudyString:(NSString *)recentStudyString {
    
    _recentStudyString = recentStudyString;
    self.recentLabel.text = recentStudyString;
    if(recentStudyString.length > 0) {
        
        self.markLabel.hidden = false;
        self.recentLabel.hidden = false;
        self.startMarkLabel.hidden = true;
        self.processBtn.selected = true;
        
    }else {
        
        self.markLabel.hidden = true;
        self.recentLabel.hidden = true;
        self.startMarkLabel.hidden = false;
        self.processBtn.selected = false;
    }
}

#pragma mark - Observers

- (void)installObservers
{
    [BXGNotificationTool addObserverForReachability:self];
}

- (void)uninstallObservers
{
    [BXGNotificationTool removeObserver:self];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageName = @"就业班详情页";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.delegate = self;
    
    [self installUI];
    [self installNavigationBarItem];
    
    self.detailScrollView.contentOffset = CGPointMake(0,0);
    self.professionalCourceBtn.selected = true;
    self.miniCourceBtn.selected = false;
    [BXGNotificationTool addObserverForReachability:self];
    
    if(self.viewModel.courseModel.course_name){
    
        self.title = self.viewModel.courseModel.course_name;
    }else {
    
        self.title = @"";
        
    }
    [self.proCourseOutlineView installLoadingMaskView];
    [self loadData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self installObservers];

    // 判断是否登录    
    if(!self.viewModel.userModel)
    {
        BXGUserLoginVC *vc = [BXGUserLoginVC new];
        vc.view.backgroundColor = [UIColor whiteColor];
        BXGBaseNaviController *nav = [[BXGBaseNaviController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:false completion:nil];
    }
    
    if(self.viewModel.userModel) {
        [self.recentView loadContent:nil];
    }
    
    // 最近学习
//    [self.recentView loadContent:nil];
//    [weakSelf.viewModel loadLastLearnHistoryWithFinished:^(id  _Nullable model) {
//
//        weakSelf.recentView.model = model;
//        // weakSelf.recentView.model = [[BXGHistoryTable new] searchLastHistoryWithCourseId:self.viewModel.courseModel.course_id];
//    }];
    
    
    
    
//    [weakSelf.recentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(38);
//    }];
//    [weakSelf.recentView layoutIfNeeded];
    // [weakSelf.view layoutSubviews];
    // 添加事件
//    self.recentViewStayDate = [NSDate new];
//    self.intervalTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(intervalTimerOperation:) userInfo:nil repeats:true];
//    [[NSRunLoop currentRunLoop] addTimer:self.intervalTimer forMode:NSRunLoopCommonModes];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self uninstallObservers];
    
    [[BXGHUDTool share] closeHUD];
//    [self.intervalTimer invalidate];
//    self.intervalTimer = nil;
}

#pragma mark - Load Data

- (void)loadData {
    __weak typeof (self) weakSelf = self;
    
    [self.viewModel loadCourseProgressFinished:^(BOOL success, BXGCourseProgressInfoModel * _Nullable model, NSString * _Nullable message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.progressView.model = model;
        });
    }];
    
    // 是否要显示学习计划
    if(weakSelf.viewModel.courseModel.isExistPlan && weakSelf.viewModel.courseModel.isExistPlan.boolValue) {
        
        if(weakSelf.viewModel.courseModel.startDate) {
            
            NSDate *date = [[BXGDateTool share] dateFormRequestDateString:weakSelf.viewModel.courseModel.startDate];
            if(!date && date.timeIntervalSinceNow > 0) {
                
                [self.proCoursePlanView installMaskView:BXGMaskViewTypeNoPlan];
            }
        }else {
            
            [self.proCoursePlanView installMaskView:BXGMaskViewTypeNoPlan];
        }
        
    }else{
        
        [self.proCoursePlanView installMaskView:BXGMaskViewTypeNoPlan];
        
    }
    
    [self.viewModel loadCourseChapterList:^(BOOL success, NSArray * _Nullable modelArray, NSString * _Nullable message) {
        
        [weakSelf.proCourseOutlineView  removeMaskView];
        if(success) {
            
            if(modelArray.count <= 0) {
                
                // 加载数据为空蒙版
                [weakSelf.proCourseOutlineView installMaskView:BXGMaskViewTypeStudyCenterEmpty];
            }
            
        }else {
            
            // 加载失败蒙版
            [weakSelf.proCourseOutlineView installMaskView:BXGMaskViewTypeLoadFailed];
            
        }
        weakSelf.proCourseChapterArray = modelArray;
        [weakSelf.proCourseOutlineView installDataSourse];

        [weakSelf.proCourseOutlineView reloadData];
  
        [weakSelf.proCourseOutlineView bxg_endHeaderRefresh];
        
    }];
}

#pragma mark - Install UI

- (void)installUI {

    __weak typeof (self) weakSelf = self;
    UIView *learingProgressView = [self installLearningProgressView];
    [self.view addSubview:learingProgressView];
    [learingProgressView mas_makeConstraints:^(MASConstraintMaker *make) {

//        make.top.equalTo(self.recentView.mas_bottom);
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.offset(0);
        make.right.offset(0);
        
        if( [RWDeviceInfo deviceScreenType] <= RWDeviceScreenTypeSE) {
            
            make.height.offset(133);
         
        }else{
            make.height.offset(133);
         
        }
    }];

    UIView *proCourseDetailView = [self installCourseDetailView];
    [self.view addSubview:proCourseDetailView];
    
    [proCourseDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(learingProgressView.mas_bottom);
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
        make.width.equalTo(proCourseDetailView.mas_width);
    }];
    
    if(self.viewModel) {
        self.recentView = [[BXGStudyProCourseFloatTipView alloc] initWithViewModel:self.viewModel];
        [self.view addSubview:self.recentView];
        
        self.recentView.touchUpInsideBlock = ^(BXGBasePlayerVC *playerVC) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.navigationController pushViewController:playerVC animated:true];
            });
        };
        
        [self.recentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(K_NAVIGATION_BAR_OFFSET);
            make.left.right.offset(0);
            make.height.equalTo(@38);
        }];
        self.recentView.hidden = YES;
    }
 
}

- (UIView *)installCourseDetailView {
    
    __weak typeof (self) weakSelf = self;
#pragma mark 课程大纲

    // tab 1
    RWMultiTableView *outlineTableView = [[RWMultiTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.proCourseOutlineView = outlineTableView;
    outlineTableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
//    outlineTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf loadData];
//    }];
    [outlineTableView bxg_setHeaderRefreshBlock:^{
        [weakSelf loadData];
    }];
    [outlineTableView registerClass:[BXGOutlineSectionCell class] forCellReuseIdentifier:@"BXGOutlineSectionCell"];
    
    [outlineTableView registerClass:[BXGStudyChapterHeaderView class] forHeaderFooterViewReuseIdentifier:@"BXGStudyChapterHeaderView"];
    
    outlineTableView.rootModelForTableViewBlock = ^NSArray *(RWMultiTableView *tableView) {
        
        return weakSelf.proCourseChapterArray;
    };
    
    outlineTableView.subModelsForTableViewBlock = ^NSArray *(RWMultiTableView *tableView, NSInteger section, RWMultiItem *parentItem) {
        
        
        if(parentItem.level == -1) {
        
            BXGCourseOutlineChapterModel *model = weakSelf.proCourseChapterArray[section];
            return model.jie;
        }else {
        
            return nil;
        }
    };
    
    outlineTableView.cellForRowBlock = ^UITableViewCell *(RWMultiTableView *tableView, NSIndexPath *indexPath, RWMultiItem *item) {
       
        BXGOutlineSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGOutlineSectionCell"];
        BXGCourseOutlineSectionModel *model= item.model;
        cell.model = model;
        if(item.tag == 0) {
        
            cell.isFirstCell = true;
        }else {
         
            cell.isFirstCell = false;
        }
        
        NSInteger lastIndex = [tableView numberOfRowsInSection:indexPath.section];
        if(item.tag == lastIndex - 1) {
        
            cell.isLastCell = true;
        }else {
        
            cell.isLastCell = false;
        }
        
        
        return cell;
    };
    
    outlineTableView.viewForHeaderInSectionBlock = ^UIView *(RWMultiTableView *tableView, NSInteger section, RWMultiItem *item) {
      
        BXGStudyChapterHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BXGStudyChapterHeaderView"];
        if(!headerView) {
        
            headerView = [BXGStudyChapterHeaderView new];
            
        }
        headerView.backgroundColor = [UIColor whiteColor];
        BXGCourseOutlineChapterModel *model = item.model;
        headerView.title = model.name;
        
        headerView.isOpen = item.isOpen;
        return headerView;
    };
    
    outlineTableView.heightForHeaderInSectionBlock = ^CGFloat(RWMultiTableView *tableView, NSInteger section) {
        
        return 50;
    };
    
    outlineTableView.didSelectRowBlock = ^(RWMultiTableView *tableView, NSIndexPath *indexPath, RWMultiItem *item) {
        
        BXGProCoursePlayerContentVC *contentVC = [[BXGProCoursePlayerContentVC alloc]initWithCourseModel:weakSelf.viewModel.courseModel andSectionModel:item.model];
        BXGBasePlayerVC *vc = [[BXGBasePlayerVC alloc]initWithCourseModel:weakSelf.viewModel.courseModel ContentVC:contentVC];
        BXGCourseOutlineSectionModel *sectionModel = item.model;
        BXGHistoryModel *historyModel = [[BXGHistoryTable new] searchHistoryWithCourseId:weakSelf.viewModel.courseModel.course_id andJieId:sectionModel.idx];
        [vc autoPlayWithPointId:historyModel.dian_id andVideoId:historyModel.video_id];

        weakSelf.currentSelectItem = item;
        [weakSelf.navigationController pushViewController:vc animated:true];
    };
    
    outlineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    outlineTableView.didSelectHeaderViewAtSectionBlock = ^(RWMultiTableView *tableView, NSInteger section, RWMultiItem *item) {
        
        if(tableView.sectionDataSourseArray) {
        
            for(NSInteger i = 0; i < tableView.sectionDataSourseArray.count; i++) {
            
                if(section == i) {
                
                    if(item.isOpen){
                        
                        [tableView closeSection:i];
                        
                    }else {
                        
                        [tableView openSection:i];
                        
                        
                    }
                }else {
                
                    [tableView closeSection:i];
                }
            }
        }
        [tableView reloadData];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        if(tableView.numberOfSections > section && [tableView numberOfRowsInSection:section] > 0){
        
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:true];
        }
        
    };
//    outlineTableView.heightForHeaderInSectionBlock = ^CGFloat(RWMultiTableView *tableView, NSInteger section) {
//        return 70;
//    };;
//    outlineTableView.heightForRowBlock = ^CGFloat(RWMultiTableView *tableView, NSInteger section, RWMultiItem *item) {
//        return 70;
//    };
    outlineTableView.rowHeight = UITableViewAutomaticDimension;
    outlineTableView.estimatedRowHeight = 70;
//    outlineTableView.rowHeight = 70;
    [outlineTableView installDataSourse];
    [outlineTableView openAllSection];
    
    // tab 2
    
    BXGStudyProCoursePlanVC *vc = [BXGStudyProCoursePlanVC new];
    self.proCourseVC = vc;
    
    vc.viewModel = self.viewModel;
    vc.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:vc];
    
    self.proCoursePlanView = vc.view;
    RWTabView *superView = [[RWTabView alloc]initWithTitles:@[@"课程大纲",@"学习计划"] andDetailViews:@[outlineTableView,vc.view]];
    superView.DidChangedIndex = ^(RWTabView *tab, NSInteger index, NSString *title, UIView *view) {
        // 百度统计
        if(index == 0)
        {
            [[BXGBaiduStatistic share] statisticEventString:jybkcdg_15 andParameter:nil];
        }else
        {
            [[BXGBaiduStatistic share] statisticEventString:jybxxjh_16 andParameter:nil];
        }
    };
//    RWTab *superView =[[RWTab alloc]initWithDetailViewArrary:@[outlineTableView,vc.view] andTitleArray:@[@"课程大纲",@"学习计划"] andCount:2];
//    superView.onChangeActionBlock = ^(RWTab *tab) {
//
//
//    };
//    superView.de = false;
    
//    superView.backgroundColor = [UIColor whiteColor];
    
    return superView;
}


- (void)installNavigationBarItem{

}

- (UIView *) installLearningProgressView {

    BXGStudyLearningProgressView *progressView = [BXGStudyLearningProgressView new];
    self.progressView = progressView;
    return progressView;
}

- (UIView *)installProCoursePlanView {
    
    UIView *superView = [UIView new];
    
    superView.backgroundColor = [UIColor whiteColor];
    BXGStudyProCoursePlanVC *vc = [BXGStudyProCoursePlanVC new];
    self.proCourseVC = vc;
    vc.viewModel = self.viewModel;
    vc.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:vc];
    [superView addSubview:vc.view];
    
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
        make.bottom.offset(0);
    }];

    return superView;
}

- (UIView *)installDetailScrollView {

    UIScrollView *superView = [UIScrollView new];
    return superView;
}

#pragma mark - Operation

//- (void)intervalTimerOperation:(NSTimer *)sender {
//
//
//    if(self.recentViewStayDate.timeIntervalSinceNow < -5) {
//
//        [self closeRecentView];
//        [sender invalidate];
//    }
//
//}
//- (void)closeRecentView {
//
//    __weak typeof (self) weakSelf = self;
//    [weakSelf.recentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(0);
//    }];
//
//    [UIView animateWithDuration:0.3 animations:^{
//
//        //[weakSelf.recentView layoutIfNeeded];
//        [weakSelf.view layoutIfNeeded];
//        //[weakSelf.view layoutSubviews];
//        //[weakSelf.proCourseVC.view layoutSubviews];
//        [weakSelf.proCourseVC updateLayout];
//
//    } completion:^(BOOL finished) {
//
//    }];
//}

#pragma mark - Response

//- (void)clickLearningProgressView {
//    
//    BXGStudyPlayerRootVC *playerRoot = [BXGStudyPlayerRootVC new];
//    [self.navigationController pushViewController:playerRoot animated:true];
//}
//
//- (void)clickRightBarItem;{
//    
//    BXGStudyPlayerRootVC *playerVC;
//    BXGHistoryModel *historyModel = [[BXGHistoryTable new] searchLastHistoryWithCourseId:self.viewModel.courseModel.course_id];
//    if(historyModel) {
//        
//        playerVC = [[BXGStudyPlayerRootVC alloc]initWithHistoryModel:historyModel];
//    }else {
//        
//        BXGCourseDetailViewModel *courseDetailViewModel = [BXGCourseDetailViewModel viewModelWithModel:self.viewModel.courseModel];
//        playerVC = [[BXGStudyPlayerRootVC alloc] initWithCourseDetailViewModel:courseDetailViewModel];
//    }
//    
//    [self.navigationController pushViewController:playerVC animated:true];
//}

#pragma mark - Catch Notification

// 监听网络状态变化
-(void)catchRechbility:(BXGReachabilityStatus)status
{
    if(status != BXGReachabilityStatusReachabilityStatusNotReachable)
    {
        // 删除蒙版
        [self.view removeMaskView];
    }
    else
    {
        // 添加无网络蒙版
        [self.view installMaskView:BXGMaskViewTypeNoNetwork andInset:UIEdgeInsetsMake(K_NAVIGATION_BAR_OFFSET, 0, 0, 0)];
    }
}

@end
