//
//  BXGLocation.h
//  Boxuegu
//
//  Created by apple on 2018/1/10.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGLocationCity : BXGBaseModel
@property (nonatomic, strong) NSString *idx;
@property (nonatomic, strong) NSString *name;
@end

@interface BXGLocationProvince : BXGBaseModel
@property (nonatomic, strong) NSString *idx;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<BXGLocationCity*> *cityList;
@end

@interface BXGLocation : BXGBaseModel
@property (nonatomic, strong) NSArray<BXGLocationProvince*> *provinceList;
@end
