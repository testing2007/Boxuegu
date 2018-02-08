//
//  BXGConstruePlanMonthView.h
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/10.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXGCalendar;

typedef NS_ENUM(NSUInteger, BXGCalendarDateEvent) {
    BXGCalendarDateEventNone,
    BXGCalendarDateEventRed,
    BXGCalendarDateEventGreen,
};

typedef NS_ENUM(NSUInteger, BXGCalendarScope) {
    BXGCalendarScopeMonth,
    BXGCalendarScopeWeek,
};

@protocol BXGCalendarDelegate<NSObject>
// datasource
- (NSDate *)minimumDateForCalendar:(BXGCalendar *)calendar;
- (NSDate *)maximumDateForCalendar:(BXGCalendar *)calendar;
- (void)calendarLessThanMinimumDate:(BXGCalendar *)calendar;
- (void)calendarLargerThanMaximumDate:(BXGCalendar *)calendar;
- (BXGCalendarDateEvent)calendar:(BXGCalendar *)calendar eventForDate:(NSDate *)date;
- (void)calendar:(BXGCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated;
// delegate
- (void)calendar:(BXGCalendar *)calendar didSelectDate:(NSDate *)date;

@end
@interface BXGCalendar : UIView
@property (nonatomic, weak) id<BXGCalendarDelegate> delegate;
- (instancetype)initWithDelegate:(id<BXGCalendarDelegate>)delegate;
@property (nonatomic, assign) BXGCalendarScope scope;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
- (void)reloadData;
- (void)pan:(UIPanGestureRecognizer *)pan;
@end
