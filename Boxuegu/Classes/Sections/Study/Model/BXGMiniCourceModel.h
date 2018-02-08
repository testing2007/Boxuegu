//
//  BXGMiniCourceModel.h
//  Boxuegu
//
//  Created by HM on 2017/4/21.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 微课信息模型(最小)
 */
@interface BXGMiniCourceModel : BXGBaseModel
@property (nonatomic, strong) NSString* course_name;
@property (nonatomic, strong) NSString* course_id;
@property (nonatomic, strong) NSString* smallimg_path;
@property (nonatomic, strong) NSString* learnd_sum;
@property (nonatomic, strong) NSString* teacher_name;
@property (nonatomic, strong) NSString* course_length;

@end
