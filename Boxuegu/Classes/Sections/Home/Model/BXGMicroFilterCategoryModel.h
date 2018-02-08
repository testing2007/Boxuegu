//
//  BXGMicroFilterCategoryModel.h
//  Boxuegu
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGMicroFilterCategoryModel : BXGBaseModel

@property(nonatomic, strong) NSNumber *tagId;
@property(nonatomic, strong) NSString *tagName;
@property(nonatomic, strong) NSNumber *parentId;

@end
