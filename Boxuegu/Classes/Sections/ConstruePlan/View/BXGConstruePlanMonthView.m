//
//  BXGConstruePlanMonthView.m
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/10.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGConstruePlanMonthView.h"

#import "BXGConstruePlanMonthItemModel.h"

@interface BXGConstruePlanMonthView() <BXGCalendarDelegate>

@property (nonatomic, strong) NSDictionary *eventCache;
@end


@implementation BXGConstruePlanMonthView

#pragma mark - init


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self installUI];
    }
    return self;
}

#pragma mark - getter setter
- (BXGCalendar *)calendar {
    
    if(_calendar == nil) {
        _calendar = [[BXGCalendar alloc]initWithDelegate:self];
    }
    return _calendar;
    
}

#pragma mark - interface

- (void)setModels:(NSArray<BXGConstruePlanMonthItemModel *> *)models {
    _models = models;
    self.eventCache = nil;
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for (NSInteger i = 0; i < models.count; i++) {
        
        if(models[i].createDate) {
            if(models[i].hasPlan) {
                [dict setObject:@(BXGCalendarDateEventRed) forKey:models[i].createDate];
            }else {
                [dict setObject:@(BXGCalendarDateEventGreen) forKey:models[i].createDate];
            }
        }
    }
    self.eventCache = dict.copy;
    
    
    [self.calendar reloadData];
}

#pragma mark - ui

- (void)installUI {
    
    UIView *calendar = self.calendar;
    [self addSubview:calendar];
    [calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
}


#pragma mark - BXGCalendarDelegate

// datasource
- (NSDate *)minimumDateForCalendar:(BXGCalendar *)calendar {
    
    if(self.models.firstObject) {
        NSDate *date = [[BXGDateTool share] dateFormRequestDateString:self.models.firstObject.startDate];
        return date;
    }
    return nil;
}
- (NSDate *)maximumDateForCalendar:(BXGCalendar *)calendar {
    
    if(self.models.firstObject) {
        NSDate *date = [[BXGDateTool share] dateFormRequestDateString:self.models.firstObject.endDate];
        return date;
    }
    return nil;
}

- (void)calendarLessThanMinimumDate:(BXGCalendar *)calendar {
    [[BXGHUDTool share] showHUDWithString:@"此前未开启直播计划"];
}

- (void)calendarLargerThanMaximumDate:(BXGCalendar *)calendar {
    
}

- (BXGCalendarDateEvent)calendar:(BXGCalendar *)calendar eventForDate:(NSDate *)date {
    
    if(self.models.firstObject) {
        NSString *dateString = [[BXGDateTool share] formaterForRequest:date];
        if(dateString) {
            NSNumber *number = self.eventCache[dateString];
            if(number.integerValue == BXGCalendarDateEventRed) {
                return BXGCalendarDateEventRed;
            }
        }
        return BXGCalendarDateEventGreen;
    }else{
        return BXGCalendarDateEventNone;
    }
}

// delegate
- (void)calendar:(BXGCalendar *)calendar didSelectDate:(NSDate *)date {
    if(self.didSelectedBlock) {
        self.didSelectedBlock(date);
    }
}

- (void)calendar:(BXGCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
    if(self.superview) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(bounds.size.height);
        }];
        [UIView animateWithDuration:0.25 animations:^{
            
//            [self.superview layoutSubviews] ;
            [self.superview layoutIfNeeded];
        }];
    }
}

@end

