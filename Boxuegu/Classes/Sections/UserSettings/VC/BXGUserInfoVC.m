//
//  BXGUserInfoVC.m
//  Boxuegu
//
//  Created by apple on 2018/1/10.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGUserInfoVC.h"
#import "BXGUserSettingsViewModel.h"
#import "BXGUserPortraitCell.h"
#import "BXGUserBaseInfoModel.h"
#import "BXGUserStudyTargetModel.h"
#import "BXGLocation.h"
#import "BXGUserAccountsModel.h"
//#import "RWContentEditingController.h"
#import "BXGEditNicknameVC.h"
#import "BXGEditAutographVC.h"
#import "BXGEditStudyDirectionVC.h"
#import "BXGEditBindCellphoneVC.h"
#import "BXGEditPasswordVC.h"
#import "BXGRealCertificationVC.h"
#import "BXGUserCertificationVC.h"
#import "BXGEditLocationView.h"
#import "UIView+Pop.h"
#import "BXGWXApiManager.h"
#import "BXGSocialManager.h"
#import "BXGUserBindExistAccountVC.h"
#import "BXGAlbumSelectObj.h"

#define kModifySuccess @"设置成功"
#define kModifyFail @"修改失败,请稍后再试!"
#define kNicknameExistence @"该昵称已存在,请重新输入!"
#define kNicknameBeyondLength @"昵称长度过咯,请重新输入!"

@interface BXGUserInfoVC ()<UITableViewDataSource,
                            UITableViewDelegate,
                            UINavigationControllerDelegate,
                            UIImagePickerControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) BXGUserSettingsViewModel *userSettingVM;
@property (nonatomic, strong) BXGAlbumSelectObj *albumVC;

@end

static NSUInteger kNumberSectionsOfUserInfo = 5;

static NSUInteger kNumberItemsOfBaseInfo = 5;
static NSUInteger kNumberItemsOfStudyInfo = 1;
static NSUInteger kNumberItemsOfThirdBindInfo = 4;

typedef enum : NSUInteger {
    UserInfoSectionBaseInfo = 0,
    UserInfoSectionStudyInfo,
    UserInfoSectionAccountInfo,
    UserInfoSectionThirdBindInfo,
    UserInfoSectionCertifyInfo,
} UserInfoSection;

typedef enum : NSUInteger {
    UserInfoSectionBaseInfoPortraint = 0,
    UserInfoSectionBaseInfoNickname,
    UserInfoSectionBaseInfoSex,
    UserInfoSectionBaseInfoCity,
    UserInfoSectionBaseInfoAutograph,
} UserInfoSectionBaseInfoItem;

typedef enum : NSUInteger {
    UserInfoSectionStudyInfoStudyDirection = 0, //学习方向
} UserInfoSectionStudyInfoItem;

typedef enum : NSUInteger {
    UserInfoSectionAccountInfoCellPhone = 0, //绑定手机
    UserInfoSectionAccountInfoResetPassword, //修改密码
} UserInfoSectionAccountInfoItem;

typedef enum : NSUInteger {
    UserInfoSectionThirdBindInfoWeixin = 0,
    UserInfoSectionThirdBindInfoQQ,
    UserInfoSectionThirdBindInfoSinaWeibo,
    UserInfoSectionThirdBindInfoEMail,
} UserInfoSectionThirdBindInfoItem;

typedef enum : NSUInteger {
    UserInfoSectionCertifyInfoReal = 0, //实名认证
    UserInfoSectionCertifyInfoUser,     //学员认证
} UserInfoSectionCertifyInfoItem;

@implementation BXGUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"个人资料";
    
    _userSettingVM = [BXGUserSettingsViewModel new];
    
    [self installUI];
    [self installPullRefresh];
}

- (void)dealloc {
    RWLog(@"dealloc is execute");
}

- (void)installUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    tableView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
    [self.view addSubview:tableView];
    _tableView = tableView;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.bottom.offset(-kBottomHeight);
    }];
}

-(void)installPullRefresh
{
    __weak typeof(self) weakSelf = self;
    [_tableView bxg_setHeaderRefreshBlock:^{
        [weakSelf refreshUI];
    }];
    // 马上进入刷新状态
    [self.tableView bxg_beginHeaderRefresh];
}

-(void)refreshUI
{
    __weak typeof(self) weakSelf = self;
    [[BXGHUDTool share] showLoadingHUDWithString:nil];
    [self.userSettingVM loadPersonInfoWithFinishBlock:^(BOOL bSuccess) {
        [self.tableView bxg_endHeaderRefresh];
        if(bSuccess) {
            [weakSelf.tableView removeMaskView];
        } else {
            [weakSelf.tableView installMaskView:BXGMaskViewTypeLoadFailed];
        }
        [weakSelf.tableView reloadData];
        [[BXGHUDTool share] closeHUD];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([self.userSettingVM isValidPersonInfoExist]) {
        return kNumberSectionsOfUserInfo;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(![self.userSettingVM isValidPersonInfoExist]) {
        return 0;
    }
    
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = kNumberItemsOfBaseInfo;
            break;
        case 1:
            rows = kNumberItemsOfStudyInfo;
            break;
        case 2: {
            if([self.userSettingVM isShowSettingPassword]) {
                rows = 2;
            } else {
                rows = 1;
            }
        }
            break;
        case 3:
            rows = kNumberItemsOfThirdBindInfo;
            break;
        case 4: {
//            rows = 2;//for testing
            //*##
            if([self.userSettingVM isBindRealCertify] &&
               [self.userSettingVM isBindUserCertify]) {
                rows = 2;
            } else {
                rows = 1;
            }
             //*/
        }
            break;
        default:
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BXGUserPortraitCell *tempCell = nil;
    switch (indexPath.section) {
        case UserInfoSectionBaseInfo:
            if(indexPath.row==UserInfoSectionBaseInfoPortraint) {
                BXGUserPortraitCell *cell = [self getImageCell];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.userSettingVM.userBaseInfoModel.img] placeholderImage:[UIImage imageNamed:@"默认头像"]]; //TODO:图片65*65, 要求显示尺寸50*50
                cell.detailTextLabel.text = nil;
                cell.textLabel.text = @"更换头像";
                tempCell = cell;
            } else if(indexPath.row==UserInfoSectionBaseInfoNickname) {
                BXGUserPortraitCell *cell = [self getTextCell];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.image = nil;
                cell.detailTextLabel.text = self.userSettingVM.userBaseInfoModel.nickName;
                cell.textLabel.text = @"昵称";
                tempCell = cell;
            } else if(indexPath.row==UserInfoSectionBaseInfoSex) {
                BXGUserPortraitCell *cell = [self getTextCell];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.image = nil;
                cell.detailTextLabel.text =  [self.userSettingVM convertSexString];
                cell.textLabel.text = @"性别";
                tempCell = cell;
            } else if(indexPath.row==UserInfoSectionBaseInfoCity) {
                BXGUserPortraitCell *cell = [self getTextCell];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.image = nil;
                cell.detailTextLabel.text = [self.userSettingVM locationName]; //self.userSettingVM.userBaseInfoModel.cityName;
                cell.textLabel.text = @"城市";
                tempCell = cell;
            } else if(indexPath.row==UserInfoSectionBaseInfoAutograph) {
                BXGUserPortraitCell *cell = [self getTextCell];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.image = nil;
                cell.detailTextLabel.text = [self.userSettingVM autograph] ;//self.userSettingVM.userBaseInfoModel.autograph;
                cell.textLabel.text = @"签名";
                tempCell = cell;
            } else {
                NSAssert(FALSE, @"couldn't happen");
            }
            break;
        case UserInfoSectionStudyInfo:
            if(indexPath.row==UserInfoSectionStudyInfoStudyDirection) {
                BXGUserPortraitCell *cell = [self getTextCell];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.image = nil;
                cell.detailTextLabel.text = [_userSettingVM convertStudyDirectionName];
                cell.textLabel.text = @"学习方向";
                tempCell = cell;
            } else {
                NSAssert(FALSE, @"couldn't happen");
            }
            break;
        case UserInfoSectionAccountInfo:
            if(indexPath.row==UserInfoSectionAccountInfoCellPhone) {
                BXGUserPortraitCell *cell = [self getTextCell];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.image = nil;
                BXGUserAccountInfoModel *cellModel = nil;
                [self.userSettingVM isBindAccountByAccountType:BXGAccountTypeCellphone andBindedUserAccountModel:&cellModel];
                cell.detailTextLabel.text =  cellModel ? cellModel.loginAccount : @""; // self.userSettingVM.userBaseInfoModel.mobile;
                cell.textLabel.text = @"绑定手机";
                tempCell = cell;
            } else if(indexPath.row == UserInfoSectionAccountInfoResetPassword) {
                BXGUserPortraitCell *cell = [self getTextCell];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.image = nil;
                cell.detailTextLabel.text = @" ";
                cell.textLabel.text = @"修改密码";
                tempCell = cell;
            } else {
                NSAssert(FALSE, @"couldn't happen");
            }
            break;
        case UserInfoSectionThirdBindInfo:
            if(indexPath.row==UserInfoSectionThirdBindInfoWeixin) {
                BXGUserPortraitCell *cell = [self getTextCell];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.image = nil;
                cell.detailTextLabel.text = [_userSettingVM showBindStatusByAccountType:BXGAccountTypeWeiXin];
                cell.textLabel.text = @"微信";
                tempCell = cell;
            } else if(indexPath.row == UserInfoSectionThirdBindInfoQQ) {
                BXGUserPortraitCell *cell = [self getTextCell];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.image = nil;
                cell.detailTextLabel.text = [_userSettingVM showBindStatusByAccountType:BXGAccountTypeQQ];
                cell.textLabel.text = @"QQ";
                tempCell = cell;
            } else if(indexPath.row==UserInfoSectionThirdBindInfoSinaWeibo) {
                BXGUserPortraitCell *cell = [self getTextCell];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.image = nil;
                cell.detailTextLabel.text = [_userSettingVM showBindStatusByAccountType:BXGAccountTypeSinaWeibo];
                cell.textLabel.text = @"微博";
                tempCell = cell;
            } else if(indexPath.row == UserInfoSectionThirdBindInfoEMail) {
                BXGUserPortraitCell *cell = [self getEMailCell];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.imageView.image = nil;
                cell.detailTextLabel.text = [_userSettingVM showEMail]; 
                cell.textLabel.text = @"邮箱";
                tempCell = cell;
            }  else {
                NSAssert(FALSE, @"couldn't happen");
            }
            break;
        case UserInfoSectionCertifyInfo:
            if(indexPath.row==UserInfoSectionCertifyInfoReal) {
                BXGUserPortraitCell *cell = [self getTextCell];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.image = nil;
                cell.detailTextLabel.text = [_userSettingVM isBindRealCertify] ? @"已认证" : @"未认证";
                cell.textLabel.text = @"实名认证";
                tempCell = cell;
            } else if(indexPath.row == UserInfoSectionCertifyInfoUser) {
                BXGUserPortraitCell *cell = [self getTextCell];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.image = nil;
                cell.detailTextLabel.text = [_userSettingVM isBindUserCertify] ? @"已认证" : @"未认证";
                cell.textLabel.text = @"学员认证";
                tempCell = cell;
            } else {
                NSAssert(FALSE, @"couldn't happen");
            }
            break;
        default:
            break;
    }
    assert(tempCell!=nil);
    return tempCell;
}

#pragma mark UITableViewDelegagte
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case UserInfoSectionBaseInfo: {
            switch (indexPath.row) {
                case UserInfoSectionBaseInfoPortraint: {
                    [self modifyPortraitImage];
                } break;
                case UserInfoSectionBaseInfoNickname: {
                    [self modifyNickname];
                } break;
                case UserInfoSectionBaseInfoSex: {
                    [self modifySex];
                } break;
                case UserInfoSectionBaseInfoCity: {
                    [self modifyCity];
                } break;
                case UserInfoSectionBaseInfoAutograph: {
                    [self modifyAutograph];
                } break;
                default: {
                    NSAssert(FALSE, @"UserInfoSectionBaseInfo didSelectRowAtIndexPath");
                } break;
            }
        }break;
        case UserInfoSectionStudyInfo: {
            switch (indexPath.row) {
                case UserInfoSectionStudyInfoStudyDirection: {
                    [self modifyStudyDirection];
                } break;
                default: {
                    NSAssert(FALSE, @"UserInfoSectionStudyInfo didSelectRowAtIndexPath");
                } break;
            }
        }break;
        case UserInfoSectionAccountInfo: {
            switch (indexPath.row) {
                case UserInfoSectionAccountInfoCellPhone: {
                    [self modifyCellPhone];
                } break;
                case UserInfoSectionAccountInfoResetPassword: {
                    [self modifyPassword];
                } break;
                default: {
                    NSAssert(FALSE, @"UserInfoSectionAccountInfo didSelectRowAtIndexPath");
                } break;
            }
        }break;
        case UserInfoSectionThirdBindInfo: {
            switch (indexPath.row) {
                case UserInfoSectionThirdBindInfoWeixin: {
                    [self modifyWeixin];
                } break;
                case UserInfoSectionThirdBindInfoQQ: {
                    [self modifyQQ];
                } break;
                case UserInfoSectionThirdBindInfoSinaWeibo: {
                    [self modifySinaWeibo];
                } break;
                case UserInfoSectionThirdBindInfoEMail: {
                    [self modifyEMail];
                } break;
                default: {
                    NSAssert(FALSE, @"UserInfoSectionThirdBindInfo didSelectRowAtIndexPath");
                } break;
            }
        }break;
        case UserInfoSectionCertifyInfo: {
            switch (indexPath.row) {
                case UserInfoSectionCertifyInfoReal: {
                    [self lookRealCertify:[_userSettingVM isBindRealCertify]];
                } break;
                case UserInfoSectionCertifyInfoUser: {
                    [self lookUserCertify];
                } break;
                default: {
                    NSAssert(FALSE, @"UserInfoSectionCertifyInfo didSelectRowAtIndexPath");
                } break;
            }
        }break;
            
        default: {
            NSAssert(FALSE, @"FAILT TO EXECUTE didSelectRowAtIndexPath, the section isn't existence");
        }break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 51;
    if(indexPath.section==UserInfoSectionBaseInfo) {
        if(indexPath.row == UserInfoSectionBaseInfoPortraint) {
            height = 74;
        }
    }
    
    return height;
}

#pragma mark 通过cellId获取cell
- (BXGUserPortraitCell*)getImageCell {
    BXGUserPortraitCell *cell = [self.tableView dequeueReusableCellWithIdentifier:idImageCell];
    if(!cell) {
        cell = [[BXGUserPortraitCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idImageCell];
    }
    return cell;
}

- (BXGUserPortraitCell*)getTextCell {
    BXGUserPortraitCell *cell = [self.tableView dequeueReusableCellWithIdentifier:idTextCell];
    if(!cell) {
        cell = [[BXGUserPortraitCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idTextCell];
    }
    return cell;
}

- (BXGUserPortraitCell*)getEMailCell {
    BXGUserPortraitCell *cell = [self.tableView dequeueReusableCellWithIdentifier:idEmailCell];
    if(!cell) {
        cell = [[BXGUserPortraitCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idEmailCell];
    }
    return cell;
}

#pragma mark 修改头像
-(void)modifyPortraitImage {
    __weak typeof (self) weakSelf = self;
    
    _albumVC = [[BXGAlbumSelectObj alloc] initWithVCDelegate:self
                                                 andTitleTip:nil
                                               andMessageTip:nil
                                        andCameraActionTitle:@"拍照"
                                         andAlbumActionTitle:@"本地相册"
                                       andConfirmActionBlock:^(NSData *photoData) {
                                           [[BXGHUDTool share] showLoadingHUDWithString:nil];
                                           [weakSelf.userSettingVM loadUserRequestUpdateHeadPhotoByImageData:photoData
                                                                                                 andFileType:@"1"
                                                                                              andFinishBlock:^(BOOL bSuccess, NSString * _Nullable errorMessage, NSString * _Nullable portraitImageURL) {
                                                                                                  if(bSuccess) {
                                                                                                      if(weakSelf.userSettingVM.userBaseInfoModel) {
                                                                                                          /*
                                                                                                           //TODO:不知道为什么重新赋值,再刷新常常不生效,偶尔生效
                                                                                                          weakSelf.userSettingVM.userBaseInfoModel.img = portraitImageURL;
                                                                                                          [weakSelf.tableView reloadData];
                                                                                                           //*/
                                                                                                          [weakSelf refreshUI];
                                                                                                          [[BXGHUDTool share] showHUDWithString:kModifySuccess];
                                                                                                      }
                                                                                                  } else {
                                                                                                      [[BXGHUDTool share] showHUDWithString:errorMessage];
                                                                                                  }
                                                                                              }];
                                       } andCancelActionBlock:nil];
    [_albumVC launchUI];
}

#pragma mark 修改昵称
- (void)modifyNickname {
    NSAssert(self.userSettingVM.userBaseInfoModel!=nil, @"userBaseInfoModel can't be nil");
    
    __weak typeof(self) weakSelf = self;
    BXGEditNicknameVC *vc = [[BXGEditNicknameVC alloc] initNickname:self.userSettingVM.userBaseInfoModel.nickName];
    vc.finishModifyBlock = ^(NSString *newNickname) {
        if([newNickname isEqualToString:self.userSettingVM.userBaseInfoModel.nickName]) {
            [[BXGHUDTool share] showHUDWithString:kModifySuccess]; //设置与原来的一样
            [weakSelf.navigationController popViewControllerAnimated:YES];
            return ;
        }
        //TODO:#define kNicknameBeyondLength @"昵称长度过咯,请重新输入!"
        [[BXGHUDTool share] showLoadingHUDWithString:nil];
        [weakSelf.userSettingVM loadUserRequestCheckNickname:newNickname andFinishBlock:^(BOOL bSuccess, NSString * _Nullable errorMessage) {
            if(bSuccess) {
                [weakSelf.userSettingVM loadUserRequestUpdateUserNickname:newNickname andAutograph:nil andSexId:nil andProvinceId:nil andCityId:nil andStudyTargetId:nil andFinishBlock:^(BOOL bSuccess, NSString * _Nullable errorMessage) {
                    if(bSuccess) {
                        [[BXGHUDTool share] showHUDWithString:kModifySuccess];
                        weakSelf.userSettingVM.userBaseInfoModel.nickName = newNickname;
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        [weakSelf.tableView reloadData];
                    } else {
                        [[BXGHUDTool share] showHUDWithString:errorMessage]; //kModifyFail
                    }
                }];
            } else {
                [[BXGHUDTool share] showHUDWithString:kNicknameExistence];
            }
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 修改性别
-(void)modifySex {
    __weak typeof (self) weakSelf = self;
    
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:nil
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf doModifySexByNewSexId:[weakSelf.userSettingVM convertSexIdBySexName:@"男"]];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alerVC addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf doModifySexByNewSexId:[weakSelf.userSettingVM convertSexIdBySexName:@"女"]];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    
    [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alerVC animated:YES completion:nil];
    });
}

-(void)doModifySexByNewSexId:(NSString*)newSexId {
    __weak typeof(self) weakSelf = self;
    [[BXGHUDTool share] showLoadingHUDWithString:nil];
    [self.userSettingVM loadUserRequestUpdateUserNickname:nil andAutograph:nil andSexId:newSexId andProvinceId:nil andCityId:nil andStudyTargetId:nil andFinishBlock:^(BOOL bSuccess, NSString * _Nullable errorMessage) {
        if(bSuccess) {
            [[BXGHUDTool share] showHUDWithString:kModifySuccess];
            weakSelf.userSettingVM.userBaseInfoModel.sex = newSexId;
            [weakSelf.tableView reloadData];
        } else {
            [[BXGHUDTool share] showHUDWithString:errorMessage]; //kModifyFail
        }
    }];
}

#pragma mark 修改城市
-(void)modifyCity {
    __weak typeof(self) weakSelf = self;
    BXGEditLocationView *locationView = [[BXGEditLocationView alloc] initCurrentProvince:nil
                                                             andandUserSettingVM:self.userSettingVM
                                                    andFinishModifyLocationBlock:^(BXGLocationProvince* newProvince){

                                                        [[BXGHUDTool share] showLoadingHUDWithString:nil];
                                                        [weakSelf.userSettingVM loadUserRequestUpdateUserNickname:nil andAutograph:nil andSexId:nil andProvinceId:newProvince.idx andCityId:newProvince.cityList[0].idx andStudyTargetId:nil andFinishBlock:^(BOOL bSuccess, NSString * _Nullable errorMessage) {
                                                            if(bSuccess) {
                                                                [[BXGHUDTool share] showHUDWithString:kModifySuccess];
                                                                
                                                                weakSelf.userSettingVM.userBaseInfoModel.city = newProvince.cityList[0].idx;
                                                                weakSelf.userSettingVM.userBaseInfoModel.cityName = newProvince.cityList[0].name;
                                                                weakSelf.userSettingVM.userBaseInfoModel.province = newProvince.idx;
                                                                weakSelf.userSettingVM.userBaseInfoModel.provinceName = newProvince.name;

                                                                [weakSelf.tableView reloadData];
                                                            } else {
                                                                [[BXGHUDTool share] showHUDWithString:errorMessage]; //kModifyFail
                                                            }
                                                        }];

                                                    }];
    [locationView showInWindowAndBgAlpha:-1 andCancelBlock:nil andMaskViewConstraint:nil];
    [locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(-kBottomHeight);
//        make.height.equalTo(@(SCREEN_HEIGHT*0.3));
        make.height.equalTo(@217);
    }];
}

#pragma mark 修改签名
- (void)modifyAutograph {
    __weak typeof(self) weakSelf = self;
    BXGEditAutographVC *vc = [[BXGEditAutographVC alloc] initAutograph:self.userSettingVM.userBaseInfoModel.autograph];
    
    vc.finishModifyAutographBlock = ^(NSString *newAutograph) {
        if(!self.userSettingVM.userBaseInfoModel.autograph ||
            [newAutograph isEqualToString:weakSelf.userSettingVM.userBaseInfoModel.autograph]) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [[BXGHUDTool share] showHUDWithString:kModifySuccess];
            return ;
        }
        [[BXGHUDTool share] showLoadingHUDWithString:nil];
        [weakSelf.userSettingVM loadUserRequestUpdateUserNickname:nil andAutograph:newAutograph andSexId:nil andProvinceId:nil andCityId:nil andStudyTargetId:nil andFinishBlock:^(BOOL bSuccess, NSString * _Nullable errorMessage) {
            if(bSuccess) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [[BXGHUDTool share] showHUDWithString:kModifySuccess];
                weakSelf.userSettingVM.userBaseInfoModel.autograph = newAutograph;
                [weakSelf.tableView reloadData];

            } else {
                [[BXGHUDTool share] showHUDWithString:errorMessage]; //kModifyFail
            }
        }];

    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 修改学习方向
- (void)modifyStudyDirection {
    
    __weak typeof(self) weakSelf = self;
    NSNumber *numberIndex = [self.userSettingVM convertStudyDirectionNumberIndex];
    
    BXGEditStudyDirectionVC *vc = [[BXGEditStudyDirectionVC alloc] initDataSource:self.userSettingVM.userBaseInfoModel.studyTarget
                                                               andCurrentSelIndex:numberIndex
                                               andFinishModifyStudyDirectionBlock:^(BXGUserStudyTargetModel *newStudyDirection) {
                                                   if(!newStudyDirection ||
                                                      
                                                      (!weakSelf.userSettingVM.userBaseInfoModel.target && newStudyDirection.idx==weakSelf.userSettingVM.userBaseInfoModel.target)) {
                                                       
                                                       //修改失败或者与原来的保持不变
                                                       [weakSelf.navigationController popViewControllerAnimated:YES];
                                                       return ;
                                                   }
                                                   
                                                   [[BXGHUDTool share] showLoadingHUDWithString:nil];
                                                   [weakSelf.userSettingVM loadUserRequestUpdateUserNickname:nil
                                                                                                andAutograph:nil
                                                                                                    andSexId:nil
                                                                                               andProvinceId:nil
                                                                                                   andCityId:nil
                                                                                            andStudyTargetId:newStudyDirection.idx
                                                                                              andFinishBlock:^(BOOL bSuccess, NSString * _Nullable errorMessage) {
                                                       if(bSuccess) {
                                                           [weakSelf.navigationController popViewControllerAnimated:YES];
                                                           [[BXGHUDTool share] showHUDWithString:kModifySuccess];
                                                           weakSelf.userSettingVM.userBaseInfoModel.target = newStudyDirection.idx;
                                                           [weakSelf.tableView reloadData];
                                                           
                                                       } else {
                                                           [[BXGHUDTool share] showHUDWithString:errorMessage]; //kModifyFail
                                                       }
                                                   }];
                                                   
                                               }];;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 修改手机号
- (void)modifyCellPhone {
    BXGUserAccountInfoModel *cellphoneAccountInfo = [self.userSettingVM accountInfoByAccountType:BXGAccountTypeCellphone];
    NSAssert(cellphoneAccountInfo!=nil && ![NSString isEmpty:cellphoneAccountInfo.loginAccount], @"modifyCellPhone--cellphone account shouldn't be nil");

    __weak typeof(self) weakSelf = self;
    BXGEditBindCellphoneVC *vc = [[BXGEditBindCellphoneVC alloc] initWithFinishModifyCellphoneBlock:^(NSString *newCellphone, NSString *vertifyCode) {
        NSAssert(newCellphone!=nil, @"newCellphone shouldn't be nil");
        NSAssert(vertifyCode!=nil, @"vertifyCode sholdn't be nil");
        /*
        if([newCellphone isEqualToString:cellphoneAccountInfo.loginAccount]) {
            与原来绑定的手机号是一样的, 忽略
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [[BXGHUDTool share] showHUDWithString:kModifySuccess];
            return ;
        }
        //*/
        
        [[BXGHUDTool share] showLoadingHUDWithString:nil];
        [[BXGUserCenter share] bindUserRequestBindUserNameByUserName:newCellphone andLoginType:@"2" andCode:vertifyCode andFinishBlock:^(BOOL bSuccess, NSString * _Nullable errorMessage) {
            if(bSuccess) {
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [[BXGHUDTool share] showHUDWithString:kModifySuccess];
                cellphoneAccountInfo.loginAccount = newCellphone;
                [weakSelf.tableView reloadData];
            } else {
                [[BXGHUDTool share] showHUDWithString:errorMessage]; //kModifyFail
            }
        }];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 修改密码
- (void)modifyPassword {
    BXGUserAccountInfoModel *cellphoneAccountInfo = [self.userSettingVM accountInfoByAccountType:BXGAccountTypeCellphone];
    NSAssert(cellphoneAccountInfo!=nil && ![NSString isEmpty:cellphoneAccountInfo.loginAccount], @"modifyPassword--cellphone account shouldn't be nil");

     __weak typeof(self) weakSelf = self;
    BXGEditPasswordVC *vc = [[BXGEditPasswordVC alloc] initCellphone:cellphoneAccountInfo.loginAccount andFinishModifyPasswordBlockType:^(NSString *newPassword, NSString *code) {
        NSAssert(newPassword!=nil, @"newPassword shouldn't be nil");
        NSAssert(code!=nil, @"code sholdn't be nil");

        [[BXGHUDTool share] showLoadingHUDWithString:nil];
        [weakSelf.userSettingVM loadUserRequestRestPWDByUserName:cellphoneAccountInfo.loginAccount
                                                     andPassword:newPassword
                                                   andVerifyCode:code
                                                  andFinishBlock:^(BOOL bSuccess, NSString * _Nullable errorMessage) {
            if(bSuccess) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [[BXGHUDTool share] showHUDWithString:kModifySuccess];
            } else {
                [[BXGHUDTool share] showHUDWithString:errorMessage]; //kModifyFail
            }
        }];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 微信号绑定
- (void)modifyWeixin {
    BXGUserAccountInfoModel *bindedAccountInfoModel;
    if([self.userSettingVM isBindAccountByAccountType:BXGAccountTypeWeiXin andBindedUserAccountModel:&bindedAccountInfoModel]) {
        //解绑操作
        [self doUnbindByUserAccountModel:bindedAccountInfoModel];
    } else {
        //绑定操作
        [self doBindAccountType:BXGAccountTypeWeiXin];
    }
}

#pragma mark QQ绑定
- (void)modifyQQ {
    BXGUserAccountInfoModel *bindedAccountInfoModel;
    if([self.userSettingVM isBindAccountByAccountType:BXGAccountTypeQQ andBindedUserAccountModel:&bindedAccountInfoModel]) {
        //解绑操作
        [self doUnbindByUserAccountModel:bindedAccountInfoModel];
    } else {
        //绑定操作
        [self doBindAccountType:BXGAccountTypeQQ];
    }
}

#pragma mark 新浪微博绑定
- (void)modifySinaWeibo {
    BXGUserAccountInfoModel *bindedAccountInfoModel;
    if([self.userSettingVM isBindAccountByAccountType:BXGAccountTypeSinaWeibo andBindedUserAccountModel:&bindedAccountInfoModel]) {
        //解绑操作
        [self doUnbindByUserAccountModel:bindedAccountInfoModel];
    } else {
        //绑定操作
        [self doBindAccountType:BXGAccountTypeSinaWeibo];
    }
}

- (void)doBindAccountType:(BXGAccountType)accountType {
    Weak(weakSelf);
    
    // 提前判断
    BXGSocialPlatformType socialPlatformType = BXGSocialPlatformTypeNone;
    switch (accountType) {
        case BXGAccountTypeWeiXin: {
            if(![BXGWXApiManager isWXAppInstalled]) {
                [[BXGHUDTool share] showHUDWithString:@"未安装微信,请安装后再试"];
                return;
            }
            socialPlatformType = BXGSocialPlatformTypeWeChat;
        }break;
            
        case BXGAccountTypeQQ: {//BXGSocialPlatformTypeQQ: {
            socialPlatformType = BXGSocialPlatformTypeQQ;
        }break;
        case BXGAccountTypeSinaWeibo: {//BXGSocialPlatformTypeWeibo: {
            socialPlatformType = BXGSocialPlatformTypeWeibo;
        }break;
        default:{
            NSString *str = [NSString stringWithFormat:@"accountType=%ld, the account type isn't supported bind", accountType];
            NSAssert(FALSE, str);
        }break;
    }
    
    // 调用授权接口
//    [[BXGHUDTool share] showLoadingHUDWithString:nil];
    [[BXGSocialManager share] getAuthWithUserInfoWithType:socialPlatformType
                                                 Finished:^(BOOL success, NSString *msg, BXGSocialModel *model) 
    {
        [[BXGHUDTool share] closeHUD];
        if(success && model) {
            // 成功,调用绑定接口
            [[BXGHUDTool share] showLoadingHUDWithString:nil];
            [weakSelf.userSettingVM loadUserRequestBindThirdAccountByThirdAccessToken:model.accessToken
                                                                         andThirdType:[NSString stringWithFormat:@"%ld", accountType]
                                                                           andThirdId:model.thirdId
                                                                       andFinishBlock:^(BOOL bSuccess, NSString * _Nullable errorMessage) {
                                                                               if(bSuccess) {
//                                                                                   [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                                   [[BXGHUDTool share] showHUDWithString:kModifySuccess];
                                                                                   [self refreshUI];
                                                                               } else {
                                                                                   [[BXGHUDTool share] showHUDWithString:errorMessage]; //kModifyFail
                                                                               }
                                                                         }];
        } else  {
            [[BXGHUDTool share] showHUDWithString:msg];
        }
    } andReturnBlock:^{
        [[BXGHUDTool share] showLoadingHUDWithString:nil];
    } andCancelBlock:^{
        [[BXGHUDTool share] showHUDWithString:@"授权取消"];
    }];
}

- (void)doUnbindByUserAccountModel:(BXGUserAccountInfoModel*)accountModel {
    Weak(weakSelf);

    BXGAlertController *alertVC = [BXGAlertController confirmWithTitle:nil message:@"解绑后将不能再使用此账号登录博学谷" andConfirmTitle:@"保留" andCancelTitle:@"解绑" confirmHandler:^{
    } cancleHandler:^{
        [[BXGHUDTool share] showLoadingHUDWithString:nil];
        [weakSelf.userSettingVM loadUserRequestUnbindThirdAccountByUserLoginAccount:accountModel.loginAccount
                                                                     andFinishBlock:^(BOOL bSuccess, NSString * _Nullable errorMessage) {
                                                                         if(bSuccess) {
                                                                             //                                                                           [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                             [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                                                                             [[BXGHUDTool share] showHUDWithString:kModifySuccess];
                                                                             accountModel.loginAccount = nil;
                                                                             [weakSelf.tableView reloadData];
                                                                         } else {
                                                                             [[BXGHUDTool share] showHUDWithString:errorMessage]; //kModifyFail
                                                                         }
                                                                     }];
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController presentViewController:alertVC animated:YES completion:nil];
    });
}

#pragma mark EMail绑定
- (void)modifyEMail {
    //do nothing
}

#pragma mark 实名认证
- (void)lookRealCertify:(BOOL)bHaveCetify {
    BXGRealCertificationVC *realCertifyVC = [[BXGRealCertificationVC alloc] initHaveCertify:bHaveCetify
                                                                               andViewModel:self.userSettingVM];
    [self.navigationController pushViewController:realCertifyVC animated:YES];
}

#pragma mark 用户名认证
- (void)lookUserCertify {
    BXGUserCertificationVC *userCertifyVC = [[BXGUserCertificationVC alloc] initUserBaseInfoModel:self.userSettingVM.userBaseInfoModel];
    [self.navigationController pushViewController:userCertifyVC animated:YES];
}

@end
