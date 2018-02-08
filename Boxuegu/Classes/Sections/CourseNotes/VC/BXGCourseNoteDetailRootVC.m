//
//  BXGCourseNoteDetailRootVC.m
//  Boxuegu
//
//  Created by apple on 2017/8/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseNoteDetailRootVC.h"
#import "BXGAllNotesVC.h"
#import "BXGMeNotesVC.h"
#import "BXGCollectNoteVC.h"
#import "RWTab.h"


@interface BXGCourseNoteDetailRootVC ()
@property(nonatomic, weak) BXGAllNotesVC *vc1;
@property(nonatomic, weak) BXGMeNotesVC *vc2;
@property(nonatomic, weak) BXGCollectNoteVC *vc3;
@end

@implementation BXGCourseNoteDetailRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _courseName;
    
    self.pageName = @"课程笔记列表页";
    
    BXGAllNotesVC *vc1 = [[BXGAllNotesVC alloc] initWithCourseId:self.courseId];
    _vc1 = vc1;
    BXGMeNotesVC *vc2 = [[BXGMeNotesVC alloc] initWithCourseId:self.courseId];
    _vc2 = vc2;
    BXGCollectNoteVC *vc3 = [[BXGCollectNoteVC alloc] initWithCourseId:self.courseId];
    _vc3 = vc3;
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
    [self addChildViewController:vc3];
    RWTab *superView = [[RWTab alloc]initWithDetailViewArrary:@[vc1.view,vc2.view,vc3.view]
                                                 andTitleArray:@[@"全部笔记", @"我的笔记", @"我的收藏"]
                                                      andCount:3];
//    superView.delegate = self;
    superView.onChangeActionBlock = ^(RWTab *tab) {
        if(tab.selectedSegmentIndex == 0) {
    
            [[BXGBaiduStatistic share] statisticEventString:qbbj andParameter:nil];
        }else if (tab.selectedSegmentIndex == 1) {
            
            [[BXGBaiduStatistic share] statisticEventString:wdbj andParameter:nil];
        }else {
            
            [[BXGBaiduStatistic share] statisticEventString:scbj andParameter:nil];
        }
    };
    
    [self.view addSubview:superView];
    [superView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.right.bottom.offset(0);
    }];
}

-(void)dealloc
{
    NSLog(@"BXGCourseNoteDetailRootVC dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
