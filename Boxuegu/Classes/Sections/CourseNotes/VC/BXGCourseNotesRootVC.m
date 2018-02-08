//
//  BXGCourseNotesRootVC.m
//  Boxuegu
//
//  Created by apple on 2017/8/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseNotesRootVC.h"
#import "BXGCourseNoteDetailRootVC.h"
#import "BXGCourseNotesViewModel.h"
//#import "BXGCourseNotesRootCell.h"
#import "BXGMaskView.h"
#import "BXGCourseHorizentalCell.h"

@interface BXGCourseNotesRootVC ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) BXGCourseNotesViewModel *courseNotesViewModel;

@property(nonatomic, weak) UITableView *tableView;

@end

@implementation BXGCourseNotesRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"课程笔记";
    self.pageName = @"课程笔记页";
    
    [self installUI];
    
    _courseNotesViewModel = [BXGCourseNotesViewModel new];

    [self installPullRefresh];
}


-(void)installPullRefresh
{
    __weak typeof(self) weakSelf = self;
    [_tableView bxg_setHeaderRefreshBlock:^{
        [weakSelf refreshUI];
    }];
    
    // 马上进入刷新状态
    [_tableView bxg_beginHeaderRefresh];
//    [self.tableView.mj_header beginRefreshing];
}

-(void)refreshUI
{
    //__weak UITableView *tableView = self.tableView;
    __weak typeof(self) weakSelf = self;
    [_courseNotesViewModel requestCourseNotesBlock:^(BOOL succeed, NSString *errorMessage) {
        NSLog(@"errorMessage=%@", errorMessage);
        [weakSelf.tableView bxg_endHeaderRefresh];
//        [weakSelf.tableView.mj_header endRefreshing];
        if(succeed)
        {
            [self.tableView reloadData];
        }
        if(!succeed)
        {
            //网络请求失败
            [weakSelf.tableView installMaskView:BXGMaskViewTypeLoadFailed];
        }
        else
        {
            [weakSelf.tableView removeMaskView];
            if(_courseNotesViewModel.arrCourseNote.count==0)
            {
               [weakSelf.tableView installMaskView:BXGMaskViewTypeNoNote];
            }
        }
    }];
}


-(void)enterCourseDetail
{
    BXGCourseNoteDetailRootVC *detailRootVC = [[BXGCourseNoteDetailRootVC alloc] init];
    [self.navigationController pushViewController:detailRootVC animated:YES];
}

-(void)installUI
{
    UIView *spView = [UIView new];
    [self.view addSubview:spView];
    spView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.right.offset(0);
        make.height.offset(9);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    tableView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
//    tableView.estimatedRowHeight = 10;
//    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.rowHeight = [UIScreen mainScreen].bounds.size.width / 3.2;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spView.mas_bottom).offset(0);
        make.right.bottom.left.offset(0);
    }];

    [tableView registerNib:[UINib nibWithNibName:@"BXGCourseHorizentalCell" bundle:nil] forCellReuseIdentifier:@"BXGCourseHorizentalCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _courseNotesViewModel.arrCourseNote.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXGCourseHorizentalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGCourseHorizentalCell" forIndexPath:indexPath];
    
    BXGCourseNoteModel *courseNoteModel = _courseNotesViewModel.arrCourseNote[indexPath.row];
    [cell setCourseNoteModel:courseNoteModel];
    /*
    [cell.thumbImageView sd_setImageWithURL:[NSURL URLWithString:courseNoteModel.smallImgPath]
                           placeholderImage:[UIImage imageNamed:@"默认加载图"]];
    cell.noteCoureseName.text = courseNoteModel.courseName;
    cell.noteNumberLabel.text = [NSString stringWithFormat:@"笔记%@条",courseNoteModel.notesCount];
    //*/
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXGCourseNoteModel *courseNoteModel = _courseNotesViewModel.arrCourseNote[indexPath.row];
    BXGCourseNoteDetailRootVC *detailRootVC = [BXGCourseNoteDetailRootVC new];
    detailRootVC.courseName = courseNoteModel.courseName;
    detailRootVC.courseId = courseNoteModel.courseId;
    [self.navigationController pushViewController:detailRootVC animated:YES];
}
@end
