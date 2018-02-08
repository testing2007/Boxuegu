//
//  BXGCategoryRootVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCategoryRootVC.h"
#import "BXGDownloadManagerVC.h"
#import "BXGMeLearnedHistoryVC.h"
#import "BXGMeMyMessageVC.h"
#import "RWCommonFunction.h"
#import "BXGMessageTool.h"
#import "BXGMoreMicroCourseVC.h"
#import "BXGCourseInfoVC.h"
#import "RWTabTitleView.h"
#import "BXGCategoryDetailView.h"
#import "BXGCategoryViewModel.h"
#import "BXGCategorySubjectModel.h"
#import "BXGHomeCourseModel.h"
#import "BXGCourseInfoVC.h"
#import "BXGMoreMicroCourseVC.h"
#import "BXGOrderFreeCoursePopVC.h"
#import "MOPopWindow.h"

#import "BXGCourseInfoViewModel.h"
#import "BXGSearchVC.h"
#import "BXGTextField.h"
#import "BXGSearchBar.h"

@interface BXGCategoryRootVC () <BXGNotificationDelegate, UISearchBarDelegate>
@property (nonatomic, strong) BXGCategoryViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray<BXGCategorySubjectModel *> *subjectModels;

//@property (nonatomic, weak) BXGTextField *textField;
@property (nonatomic, weak) UISearchBar *textField;


@property (nonatomic, weak) RWTabTitleView *tabTitleView;
@property (nonatomic, weak) BXGCategoryDetailView *tabDetailView;
@property (nonatomic, strong) BXGHomeCourseModel *proCourseModel;
@property (nonatomic, strong) NSMutableArray<BXGCategoryMiniCourseModel *> *miniCourseModels;
@end

@implementation BXGCategoryRootVC

#pragma mark - Getter Setter

- (BXGCategoryViewModel *)viewModel {
    if(_viewModel == nil) {
        
        _viewModel = [BXGCategoryViewModel new];
    }
    return _viewModel;
}

- (void)setSubjectModels:(NSMutableArray<BXGCategorySubjectModel *> *)subjectModels {
    _subjectModels = subjectModels;
    NSMutableArray *titles = [NSMutableArray new];
    for (NSInteger i = 0; i < subjectModels.count; i++) {
        NSString *title = subjectModels[i].menuName;
        if(title) {
            [titles addObject:title];
        }
    }
    self.tabTitleView.tabTitleArray = titles;
}

#pragma mark - Override

- (void)viewDidLoad {
    self.pageName = @"分类";
    [super viewDidLoad];
    [self installNavigationBarItem];
    [self installUI];
    [self loadData];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textField resignFirstResponder];
}

- (void)installNavigationBarItem
{
    [super installNavigationBar];
    self.navigationItem.title = @"";
//    BXGTextField *textField = [[BXGTextField alloc] initWithFrame:CGRectMake(5,
//                                                                           8,
//                                                                           SCREEN_WIDTH-5-15,
//                                                                           28)];
//    textField.delegate = self;
//    _textField = textField;
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.textField];
//    self.navigationItem.leftBarButtonItem = leftItem;
////    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(15,
////                                                                           8,
////                                                                           SCREEN_WIDTH-5-15,
////                                                                           28)];
    BXGSearchBar *searchBar = [[BXGSearchBar alloc] initWithFrame:CGRectMake(0,
                                                                           8,
                                                                           SCREEN_WIDTH-2*15-5,
                                                                           28)];
//    if (@available(iOS 11.0, *)) {
//        [searchBar.heightAnchor constraintEqualToConstant:28].active = YES;
//    }
    [searchBar setImage:[UIImage imageNamed:@"搜索-搜索"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [searchBar setPositionAdjustment:UIOffsetMake(5, 0) forSearchBarIcon:UISearchBarIconSearch];
    [searchBar setImage:[UIImage imageNamed:@"搜索-清除"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    searchBar.backgroundImage = [[UIImage alloc] init];//设置背景图是为了去掉上下黑线
    searchBar.tintColor = [UIColor colorWithHex:0xFFFFFF];//光标颜色
//    UITextField *searchField = [searchBar valueForKey:@"searchField"];
//    if (searchField) {
//        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入要搜索的内容" attributes:
//                                          @{NSForegroundColorAttributeName:
//                                                [UIColor colorWithHex:0xFFFFFF],
//                                            NSFontAttributeName:[UIFont bxg_fontRegularWithSize:13]
//                                            }];
//        searchField.attributedPlaceholder = attrString;
//        [searchField setBackgroundColor:[UIColor colorWithHex:0xffffff alpha:0.2]];
//        searchField.textColor = [UIColor whiteColor];
//        if (@available(iOS 11.0, *)) {
//            searchField.layer.cornerRadius = 18.0f;
//        } else {
//            searchField.layer.cornerRadius = 14.0f;
//        }
//        searchField.layer.masksToBounds = YES;
//    }
    searchBar.returnKeyType = UIReturnKeySearch;
    searchBar.delegate = self;
    
//    UIBarButtonItem *barSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    barSpace2.width = -2;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    self.navigationItem.leftBarButtonItems = @[leftItem];
    _textField = searchBar;
}

#pragma mark - Operation
- (void)operationDownload
{
    RWLog(@"跳转到下载");
    [[BXGBaiduStatistic share] statisticEventString:xzgl_icon_08 andParameter:nil];
    BXGDownloadManagerVC *vc = [BXGDownloadManagerVC new];
    [self.navigationController pushViewController:vc animated:true needLogin:true];
}

- (void)operationViewRecord
{
    RWLog(@"跳转到观看记录");
    [[BXGBaiduStatistic share] statisticEventString:gkjl_icon_10 andParameter:nil];
    BXGMeLearnedHistoryVC *vc = [BXGMeLearnedHistoryVC new];
    [self.navigationController pushViewController:vc animated:true needLogin:true];
}

- (void)operationMessage
{
    RWLog(@"跳转到我的消息");    
    [[BXGBaiduStatistic share] statisticEventString:xx_icon_11 andParameter:nil];
    BXGMeMyMessageVC *vc = [BXGMeMyMessageVC new];
    [self.navigationController pushViewController:vc animated:true needLogin:true];
}


- (void)installUI {
    Weak(weakSelf);
    RWTabTitleView *tabTitleView = [RWTabTitleView new];
    tabTitleView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    _tabTitleView = tabTitleView;
    
    BXGCategoryDetailView *tabdetail = [BXGCategoryDetailView new];
    // 响应分类详情页点击响应
    tabdetail.didSelectedTagBlock = ^(NSIndexPath *indexPath) {
        if(indexPath.section <= 1) { // 就业课
            BXGCourseInfoViewModel *courseInfoVM = [[BXGCourseInfoViewModel alloc]initWithCourseModel:weakSelf.proCourseModel];
            BXGCourseInfoVC *courseInfoVC = [[BXGCourseInfoVC alloc] initWithViewModel:courseInfoVM];
            [weakSelf.navigationController pushViewController:courseInfoVC animated:true];
            // TODO: 添加统计
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatCategoryEventTypeProCourse andLabel:weakSelf.proCourseModel.courseName];
            
        }
        if(indexPath.section == 2) { // 微课
            
            BXGMoreMicroCourseVC *vc = [[BXGMoreMicroCourseVC alloc]init];
            vc.type = BOUTIQUE_MICRO_COURSE_TYPE;
            vc.subjectId = @(weakSelf.subjectModels[weakSelf.tabTitleView.currentIndexPath.item].menuId.integerValue);
            vc.tagId = @(weakSelf.miniCourseModels[indexPath.row].idx.integerValue);
            vc.freeId = @(0);
            [weakSelf.navigationController pushViewController:vc animated:true];
            // TODO: 添加统计
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatCategoryEventTypeMiniCourse andLabel:weakSelf.proCourseModel.courseName];
        }
    };
    tabdetail.didSelectedHeaderViewBlock =^{
        BXGCourseInfoViewModel *courseInfoVM = [[BXGCourseInfoViewModel alloc]initWithCourseModel:weakSelf.proCourseModel];
        BXGCourseInfoVC *courseInfoVC = [[BXGCourseInfoVC alloc] initWithViewModel:courseInfoVM];
        [weakSelf.navigationController pushViewController:courseInfoVC animated:true];
    };
    
    _tabDetailView = tabdetail;
    [self.view addSubview:tabdetail];
    
    [self.view addSubview:tabTitleView];
    
    // 90 49
    UIView *arrowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 49)];
    arrowView.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    tabTitleView.arrowView = arrowView;
    [tabTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(90);
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.bottom.offset(0);
    }];
    tabTitleView.cellSizeType = RWTabCellSizeTypeCustom;
    tabTitleView.cellSize = CGSizeMake(90, 49);

    tabTitleView.cellClassName = @"BXGCategoryTitleViewCell";
    tabTitleView.minimumLineSpacing = 0;
    tabTitleView.minimumInteritemSpacing = 0;
    
    
    tabTitleView.didChangedBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        
        BXGCategorySubjectModel *model = weakSelf.subjectModels[indexPath.row];
        if(model && model.menuId){
            
            // TODO: 添加统计
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatCategoryEventTypeSubject andLabel:model.menuName];
            
            [weakSelf.tabDetailView installLoadingMaskView];
            [weakSelf.viewModel loadCourseCategoryInfoWithSubjectId:model.menuId andFinished:^(BOOL succeed, BXGHomeCourseModel *proCourseModel, NSArray<BXGCategoryMiniCourseModel *> *miniCourseModels) {
                [weakSelf.tabDetailView removeMaskView];
                if(!succeed) {
                    // 加载失败
                    [weakSelf.tabDetailView installMaskView:BXGMaskViewTypeLoadFailed];
                } else {
                    NSMutableArray<NSString *> *firstTitles = [NSMutableArray new];
                    NSMutableArray<NSString *> *secondTitles = [NSMutableArray new];
                    if(proCourseModel){
                        if(proCourseModel.courseName){
                            [firstTitles addObject:proCourseModel.courseName];
                        }
                        if(proCourseModel.courseImg){
                        }
                    }
                    
                    if(miniCourseModels){
                        for(NSInteger i = 0; i < miniCourseModels.count; i++){
                            if(miniCourseModels[i].name){
                                [secondTitles addObject:miniCourseModels[i].name];
                            }
                        }
                    }
                    
                    weakSelf.proCourseModel = proCourseModel;
                    weakSelf.miniCourseModels = [miniCourseModels copy];;
                    [weakSelf.tabDetailView setHeaderURL:proCourseModel.courseImg andFirstSectionTitles:firstTitles andSecondSectionTitles:secondTitles];
                }
            }];
        }
    };
    tabTitleView.didChangedArrowViewBlock = ^(UICollectionView *collectionView, UICollectionViewCell *cell, NSIndexPath *indexPath, UIView *arrowView) {
        arrowView.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 3, 49);
    };
    

    [tabdetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tabTitleView.mas_right);
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.bottom.offset(0);
        make.right.offset(0);
    }];
    tabTitleView.currentIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
}
#pragma mark - Data

- (void)loadData {
    Weak(weakSelf);
    [weakSelf.view installLoadingMaskViewWithInset:UIEdgeInsetsMake(K_NAVIGATION_BAR_OFFSET, 0, 0, 0)];
    [self.viewModel loadCourseCategorySubjectWithFinished:^(NSMutableArray<BXGCategorySubjectModel *> *models) {
        [weakSelf.view removeMaskView];
        weakSelf.subjectModels = models;
        if(!models || !models.firstObject){
            [weakSelf.view installMaskView:BXGButtonMaskViewTypeLoadFailed andInset:UIEdgeInsetsMake(K_NAVIGATION_BAR_OFFSET, 0, 0, 0) buttonBlock:^{
                [weakSelf loadData];
            }];
        }else {
            // 调用第一个元素
            weakSelf.tabTitleView.didChangedBlock(nil, [NSIndexPath indexPathForItem:0 inSection:0]);
        }
    }];
}

//#pragma mark UITextFieldDelegate
//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    [[BXGBaiduStatistic share] statisticEventString:kBXGStatSearchEventTypeIntoSearchPage andLabel:@"分类"];
//    BXGSearchVC *vc = [BXGSearchVC new];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [[BXGBaiduStatistic share] statisticEventString:kBXGStatSearchEventTypeIntoSearchPage andLabel:@"分类"];
    BXGSearchVC *vc = [BXGSearchVC new];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    BXGBaseNaviController *nav = [[BXGBaseNaviController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
//    [self.navigationController presentViewController:vc animated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)searchBarTextDidEndEditing:(UISearchBar*)searchBar {
//    if(!_textField.text.length) {
//        [_textField setPositionAdjustment:UIOffsetMake(5,0) forSearchBarIcon:UISearchBarIconSearch];
//    }
//}

@end
