//
//  BXGConstruePlanMonthView.h
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/10.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGCalendar.h"
#import "FSCalendar.h"

@interface BXGCalendar()<FSCalendarDataSource,FSCalendarDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSCalendar *gregorian;
@property (nonatomic, strong) FSCalendar *calendar;//

@property (nonatomic, assign) BOOL isTrue;
//@property (weak, nonatomic) IBOutlet UISwitch *animationSwitch;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarHeightConstraint;//
//@property (strong, nonatomic) NSDateFormatter *dateFormatter;
//@property (strong, nonatomic) UIPanGestureRecognizer *scopeGesture;
//@property (strong, nonatomic) NSDictionary *courseSecdule;//课程安排, todo




@end

@implementation BXGCalendar

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    self.isTrue = !self.isTrue;
//    if(self.isTrue){
//        [self.calendar setScope:FSCalendarScopeWeek animated:true];
////        self.calendar.scope = FSCalendarScopeWeek;
//    }else {
//        [self.calendar setScope:FSCalendarScopeMonth animated:true];
////        self.calendar.scope = FSCalendarScopeMonth;
//        
//    }
////    [self.calendar reloadData];
//}

- (void)setScope:(BXGCalendarScope)scope {
    
    switch (scope) {
        case BXGCalendarScopeMonth:
        {
            if(self.calendar.scope != FSCalendarScopeMonth) {
                [self.calendar setScope:FSCalendarScopeMonth animated:true];
            }
        }break;
        case BXGCalendarScopeWeek:
        {
            if(self.calendar.scope != FSCalendarScopeWeek) {
                [self.calendar setScope:FSCalendarScopeWeek animated:true];
            }
        }break;
    }
}

- (BXGCalendarScope)scope {
    switch (self.calendar.scope) {
        case FSCalendarScopeMonth:
        {
            return BXGCalendarScopeMonth;
        }break;
        case FSCalendarScopeWeek:
        {
            return BXGCalendarScopeWeek;
        }break;
    }
}

#pragma mark - init

- (instancetype)initWithDelegate:(id<BXGCalendarDelegate>)delegate {
    self = [self initWithFrame:CGRectZero];
    if(self) {
        self.delegate = delegate;
        [self installUI];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
    }
    return self;
}

#pragma mark - getter setter


- (void)pan:(UIPanGestureRecognizer *)pan {
    [self.calendar handleScopeGesture:pan];
}

- (UIPanGestureRecognizer *)panGesture {
    
    if(_panGesture == nil) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendar action:@selector(handleScopeGesture:)];
        _panGesture.delegate = self;
        _panGesture.minimumNumberOfTouches = 1;
        _panGesture.maximumNumberOfTouches = 2;
//        self.scopeGesture = panGesture;
    }
    return _panGesture;
    
}
- (FSCalendar *)calendar {
    if(_calendar == nil) {
        _calendar = [FSCalendar new];
        [self addSubview:_calendar];
        _calendar.backgroundColor = [UIColor whiteColor];
        _calendar.appearance.headerMinimumDissolvedAlpha = 0;
        _calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];//现在中文
        //    self.calendar.placeholderType = FSCalendarPlaceholderTypeNone;//是否隐藏前后月日历显示
        _calendar.delegate = self;
        _calendar.dataSource = self;
        // 初始值
        [_calendar selectDate:[NSDate date] scrollToDate:YES];
//        _calendar.scope = FSCalendarScopeWeek;
        _calendar.scope = FSCalendarScopeMonth;
        
        _calendar.accessibilityIdentifier = @"calendar";
        
        
        // header view
//        _calendar.calendarHeaderView.
        
        // appearance
        _calendar.appearance.weekdayTextColor = [UIColor colorWithHex:0xa9a9a9];
        _calendar.appearance.selectionColor = [UIColor themeColor];
        _calendar.appearance.eventSelectionColor = [UIColor themeColor];
        
        
//        _calendar.appearance.todayColor = [UIColor redColor];
        
//        _calendar.appearance.headerDateFormat = @"MM月yyyy";
//        _calendar.appearance.headerTitleColor
//        _calendar.appearance.headerMinimumDissolvedAlpha
//        _calendar.appearance.headerTitleFont = [UIFont systemFontOfSize:30];
        
//        _calendar.appearance.titleSelectionColor =  [UIColor themeColor];
//        _calendar.appearance.todaySelectionColor = [UIColor redColor];
//        _calendar.appearance.titleTodayColor = [UIColor grayColor];
//        _calendar.appearance.subtitleTodayColor = [UIColor greenColor];
        
        // 操作
        // [self.calendar setScope:selectedScope animated:self.animationSwitch.on];
//        [weakSelf.calendar reloadData];
        // 开始日期
        
        // 结束日期
    }
    return _calendar;
}

- (NSCalendar *)gregorian {
    
    if(_gregorian == nil) {
        
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
    }
    return _gregorian;
}

- (void)installUI {

    // 设置日历
    [self addSubview:self.calendar];
    [self.calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendar action:@selector(handleScopeGesture:)];
    panGesture.delegate = self;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 2;
    [self.calendar addGestureRecognizer:self.panGesture];
    
//    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    
    
    
//    __weak typeof (self) weakSelf = self;
//
//    self.dateFormatter = [[NSDateFormatter alloc] init];
//    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
//    //初始化数据
//    //    self.courseSecdule = @{@"2017/05/01" : [NSNumber numberWithInt:BXGCourseSecduleStateBreak],
//    //                           @"2017/05/02" : [NSNumber numberWithInt:BXGCourseSecduleStateClass],
//    //                           @"2017/05/03" : [NSNumber numberWithInt:BXGCourseSecduleStateClass],
//    //                           @"2017/05/04" : [NSNumber numberWithInt:BXGCourseSecduleStateBreak]};
//
//    [self.calendar selectDate:[NSDate date] scrollToDate:YES];
//
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendar action:@selector(handleScopeGesture:)];
//    panGesture.delegate = self;
//    panGesture.minimumNumberOfTouches = 1;
//    panGesture.maximumNumberOfTouches = 2;
//    [self addGestureRecognizer:panGesture];
//    self.scopeGesture = panGesture;
//
//    // While the scope gesture begin, the pan gesture of tableView should cancel.
//    //[self.tableView.panGestureRecognizer requireGestureRecognizerToFail:panGesture];
//
//    [self.calendar addObserver:self forKeyPath:@"scope" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:_KVOContext];
//
//    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    self.calendar.scope = FSCalendarScopeWeek;
//
//    // For UITest
//    self.calendar.accessibilityIdentifier = @"calendar";
//    _indicateView = [BXGIndicateView acquireCustomView];
//    [self.view addSubview:_indicateView];
//
//    _planView = [UIView new];
//    [self.view addSubview:_planView];
//
//    // 添加课程计划表
//    BXGStudyProCoursePlanTableVC *proCoursePlanTableVC = [[BXGStudyProCoursePlanTableVC alloc] initWithCourseModel:weakSelf.courseModel];
//    self.planTableVC = proCoursePlanTableVC;
//    [self addChildViewController:proCoursePlanTableVC];
//    [self.planView addSubview:proCoursePlanTableVC.view];
//    proCoursePlanTableVC.didSelectProCoursePlanBlock = ^(BXGProCourseModel *model) {
//
//        BXGCourseModel *courseModel = weakSelf.courseModel;
//        NSString *pointId = model.charpter_id;
//        NSString *sectionId = model.parent_id;
//
//        // BXGCourseModel *courseModel = self.viewModel.courseModel;
//        BXGCourseOutlineSectionModel *sectionModel = [BXGCourseOutlineSectionModel new];
//        sectionModel.idx = sectionId;
//        BXGProCoursePlayerContentVC *proContentVC = [[BXGProCoursePlayerContentVC alloc]initWithCourseModel:courseModel andSectionModel:sectionModel];
//        BXGBasePlayerVC *playerVC = [[BXGBasePlayerVC alloc] initWithCourseModel:courseModel ContentVC:proContentVC];
//        [playerVC autoPlayWithPointId:pointId andVideoId:nil];
//        playerVC.hidesBottomBarWhenPushed = true;
//        [weakSelf.navigationController pushViewController:playerVC animated:true];
//    };
//
//    UIView *spView = [UIView new];
//    spView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
//    [self.view addSubview:spView];
//    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(K_NAVIGATION_BAR_OFFSET);
//        make.left.right.offset(0);
//        make.height.offset(0);
//    }];
//    //去除日历控件顶上的那根横线. 不知道日历控件上面边框的颜色是怎么加进来的.
//    [self.calendar mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(spView.mas_bottom).offset(-1);
//    }];
//
//    [_indicateView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_calendar.mas_bottom).offset(0);
//        make.left.right.offset(0);
//        make.height.mas_equalTo(34);
//    }];
//
//    [_planView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_indicateView.mas_bottom).offset(0);
//        make.left.right.bottom.offset(0);
//    }];
//
//    [proCoursePlanTableVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.bottom.left.right.offset(0);
//    }];
//
//    //初始值
//    self.planTableVC.planDate = [NSDate date];
}

- (void)dealloc {
//    [self.calendar removeObserver:self forKeyPath:@"scope" context:_KVOContext];
//    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - KVO

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    if (context == _KVOContext) {
//        FSCalendarScope oldScope = [change[NSKeyValueChangeOldKey] unsignedIntegerValue];
//        FSCalendarScope newScope = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
//        NSLog(@"From %@ to %@",(oldScope==FSCalendarScopeWeek?@"week":@"month"),(newScope==FSCalendarScopeWeek?@"week":@"month"));
//    } else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}

#pragma mark - Method

- (void)reloadData {
    [self.calendar reloadData];
}

#pragma mark - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    if([self.delegate respondsToSelector:@selector(calendar:boundingRectWillChange:animated:)]) {
        [self.delegate calendar:self boundingRectWillChange:bounds animated:animated];
    }
}

// 日期显示样式
- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @"今";
    }
    return nil;
}

// 日期点击事件
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    
    if([self.delegate respondsToSelector:@selector(calendar:didSelectDate:)]) {
        [self.delegate calendar:self didSelectDate:date];
    }
    
    // 是否是下一个月 跳转到下一个月
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
}

// 设置最小日期
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar {
    
    if([self.delegate respondsToSelector:@selector(minimumDateForCalendar:)]) {
        return [self.delegate minimumDateForCalendar:self];
    }
    return nil;
}

// 设置最大时间
- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar {
    
    if([self.delegate respondsToSelector:@selector(maximumDateForCalendar:)]) {
        return [self.delegate maximumDateForCalendar:self];
    }
    return nil;
}

// 超过最小日期
- (void)calendarLessThanMinimumDate:(FSCalendar*)calendar {
    
    if([self.delegate respondsToSelector:@selector(calendarLessThanMinimumDate:)]) {
        [self.delegate calendarLessThanMinimumDate:self];
    }
}

// 超过最大日期
- (void)calendarLargerThanMaximumDate:(FSCalendar*)calendar {
    
    if([self.delegate respondsToSelector:@selector(calendarLargerThanMaximumDate:)]) {
        [self.delegate calendarLessThanMinimumDate:self];
    }
}

// 是否有活动
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date {
    
    if([calendar.minimumDate compare:date] == NSOrderedDescending) {
        return 0;
    }
    
    if([calendar.maximumDate compare:date] == NSOrderedAscending) {
        return 0;
    }
    
    if([self.delegate respondsToSelector:@selector(calendar:eventForDate:)]) {
        BXGCalendarDateEvent event = [self.delegate calendar:self eventForDate:date];
        if(event != BXGCalendarDateEventNone) {
            return 1;
        }
    }
    return 0;
}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date {
    
    if([self.delegate respondsToSelector:@selector(calendar:eventForDate:)]) {
        
        BXGCalendarDateEvent event = [self.delegate calendar:self eventForDate:date];
        switch (event) {
            case BXGCalendarDateEventNone: {
                
            }break;
            case BXGCalendarDateEventRed: {
                return @[[UIColor colorWithHex:0xFF554C]];
            }break;
            case BXGCalendarDateEventGreen: {
                return @[[UIColor colorWithHex:0x50E3C2]];
            }break;
        }
    }
    return @[appearance.eventDefaultColor];
}
@end
