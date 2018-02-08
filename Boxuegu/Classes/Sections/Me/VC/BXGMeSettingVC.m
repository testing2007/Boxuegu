//
//  BXGMeSettingVC.m
//  Boxuegu
//
//  Created by RW on 2017/6/2.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMeSettingVC.h"
#import "BXGMeAboutVC.h"
#import "BXGMeViewModel.h"
#import "BXGUserLoginVC.h"
#import "UIPushTableViewCell.h"
#import "BXGUserDefaults.h"
#import "BXGUserInfoVC.h"

#pragma mark - UISwitchTableViewCell
@interface UISwitchTableViewCell: UITableViewCell

// public
@property (nonatomic, weak) UISwitch *selectSwitch;
@property (nonatomic, assign) BOOL condition;
@property (nonatomic, copy) NSString *title;

// private
@property (nonatomic,weak) UILabel *cellTitleLabel;
@end

@implementation UISwitchTableViewCell

- (void)setCondition:(BOOL)condition {

    _condition = condition;
    [self.selectSwitch setOn:condition];
}

- (void)setTitle:(NSString *)title {

    _title = title;
    if(title){
        self.cellTitleLabel.text = title;
    }else {
    
        self.cellTitleLabel.text = @"";
    }
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        [self installUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self){
    
        [self installUI];
    }
    return self;
}

- (void)installUI {
 
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UISwitch *selectSwitch = [UISwitch new];
    UILabel *cellTitleLabel = [UILabel new];
    
    [self.contentView addSubview:selectSwitch];
    [self.contentView addSubview:cellTitleLabel];
    
    self.selectSwitch = selectSwitch;
    self.cellTitleLabel = cellTitleLabel;
    
    [selectSwitch sizeToFit];
    selectSwitch.tintColor = [UIColor colorWithHex:0xCCCCCC];
    selectSwitch.onTintColor = [UIColor colorWithHex:0x38ADFF];
    selectSwitch.thumbTintColor = [UIColor colorWithHex:0xffffff];
    selectSwitch.backgroundColor = [UIColor colorWithHex:0xCCCCCC];
    selectSwitch.layer.cornerRadius = selectSwitch.bounds.size.height / 2.0;
    selectSwitch.layer.masksToBounds = true;
    
    [selectSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(0);
    }];

    cellTitleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    cellTitleLabel.textColor = [UIColor colorWithHex:0x333333];
    cellTitleLabel.text = @"";
    cellTitleLabel.textColor = [UIColor blackColor];
    [cellTitleLabel sizeToFit];
    
    [cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
        make.right.equalTo(selectSwitch).offset(-15);
    }];
}
@end

#pragma mark - UIDetailTableViewCell

@interface UIDetailTableViewCell: UITableViewCell

// public
@property (nonatomic, assign) NSString *detail;
@property (nonatomic, copy) NSString *title;

// private
@property (nonatomic,strong) UILabel *cellTitleLabel;
@property (nonatomic,strong) UILabel *cellDetailLabel;
@end

@implementation UIDetailTableViewCell

- (void)setTitle:(NSString *)title {
    
    _title = title;
    if(title){
        self.cellTitleLabel.text = title;
    }else {
        
        self.cellTitleLabel.text = @"";
    }
}

- (void)setDetail:(NSString *)detail {

    _detail = detail;
    if(detail) {
    
        self.cellDetailLabel.text = detail;
    }else {
    
        self.cellDetailLabel.text = @"";
    }
}

- (UILabel *)cellTitleLabel {

    if(!_cellTitleLabel) {
        
        _cellTitleLabel = [UILabel new];
    }
    return  _cellTitleLabel;
}

- (UILabel *)cellDetailLabel {

    if(!_cellDetailLabel) {
        
        _cellDetailLabel = [UILabel new];
    }
    return  _cellDetailLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        [self installUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self){
        
        [self installUI];
    }
    return self;
}

- (void)installUI {
    
    self.cellDetailLabel.font = [UIFont bxg_fontRegularWithSize:15];
    self.cellDetailLabel.textColor = [UIColor colorWithHex:0x999999];
    self.cellDetailLabel.text = @"";
    [self.cellDetailLabel sizeToFit];
    self.cellDetailLabel.textAlignment = NSTextAlignmentRight;
    
    self.cellTitleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    self.cellTitleLabel.text = @"";
    self.cellTitleLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.cellTitleLabel sizeToFit];
    
    
    [self.contentView addSubview:self.cellDetailLabel];
    [self.cellDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.offset(0);
        make.centerY.offset(0);
        make.right.offset(-15);
        
    }];
    
    [self.contentView addSubview:self.cellTitleLabel];
    [self.cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
        make.right.equalTo(self.cellTitleLabel.mas_left).offset(-15);
        make.width.offset([UIScreen mainScreen].bounds.size.width - 70);
        
    }];
//    UIView *spView = [UIView new];
//    spView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
//    [self.contentView addSubview:spView];
//    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.offset(15);
//        make.bottom.right.offset(0);
//        make.height.offset(1);
//    }];

}

@end

@interface UICenterTitleTableViewCell: UITableViewCell

// public
@property (nonatomic, copy) NSString *title;

// private
@property (nonatomic,strong) UILabel *cellTitleLabel;
@end

@implementation UICenterTitleTableViewCell

- (void)setTitle:(NSString *)title {
    
    _title = title;
    if(title){
        self.cellTitleLabel.text = title;
    }else {
        
        self.cellTitleLabel.text = @"";
    }
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        [self installUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self){
        
        [self installUI];
    }
    return self;
}

- (void)installUI {

    UILabel *cellTitleLabel = [UILabel new];
    cellTitleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    cellTitleLabel.textColor = [UIColor colorWithHex:0x333333];
    cellTitleLabel.text = @"";
    cellTitleLabel.textAlignment = NSTextAlignmentCenter;
    [cellTitleLabel sizeToFit];
    [self.contentView addSubview:cellTitleLabel];
    [cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(15);
        make.centerY.offset(0);
        make.width.offset([UIScreen mainScreen].bounds.size.width - 15 - 15);
        make.height.lessThanOrEqualTo(self);
        
    }];
    cellTitleLabel.textColor = [UIColor blackColor];
    self.cellTitleLabel = cellTitleLabel;
    
//    UIView *spView = [UIView new];
//    spView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
//    [self.contentView addSubview:spView];
//    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.offset(15);
//        make.bottom.right.offset(0);
//        make.height.offset(1);
//    }];
}

@end

static NSString *idOfUITableViewCell = @"idForUITableViewCell";
static NSString *idOfUIDetailTableViewCell = @"idOfUIDetailTableViewCell";
static NSString *idOfUICenterTitleTableViewCell = @"idOfUICenterTitleTableViewCell";

#define K_NUMBER_OF_ROW_FOR_SECTION_USER_SETTINGS 1
#define K_NUMBER_OF_ROW_FOR_SECTION_ZERO 2
#define K_NUMBER_OF_ROW_FOR_SECTION_ONE 1
#define K_NUMBER_OF_ROW_FOR_SECTION_TWO 1
#define K_NUMBER_OF_ROW_FOR_SECTION_THREE 1
#define K_NUMBER_OF_SECTION 5 //4

typedef enum : NSUInteger {
    BXGMeSettingMenuSectionUserSettings = 0,
    BXGMeSettingMenuSectionZero,
    BXGMeSettingMenuSectionOne,
    BXGMeSettingMenuSectionTwo,
    BXGMeSettingMenuSectionThree,
} BXGMeSettingMenuSectionType;

typedef enum : NSUInteger {
    BXGMeSettingMenuUserSettings = 0,
} BXGMeSettingMenuSectionUserSettingsType;

typedef enum : NSUInteger {
    BXGMeSettingMenuAllowCellularWatch = 0,
    BXGMeSettingMenuAllowCellularDownload,
    BXGMeSettingMenuAllowPushNotification = -1
} BXGMeSettingMenuSectionZeroType;

typedef enum : NSUInteger {
    BXGMeSettingMenuClearCache = 0,
    BXGMeSettingMenuVersion = -1,
} BXGMeSettingMenuSectionOneType;

typedef enum : NSUInteger {
    BXGMeSettingMenuAbout = 0,
} BXGMeSettingMenuSectionTwoType;

typedef enum : NSUInteger {
    BXGMeSettingMenuLogout = 0,
} BXGMeSettingMenuSectionThreeType;
#pragma mark -
@interface BXGMeSettingVC () <UITableViewDelegate, UITableViewDataSource, BXGNotificationDelegate>
@property (nonatomic, weak) BXGMeViewModel *viewModel;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation BXGMeSettingVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    [self installView];
    
    if(![BXGUserDefaults share].userModel) {
        [self installObservers];
    }
}

-(void)dealloc {
    [self uninstallObservers];
}

#pragma mark - 登录通知
- (void)installObservers
{
    [BXGNotificationTool addObserverForUserLogin:self];
}

- (void)uninstallObservers
{
    [BXGNotificationTool removeObserver:self];
}

- (void)catchUserLoginNotificationWith:(BOOL)isLogin {
    if(isLogin) {
        [self.tableView reloadData];
    }
}

#pragma mark - Getter Setter

- (BXGMeViewModel *)viewModel {

    if(!_viewModel) {
    
        _viewModel = [BXGMeViewModel share];
    }
    return  _viewModel;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.row == BXGMeSettingMenuLogout && indexPath.section == BXGMeSettingMenuSectionThree && ![BXGUserDefaults share].userModel) {
    
        return 0;
    }else {
    
        return 50;
    }
}

#pragma mark - Install View

- (void)installView {

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
    [tableView registerClass:[UISwitchTableViewCell class] forCellReuseIdentifier:idOfUITableViewCell];
    [tableView registerClass:[UIDetailTableViewCell class] forCellReuseIdentifier:idOfUIDetailTableViewCell];
    [tableView registerClass:[UIPushTableViewCell class] forCellReuseIdentifier:idOfUIPushTableViewCell];
    [tableView registerClass:[UICenterTitleTableViewCell class] forCellReuseIdentifier:idOfUICenterTitleTableViewCell];
    
    [tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.bottom.right.offset(0);
        
    }];
    tableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    tableView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
    self.tableView = tableView;
}
#pragma mark - DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return K_NUMBER_OF_SECTION;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section) {
        case BXGMeSettingMenuSectionUserSettings: {
            return K_NUMBER_OF_ROW_FOR_SECTION_USER_SETTINGS;
        }break;
            
        case BXGMeSettingMenuSectionZero:{
        
            return K_NUMBER_OF_ROW_FOR_SECTION_ZERO;
        }break;
            
        case BXGMeSettingMenuSectionOne:{
            return K_NUMBER_OF_ROW_FOR_SECTION_ONE;
        }break;
        case BXGMeSettingMenuSectionTwo:{
            return K_NUMBER_OF_ROW_FOR_SECTION_TWO;
        }break;
        case BXGMeSettingMenuSectionThree:{
            return K_NUMBER_OF_ROW_FOR_SECTION_THREE;
        }break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    
    switch (indexPath.section) {
        case BXGMeSettingMenuSectionUserSettings:{
            switch (indexPath.row) {
                case BXGMeSettingMenuUserSettings:{
                    UIPushTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idOfUIPushTableViewCell forIndexPath:indexPath];
                    cell.title = @"个人设置";
                    return cell;
                    
                }break;
                default:{}break;
            }
        }break;

        case BXGMeSettingMenuSectionZero:{
            
            // return K_NUMBER_OF_ROW_FOR_SECTION_ZERO;
            switch (indexPath.row) {
                case BXGMeSettingMenuAllowCellularWatch:{
                    UISwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idOfUITableViewCell forIndexPath:indexPath];
                    cell.title = @"允许使用3G/4G网络观看视频";
                    cell.condition = [BXGUserDefaults share].isAllowCellularWatch;
                    [cell.selectSwitch addTarget:self action:@selector(operationForAllowCellularWatch:) forControlEvents:UIControlEventValueChanged];
                    return cell;
                    // cell.textLabel.text = @"允许使用3G/4G网络观看视频";
                    //[self operationForAllowCellularWatch];
                }break;
                case BXGMeSettingMenuAllowCellularDownload:{
                    UISwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idOfUITableViewCell forIndexPath:indexPath];
                    cell.title = @"允许使用3G/4G网络下载视频";
                    cell.condition = [BXGUserDefaults share].isAllowCellularDownload;
                    [cell.selectSwitch addTarget:self action:@selector(operationForAllowCellularDownload:) forControlEvents:UIControlEventValueChanged];
                    return cell;
                    
                }break;
                case BXGMeSettingMenuAllowPushNotification:{
                    UISwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idOfUITableViewCell forIndexPath:indexPath];
                    cell.title = @"允许推送消息";
                    cell.condition = [BXGUserDefaults share].isAllowPushNotification;
                    [cell.selectSwitch addTarget:self action:@selector(operationForAllowPushNotification:) forControlEvents:UIControlEventValueChanged];
                    
                    cell.selectSwitch.enabled = false;
                    return cell;
                    
                }break;
                default:
                    break;
            }
        }break;
            
        case BXGMeSettingMenuSectionOne:{
            
            switch (indexPath.row) {
                case BXGMeSettingMenuClearCache:{
                    UIDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idOfUIDetailTableViewCell forIndexPath:indexPath];
                    cell.title = @"清理缓存";
                    cell.detail = @"0MB";
                    [self.viewModel loadCacheSize:^(double cacheSize) {
                    
                        cell.detail = [NSString stringWithFormat:@"%.2lf MB",cacheSize];
                    }];
                    return cell;
                }break;
                case BXGMeSettingMenuVersion:{
                    
                    cell.textLabel.text = @"版本号";
                    return cell;
                }break;
                default:
                    break;
            }
        }break;
        case BXGMeSettingMenuSectionTwo:{
            switch (indexPath.row) {
                case BXGMeSettingMenuAbout:{
                    UIPushTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idOfUIPushTableViewCell forIndexPath:indexPath];
                    cell.title = @"关于";
                    return cell;
                    
                }break;
                default:{}break;
            }
        }break;
        case BXGMeSettingMenuSectionThree:{
            switch (indexPath.row) {
                case BXGMeSettingMenuLogout:{
                    
                    UICenterTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idOfUICenterTitleTableViewCell forIndexPath:indexPath];
                    cell.title = @"退出登录";
                    return cell;
                }break;
                default:{}break;
            }
        }break;
            
        default:{}break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case BXGMeSettingMenuSectionUserSettings: {
            switch (indexPath.row) {
                case BXGMeSettingMenuUserSettings: {
                    BXGUserInfoVC *vc = [BXGUserInfoVC new];
                    [self.navigationController pushViewController:vc animated:YES needLogin:YES];
                }break;
                default:
                    break;
            }
        }break;
            
            
        case BXGMeSettingMenuSectionZero:{
            
            // return K_NUMBER_OF_ROW_FOR_SECTION_ZERO;
            switch (indexPath.row) {
                case BXGMeSettingMenuAllowCellularWatch:{
                    
                    //[self operationForAllowCellularWatch];
                    
                }break;
                case BXGMeSettingMenuAllowCellularDownload:{
                    
                    //[self operationForAllowCellularDownload];
                }break;
                case BXGMeSettingMenuAllowPushNotification:{
                    
                    //[self operationForAllowPushNotification];
                }break;
                default:
                    break;
            }
        }break;
            
        case BXGMeSettingMenuSectionOne:{
            
            switch (indexPath.row) {
                case BXGMeSettingMenuClearCache:{
                    
                    [self operationForClearCache];
                }break;
                case BXGMeSettingMenuVersion:{
                    
                    [self operationForVersion];
                }break;
                default:
                    break;
            }
        }break;
        case BXGMeSettingMenuSectionTwo:{
            switch (indexPath.row) {
                case BXGMeSettingMenuAbout:{
                    
                    [self operationForAbout];
                    
                }break;
                default:{}break;
            }
        }break;
        case BXGMeSettingMenuSectionThree:{
            switch (indexPath.row) {
                case BXGMeSettingMenuLogout:{
                    
                    
                    [self operationForLogout];
                }break;
                default:{}break;
            }
        }break;
            
        default:{}break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:true];


}

//@property (nonatomic, assign) BOOL isAllowCellularWatch;
//
///// 允许使用3G/4G网络下载视频
//@property (nonatomic, assign) BOOL isAllowCellularDownload;
//
///// 允许推送消息
//@property (nonatomic, assign) BOOL isAllowPushNotification;


#pragma mark - Response

- (void)operationForAllowCellularWatch:(UISwitch *)sender{

    if(sender.isOn){
        // 允许
        [BXGUserDefaults share].isAllowCellularWatch = true;
    }else{
    
        [BXGUserDefaults share].isAllowCellularWatch = false;
        // 不允许
    }
    RWLog(@"蜂窝网允许观看视频");
}

- (void)operationForAllowCellularDownload:(UISwitch *)sender{
    
    if(sender.isOn){
        // 允许
        [BXGUserDefaults share].isAllowCellularDownload = true;
    }else{
        
        [BXGUserDefaults share].isAllowCellularDownload = false;
        // 不允许
    }
    RWLog(@"蜂窝网允许下载视频");
}

- (void)operationForAllowPushNotification:(UISwitch *)sender{
    
    if(sender.isOn){
        // 允许
        [BXGUserDefaults share].isAllowPushNotification = true;
    }else{
        
        // 不允许
        [BXGUserDefaults share].isAllowPushNotification = false;
    }
    RWLog(@"允许推送");
}
- (void)operationForAbout{
    
    BXGMeAboutVC *aboutVC = [BXGMeAboutVC new];
    [self.navigationController pushViewController:aboutVC animated:true];
}

- (void)operationForVersion{
    
    RWLog(@"版本");
}

- (void)updateData{

    [self.tableView reloadData];
}

// 响应登出按钮
- (void)operationForLogout {
    
    __weak typeof (self) weakSelf = self;
    UIViewController *vc = [BXGUserLoginVC new];
    vc.view.backgroundColor = [UIColor whiteColor];
    BXGBaseNaviController *nav = [[BXGBaseNaviController alloc] initWithRootViewController:vc];
    BXGAlertController *alertVc = [BXGAlertController confirmWithTitle:@"确定要退出博学谷么?" message:nil handler:^{
        [weakSelf.viewModel operationLogout];
        [weakSelf.navigationController.topViewController presentViewController:nav animated:true completion:^{
        
            [weakSelf.navigationController popToRootViewControllerAnimated:false];
        }];
        
    }];
    
    [self presentViewController:alertVc animated:true completion:nil];
}
// 响应清除缓存按钮
- (void)operationForClearCache {
    
    // 1.进行清理缓存操作
    __weak typeof (self) weakSelf = self;
    
    BXGAlertController *vc = [BXGAlertController confirmWithTitle:@"确定清除缓存么?" message:nil handler:^{
        [weakSelf.viewModel operationClearImageCaches];
        [weakSelf updateData];
    }];
    
    [self presentViewController:vc animated:true completion:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

// 头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 9;
}

// 脚视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
@end
