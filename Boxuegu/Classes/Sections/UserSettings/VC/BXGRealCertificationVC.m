//
//  BXGRealCertificationVC.m
//  Boxuegu
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGRealCertificationVC.h"
#import "BXGRealCertificationCell.h"
#import "BXGRealUncertificationCell.h"
#import "BXGUserSettingsViewModel.h"

static NSString *BXGRealCertificationCellId = @"BXGRealCertificationCell";
static NSString *BXGRealUncertificationCellId = @"BXGRealUncertificationCell";

@interface BXGRealCertificationVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) BOOL bCertify;
@property (nonatomic, weak) BXGUserSettingsViewModel *userSettingVM;

@end

@implementation BXGRealCertificationVC

- (instancetype)initHaveCertify:(BOOL)bCertify
           andViewModel:(BXGUserSettingsViewModel*)userSettingVM {
    self = [super init];
    if(self) {
        _bCertify = bCertify;
//        _userBaseInfoModel = userBaseInfoModel;
        _userSettingVM = userSettingVM;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"实名认证";
    
    [self installUI];
    [self registerUI];
}

- (void)installUI {
    self.view.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    
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
    if(_bCertify) {
        tableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    } else {
        tableView.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    }
    
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
    if(_bCertify) {
        [self.tableView registerNib:[UINib nibWithNibName:@"BXGRealCertificationCell" bundle:nil] forCellReuseIdentifier:BXGRealCertificationCellId];
    } else {
        [self.tableView registerNib:[UINib nibWithNibName:@"BXGRealUncertificationCell" bundle:nil] forCellReuseIdentifier:BXGRealUncertificationCellId];
    }
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
//    NSInteger numberOfItems = 0;
//    if(_bCertify) {
//        numberOfItems = 1;
//    } else {
//
//    }
//    return numberOfItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *retCell = nil;
    if(_bCertify) {
        BXGRealCertificationCell *cell = [tableView dequeueReusableCellWithIdentifier:BXGRealCertificationCellId
                                                                         forIndexPath:indexPath];
        [cell setRealName:self.userSettingVM.userBaseInfoModel.realName
                   andSex:[self.userSettingVM convertSexString]
             andCellphone:self.userSettingVM.userBaseInfoModel.mobile
       andCertificationId:self.userSettingVM.userBaseInfoModel.idCardNo
                 andEMail:self.userSettingVM.userBaseInfoModel.email
                    andQQ:self.userSettingVM.userBaseInfoModel.qq
              andAcademic:self.userSettingVM.userBaseInfoModel.educationName
        andGraduateSchool:self.userSettingVM.userBaseInfoModel.schoolName
               andSpecial:self.userSettingVM.userBaseInfoModel.majorName];
        retCell = cell;
    } else {
        BXGRealUncertificationCell *cell = [tableView dequeueReusableCellWithIdentifier:BXGRealUncertificationCellId
                                                                           forIndexPath:indexPath];
        retCell = cell;
    }

    return retCell;
}

#pragma mark UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//        return 1000;
//}

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
