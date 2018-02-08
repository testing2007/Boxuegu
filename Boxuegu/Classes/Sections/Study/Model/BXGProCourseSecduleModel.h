//
//  BXGProCourseSecduleModel.h
//  Boxuegu
//
//  Created by apple on 2017/6/27.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXGProCourseSecduleModel : NSObject
//id = 0971731d3f9f11e7b1650025900538a3,
//day = 22,
//week = 星期五,
//chuanjiang_has = 0,
//chuanjiang_name = <null>,
//template_id = b00c3ee7f3de421c9929fc8eea066622,
//plan_date = 2017-06-16 00:00:00,
//rest_has = 0
@property(nonatomic, strong) NSString *id;
@property(nonatomic, assign) NSInteger day;
@property(nonatomic, strong) NSString *week;
@property(nonatomic, assign) BOOL chuanjiang_has;
@property(nonatomic, strong) NSString *chuanjiang_name;
@property(nonatomic, strong) NSString *template_id;
@property(nonatomic, strong) NSString *plan_date;
@property(nonatomic, assign) BOOL rest_has;

@end
