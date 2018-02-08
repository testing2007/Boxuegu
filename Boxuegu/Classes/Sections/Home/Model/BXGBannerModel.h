//
//  BXGBannerModel.h
//  Boxuegu
//
//  Created by apple on 2017/11/1.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGBannerModel : BXGBaseModel

///bannerId
@property(nonatomic, strong) NSString *idx;
///创建时间
@property(nonatomic, strong) NSString *createTime;
///创建人
@property(nonatomic, strong) NSString *createPerson;
///更新人
@property(nonatomic, strong) NSString *updatePerson;
///是否删除 0:否 1:是
@property(nonatomic, strong) NSString *isDelete;
///Banner名称
@property(nonatomic, strong) NSString *name;
///学科ID
@property(nonatomic, strong) NSString *menuId;
///课程ID
@property(nonatomic, strong) NSString *courseId;
///Banner链接地址
@property(nonatomic, strong) NSString *imgHref;
///banner图片存储地址
@property(nonatomic, strong) NSString *imgPath;
///应用客户端：0:App，1:移动web
@property(nonatomic, strong) NSString *clientType;
///banner类型：0课程详情，1专题活动
@property(nonatomic, strong) NSString *type;
///排序
@property(nonatomic, strong) NSString *sort;
///1已启用，0已禁用
@property(nonatomic, strong) NSString *status;
///启用时间
@property(nonatomic, strong) NSString *startTime;
///禁用时间
@property(nonatomic, strong) NSString *endTime;
///点击次数
@property(nonatomic, strong) NSString *clickCount;

@end
