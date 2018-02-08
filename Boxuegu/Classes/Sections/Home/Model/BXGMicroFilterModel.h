//
//  BXGMicroFilterModel.h
//  Boxuegu
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@class BXGMicroFilterDirectionModel;

@interface BXGMicroFilterModel : BXGBaseModel

@property(nonatomic, strong) NSArray<BXGMicroFilterDirectionModel*> *direction;

@end
