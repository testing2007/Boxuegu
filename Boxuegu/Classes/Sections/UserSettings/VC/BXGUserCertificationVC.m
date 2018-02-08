//
//  BXGUserCertificationVC.m
//  Boxuegu
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGUserCertificationVC.h"
#import "BXGUserCertificationCell.h"
#import "BXGUserSettingsViewModel.h"

static NSString *BXGUserCertificationCellId = @"BXGUserCertificationCell";

@interface BXGUserCertificationVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) BXGUserBaseInfoModel *userBaseInfoModel;

@end

@implementation BXGUserCertificationVC

- (instancetype)initUserBaseInfoModel:(BXGUserBaseInfoModel*)userBaseInfoModel {
    self = [super init];
    if(self) {
        _userBaseInfoModel = userBaseInfoModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"学员认证";
    
    [self installUI];
    [self registerUI];
}

- (void)installUI {
    self.view.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
    UIView *spView = [UIView new];
    spView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [self.view addSubview:spView];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.height.equalTo(@9);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    tableView.estimatedRowHeight = 200;
    tableView.rowHeight = UITableViewAutomaticDimension;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    [self.view addSubview:tableView];
    _tableView = tableView;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(spView.mas_bottom).offset(0);
        make.bottom.offset(-kBottomHeight);
    }];
}

- (void)registerUI {
     [self.tableView registerNib:[UINib nibWithNibName:@"BXGUserCertificationCell" bundle:nil] forCellReuseIdentifier:BXGUserCertificationCellId];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        BXGUserCertificationCell *cell = [tableView dequeueReusableCellWithIdentifier:BXGUserCertificationCellId
                                                                         forIndexPath:indexPath];
    [cell setSubjectName:self.userBaseInfoModel.oldUserSubjectName
            andClassName:self.userBaseInfoModel.oldUserClassName];
   
    return cell;
}

@end
