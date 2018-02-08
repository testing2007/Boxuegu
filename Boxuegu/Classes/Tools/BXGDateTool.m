//
//  BXGDate.m
//  Boxuegu
//
//  Created by Renying Wu on 2017/4/21.
//  Copyright © 2017年 itcast. All rights reserved.
//
#define kDayTimeInterval (60 * 60 * 24)
#import "BXGDateTool.h"

@interface BXGDateTool ()
@property (nonatomic, strong) NSCalendar *calender;
@property (nonatomic, assign) NSUInteger option;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSDateFormatter *shortCNformatter;
@property (nonatomic, strong) NSDateFormatter *longCNformatter;
@property (nonatomic, strong) NSDateFormatter *timeformatter;
@property (nonatomic, strong) NSDateFormatter *shortTimeformatter;
@property (nonatomic, strong) NSMutableDictionary *formatterDict;
@end

@implementation BXGDateTool

static BXGDateTool *instance;
+ (instancetype)share {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BXGDateTool new];
    });
    return instance;
}

- (NSMutableDictionary *)formatterDict {
    if(_formatterDict != nil) {
        _formatterDict = [NSMutableDictionary new];
    }
    return _formatterDict;
}

- (instancetype)init {

    self = [super init];
    if(self){
        NSCalendar *calendar = [NSCalendar currentCalendar];
        self.calender = calendar;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        self.formatter = formatter;
        formatter.timeZone = [NSTimeZone localTimeZone];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDateFormatter *shortCNformatter = [[NSDateFormatter alloc]init];
        self.shortCNformatter = shortCNformatter;
        shortCNformatter.timeZone = [NSTimeZone localTimeZone];
        [shortCNformatter setDateFormat:@"MM月d日"];
        
        NSDateFormatter *longCNformatter = [[NSDateFormatter alloc]init];
        self.longCNformatter = longCNformatter;
        longCNformatter.timeZone = [NSTimeZone localTimeZone];
        [longCNformatter setDateFormat:@"yyyy年MM月d日"];
        
        NSDateFormatter *timeformatter = [[NSDateFormatter alloc]init];
        self.timeformatter = timeformatter;
        [timeformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
       
        NSDateFormatter *shortTimeformatter = [[NSDateFormatter alloc]init];
        self.shortTimeformatter = shortTimeformatter;
        shortTimeformatter.timeZone = [NSTimeZone localTimeZone];
        [shortTimeformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
    }
    return self;
}

/**
 获得from:前天length:7天的Date
 @return Date Array
 */
- (NSArray<NSDate *> *)getWeekDate{

    NSDate *today = [NSDate date];
    
    return [self dateArrayForDate:today andDayOffset:-2 andLength:7];
}

- (NSArray<NSDate *> *)dateArrayForDate:(NSDate *)date andDayOffset:(NSInteger)offset andLength:(NSInteger)length {

    NSMutableArray *marr = [NSMutableArray new];
    NSDate *baseDate = [date dateByAddingTimeInterval: + kDayTimeInterval * offset];
    for(NSInteger i = 0; i < length; i++) {
        
        NSDate *newDate = [baseDate dateByAddingTimeInterval: i * kDayTimeInterval];
        [marr addObject:newDate];
    }
    return marr.copy;
}

- (NSDate *)dateFormRequestDateString:(NSString *)dateString {

    if(dateString) {
    
        return [self.formatter dateFromString:dateString];
    }
    return nil;
}

/**
 获取当月有多少日

 @param date 指定日期
 @return 指定日期月份的总日数
 */
- (NSInteger)countOfDayForMonthWithDate:(NSDate *)date {
    
    if(!date || ![date isKindOfClass:[NSDate class]]){
    
        return 0;
    }
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}


/**
 获取指定日期该月份的所有日期数组

 @param date 指定日期
 @return 获取指定日期该月份的所有日期数组
 */
- (NSArray <NSDate *>*)dateArrayForMonthWithDate:(NSDate *)date {
    
    NSDateComponents *components = [self.calender components:NSCalendarUnitYear| NSCalendarUnitMonth fromDate:date];
    // [components setDay:1];
    NSDate *thisMonthDate = [self.calender dateFromComponents:components];
    NSInteger count = [self countOfDayForMonthWithDate:thisMonthDate];
    
    NSMutableArray *mArray = [NSMutableArray new];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    for(NSInteger i = 0; i < count; i ++) {
    
        [adcomps setYear:0];
        [adcomps setMonth:0];
        [adcomps setDay:i];
        
        NSDate *newdate = [self.calender dateByAddingComponents:adcomps toDate:thisMonthDate options:0];
        [mArray addObject:newdate];
    }

    return mArray;
}



- (NSString *)convertDateString:(NSString *)dateString toFormat:(NSString *)toFormat; {
    NSDateFormatter *fromFormatter = self.timeformatter;
    NSDateFormatter *toFormatter = [self getFormatter:toFormat];
    
    NSDate *date= [fromFormatter dateFromString:dateString];
    if(!date){
        return nil;
    }
    return [toFormatter stringFromDate:date];
}

// format 缓存方法
- (NSDateFormatter *)makeFormatter:(NSString *)format; {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.timeZone = [NSTimeZone localTimeZone];
    formatter.locale = [NSLocale currentLocale];
    [formatter setDateFormat:format];
    self.formatterDict[format] = formatter;
    return formatter;
}
- (NSDateFormatter *)getFormatter:(NSString *)format; {
    
    NSDateFormatter *formatter = self.formatterDict[format];
    if(formatter == nil) {
        formatter = [self makeFormatter:format];
    }
    return formatter;
}

- (NSString *)translateDateString:(NSString *)dateString toFormat:(NSString *)toFormat {
    return nil;
}

/**
 获取一个月后的日期

 @param date 指定日期
 @return 该日期的一个月后的日期
 */
- (NSDate *)dateForNextMonthWithDate:(NSDate *)date {
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:1];
    
    [adcomps setDay:0];
    
    NSDate *newdate = [self.calender dateByAddingComponents:adcomps toDate:date options:0];
    
    
    return newdate;
    
}

/**
 获取指定日期的月份第一天

 @param date 指定日期
 @return 该月份第一天
 */
- (NSDate *)dateForLastMonthWithDate:(NSDate *)date {
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    [adcomps setMonth:-1];
    [adcomps setDay:0];
    
    NSDate *newdate = [self.calender dateByAddingComponents:adcomps toDate:date options:0];
    return newdate;
}

/**
 判断指定日期是今天

 @param date 指定日期
 @return 是否为今天
 */
- (BOOL)isToday:(NSDate *)date {

    NSDateComponents *todayComponents = [self.calender components:NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay fromDate:[NSDate new]];
    
    NSDateComponents *components = [self.calender components:NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay fromDate:date];
    
    if(todayComponents.day != components.day) {
    
        return false;
    }
    
    if(todayComponents.month != components.month) {
        
        return false;
    }
    
    if(todayComponents.year != components.year) {
    
        return false;
    }
    
    return true;
}



/**
 获取指定日期时间元素 (月,日,年)

 @param date 指定日期
 @return 时间元素
 */
- (NSDateComponents *)dateComponentsForDate:(NSDate *)date {

    NSDateComponents *components = [self.calender components:NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay fromDate:date];

    return components;
}

/**
 日期转换成 请求格式日期字符串

 @param date 指定日期
 @return @"yyyy-MM-dd"
 */
- (NSString *)formaterForRequest:(NSDate *)date {

    return [self.formatter stringFromDate:date];
}

/**
 日期转换成 短中文显示格式

 @param date 指定日期
 @return @"MM月d日"
 */
- (NSString *)formaterForshortCN:(NSDate *)date {
    
    return [self.shortCNformatter stringFromDate:date];
}

/**
 日期格式转换 (去掉秒)

 @param str @"yyyy-MM-dd HH:mm:SS"
 @return @"yyyy-MM-dd HH:mm"
 */
- (NSString*)shortTimeformatFromLong:(NSString *)str;{
    
    NSDate *date= [self.timeformatter dateFromString:str];
    if(!date){
    
        return nil;
    }
    
    return [self.shortTimeformatter stringFromDate:date];
}

- (NSString*)convertYYYYMMDDHHMMSSToYYYYMMDD:(NSString *)str;{
    
    NSDate *date= [self.timeformatter dateFromString:str];
    if(!date){
        
        return nil;
    }

    return [self.formatter stringFromDate:date];
}
- (NSString *)longRequestDateStringForDate:(NSDate *)date; {

    return [self.timeformatter stringFromDate:date];
}
- (NSDate *)dateFormFormaterStringForLongRequest:(NSString *)string; {

    return [self.timeformatter dateFromString:string];
}



// string 转 date
- (NSDate *)convertDateWithString:(NSString *)dateString fromFormat:(NSString *)fromFormat {
    
    NSDateFormatter *fromFormatter = [self getFormatter:fromFormat];
    NSDate *date= [fromFormatter dateFromString:dateString];
    return date;
}

// string 转 string
- (NSString *)convertDateString:(NSString *)dateString fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat; {
    
    NSDate *date = [self convertDateWithString:dateString fromFormat:fromFormat];
    NSString *result = [self convertDateStringWithDate:date toFormat:toFormat];
    
    return result;
}

// date 转 string
- (NSString *)convertDateStringWithDate:(NSDate *)date toFormat:(NSString *)toFormat {
    
    NSDateFormatter *toFormatter = [self getFormatter:toFormat];
    if(!date){
        return nil;
    }
    return [toFormatter stringFromDate:date];
}


@end

@implementation NSString(BXGDateTool)

- (NSString *)converDateStringFromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat; {
    
    return [[BXGDateTool share] convertDateString:self fromFormat:fromFormat toFormat:toFormat];
}

- (NSString *)converDateStringToFormat:(NSString *)toFormat {
    return [[BXGDateTool share] convertDateString:self toFormat:toFormat];
}

- (NSDate *)converDateFromFormat:(NSString *)fromFormat {
    return [[BXGDateTool share] convertDateWithString:self fromFormat:fromFormat];
}

@end

@implementation NSDate(BXGDateTool)

- (NSString *)converDateStringToFormat:(NSString *)toFormat {
    return [[BXGDateTool share] convertDateStringWithDate:self toFormat:toFormat];
}
@end


