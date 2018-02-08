//
//  BXGStudyProfessionalCourseController.m
//  Boxuegu
//
//  Created by mynSoo RW on 2017/4/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "RWDeviceInfo.h"
#import "BXGStudtyDateTagCollectionCell.h"
#import "BXGStudyProCourseCollectionCell.h"

#import "BXGStudyProCoursePlanVC.h"

#import "BXGStudyConstruePopVC.h"

#import "BXGConstrueModel.h"
#import "BXGStudyViewModel.h"

#import "MOPopWindow.h"
#import "UIImage+Extension.h"
#import "BXGStudyConstrueVC.h"

#import "BXGStudyProCoursePlanDetailVC.h"

#import "BXGStudyProCourseCollectionCell.h"

#import "BXGMiniCalendarView.h"

#import "BXGProCoursePlayerContentVC.h"
#import "BXGBasePlayerVC.h"
#import "BXGMiniCoursePlayerContentVC.h"


#pragma mark - [Class] BXGDateTagViewFlowLayout -
@interface BXGDateTagViewFlowLayout : UICollectionViewFlowLayout
// self.needRefreshUI =


@end

@implementation BXGDateTagViewFlowLayout
-(void)prepareLayout {
    
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = CGSizeMake(75, self.collectionView.bounds.size.height);
    //self.itemSize = CGSizeMake(75, 86);
    self.collectionView.bounces = true;
    self.collectionView.showsVerticalScrollIndicator = false;
    self.collectionView.showsHorizontalScrollIndicator = false;
}
@end

#pragma mark - [Class] BXGDateDetailViewFlowLayout -
@interface BXGDateDetailViewFlowLayout : UICollectionViewFlowLayout
@end

@implementation BXGDateDetailViewFlowLayout
-(void)prepareLayout {
    
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    self.collectionView.pagingEnabled = true;
    // self.collectionView.bounces = false;
    self.collectionView.bounces = true;
    self.collectionView.showsVerticalScrollIndicator = false;
    self.collectionView.showsHorizontalScrollIndicator = false;
    self.collectionView.scrollEnabled = true;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {

    // self.itemSize = CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);;
    return YES;
}

@end

#pragma mark - [Class] BXGStudyProCourseVC -

@interface BXGStudyProCoursePlanVC() <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) UILabel *courseNameLabel;
@property (nonatomic, weak) UICollectionView *dateTagCollecionView;
@property (nonatomic, strong) UICollectionView *dateDetailCollecionView;

@property (nonatomic, weak) UIButton *moreBtn;

@property (nonatomic, strong) UIView *selectCouresePopView;
@property (nonatomic, assign) BOOL needRefreshUI;
@property (nonatomic, strong) BXGDateDetailViewFlowLayout *detailFlowLayout;


@property (nonatomic, weak) UIView *arrowPlanDateView;
@property (nonatomic, strong) NSArray *dateTagBtnArray;

@end
@implementation BXGStudyProCoursePlanVC
@synthesize dateArray = _dateArray;

#pragma mark - Getter Setter

- (void)setDateArray:(NSArray *)dateArray {

    _dateArray = dateArray;
    [self.dateTagCollecionView reloadData];
    [self.dateDetailCollecionView reloadData];
}

- (NSArray *)dateArray {
// - (NSArray<NSDate *> *)dateArrayForDate:(NSDate *)date andDayOffset:(NSInteger)offset andLength:(NSInteger)length {
    
    
    if(!_dateArray) {
    
        if([RWDeviceInfo deviceScreenType] <= RWDeviceScreenTypeSE) {
        
            _dateArray = [[BXGDateTool share] dateArrayForDate:[NSDate new] andDayOffset:-1 andLength:3];
        }else {
        
            _dateArray = [[BXGDateTool share] dateArrayForDate:[NSDate new] andDayOffset:-2 andLength:4];
            // _dateArray = [[BXGDateTool share] getWeekDate] ;
        }
        // 判断5s
        
        
        //_dateArray = [[BXGDateTool share] dateArrayForMonthWithDate:[NSDate new]] ;
    }
    return _dateArray;
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];
    self.needRefreshUI = true;
    [self installUI];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
    [self updateLayout];
    [self refreshUI];
//    __weak typeof (self) weakSelf = self;


}




#pragma mark - Data Source
- (void)viewDidAppear:(BOOL)animated {

    
    [super viewDidAppear:animated];
    //     滚动到今日页面
    
}

//- (void)updateData{
//
//    __weak typeof (self) weakSelf = self;
////
//
//    [weakSelf refreshUI];
//    
//}
#pragma mark - Refresh UI

- (void)refreshUI {

    __weak typeof (self) weakSelf = self;
    // BXGStudyPayCourseModel *courseModel = self.viewModel.currentPayCourseModel;
    BXGCourseModel *courseModel = self.viewModel.courseModel;
    weakSelf.courseNameLabel.text = courseModel.course_name ;
    
    self.dateDetailCollecionView.alpha = 0.0;
    
     // [self.dateDetailCollecionView reloadData];
    
    [UIView animateWithDuration:0.2 animations:^{
    
        self.dateDetailCollecionView.alpha = 1;
    }];
}


#pragma mark - Install UI 职业课程控制器

- (void)installUI {
    
//    UIView *courseTitleView = [self installCourseTitleView];
//    [self.view addSubview:courseTitleView];
//    [courseTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.left.right.offset(0);
//        make.height.offset(47);
//        
//    }];
    
    UIView *dateTagView = [self installDateTagView];
    [self.view addSubview:dateTagView];
    // dateTagView.backgroundColor = [UIColor clearColor];
    [dateTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        // make.top.equalTo(courseTitleView.mas_bottom);
        make.top.offset(0);
        make.left.right.offset(0);
        //make.left.offset(15);
        //make.right.offset(-15);
        // make.height.offset(121 - 46);
        make.height.offset(86 - 47);
    }];
    
//    UIView *splitView = [UIView new];
//    [self.view addSubview:splitView];
//    splitView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
//    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(dateTagView.mas_bottom).offset(10);
//        make.left.right.offset(0);
//        make.height.offset(1);
//    }];
    
    UIView *dateDetailView = [self installDateDetailView];
    [self.view addSubview:dateDetailView];
    [dateDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        // make.top.equalTo(splitView.mas_bottom).offset(0);
        make.top.equalTo(dateTagView.mas_bottom).offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
    }];
    

}



- (UIView *)installCourseTitleView {
    
    UIView *superview = [UIView new];
    
    // 标记
    
    UIView *markView = [UIView new];
    [superview addSubview:markView];
    markView.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    [markView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(15);
        make.height.offset(15);
        make.width.offset(2);
        make.centerY.offset(-2);
    }];
    markView.layer.cornerRadius = 1;
    
    // 标题
    
    UILabel *titleLabel = [UILabel new];
    [superview addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(markView.mas_left).offset(6);
        make.right.offset(0);
        make.centerY.offset(-2);
        make.height.offset(16);
    }];
    titleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    titleLabel.textColor = [UIColor colorWithHex:0x333333];
    self.courseNameLabel = titleLabel;
    
    // 更多图标
    UIImageView *moreImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"选择课程-更多"]];
    
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [superview addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.offset(0);
        make.width.offset(50);
        make.top.bottom.offset(0);
    }];
    
    [moreButton addSubview:moreImageView];
    [moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(0);
        make.width.height.offset(15);
    }];
    
    self.moreBtn = moreButton;
    [moreButton addTarget:self action:@selector(clickMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    // self.moreBtn.hidden = true;
    return superview;
}

- (void)arrowDateTag:(NSInteger)index {

    if(self.dateTagBtnArray.count <= index) {
    
        return;
    }
    
    // UIButton *btn =
    for(NSInteger i = 0; i < self.dateTagBtnArray.count - 1; i++) {
    
        if(i == index){
        
            [self.dateTagBtnArray[i] setTitleColor:[UIColor colorWithHex:0x38ADFF] forState:UIControlStateNormal];
        }else {
        
            NSDate *date = self.dateArray[i];
            
            if([[BXGDateTool share] isToday:date]) {
            
                [self.dateTagBtnArray[i] setTitleColor:[UIColor colorWithHex:0xFF554C] forState:UIControlStateNormal];
                
            }else {
            
                [self.dateTagBtnArray[i] setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
            }
            
        }
    }
    
    [self.arrowPlanDateView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.dateTagBtnArray[index]).offset(-1);
        make.bottom.equalTo(self.dateTagBtnArray[index]).offset(1);
        make.left.equalTo(self.dateTagBtnArray[index]).offset(-1);
        make.right.equalTo(self.dateTagBtnArray[index]).offset(1);
        // make.edges.equalTo(self.dateTagBtnArray[index]).offset(UIEdgeInsetsMake(1, 1, 1, 1));
    }];
}

- (UIView *)installDateTagView {

    UIView *superView = [UIView new];
    
    UIView *arrowView = [UIView new];
    self.arrowPlanDateView = arrowView;
    [superView addSubview:arrowView];
    arrowView.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    
    
//    UICollectionViewFlowLayout *layout = [BXGDateTagViewFlowLayout new];
//    UICollectionView *superView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
//    self.dateTagCollecionView = superView;
//    superView.dataSource = self;
//    superView.delegate = self;
//    [superView registerNib:[UINib nibWithNibName:@"BXGStudtyDateTagCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"BXGStudtyDateTagCollectionCell" ];
    
    superView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
    NSInteger count = self.dateArray.count + 1;
    
    NSMutableArray *btnArray = [NSMutableArray new];
    self.dateTagBtnArray = btnArray;
    UIButton *lastBtn;
    for(NSInteger i = 0; i < count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:0];
        [superView addSubview:btn];
        [btnArray addObject:btn];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont bxg_fontRegularWithSize:14];
        [btn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(clickPlanTitle:) forControlEvents:UIControlEventTouchUpInside];
        
        if(!lastBtn) {
        
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.left.offset(1);
                make.top.offset(1);
                make.bottom.offset(-1);
            }];
            
        }else {
        
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(lastBtn.mas_right).offset(1);
                make.top.offset(1);
                make.bottom.offset(-1);
                make.width.equalTo(lastBtn);
            }];
        }
        
        if(i == count -1){
        
            [btn setTitle:@"更多" forState:UIControlStateNormal];
            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
               
                make.right.offset(0);
            }];
        }else {
        
            
            [btn setTitle:[[BXGDateTool share]formaterForshortCN:self.dateArray[i]] forState:UIControlStateNormal];
        }
        
        lastBtn = btn;
    }
    
    
    // 指向今天
    for(NSInteger i = 0; i < self.dateArray.count; i++) {
    
        NSDate *date = self.dateArray[i];
        if([[BXGDateTool share] isToday:date]){
        
            [self arrowDateTag:i];
            break;
        }
    }
    
    
    return superView;
}
- (void)clickPlanTitle:(UIButton *)sender {

    if(sender.tag == self.dateArray.count) {
    
        BXGStudyProCoursePlanDetailVC *vc = [BXGStudyProCoursePlanDetailVC new];
        vc.courseModel = self.viewModel.courseModel;
        [self.navigationController pushViewController:vc animated:true];
        
    }else {
    
        [self arrowDateTag:sender.tag];
        [self.dateDetailCollecionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:false];
    }
}

- (UIView *)installDateDetailView {
    
    UICollectionViewFlowLayout *layout = [BXGDateDetailViewFlowLayout new];
    self.detailFlowLayout = layout;
    UICollectionView *superView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    superView.backgroundColor = [UIColor whiteColor];
    self.dateDetailCollecionView = superView;
    superView.dataSource = self;
    superView.delegate = self;
    superView.backgroundColor = [UIColor colorWithHex:0xF5F5F5 alpha:1];
    // [superView registerNib:[UINib nibWithNibName:@"BXGStudyProCourseCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"BXGStudyProCourseCollectionCell" ];
    [superView registerClass:[BXGStudyProCourseCollectionCell class] forCellWithReuseIdentifier:@"BXGStudyProCourseCollectionCell"];
   
    return superView;
}


#pragma mark - [层级1] CollectionView Delegate & Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    // return self.viewModel.weekDateArray.count;
    return self.dateArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    __weak typeof (self) weakSelf = self;
    if (collectionView == self.dateDetailCollecionView) {
       
        BXGStudyProCourseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BXGStudyProCourseCollectionCell" forIndexPath:indexPath];

        
        cell.viewModel = self.viewModel;
        cell.planDate = self.dateArray[indexPath.row];
        
        cell.didSelectProCoursePlanBlock = ^(BXGProCourseModel *model) {
            
            [[BXGBaiduStatistic share] statisticEventString:jybjxx_button_18 andParameter:nil];
            if(!model){
            
                RWLog(@"参数异常");
                return;
            }
            
            
            if(!self.viewModel || !self.viewModel.courseModel) {
            
            
                RWLog(@"参数异常");
                return;
            }
            
            NSString *pointId = model.charpter_id;
            NSString *sectionId = model.parent_id;
            BXGCourseModel *courseModel = self.viewModel.courseModel;
            BXGCourseOutlineSectionModel *sectionModel = [BXGCourseOutlineSectionModel new];
            sectionModel.idx = sectionId;
            BXGProCoursePlayerContentVC *proContentVC = [[BXGProCoursePlayerContentVC alloc]initWithCourseModel:courseModel andSectionModel:sectionModel];
            // BXGBasePlayerVC *playerVC = [[BXGBasePlayerVC alloc]initWithContentVC:proContentVC];
            BXGBasePlayerVC *playerVC = [[BXGBasePlayerVC alloc] initWithCourseModel:courseModel ContentVC:proContentVC];
            [playerVC autoPlayWithPointId:pointId andVideoId:nil];
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                [weakSelf.navigationController pushViewController:playerVC animated:true];
//            });
//            BXGStudyPlayerRootVC *vc = [[BXGStudyPlayerRootVC alloc]initWithCourseModel:courseModel andPointId:pointId];
            
//            BXGMiniCoursePlayerContentVC *contentVC = [[BXGMiniCoursePlayerContentVC alloc]initWithCourseModel:courseModel];
//            
//            BXGBasePlayerVC *playerVC = [[BXGBasePlayerVC alloc]initWithCourseModel:courseModel ContentVC:contentVC];
            
            playerVC.hidesBottomBarWhenPushed = true;
            [weakSelf.navigationController pushViewController:playerVC animated:true];
            
        };
        
        return cell;
    }
    BXGStudtyDateTagCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BXGStudtyDateTagCollectionCell" forIndexPath:indexPath];
    if(self.dateArray) {
    NSDate *date = self.dateArray[indexPath.row];
    
        cell.dateText = [[BXGDateTool share] formaterForshortCN:date];

    if([[BXGDateTool share] isToday:date]) {
    
        cell.isToday = true;
    }else {
    
        cell.isToday = false;
    }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.dateDetailCollecionView) {
    
        cell.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{
            cell.alpha = 1;
        }];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    if (collectionView == self.dateTagCollecionView) {
        [self.dateDetailCollecionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:false];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == self.dateDetailCollecionView) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:scrollView.contentOffset.x / scrollView.bounds.size.width inSection:0];
        [self arrowDateTag:indexPath.row];
        // [self.dateTagCollecionView reloadData];
        // [self.dateTagCollecionView selectItemAtIndexPath:indexPath animated:true scrollPosition:UICollectionViewScrollPositionLeft];
        
    }

}
- (CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    if(collectionView == self.dateDetailCollecionView) {
        
        return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
    }else {
    
        return CGSizeMake(75, collectionView.bounds.size.height);
    }
    
    
}

#pragma mark Response

- (void)clickMoreBtn {

    RWLog(@"更多按钮被点击");

    // 百度统计
    [[BXGBaiduStatistic share] statisticEventString:xxjhgd_17 andParameter:nil];
    
    BXGStudyProCoursePlanDetailVC *vc = [BXGStudyProCoursePlanDetailVC new];
    vc.courseModel = self.viewModel.courseModel;
    [self.navigationController pushViewController:vc animated:true];
    
    
}
- (void)updateLayout; {
    
    CGPoint offset = self.dateDetailCollecionView.contentOffset;
    [self.dateDetailCollecionView reloadData];
    self.dateDetailCollecionView.contentOffset = offset;

}
@end

