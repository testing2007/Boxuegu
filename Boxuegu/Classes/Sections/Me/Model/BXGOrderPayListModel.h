//
//  BXGOrderPayListModel.h
//  Boxuegu
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@class BXGOrderPayItemModel;

@interface BXGOrderPayListModel : BXGBaseModel

@property(nonatomic, strong) NSArray<BXGOrderPayItemModel*> *items;

@end
