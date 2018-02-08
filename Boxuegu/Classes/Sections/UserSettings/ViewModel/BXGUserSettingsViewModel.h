//
//  BXGUserSettingsViewModel.h
//  Boxuegu
//
//  Created by apple on 2018/1/10.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
#import "BXGUserBaseInfoModel.h"
#import "BXGUserStudyTargetModel.h"
#import "BXGUserAccountsModel.h"
#import "BXGLocation.h"

typedef enum : NSInteger {
    //5：qq，6：微信，7：微博
    //1：用户名，2：手机号，3：邮箱，5：qq，6：微信，7：微博，8：支付宝
    BXGAccountTypeUserName = 1,
    BXGAccountTypeCellphone,
    BXGAccountTypeEMail,
    BXGAccountTypeQQ = 5,
    BXGAccountTypeWeiXin,
    BXGAccountTypeSinaWeibo,
    BXGAccountTypeAlipay
}BXGAccountType;

@interface BXGUserSettingsViewModel : BXGBaseViewModel

@property (nonatomic, strong) BXGUserBaseInfoModel *userBaseInfoModel;
@property (nonatomic, strong) BXGUserAccountsModel *userAccountsModel;


- (void)loadPersonInfoWithFinishBlock:(void (^)(BOOL bSuccess))finishBlock;

///修改头像 /bxg/user/updateHeadPhoto
- (void)loadUserRequestUpdateHeadPhotoByImageData:(NSData* _Nonnull)imageData
                                      andFileType:(NSString* _Nonnull)fileType //"1图片，2附件"
                                   andFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString * _Nullable errorMessage, NSString * _Nullable portraitImageURL))finishBlock;

///检查昵称是否重复 /bxg/user/checkNickName
- (void)loadUserRequestCheckNickname:(NSString* _Nonnull)nickname
                      andFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString * _Nullable errorMessage))finishBlock;

///修改昵称，性别，地区，签名，学习方向 /bxg/user/updateUser
- (void)loadUserRequestUpdateUserNickname:(NSString* _Nullable)nickname //昵称
                             andAutograph:(NSString* _Nullable)autograph //签名
                                 andSexId:(NSString* _Nullable)sexId //性别 [0女1男2未知]
                            andProvinceId:(NSString* _Nullable)provinceId //省id
                                andCityId:(NSString* _Nullable)cityId //市id
                         andStudyTargetId:(NSString* _Nullable)targetId //学习目标id
                           andFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString * _Nullable errorMessage))finishBlock;

///省市列表 /bxg/user/getAllProvinceAndCity
- (void)loadUserRequestGetAllProvinceAndCityWithFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString* _Nullable errorMessage, BXGLocation* _Nullable location))finishBlock;

///绑定三方账号 /bxg/user/thirdLoginForExitUser
- (void)loadUserRequestBindThirdAccountByThirdAccessToken:(NSString* _Nonnull)thirdaccessToken //调用三方登录返回的凭证
                                             andThirdType:(NSString* _Nonnull)thirdType //5：qq，6：微信，7：微博
                                               andThirdId:(NSString* _Nonnull)thirdId   //（微信需返回openId，微博的uid，qq的appID
                                           andFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString * _Nullable errorMessage))finishBlock;
///解除第三方绑定
- (void)loadUserRequestUnbindThirdAccountByUserLoginAccount:(NSString * _Nullable)userLoginAccount
                                             andFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString * _Nullable errorMessage))finishBlock;

/////绑定用户名 /bxg/user/bindOtherCount
//- (void)loadUserRequestBindUserNameByUserName:(NSString* _Nonnull)userName
//                                 andLoginType:(NSString* _Nonnull)loginType //绑定类型，目前只有手机，传2即可（1：用户名，2：手机号，3：邮箱）
//                                      andCode:(NSString* _Nonnull)code //手机验证码（绑定手机时必填，此处目前只有手机，所以设置必填，未来有扩展的话就是非必填）
////                                andBindStatus:(NSString* _Nullable)bindStatus //1.更换(更换绑定账号时必填，绑定账号操作不用传)
//                                 andFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString * _Nullable errorMessage))finishBlock;


///更换手机号时验证验证身份接口 /bxg/user/identityValid
- (void)loadUserRequestCheckIdentityValidByUserName:(NSString* _Nonnull)userName
                                            andCode:(NSString* _Nonnull)code
                                     andFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString * _Nullable errorMessage))finishBlock;

///修改密码 /bxg/user/resetPWD
- (void)loadUserRequestRestPWDByUserName:(NSString* _Nonnull)userName
                             andPassword:(NSString* _Nonnull)password
                           andVerifyCode:(NSString* _Nonnull)verifyCode
                             andFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString * _Nullable errorMessage))finishBlock;

#pragma mark 逻辑函数
///是否有有效的个人信息数据存在
- (BOOL)isValidPersonInfoExist;
- (BOOL)isShowSettingPassword;

-(NSString*_Nullable)locationName;
-(NSString*_Nullable)autograph;

///服务器返回: 性别 [0女1男2未知] ; 需求:男、女、请选择(默认提示)
- (NSString*_Nullable)convertSexString;
- (NSString*_Nullable)convertSexIdBySexName:(NSString*_Nullable)sexName;
///1：用户名，2：手机号，3：邮箱，5：qq，6：微信，7：微博，8：支付宝
- (BOOL)isBindAccountByAccountType:(BXGAccountType)thirdAccountType
         andBindedUserAccountModel:(BXGUserAccountInfoModel**)userAccountModel;
- (NSString* _Nonnull)showBindStatusByAccountType:(BXGAccountType)accountType;
- (NSString* _Nonnull)showEMail;

///根据targetId在学习方向列表中找到匹配的数据, 找到匹配的,返回对应的名称/或索引值, 否则,返回空串/或nil;
- (NSString* _Nonnull)convertStudyDirectionName;
- (NSNumber*_Nullable)convertStudyDirectionNumberIndex;

///是否已实名认证
- (BOOL)isBindRealCertify;
///是否已学员认证
- (BOOL)isBindUserCertify;


#pragma mark 位置相关
-(NSInteger)numberOfComponetents;
-(void)loadProvinceAndCityListBlock:(void (^_Nullable)(BXGLocation* _Nullable location, NSString* _Nullable errorMessage))locationBlock;
-(NSInteger)getProvincesCount;
-(NSInteger)getCitiesCountByProvinceId:(NSString*_Nullable)provinceId;
-(NSString*_Nullable)getProvinceNameByIndex:(NSInteger)index;
-(BXGLocationProvince*_Nullable)getLocationProvinceByIndex:(NSInteger)index;
-(NSString*_Nullable)getCityNameByProvinceId:(NSString*_Nullable)provinceId andIndex:(NSInteger)index;
-(BXGLocationCity*_Nullable)getLocationCityByProvinceId:(NSString*_Nullable)provinceId andIndex:(NSInteger)index;
-(NSArray<BXGLocationCity*>*_Nullable)findCurrentCitiesByProvinceId:(NSString*_Nullable)provinceId;


#pragma mark 手机账号信息
- (BXGUserAccountInfoModel*_Nullable)accountInfoByAccountType:(BXGAccountType)accountType;

@end
