//
//  BXGStudyProCourseVC.m
//  Boxuegu
//
//  Created by apple on 17/6/3.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGStudyProCoursePlanDetailVC.h"
#import "BXGIndicateView.h"
#import "UIView+Frame.h"

#import "BXGStudyProCoursePlanTableVC.h"

#import <UIKit/UITableView.h>

#import "BXGProCourseSecduleModel.h"
#import "NSObject+yymodel.h"

#import "BXGProCoursePlayerContentVC.h"
#import "BXGMiniCoursePlayerContentVC.h"
#import "BXGBasePlayerVC.h"

typedef NS_ENUM(NSUInteger, BXGCourseSecduleState)
{
    BXGCourseSecduleStateBreak, //休息
    BXGCourseSecduleStateClass, //上课
};

@interface BXGStudyProCoursePlanDetailVC ()<UITableViewDataSource,UITableViewDelegate,FSCalendarDataSource,FSCalendarDelegate,UIGestureRecognizerDelegate>
{
    void * _KVOContext;
}
@property (nonatomic, strong) NSCalendar *gregorian;

@property (weak, nonatomic) IBOutlet FSCalendar *calendar;//

@property (weak, nonatomic) IBOutlet UISwitch *animationSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarHeightConstraint;//

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) UIPanGestureRecognizer *scopeGesture;

//@property (strong, nonatomic) UIButton *previousButton;//++
//@property (strong, nonatomic) UIButton *nextButton;//++

@property (strong, nonatomic) NSDictionary *courseSecdule;//课程安排, todo

//@property (strong, nonatomic) NSArray<BXGProCourseSecduleModel*> *arrCourseSecdule;//

@property (strong, nonatomic) BXGIndicateView *indicateView;//

- (IBAction)toggleClicked:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicateViewHeightContraint;//

// 课程计划表
@property (strong, nonatomic) UIView *planView;
@property (nonatomic, weak) BXGStudyProCoursePlanTableVC * planTableVC;

@property (nonatomic, strong) NSDate *courseMinDate;
//@property (nonatomic, strong) NSDate *courseMaxDate;

@property (nonatomic, assign) BOOL bFirstRequestForCourse;
@end

@implementation BXGStudyProCoursePlanDetailVC
//
//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    self = [super initWithCoder:coder];
//    if (self) {
//        self.dateFormatter = [[NSDateFormatter alloc] init];
//        self.dateFormatter.dateFormat = @"yyyy/MM/dd";
//    }
//    return self;
//}


- (void)awakeFromNib {

    [super awakeFromNib];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageName = @"日历学习计划页";
    
    self.navigationItem.title = @"学习计划";
    self.view.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
    self.bFirstRequestForCourse = YES;
    [self loadDataWithDateString:nil];
    
    __weak typeof (self) weakSelf = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    //初始化数据
//    self.courseSecdule = @{@"2017/05/01" : [NSNumber numberWithInt:BXGCourseSecduleStateBreak],
//                           @"2017/05/02" : [NSNumber numberWithInt:BXGCourseSecduleStateClass],
//                           @"2017/05/03" : [NSNumber numberWithInt:BXGCourseSecduleStateClass],
//                           @"2017/05/04" : [NSNumber numberWithInt:BXGCourseSecduleStateBreak]};
    self.calendar.backgroundColor = [UIColor whiteColor];
    self.calendar.appearance.headerMinimumDissolvedAlpha = 0;
    self.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];//现在中文
    //    self.calendar.placeholderType = FSCalendarPlaceholderTypeNone;//是否隐藏前后月日历显示
    self.calendar.delegate = self;
    self.calendar.dataSource = self;
    [self.calendar selectDate:[NSDate date] scrollToDate:YES];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendar action:@selector(handleScopeGesture:)];
    panGesture.delegate = self;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 2;
    [self.view addGestureRecognizer:panGesture];
    self.scopeGesture = panGesture;
    
    // While the scope gesture begin, the pan gesture of tableView should cancel.
    //[self.tableView.panGestureRecognizer requireGestureRecognizerToFail:panGesture];
    
    [self.calendar addObserver:self forKeyPath:@"scope" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:_KVOContext];
    
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.calendar.scope = FSCalendarScopeWeek;
    
    // For UITest
    self.calendar.accessibilityIdentifier = @"calendar";
    _indicateView = [BXGIndicateView acquireCustomView];
    [self.view addSubview:_indicateView];
    
    _planView = [UIView new];
    [self.view addSubview:_planView];
    
    // 添加课程计划表
    BXGStudyProCoursePlanTableVC *proCoursePlanTableVC = [[BXGStudyProCoursePlanTableVC alloc] initWithCourseModel:weakSelf.courseModel];
    self.planTableVC = proCoursePlanTableVC;
    [self addChildViewController:proCoursePlanTableVC];
    [self.planView addSubview:proCoursePlanTableVC.view];
    proCoursePlanTableVC.didSelectProCoursePlanBlock = ^(BXGProCourseModel *model) {
      
        BXGCourseModel *courseModel = weakSelf.courseModel;
        NSString *pointId = model.charpter_id;
        NSString *sectionId = model.parent_id;
        
        // BXGCourseModel *courseModel = self.viewModel.courseModel;
        BXGCourseOutlineSectionModel *sectionModel = [BXGCourseOutlineSectionModel new];
        sectionModel.idx = sectionId;
        BXGProCoursePlayerContentVC *proContentVC = [[BXGProCoursePlayerContentVC alloc]initWithCourseModel:courseModel andSectionModel:sectionModel];
        BXGBasePlayerVC *playerVC = [[BXGBasePlayerVC alloc] initWithCourseModel:courseModel ContentVC:proContentVC];
        [playerVC autoPlayWithPointId:pointId andVideoId:nil];
        playerVC.hidesBottomBarWhenPushed = true;
        [weakSelf.navigationController pushViewController:playerVC animated:true];
    };

    UIView *spView = [UIView new];
    spView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [self.view addSubview:spView];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.right.offset(0);
        make.height.offset(0);
    }];
    //去除日历控件顶上的那根横线. 不知道日历控件上面边框的颜色是怎么加进来的.
    [self.calendar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spView.mas_bottom).offset(-1);
    }];
    
    [_indicateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_calendar.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.height.mas_equalTo(34);
    }];
    
    [_planView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_indicateView.mas_bottom).offset(0);
        make.left.right.bottom.offset(0);
    }];
    
    [proCoursePlanTableVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.left.right.offset(0);
    }];
    
    //初始值
    self.planTableVC.planDate = [NSDate date];
}
- (void)loadDataWithDateString:(NSString *)dateString {

    BXGUserDefaults* userDefaults = [BXGUserDefaults share];
    BXGUserModel* userModel= userDefaults.userModel;
    if(!dateString) {
        dateString = [[BXGDateTool share] formaterForRequest:[NSDate date]];
    }
    
    
    __weak typeof (self) weakSelf = self;
    // __weak typeof(BXGStudyProCoursePlanDetailVC) *weakSelf = self;
    [[BXGNetWorkTool sharedTool] requestCalendarCourseMonthPlanWithUserId:userModel.user_id
                                                              andCourseId:weakSelf.courseModel.course_id
                                                                  andSign:userModel.sign
                                                            andDateString:dateString
                                                                 Finished:^(id  _Nullable responseObject)
     {
         if(responseObject)
         {
             NSNumber *succeed = responseObject[@"success"];
             if([succeed isKindOfClass:[NSNumber class]] && succeed.boolValue)
             {
                 NSArray *resultObject = responseObject[@"resultObject"];
                 if([resultObject isKindOfClass:[NSArray class]])
                 {
                     NSMutableDictionary *dictObj = [NSMutableDictionary new];
                     for(NSInteger i = 0; i < resultObject.count; i++)
                     {
                         BXGProCourseSecduleModel *model = [BXGProCourseSecduleModel yy_modelWithDictionary:resultObject[i]];
                         // model.plan_date = [[BXGDateTool share] convertYYYYMMDDHHMMSSToYYYYMMDD:model.plan_date];
                         if(model.plan_date)
                         {
                             [dictObj setObject:model forKey:model.plan_date];
                         }
                     }
                     NSArray* arrValues = [dictObj keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                         BXGProCourseSecduleModel *obj1Model = (BXGProCourseSecduleModel*)obj1;
                         BXGProCourseSecduleModel *obj2Model = (BXGProCourseSecduleModel*)obj2;
                         return [obj1Model.plan_date compare:obj2Model.plan_date];
                             }];
                     if(weakSelf.bFirstRequestForCourse && arrValues!=nil && arrValues.count>0)
                     {
                         weakSelf.bFirstRequestForCourse = NO;
                         weakSelf.courseMinDate = [weakSelf.dateFormatter dateFromString:arrValues[0]];
                         //weakSelf.courseMaxDate = [weakSelf.dateFormatter dateFromString:arrValues[arrValues.count-1]];
//                         weakSelf.planTableVC.planDate = weakSelf.courseMinDate;
                     }
                     weakSelf.courseSecdule = [NSDictionary dictionaryWithDictionary:dictObj];
                     [weakSelf.calendar reloadData];
                 }
             }
         }
         NSLog(@"%@", responseObject);
     } Failed:^(NSError * _Nonnull error) {
         NSLog(@"erro=%@", error.debugDescription);
     }];
}

- (void)dealloc
{
    [self.calendar removeObserver:self forKeyPath:@"scope" context:_KVOContext];
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == _KVOContext) {
        FSCalendarScope oldScope = [change[NSKeyValueChangeOldKey] unsignedIntegerValue];
        FSCalendarScope newScope = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
        NSLog(@"From %@ to %@",(oldScope==FSCalendarScopeWeek?@"week":@"month"),(newScope==FSCalendarScopeWeek?@"week":@"month"));
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - <UIGestureRecognizerDelegate>

// Whether scope gesture should begin
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    BOOL shouldBegin = self.planView.contentOffset.y <= -self.planView.contentInset.top;
//    //NSLog(@"contentOffset=[x=%f,y=%f], contentInset=[top=%f, left=%f, bottom=%f, right=%f]", self.tableView.contentOffset.x, self.tableView.contentOffset.y
//          , self.tableView.contentInset.top, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right);
//    if (shouldBegin) {
//        CGPoint velocity = [self.scopeGesture velocityInView:self.view];
//        switch (self.calendar.scope) {
//            case FSCalendarScopeMonth:
//                return velocity.y < 0;
//            case FSCalendarScopeWeek:
//                return velocity.y > 0;
//        }
//    }
//    return shouldBegin;
//}

-(NSString*)convertYYYYMMDD_Weekday:(NSDate*)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy年MM月dd日"];
    NSString *YYYYMMDD = [format stringFromDate:date];
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSDateComponents *theComponents = [self.gregorian components:NSCalendarUnitWeekday fromDate:date];
    NSString *weekday = [weekdays objectAtIndex:theComponents.weekday];
    
    return [NSString stringWithFormat:@"%@ %@", YYYYMMDD, weekday];
}

////begin
#pragma mark - FSCalendarDataSource

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        NSDate *showDate = calendar.selectedDate!=nil ? calendar.selectedDate : date;
        NSString *YYYYMMDD_Weekday = [self convertYYYYMMDD_Weekday:showDate];
        NSLog(@"%@",YYYYMMDD_Weekday);
//        self.indicateView.strSelectDay = YYYYMMDD_Weekday;
        [self.indicateView setSelDay:YYYYMMDD_Weekday];
        return @"今";
    }
    return nil;
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    if(self.courseSecdule && ([self.courseSecdule.allKeys containsObject:dateString]) )
    {
        if( ((BXGProCourseSecduleModel*)self.courseSecdule[dateString]).rest_has == YES)
        {
            return 1;
        }
        else
            return 1;
    }
    return 0;
}

#pragma mark - FSCalendarDelegate
- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    if(self.courseSecdule && ([self.courseSecdule.allKeys containsObject:dateString]) )
    {
        if( ((BXGProCourseSecduleModel*)self.courseSecdule[dateString]).rest_has == YES)
            return @[[UIColor colorWithHex:0x50E3C2]];
        else
        {
            return @[[UIColor colorWithHex:0xFF554C]];
        }
    }
    return @[appearance.eventDefaultColor];
}

//- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
//{
//    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
//
//    self.eventLabel.frame = CGRectMake(0, CGRectGetMaxY(calendar.frame)+10, self.view.frame.size.width, 50);
//
//}
//
//- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
//{
//    return monthPosition == FSCalendarMonthPositionCurrent;
//}
//
//- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
//{
//    return monthPosition == FSCalendarMonthPositionCurrent;
//}
//
//- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
//{
//    NSLog(@"did select date %@",[self.dateFormatter stringFromDate:date]);
//    [self configureVisibleCells];
//}
//
//- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
//{
//    NSLog(@"did deselect date %@",[self.dateFormatter stringFromDate:date]);
//    [self configureVisibleCells];
//}
////end

#pragma mark - <FSCalendarDelegate>

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    _calendarHeightConstraint.constant = CGRectGetHeight(bounds);
    [self.view layoutIfNeeded];
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.dateFormatter stringFromDate:date]);
    
    NSMutableArray *selectedDates = [NSMutableArray arrayWithCapacity:calendar.selectedDates.count];
    [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [selectedDates addObject:[self.dateFormatter stringFromDate:obj]];
    }];
    NSLog(@"selected dates is %@",selectedDates);
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }

    NSString *YYYYMMDD_Weekday = [self convertYYYYMMDD_Weekday:date];
    NSLog(@"%@",YYYYMMDD_Weekday);
    [self.indicateView setSelDay:YYYYMMDD_Weekday];
    self.planTableVC.planDate = date;
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"%s %@", __FUNCTION__, [self.dateFormatter stringFromDate:calendar.currentPage]);
}

- (void)calendarLessThanMinimumDate:(FSCalendar*)calendar
{
    [[BXGHUDTool share] showHUDWithString:@"上个月未开启学习计划"];
    NSLog(@"min");
}

- (void)calendarLargerThanMaximumDate:(FSCalendar*)calendar
{
    //[[BXGHUDTool share] showHUDWithString:@"在此之后没有学习计划"];
    NSLog(@"max");
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numbers[2] = {2,20};
    return numbers[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *identifier = @[@"cell_month",@"cell_week"][indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        return cell;
    }
}

/**
 * Asks the dataSource the minimum date to display.
 */
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return self.courseMinDate;
}

/**
 * Asks the dataSource the maximum date to display.
 */
//- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
//{
//    return self.courseMaxDate;
//}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        FSCalendarScope selectedScope = indexPath.row == 0 ? FSCalendarScopeMonth : FSCalendarScopeWeek;
        [self.calendar setScope:selectedScope animated:self.animationSwitch.on];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - Target actions

- (IBAction)toggleClicked:(id)sender
{
    if (self.calendar.scope == FSCalendarScopeMonth) {
        [self.calendar setScope:FSCalendarScopeWeek animated:_animationSwitch.on];
    } else {
        [self.calendar setScope:FSCalendarScopeMonth animated:_animationSwitch.on];
    }
}

@end
