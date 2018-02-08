//
//  BXGUserAccountsModel.h
//  Boxuegu
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGUserAccountInfoModel : BXGBaseModel
@property (nonatomic, strong) NSString *type; //5：qq，6：微信，7：微博
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *loginAccount; //loginAccount为空,表示未绑定, 否则表示已绑定
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *bindDate;
@property (nonatomic, strong) NSString *nickName;
@end

@interface BXGUserLoginInfoModel : BXGBaseModel
@property (nonatomic, strong) NSString *idx;
@property (nonatomic, strong) NSString *loginName; //"18612376413"
@property (nonatomic, strong) NSString *password;
//@property (nonatomic, strong) NSString *salt; //颜值
@property (nonatomic, strong) NSString *nikeName; //昵称
//@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *type; //1：用户名，2：手机号，3：邮箱，5：qq，6：微信，7：微博，8：支付宝
@property (nonatomic, strong) NSString *origin; //"online"
@property (nonatomic, strong) NSString *status; //"0
@property (nonatomic, strong) NSString *lastLoginDate; //null
@property (nonatomic, strong) NSString *registDate; //"2017-07-15 17:04:01"
@property (nonatomic, strong) NSString *username; //"18612376413"
@property (nonatomic, strong) NSString *portait; //"https://attachment-center.boxuegu.com/data/attachment/online/2017/08/02/04/d8ed64380ff14047b18d179383c948ce.png",
@property (nonatomic, strong) NSString *registLoginType; //"MOBILE"
@end

@interface BXGUserAccountsModel : BXGBaseModel
@property (nonatomic, strong) NSArray<BXGUserAccountInfoModel*> *accounts;
@property (nonatomic, strong) BXGUserLoginInfoModel *usercenter;
@end
