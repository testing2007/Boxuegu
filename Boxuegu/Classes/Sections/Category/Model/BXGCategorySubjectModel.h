//
//  BXGCategorySubjectModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

/**
 分类所有学科模型
 */
@interface BXGCategorySubjectModel : BXGBaseModel
@property (nonatomic, strong) NSString *menuId;
@property (nonatomic, strong) NSString *menuName;
@end
