//
//  BXGStudyProCoursePlanTableVC.m
//  Boxuegu
//
//  Created by Renying Wu on 2017/6/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGStudyProCoursePlanTableVC.h"
#import "BXGStudyViewModel.h"
#import "BXGProDayPlanModel.h"
#import "BXGStudyProCourseCollectionCell.h"
#import "MOPopWindow.h"
#import "MJRefresh.h"
#import "BXGStudyConstruePopVC.h"
#import "BXGConstrueModel.h"

#import "BXGProCorCell.h"


// 1.1.1

// 蒙版控件
#import "BXGMaskView.h"

#pragma mark - BXGStudyPointCell
@interface BXGStudyPointCell : UITableViewCell
@property (nonatomic, weak) UILabel *cellTitleLabel;
@property (nonatomic, weak) UILabel *cellSubfirstLabel;
@property (nonatomic, weak) UILabel *cellSubSecondLabel;
@property (nonatomic, weak) UIButton *cellBtn;
@property (nonatomic, weak) UIImageView *cellIconImageView;
@end

@implementation BXGStudyPointCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.textLabel.font = [UIFont bxg_fontRegularWithSize:16];
        self.textLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    return self;
    
}


- (void)installUI {
    
    
    UILabel *cellTitleLabel = [UILabel new];
    self.cellTitleLabel = cellTitleLabel;
    [self.contentView addSubview:cellTitleLabel];
    
    
    UILabel *cellSubfirstLabel = [UILabel new];
    self.cellSubfirstLabel = cellSubfirstLabel;
    [self.contentView addSubview:cellSubfirstLabel];
    
    UILabel *cellSubSecondLabel = [UILabel new];
    self.cellSubSecondLabel = cellSubSecondLabel;
    [self.contentView addSubview:cellSubSecondLabel];
    
    UIButton *cellBtn = [UIButton new];
    self.cellBtn = cellBtn;
    [self.contentView addSubview:cellBtn];
    
    UIImageView *cellIconImageView = [UIImageView new];
    [cellIconImageView setImage:[UIImage imageNamed:@"学习中心-列表轴"]];
    
    self.cellIconImageView = cellIconImageView;
    [self.contentView addSubview:cellIconImageView];
    
    [cellIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(-15);
        make.left.offset(15);
        make.bottom.offset(0);
        make.width.offset(12);
    }];
    
}
@end

#pragma mark - BXGStudyProCoursePlanTableVC

@interface BXGStudyProCoursePlanTableVC () <UITableViewDelegate, UITableViewDataSource>

//@property (nonatomic, strong) BXGStudyProCoursePlanTableVC *tableVC;
@property (strong, nonatomic) UITableView *detailTableView;

// @property (weak, nonatomic) IBOutlet UIView *maskView;



@property (nonatomic, strong) BXGProDayPlanModel *dayPlanModel;
@property (weak, nonatomic) NSArray<BXGProCourseModel *> *detailModelArr; // List

@property (strong, nonatomic) NSArray<BXGProCourseModel *> *planDetailModelArray; // List

@end

@implementation BXGStudyProCoursePlanTableVC
@synthesize detailTableView = _detailTableView;

- (instancetype)initWithCourseModel:(BXGCourseModel *)courseModel; {
    
    self = [super init];
    if(self) {
        
        
        if(courseModel) {
            
            _viewModel = [BXGProCoursePlanViewModel viewModelWithModel:courseModel];
        }
    }
    return self;
}

-(void)loadView {
    
    self.view = self.detailTableView;
}

- (void)setPlanDate:(NSDate *)planDate {
    
    __weak typeof (self) weakSelf = self;
    _planDate = planDate;
    [UIView animateWithDuration:0.5 animations:^{
    
        [weakSelf.detailTableView installLoadingMaskView];
    }];
    
    [self loadData];
}

- (UITableView *)detailTableView {
    
    if(!_detailTableView) {
        
        _detailTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _detailTableView.dataSource = self;
        _detailTableView.delegate = self;
    }
    return _detailTableView;
}


- (void)setDetailTableView:(UITableView *)detailTableView {

    _detailTableView = detailTableView;
    _detailTableView.dataSource = self;
    _detailTableView.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.detailTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    Weak(weakSelf);
    [self.detailTableView bxg_setHeaderRefreshBlock:^{
        [weakSelf loadData];
    }];
    
    [self.detailTableView registerClass:[BXGProCorCell class] forCellReuseIdentifier:@"BXGProCorCell"];
    self.detailTableView.backgroundColor = [UIColor whiteColor];
    self.detailTableView.rowHeight = 62 + 15;
    
    self.view.backgroundColor = [UIColor colorWithHex:0xF5F5F5 alpha:1];
    self.detailTableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5 alpha:1];
}

- (void)loadData{
    
    __weak typeof (self) weakSelf = self;
    
    // 1.获取数据
    [self.viewModel loadProDayPlanWithDate:weakSelf.planDate andFinished:^(BOOL success, BXGProDayPlanModel * _Nullable model, NSString * _Nullable message) {
        
        [weakSelf.detailTableView removeMaskView];
        [weakSelf.detailTableView bxg_endHeaderRefresh];
        // 1.数据
        if(model) {
            
            weakSelf.dayPlanModel = model;
        }else {
            
            weakSelf.dayPlanModel = nil;
        }
        
        [weakSelf.detailTableView reloadData];
        
        // 2.添加蒙版
        if(!success){
        
            // 1.添加蒙版 加载失败
            [weakSelf.detailTableView installMaskView:BXGMaskViewTypeLoadFailed];
            return;
        }
        
        if(!model) {
            
            // 添加蒙版:老师正在制定学习计划
            [weakSelf.detailTableView installMaskView:BXGMaskViewTypeNoPlan];
            return;
            
        }
        
        if(model.rest_has && model.chuanjiang_has == false) {
            
            // 显示休息
            [weakSelf.detailTableView installMaskView:BXGMaskViewTypeRest];
            return;
        }
        
        if(!model.list || (model.list.count <= 0 && model.chuanjiang_has == false)) {
            
            // 课程为空
            [weakSelf.detailTableView installMaskView:BXGMaskViewTypeNoPlan];
            return;
        }
        
        
    }];
    
}

#pragma mark - Getter Setter

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.dayPlanModel && self.dayPlanModel.chuanjiang_has){
        return self.dayPlanModel.list.count + 1;
    }
    
    return self.dayPlanModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BXGProCorCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"BXGProCorCell" forIndexPath:indexPath];
    
    NSArray<BXGProCourseModel *> *detailArray = self.dayPlanModel.list;
    if(detailArray.count == indexPath.row)
    {
        cell.pointTitle = @"串讲";
        cell.model = nil;
        
    }else
    {
        cell.pointTitle = detailArray[indexPath.row].charpter_name;
        cell.model = detailArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof (self) weakSelf = self;
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    // 1.是否是串讲
    if(indexPath.row == self.dayPlanModel.list.count) {
     
        // TODO: 执行串讲操作
        [[BXGHUDTool share] showHUDWithString:@"请按时到官网观看串讲直播！"];
        return;
    }
    
    // 2.
    if(weakSelf.didSelectProCoursePlanBlock) {
    
        weakSelf.didSelectProCoursePlanBlock(weakSelf.dayPlanModel.list[indexPath.row]);
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds; {

    return true;
}
@end
