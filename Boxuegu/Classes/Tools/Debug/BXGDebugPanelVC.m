//
//  BXGDebugPanelVC.m
//  Boxuegu
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGDebugPanelVC.h"
#import "BXGLogMonitor.h"

@interface BXGDebugPanelVC ()
@property (weak, nonatomic) IBOutlet UILabel *networkLabel;
@property (weak, nonatomic) IBOutlet UISwitch *networkLogSwitch;
@property (weak, nonatomic) IBOutlet UITextView *logTxtView;
@property (weak, nonatomic) IBOutlet UITextField *limitTxtField;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@end

@implementation BXGDebugPanelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"调试";
    
    [self installUI];
    
    _limitTxtField.placeholder = [NSString stringWithFormat:@"请输入限制数, 默认值为%ld", [BXGLogMonitor share].maxLimits];
    _limitTxtField.adjustsFontSizeToFitWidth = YES;
    _limitTxtField.clearsOnBeginEditing = YES;
    _limitTxtField.keyboardType = UIKeyboardTypeNumberPad;
    
    _logTxtView.editable = NO;
    _networkLogSwitch.on = [BXGLogMonitor share].bEnableLog;
}

- (void)installUI {
    [_networkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(K_NAVIGATION_BAR_OFFSET+20);
        make.left.offset(15);
        make.right.offset(-15);
    }];
    [_networkLogSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(_networkLabel.mas_centerY);
    }];

    [_limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_networkLabel.mas_left);
        make.top.equalTo(_networkLabel.mas_bottom).offset(10);
    }];
    [_limitTxtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_limitLabel.mas_right).offset(15);
        make.centerY.equalTo(_limitLabel.mas_centerY);
    }];
    [_clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_networkLogSwitch.mas_right);
        make.centerY.equalTo(_limitTxtField.mas_centerY);
    }];
    [_clearBtn sizeToFit];
    
    _logTxtView.backgroundColor = [UIColor blackColor];
    _logTxtView.textColor = [UIColor whiteColor];
    [_logTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_limitLabel.mas_bottom).offset(10);
        make.right.equalTo(_networkLogSwitch.mas_right);
        make.left.equalTo(_networkLabel.mas_left);
        make.height.equalTo(@300);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_networkLogSwitch.enabled) {
        _logTxtView.text = [BXGLogMonitor share].logInfo;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onEnableNetworkLog:(id)sender {
    UISwitch *switchCtl = (UISwitch*)sender;
    _networkLogSwitch.on = !switchCtl.on;
    [[BXGLogMonitor share] setEnableLog:_networkLogSwitch.on];
    
    if(_networkLogSwitch.on) {
        _limitTxtField.enabled = YES;
    } else {
        _limitTxtField.enabled = NO;
    }
    
}
- (IBAction)onClear:(id)sender {
    [[BXGLogMonitor share] clear];
    _logTxtView.text = @"";
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
