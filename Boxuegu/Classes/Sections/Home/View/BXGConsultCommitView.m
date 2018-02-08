//
//  BXGConsultCommitView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGConsultCommitView.h"
#import "BXGInputItemTFCell.h"
#import "UIView+Extension.h"
#import "BXGConsultCommitViewModel.h"

static NSString *cellId = @"BXGInputItemTFCell";
@interface BXGConsultCommitView() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *offsetView;
@property (nonatomic, strong) BXGConsultCommitViewModel *viewModel;

@property (nonatomic, strong) NSString *telString;
@property (nonatomic, weak) UILabel *bottomSectionTitleLb;
@property (nonatomic, weak) UIButton *bottomSectionTitleContentBtn;

@property (nonatomic, weak) UITextField *nameTF;
@property (nonatomic, weak) UITextField *mobileTF;
@property (nonatomic, weak) UITextField *qqTF;

@end
@implementation BXGConsultCommitView

#pragma mark - Interface

- (instancetype)initWithViewModel:(BXGConsultCommitViewModel *)viewModel; {
    self = [super init];
    if(self) {
        self.viewModel = viewModel;
        // install notification
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
        [self installUI];
        [self loadData];
    }
    return self;
}

#pragma mark - Getter Setter

- (void)setTelString:(NSString *)telString {
    _telString = telString;
    if(telString) {
        [self.bottomSectionTitleContentBtn setTitle:telString forState:UIControlStateNormal];
    }else {
        [self.bottomSectionTitleContentBtn setTitle:@"" forState:UIControlStateNormal];
    }
}

#pragma mark - UI

- (void)installUI {

    // 偏移量View
    UIView *offsetView = [UIView new];
    [self addSubview:offsetView];

    [offsetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(0);
    }];
    [offsetView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    self.offsetView = offsetView;

    // ****** Header View
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 55)];
    [self addSubview:headerView];
    
    UIView *bottomSectionView = [UIView new];
    [headerView addSubview:bottomSectionView];
    UIView *topSectionView = [UIView new];
    [headerView addSubview:topSectionView];
    // top
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    UILabel *topSectionTitle = [UILabel new];
    UIView *topSpView = [UIView new];
    
    [topSectionView addSubview:cancleBtn];
    [topSectionView addSubview:commitBtn];
    [topSectionView addSubview:topSectionTitle];
    [topSectionView addSubview:topSpView];
    
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancleBtn.tintColor = [UIColor colorWithHex:0x666666];
    cancleBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:18];
    
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    commitBtn.tintColor = [UIColor colorWithHex:0x38ADFF];
    commitBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:18];
    
    topSectionTitle.text = @"咨询课程";
    topSectionTitle.font = [UIFont bxg_fontRegularWithSize:18];
    topSectionTitle.textColor = [UIColor colorWithHex:0x333333];
    
    topSpView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    // Layout
    [cancleBtn sizeToFit];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    
    [commitBtn sizeToFit];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(0);
    }];
    
    [topSectionTitle sizeToFit];
    [topSectionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(0);
    }];
    
    [topSpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.offset(1);
    }];
    UITableView *tableView = [UITableView new];
    [self addSubview:tableView];
    [topSectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
    }];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.equalTo(tableView.mas_top);
        make.height.offset(55 + 73);
        make.top.greaterThanOrEqualTo(self).offset(20);
    }];
    headerView.backgroundColor = [UIColor whiteColor];
    
    // bottom
    UIView *bottomSectionTitleView = [UIView new];
    UILabel *bottomSectionTitleLb = [UILabel new];
    UILabel *bottomSectionSubTagLb = [UILabel new];
    UIButton *bottomSectionTitleContentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    bottomSectionSubTagLb.font = [UIFont bxg_fontRegularWithSize:13];
    bottomSectionSubTagLb.textColor = [UIColor colorWithHex:0x999999];
    bottomSectionSubTagLb.text = @"工作时间：09:00-20:00";
    
    UIView *bottomSpView = [UIView new];
    [bottomSectionView addSubview:bottomSectionTitleView];
    [bottomSectionView addSubview:bottomSpView];
    [bottomSectionView addSubview:bottomSectionSubTagLb];
    
    [bottomSectionTitleView addSubview:bottomSectionTitleLb];
    [bottomSectionTitleView addSubview:bottomSectionTitleContentBtn];
    [bottomSectionTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.right.equalTo(bottomSectionTitleContentBtn.mas_left).offset(-5);
    }];
    [bottomSectionTitleLb setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [bottomSectionTitleLb setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [bottomSectionTitleContentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.offset(0);
    }];
    
    [bottomSectionSubTagLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-9);
        make.centerX.offset(0);
    }];
    
    [bottomSectionTitleContentBtn addTarget:self action:@selector(onClickTelBtn:) forControlEvents:UIControlEventTouchUpInside];
    bottomSectionTitleContentBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:18];
    self.bottomSectionTitleContentBtn = bottomSectionTitleContentBtn;
    
    bottomSectionTitleLb.text = @"咨询电话:";
    bottomSectionTitleLb.font = [UIFont bxg_fontRegularWithSize:18];
    bottomSectionTitleLb.textColor = [UIColor colorWithHex:0x333333];
    bottomSpView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    [bottomSectionTitleView sizeToFit];
    [bottomSectionTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(9);
    }];
    
    [bottomSpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.offset(1);
    }];
    [bottomSectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topSectionView.mas_bottom);
        make.left.right.offset(0);
        make.bottom.offset(0);
        make.height.offset(73);
        
    }];
    [tableView registerNib:[UINib nibWithNibName:@"BXGInputItemTFCell" bundle:nil] forCellReuseIdentifier:cellId];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // footer view
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 60)];
    [self addSubview:footerView];
    
    UILabel *footerContentLb = [UILabel new];
    [footerView addSubview:footerContentLb];
    footerContentLb.numberOfLines = 0;
    footerContentLb.font = [UIFont bxg_fontRegularWithSize:14];
    footerContentLb.textColor = [UIColor colorWithHex:0x666666];
    footerContentLb.text = @"您也可以留下您的联系方式，稍后有博学谷老师与您联系";
    
    [footerContentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.centerY.offset(0);
    }];
    tableView.tableFooterView = footerView;
//    tableView.allowsSelection = false;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
     [tableView addGestureRecognizer:tap];
//    [self addGestureRecognizer:tap];

    self.tableView = tableView;
    
    
    [cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClickTelBtn:(UIButton *)btn {
    // 弹出选择 复制 or 打电话
    [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoProCourseEventTypePhoneNumber andLabel:nil];
    if(self.telString.length > 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.telString message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *callAction = [UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.telString];
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"复制文本" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:self.telString];
        }];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:callAction];
        [alert addAction:copyAction];
        [alert addAction:cancleAction];
        [self.findOwnerVC presentViewController:alert animated:true completion:nil];
    }
}

- (void)keyboardShow:(NSNotification *)noti {

    NSValue *nsrect = noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect cgrect = nsrect.CGRectValue;
    [self.offsetView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(cgrect.size.height);
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)keyboardHide:(NSNotification *)noti {
    [self.offsetView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0);
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)loadData {
    // 电话
    Weak(weakSelf);
    [self.viewModel loadConsultTelWithFinished:^(NSString *telString, NSString *msg) {
        weakSelf.telString = telString;
    }];    // 用户信息
    
    [self.viewModel loadApplyInfoWithFinished:^(BOOL succeed, NSString *msg) {
        
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        
        make.bottom.equalTo(self.offsetView.mas_top);
        make.height.lessThanOrEqualTo(@(self.tableView.contentSize.height));
    }];
    [self.tableView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

- (void)tapView:(UITapGestureRecognizer *)tap {
    [self endEditing:true];
}

#pragma mark - TableView DataSource Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BXGInputItemTFCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];

    switch (indexPath.row) {
        case 0:{
            cell.cellTitleLabel.text = @"姓名:";
            cell.cellContentTF.placeholder = @"请输入您的真实姓名";
            self.nameTF = cell.cellContentTF;
        }break;
        case 1:{
            cell.cellTitleLabel.text = @"手机:";
            self.mobileTF = cell.cellContentTF;
            cell.cellContentTF.placeholder = @"请输入您的联系电话";
            cell.cellContentTF.keyboardType = UIKeyboardTypeNumberPad;
        }break;
        case 2:{
            cell.cellTitleLabel.text = @"QQ :";
            cell.cellContentTF.placeholder = @"请输入您的QQ";
            self.qqTF = cell.cellContentTF;
            cell.cellContentTF.keyboardType = UIKeyboardTypeNumberPad;
        }break;
        default:
            break;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

#pragma mark - Action

- (void)commit; {
    
    [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoProCourseEventTypeCommitConsult andLabel:nil];
    
    if(self.nameTF.text.length <= 0){
        [[BXGHUDTool share] showHUDWithString:@"请填写您的姓名"];
        return;
    }
    
    if(self.nameTF.text.length >= 20){
        [[BXGHUDTool share] showHUDWithString:@"请填写正确的姓名"];
        return;
    }
    
    // TODO: 真实姓名不能使用emoj
    if([BXGVerifyTool containsEmoji:self.nameTF.text]) {
        [[BXGHUDTool share] showHUDWithString:@"姓名中不能包含特殊符号"];
        return;
    }
    
    if(self.mobileTF.text.length <= 0){
        [[BXGHUDTool share] showHUDWithString:@"请填写手机号码"];
        return;
    }
    // TODO: 校验手机号
    if(![BXGVerifyTool verifyPhoneNumber:self.mobileTF.text]) {
        [[BXGHUDTool share] showHUDWithString:@"请填写正确的手机号码"];
        return;
    }
    
    if(self.qqTF.text.length <= 0){
        [[BXGHUDTool share] showHUDWithString:@"请填写QQ号码"];
        return;
    }
    
    // TODO: 校验QQ号
    if(![BXGVerifyTool verifyQQ:self.qqTF.text]) {
        [[BXGHUDTool share] showHUDWithString:@"请填写正确的QQ号码"];
        return;
    }
    
    [[BXGHUDTool share] showLoadingHUDWithString:nil];
    [self.viewModel postConsultCollectRecordWithName:self.nameTF.text andWechat:nil andQQ:self.qqTF.text andMobile:self.mobileTF.text Finished:^(BOOL succeed, NSString *msg) {
        if(succeed) {
            [[BXGHUDTool share] showHUDWithString:@"提交成功"];
            [self.findOwnerVC dismissViewControllerAnimated:true completion:nil];
        }else {
            [[BXGHUDTool share] showHUDWithString:msg];
        }
    }];
}

- (void)cancle {
    [[BXGBaiduStatistic share] statisticEventString:kBXGStatCourseInfoProCourseEventTypeCancleConsult andLabel:nil];
    UIViewController *vc = self.findOwnerVC;
    if(vc){
        [vc dismissViewControllerAnimated:true completion:nil];
    }
}

@end
