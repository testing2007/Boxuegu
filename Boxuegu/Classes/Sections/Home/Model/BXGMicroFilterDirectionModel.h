//
//  BXGMicroFilterDirectionModel.h
//  Boxuegu
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@class BXGMicroFilterSubjectModel;

@interface BXGMicroFilterDirectionModel : BXGBaseModel

@property(nonatomic, strong) NSNumber *directionId;
@property(nonatomic, strong) NSString *directionName;
@property(nonatomic, strong) NSArray<BXGMicroFilterSubjectModel*> *subject;

@end
