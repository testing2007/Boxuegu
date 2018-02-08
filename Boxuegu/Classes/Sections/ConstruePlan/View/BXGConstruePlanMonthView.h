//
//  BXGConstruePlanMonthView.h
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/10.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGCalendar.h"

typedef void(^DidSelectedBlockType)(NSDate *date);

@class BXGConstruePlanMonthItemModel;
@interface BXGConstruePlanMonthView : UIView
@property (nonatomic, strong) NSArray<BXGConstruePlanMonthItemModel *> *models;
@property (nonatomic, copy) DidSelectedBlockType didSelectedBlock;
@property (nonatomic, assign) BOOL isWeek;
@property (nonatomic, strong) BXGCalendar *calendar;
@end
