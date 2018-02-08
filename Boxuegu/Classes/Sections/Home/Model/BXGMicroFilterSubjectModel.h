//
//  BXGMicroFilterSubjectModel.h
//  Boxuegu
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@class BXGMicroFilterCategoryModel;

@interface BXGMicroFilterSubjectModel : BXGBaseModel

@property(nonatomic, strong) NSNumber *subjectId;
@property(nonatomic, strong) NSNumber *parentId;
@property(nonatomic, strong) NSString *subjectName;
@property(nonatomic, strong) NSArray<BXGMicroFilterCategoryModel*> *tag;

@end
