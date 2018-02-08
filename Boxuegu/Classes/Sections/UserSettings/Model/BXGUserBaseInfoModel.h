//
//  BXGUserBaseInfoModel.h
//  Boxuegu
//
//  Created by apple on 2018/1/10.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"
#import "BXGUserStudyTargetModel.h"

@interface BXGUserBaseInfoModel : BXGBaseModel

@property (nonatomic, strong) NSString *uid;
//@property (nonatomic, strong) NSString *applyId;
@property (nonatomic, strong) NSString *img; //用户头像URL
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *realName; //实名认证的真实姓名, 如果有值,表示完成了实名认证; 否则,没有实名认证.
@property (nonatomic, strong) NSString *loginName; //登录名
@property (nonatomic, strong) NSString *autograph; //个性签名
@property (nonatomic, strong) NSString *mobile; //实名认证的手机号
@property (nonatomic, strong) NSString *qq; //实名认证的qq
@property (nonatomic, strong) NSString *email; //实名认证的邮箱
@property (nonatomic, strong) NSString *sex; //实名认证的性别(0女1男2未知)
//@property (nonatomic, strong) NSString *birthday;
//@property (nonatomic, strong) NSString *birthdayStr;
//"occupation": 24,职业<number>
//"job": null,<string>
@property (nonatomic, strong) NSArray<BXGUserStudyTargetModel*> *studyTarget;
//-"studyTarget": [学习目标列表<array>
//                 -{
//                     "id": "50",<string>
//                     "key": "1",<string>
//                     "value": "Android"<string>
//                 }
//                 ],
@property (nonatomic, strong) NSString *target;//"55",学习目标id<string>
//"targetName": null,<string>
//"jobyearId": 1,工作年限id<number>
//"jobyear": null,<string>
//@property (nonatomic, strong) NSString *education;//": null,<string>
//"educationId": "1",<string>
@property (nonatomic, strong) NSString *educationName; //实名认证的学历
//"major": null,<string>
//"majorId": "060102",<string>
@property (nonatomic, strong) NSString *majorName;//实名认证的专业
//"company": null,<string>
//"posts": null,<string>
//"occupationOther": null,<string>
@property (nonatomic, strong) NSString *province; //省名称Id TODO:考虑获取province/city为空情况处理
@property (nonatomic, strong) NSString *city;//市名称id
@property (nonatomic, strong) NSString *provinceName; //省名称
@property (nonatomic, strong) NSString *cityName; //市名称

//"applyProvince": null,<string>
//"appCity": null,<string>
//"schoolId": "3028801751571afa0151571b10710856",<string>
@property (nonatomic, strong) NSString *schoolName; //实名认证的学校名称
//"district": null,<string>
//"county": null,<string>
@property (nonatomic, strong) NSString *idCardNo; //实名认证的身份证
//"fullAddress": "",<string>
@property (nonatomic, strong) NSString *isOldUser; //是否是老学员0否1是
@property (nonatomic, strong) NSString *oldUserClassName; //VUE进阶就业班120期",老学员班级
@property (nonatomic, strong) NSString *oldUserSubjectName; //"Web前端"老学员学科

@end
