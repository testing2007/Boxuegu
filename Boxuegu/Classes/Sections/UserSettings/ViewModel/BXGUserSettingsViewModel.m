//
//  BXGUserSettingsViewModel.m
//  Boxuegu
//
//  Created by apple on 2018/1/10.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGUserSettingsViewModel.h"

@interface BXGUserSettingsViewModel()
@property (nonatomic, strong) BXGLocation *location;
@end

@implementation BXGUserSettingsViewModel

- (void)loadPersonInfoWithFinishBlock:(void (^)(BOOL bSuccess))finishBlock {
    __weak typeof (self) weakSelf = self;
    __block BOOL bRequestSuccess = YES;
    _userBaseInfoModel = nil;
    _userAccountsModel = nil;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建一个信号量为0的信号(红灯)
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        [weakSelf loadAppRequestUserBaseSettingInfoWithFinishBlock:^(BOOL bSuccess, NSString * _Nullable errorMessage, BXGUserBaseInfoModel * _Nullable userBaseInfoModel) {
            if(bSuccess) {
                weakSelf.userBaseInfoModel = userBaseInfoModel;
                bRequestSuccess &= YES;
            } else {
                weakSelf.userBaseInfoModel = nil;
                bRequestSuccess &= NO;
            }
            
            // 使信号的信号量+1，这里的信号量本来为0，+1信号量为1(绿灯)
            dispatch_semaphore_signal(sema);
            RWLog(@"####wait 1");
        }];
        
        // 开启信号等待，设置等待时间为永久，直到信号的信号量大于等于1（绿灯）
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建一个信号量为0的信号(红灯)
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [weakSelf loadAppRequestUserThirdBindInfoWithFinishBlock:^(BOOL bSuccess, NSString * _Nullable errorMessage, BXGUserAccountsModel * _Nullable userAccountsModel) {
            if(bSuccess) {
                weakSelf.userAccountsModel = userAccountsModel;
                bRequestSuccess &= YES;
            } else {
                weakSelf.userAccountsModel = nil;
                bRequestSuccess &= NO;
            }
            // 使信号的信号量+1，这里的信号量本来为0，+1信号量为1(绿灯)
            dispatch_semaphore_signal(sema);
            RWLog(@"####wait 2");
        }];
        
        // 开启信号等待，设置等待时间为永久，直到信号的信号量大于等于1（绿灯）
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        RWLog(@"####刷新界面等在主线程的操作");
        if(finishBlock) {
            if(!bRequestSuccess) {
                weakSelf.userBaseInfoModel = nil;
                weakSelf.userAccountsModel = nil;
            }
            finishBlock(bRequestSuccess);
        }
    });
    
}

///用户基本信息的获取（点击个人设置需要调用）/bxg/onlineUser/getBaseUserInfo
- (void)loadAppRequestUserBaseSettingInfoWithFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString * _Nullable errorMessage, BXGUserBaseInfoModel * _Nullable userBaseInfoModel))finishBlock {
    if(finishBlock==nil) {
        return finishBlock(NO, @"失败", nil);
    }
    
    [[BXGNetWorkTool sharedTool] appRequestUserBaseSettingInfoWithFinished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        if(status==200) {
            if([result isKindOfClass:[NSDictionary class]]) {
                BXGUserBaseInfoModel *model = [BXGUserBaseInfoModel yy_modelWithDictionary:result];
                return finishBlock(YES, @"成功", model);
            } else {
                finishBlock(NO, message, nil);
            }
        } else {
            finishBlock(NO, message, nil);
        }
    }];
}

///三方账号绑定与否列表（点击个人设置需要调用）bxg/onlineUser/getCurrAccountInfo
- (void)loadAppRequestUserThirdBindInfoWithFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString * _Nullable errorMessage, BXGUserAccountsModel * _Nullable userAccountModel))finishBlock {
    if(finishBlock==nil) {
        return finishBlock(NO, @"失败", nil);
    }
    
    [[BXGNetWorkTool sharedTool] appRequestUserThirdBindInfoWithFinished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        if(status==200) {
            if([result isKindOfClass:[NSDictionary class]]) {
                BXGUserAccountsModel *model = [BXGUserAccountsModel yy_modelWithDictionary:result];
                return finishBlock(YES, @"成功", model);
            } else {
                finishBlock(NO, message, nil);
            }
        } else {
            finishBlock(NO, message, nil);
        }
    }];
}

///修改头像 /bxg/user/updateHeadPhoto
- (void)loadUserRequestUpdateHeadPhotoByImageData:(NSData* _Nonnull)imageData
                                      andFileType:(NSString* _Nonnull)fileType //"1图片，2附件"
                                   andFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString * _Nullable errorMessage, NSString * _Nullable portraitImageURL))finishBlock {
    if (!finishBlock) {
        return finishBlock(NO, @"失败", nil);
    }
    [[BXGNetWorkTool sharedTool] userRequestUpdateHeadPhotoByImageData:imageData andFileType:fileType Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        if(status==200) {
            if([result isKindOfClass:[NSString class]]) {
                finishBlock(YES, @"成功", result);
            } else {
                finishBlock(NO, message, nil);
            }
        } else {
            finishBlock(NO, message, nil);
        }
    }];
}

///检查昵称是否重复 /bxg/user/checkNickName
- (void)loadUserRequestCheckNickname:(NSString* _Nonnull)nickname
                      andFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString * _Nullable errorMessage))finishBlock {
    [[BXGNetWorkTool sharedTool] userRequestCheckNickname:nickname Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        if(status == 200) {
            finishBlock(TRUE, @"成功");
        } else {
            finishBlock(FALSE, message);
        }
    }];
}

///修改昵称，性别，地区，签名，学习方向 /bxg/user/updateUser
- (void)loadUserRequestUpdateUserNickname:(NSString* _Nullable)nickname //昵称
                             andAutograph:(NSString* _Nullable)autograph //签名
                                 andSexId:(NSString* _Nullable)sexId //性别 [0女1男2未知]
                            andProvinceId:(NSString* _Nullable)provinceId //省id
                                andCityId:(NSString* _Nullable)cityId //市id
                         andStudyTargetId:(NSString* _Nullable)targetId //学习目标id
                           andFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString * _Nullable errorMessage))finishBlock {
    
    [[BXGNetWorkTool sharedTool] userRequestUpdateUserNickname:nickname andAutograph:autograph andSexId:sexId andProvinceId:provinceId andCityId:cityId andStudyTargetId:targetId Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        if(status == 200) {
            finishBlock(TRUE, @"成功");
        } else {
            finishBlock(FALSE, message);
        }
    }];
}

///省市列表 /bxg/user/getAllProvinceAndCity
- (void)loadUserRequestGetAllProvinceAndCityWithFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString* _Nullable errorMessage, BXGLocation* _Nullable location))finishBlock {
    [[BXGNetWorkTool sharedTool] userRequestGetAllProvinceAndCityFinished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        if(status == 200) {
            if([result isKindOfClass:[NSArray class]]) {
                NSMutableArray *arrTemp = [NSMutableArray new];
                for(NSDictionary *dictItem in result) {
                    BXGLocationProvince *model = [BXGLocationProvince yy_modelWithDictionary:dictItem];
                    [arrTemp addObject:model];
                }
                BXGLocation *location = [BXGLocation new];
                location.provinceList = [NSArray arrayWithArray:arrTemp];
                return finishBlock(TRUE, @"成功", location);
            } else {
                return finishBlock(FALSE, message, nil);
            }
        } else {
            return finishBlock(FALSE, message, nil);
        }
    }];
}

///绑定三方账号 /bxg/user/thirdLoginForExitUser
- (void)loadUserRequestBindThirdAccountByThirdAccessToken:(NSString* _Nonnull)thirdaccessToken //调用三方登录返回的凭证
                                             andThirdType:(NSString* _Nonnull)thirdType //5：qq，6：微信，7：微博
                                               andThirdId:(NSString* _Nonnull)thirdId   //（微信需返回openId，微博的uid，qq的appID
                                           andFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString * _Nullable errorMessage))finishBlock {
    [[BXGNetWorkTool sharedTool] userRequestBindThirdAccountByThirdAccessToken:thirdaccessToken andThirdType:thirdType andThirdId:thirdId Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        if(status==200) {
            return finishBlock(TRUE, @"成功");
        } else {
            return finishBlock(FALSE, message);
        }
    }];
}

- (void)loadUserRequestUnbindThirdAccountByUserLoginAccount:(NSString * _Nullable)userLoginAccount
                                             andFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString * _Nullable errorMessage))finishBlock {
    [[BXGNetWorkTool sharedTool] userRequestUnbindThirdAccountByUserLoginAccount:userLoginAccount
                                                                    Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        if(status==200) {
            return finishBlock(TRUE, @"成功");
        } else {
            return finishBlock(FALSE, message);
        }
    }];
}

/////绑定用户名 /bxg/user/bindOtherCount
//- (void)loadUserRequestBindUserNameByUserName:(NSString* _Nonnull)userName
//                                 andLoginType:(NSString* _Nonnull)loginType //绑定类型，目前只有手机，传2即可（1：用户名，2：手机号，3：邮箱）
//                                      andCode:(NSString* _Nonnull)code //手机验证码（绑定手机时必填，此处目前只有手机，所以设置必填，未来有扩展的话就是非必填）
////                                andBindStatus:(NSString* _Nullable)bindStatus //1.更换(更换绑定账号时必填，绑定账号操作不用传)
//                               andFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString * _Nullable errorMessage))finishBlock {
//    [[BXGNetWorkTool sharedTool] userRequestBindUserNameByUserName:userName andLoginType:loginType andCode:code Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
//        if(status==200) {
//             return finishBlock(TRUE, @"成功");
//        } else {
//            return finishBlock(FALSE, message);
//        }
//    }];
//}
/*
 - (void)loadUserRequestBindUserNameByUserName:(NSString* _Nonnull)userName
 andLoginType:(NSString* _Nonnull)loginType //绑定类型，目前只有手机，传2即可（1：用户名，2：手机号，3：邮箱）
 andCode:(NSString* _Nonnull)code //手机验证码（绑定手机时必填，此处目前只有手机，所以设置必填，未来有扩展的话就是非必填）
 //                                andBindStatus:(NSString* _Nullable)bindStatus //1.更换(更换绑定账号时必填，绑定账号操作不用传)
 andFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString * _Nullable errorMessage))finishBlock {
 [[BXGNetWorkTool sharedTool] userRequestBindUserNameByUserName:userName andLoginType:loginType andCode:code Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
 if(status==200) {
 return finishBlock(TRUE, @"成功");
 } else {
 return finishBlock(FALSE, message);
 }
 }];
 }

 //*/


///更换手机号时验证验证身份接口 /bxg/user/identityValid
- (void)loadUserRequestCheckIdentityValidByUserName:(NSString* _Nonnull)userName
                                            andCode:(NSString* _Nonnull)code
                                     andFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString * _Nullable errorMessage))finishBlock {
    //TODO:这是什么时候调用的
}

///修改密码 /bxg/user/resetPWD
- (void)loadUserRequestRestPWDByUserName:(NSString* _Nonnull)userName
                             andPassword:(NSString* _Nonnull)password
                           andVerifyCode:(NSString* _Nonnull)verifyCode
                          andFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString * _Nullable errorMessage))finishBlock {
    [[BXGNetWorkTool sharedTool] userRequestRestPWDByUserName:userName
                                                  andPassword:password
                                                andVerifyCode:verifyCode
                                                     Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        if(status==200){
            return finishBlock(TRUE, @"成功");
        } else {
            return finishBlock(FALSE, message);
        }
    }];
}

#pragma mark 逻辑函数
- (BOOL)isValidPersonInfoExist {
    if(self.userBaseInfoModel && self.userAccountsModel) {
        return YES;
    }
    return NO;
}

- (BOOL)isShowSettingPassword {
    BOOL bShow = NO;
    BXGUserAccountInfoModel *cellphoneAccountInfo = [self accountInfoByAccountType:BXGAccountTypeCellphone];
    if(!cellphoneAccountInfo ||
       !self.userAccountsModel.usercenter.password ||
       !cellphoneAccountInfo.loginAccount) {
        //情形一:若用户登录的账号，没有设置过密码，则隐藏修改密码项
        //情形二:若之前未绑定手机号，修改密码项隐藏
//        rows = 1;//不存在手机号, 那么就只有 绑定手机 项
        bShow = NO;
    } else {
        bShow = YES;
//        rows = 2;//存在手机号, 那么就有 绑定手机+修改密码 项
    }
    return bShow;
}

- (NSString*)convertSexString {
    NSString *sexId = self.userBaseInfoModel.sex;
    if([NSString isEmpty:sexId]) {
        return @"请选择";
    }
    if(sexId.integerValue == 0) {
        return @"女";
    }
    if(sexId.integerValue == 1) {
        return @"男";
    } else {
        return @"请选择";
    }
}

- (NSString*)convertSexIdBySexName:(NSString*)sexName {
    if([NSString isEmpty:sexName]) {
        return @"2";
    }
    sexName = [sexName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([sexName isEqualToString:@"男"]) {
        return @"1";
    } else if([sexName isEqualToString:@"女"]) {
        return @"0";
    } else {
        return @"2";
    }
}

- (BOOL)isBindAccountByAccountType:(BXGAccountType)accountType
         andBindedUserAccountModel:(BXGUserAccountInfoModel**)userAccountModel {
    if(!self.userAccountsModel) {
        return NO;
    }
    
    if(self.userAccountsModel.accounts && self.userAccountsModel.accounts.count<=0) {
        return NO;
    }
    for (BXGUserAccountInfoModel *item in self.userAccountsModel.accounts) {
        if(item.type.integerValue == accountType && item.loginAccount!=nil) {
            if(userAccountModel) {
                *userAccountModel = item;
            }
            return YES;
        }
    }
    
    return NO;
}

- (NSString*)showBindStatusByAccountType:(BXGAccountType)accountType {
    if([self isBindAccountByAccountType:accountType andBindedUserAccountModel:nil]) {
        return @"已绑定";
    } else {
        return @"未绑定";
    }
}

- (NSString*)showEMail {
    NSString *detailEMail = @"未绑定";
    BXGUserAccountInfoModel *accountEMail = [self accountInfoByAccountType:BXGAccountTypeEMail];
    if(!accountEMail || !accountEMail.loginAccount) {
        detailEMail =  @"未绑定";
    } else {
        detailEMail = accountEMail.loginAccount;//detailEMail; //不能用@"", 也不能是nil, 否则会崩溃,(可以设置为@" ", 让其占位)
    }
    return detailEMail;
}

- (BXGUserAccountInfoModel*)accountInfoByAccountType:(BXGAccountType)accountType {
    if(!self.userAccountsModel)
        return nil;
    for (BXGUserAccountInfoModel *item in self.userAccountsModel.accounts) {
        if(![NSString isEmpty:item.type] && accountType == item.type.integerValue) {
            return item;
        }
    }
    return nil;
}

- (NSString*)convertStudyDirectionName {
    
    if(!self.userBaseInfoModel || [NSString isEmpty:self.userBaseInfoModel.target] || !self.userBaseInfoModel.studyTarget || self.userBaseInfoModel.studyTarget.count==0) {
        return @"请选择";
    } else {
        NSString *targetId = self.userBaseInfoModel.target;
        NSArray<BXGUserStudyTargetModel*> *studyTargetList = self.userBaseInfoModel.studyTarget;
        for (BXGUserStudyTargetModel *item in studyTargetList) {
            if(targetId.integerValue == item.idx.integerValue) {
                return item.value;
            }
        }
    }
    
    return @"请选择";
}

- (NSNumber*)convertStudyDirectionNumberIndex {
    if(!self.userBaseInfoModel || [NSString isEmpty:self.userBaseInfoModel.target] || !self.userBaseInfoModel.studyTarget || self.userBaseInfoModel.studyTarget.count==0) {
        return nil;
    } else {
        NSNumber *numberIndex = nil;
        NSInteger index = 0;
        NSString *targetId = self.userBaseInfoModel.target;
        NSArray<BXGUserStudyTargetModel*> *studyTargetList = self.userBaseInfoModel.studyTarget;
        for (BXGUserStudyTargetModel *item in studyTargetList) {
            if(targetId.integerValue == item.idx.integerValue) {
                numberIndex = [NSNumber numberWithInteger:index];
                return numberIndex;
            }
            index++;
        }
    }
    
    return nil;
}

- (BOOL)isBindRealCertify {
    if([NSString isEmpty:self.userBaseInfoModel.realName]) {
        return NO; //@"未认证";
    }
    return YES;//@"已认证";
}

- (BOOL)isBindUserCertify {
    if(self.userBaseInfoModel && self.userBaseInfoModel.isOldUser && self.userBaseInfoModel.isOldUser.integerValue==1) {
        return YES; //@"已认证";
    }
    return NO;// @"未认证";
}

#pragma mark 位置相关(省/城市)
-(NSInteger)numberOfComponetents {
    if(!self.location) {
        return 0;
    }
    return 2;
}

-(void)loadProvinceAndCityListBlock:(void (^)(BXGLocation* location, NSString *errorMessage))locationBlock {
    if(!locationBlock) {
        return ;
    }
    if(self.location) {
        return locationBlock(self.location, nil);
    }
    [self loadUserRequestGetAllProvinceAndCityWithFinishBlock:^(BOOL bSuccess, NSString * _Nullable errorMessage, BXGLocation * _Nullable location) {
        if(bSuccess) {
            self.location = location;
            locationBlock(location, nil);
        } else {
            locationBlock(nil, errorMessage);
        }
    }];
}

-(NSInteger)getProvincesCount {
    if(!self.location) {
        return 0;
    }
    if(!self.location.provinceList) {
        return 0;
    }
    return self.location.provinceList.count;
}

-(NSInteger)getCitiesCountByProvinceId:(NSString*)provinceId {
    if(!self.location) {
        return 0;
    }
    if(!self.location.provinceList) {
        return 0;
    }
    
    NSArray<BXGLocationCity*> *arrCity = [self findCurrentCitiesByProvinceId:provinceId];
    return arrCity!=nil?arrCity.count:0;
}

-(NSString*)getProvinceNameByIndex:(NSInteger)index {
    BXGLocationProvince *locationProvince = [self getLocationProvinceByIndex:index];
    if(!locationProvince) {
        return nil;
    }
    return locationProvince.name;
}

-(BXGLocationProvince*)getLocationProvinceByIndex:(NSInteger)index {
    if(index>=self.location.provinceList.count) {
        RWLog(@"index is beyond the maximum size of provinceList");
        return nil;
    }
    BXGLocationProvince *locationProvince = self.location.provinceList[index];
    NSAssert(locationProvince!=nil, @"getProvinceNameByIndex couldn't be nil");
    return locationProvince;
}

-(NSString*)getCityNameByProvinceId:(NSString*)provinceId andIndex:(NSInteger)index {
    BXGLocationCity* curCity = [self getLocationCityByProvinceId:provinceId andIndex:index];
    if(!curCity) {
        return nil;
    }
    return curCity.name;
}

-(BXGLocationCity*)getLocationCityByProvinceId:(NSString*)provinceId andIndex:(NSInteger)index {
    NSArray<BXGLocationCity*>* curCities = [self findCurrentCitiesByProvinceId:provinceId];
    if(!curCities) {
        return nil;
    }
    if(index>=curCities.count) {
        RWLog(@"index is beyond the curCities's size");
        return nil;
    }
    BXGLocationCity *locCity = curCities[index];
    return locCity;
}


-(NSArray<BXGLocationCity*>*)findCurrentCitiesByProvinceId:(NSString*)provinceId {
    BXGLocationProvince *curLocationProvince = [self findCurrentProvinceByProvinceId:provinceId];
    if(curLocationProvince) {
        return curLocationProvince.cityList;
    }
    return nil;
}

-(BXGLocationProvince*)findCurrentProvinceByProvinceId:(NSString*)provinceId {
    for (BXGLocationProvince *provinceItem in self.location.provinceList) {
        if([provinceId isEqualToString:provinceItem.idx]){
            return provinceItem;
        }
    }
    return nil;
}

-(BXGLocationCity *)findCurrentCityByProvinceId:(NSString*)provinceId andCityId:(NSString*)cityId {
    if(provinceId==nil || cityId==nil)
        return nil;
    NSArray<BXGLocationCity*>* locationCitiesOfProvince = [self findCurrentCitiesByProvinceId:provinceId];
    if(locationCitiesOfProvince) {
        for(BXGLocationCity *item in locationCitiesOfProvince) {
            if([item.idx isEqualToString:cityId]) {
                return item;
            }
        }
    }
    return nil;
}

-(NSString*)locationName {
    NSString *locationName = nil;
    if(!self.userBaseInfoModel) {
        return locationName;
    }
    if([NSString isEmpty:self.userBaseInfoModel.provinceName] || [NSString isEmpty:self.userBaseInfoModel.cityName]) {
        locationName = @"请选择";
        return locationName;
    }
    if([self.userBaseInfoModel.provinceName isEqualToString:self.userBaseInfoModel.cityName]) {
        locationName = self.userBaseInfoModel.provinceName;
    } else {
        locationName = [NSString stringWithFormat:@"%@ %@", self.userBaseInfoModel.provinceName, self.userBaseInfoModel.cityName];
    }
    return locationName;
}

-(NSString*)autograph {
    
    if(!self.userBaseInfoModel) {
        return nil;
    }
    if([NSString isEmpty:self.userBaseInfoModel.autograph]) {
        return nil;
    }
    return [self.userBaseInfoModel.autograph trimWhitespaceAndNewLineCharacterSet];
}


@end
