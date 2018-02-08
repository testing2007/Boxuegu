//
//  BXGDate.h
//  Boxuegu
//
//  Created by Renying Wu on 2017/4/21.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(BXGDateTool)

/// 服务器日期格式 日期字符串 转换成 toformat 格式字符串 - format: yyyy-MM-dd
- (NSString *)converDateStringToFormat:(NSString *)toFormat;

/// fromformat 日期字符串 转换成 toformat 格式字符串 - format: yyyy-MM-dd
- (NSString *)converDateStringFromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat;

/// fromformat 日期字符串 转换成 NSDate - format: yyyy-MM-dd
- (NSDate *)converDateFromFormat:(NSString *)fromFormat;

@end

@interface NSDate(BXGDateTool)

/// NSDate 转换成 toformat 格式字符串 - format: yyyy-MM-dd
- (NSString *)converDateStringToFormat:(NSString *)toFormat;

@end

@interface BXGDateTool : NSObject

+ (instancetype)share;

// string 转 date
- (NSDate *)convertDateWithString:(NSString *)dateString fromFormat:(NSString *)fromFormat;

// date 转 string
- (NSString *)convertDateStringWithDate:(NSDate *)date toFormat:(NSString *)toFormat;

// string 转 string
- (NSString *)convertDateString:(NSString *)dateString fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat;

// yyyy-MM-dd HH:mm:ss
// yyyy年MM月dd日

- (NSString *)convertDateString:(NSString *)dateString toFormat:(NSString *)toFormat;

/**
 获得from:前天length:7天的Date
 @return Date Array
 */
- (NSArray<NSDate *> *)getWeekDate;

- (NSArray<NSDate *> *)dateArrayForDate:(NSDate *)date andDayOffset:(NSInteger)offset andLength:(NSInteger)length;

/**
 获取当月有多少日
 
 @param date 指定日期
 @return 指定日期月份的总日数
 */
- (NSInteger)countOfDayForMonthWithDate:(NSDate *)date;

/**
 获取指定日期该月份的所有日期数组
 
 @param date 指定日期
 @return 获取指定日期该月份的所有日期数组
 */
- (NSArray <NSDate *>*)dateArrayForMonthWithDate:(NSDate *)date;

/**
 获取一个月后的日期
 
 @param date 指定日期
 @return 该日期的一个月后的日期
 */
- (NSDate *)dateForNextMonthWithDate:(NSDate *)date;

/**
 获取指定日期的月份第一天
 
 @param date 指定日期
 @return 该月份第一天
 */
- (NSDate *)dateForLastMonthWithDate:(NSDate *)date;

/**
 判断指定日期是今天
 
 @param date 指定日期
 @return 是否为今天
 */
- (BOOL)isToday:(NSDate *)date;

/**
 获取指定日期时间元素 (月,日,年)
 
 @param date 指定日期
 @return 时间元素
 */
- (NSDateComponents *)dateComponentsForDate:(NSDate *)date;

/**
 日期转换成 请求格式日期字符串
 
 @param date 指定日期
 @return @"yyyy-MM-dd"
 */
- (NSString *)formaterForRequest:(NSDate *)date;

/**
 日期转换成 短中文显示格式
 
 @param date 指定日期
 @return @"MM月d日"
 */
- (NSString *)formaterForshortCN:(NSDate *)date;

/**
 日期格式转换 (去掉秒)
 
 @param str @"yyyy-MM-dd HH:mm:SS"
 @return @"yyyy-MM-dd HH:mm"
 */
- (NSString*)shortTimeformatFromLong:(NSString *)str;

//将YYYY-MM-dd HH:mm:ss 转 YYYY-MM-dd
- (NSString*)convertYYYYMMDDHHMMSSToYYYYMMDD:(NSString *)str;

- (NSDate *)dateFormRequestDateString:(NSString *)dateString;

- (NSString *)longRequestDateStringForDate:(NSDate *)date;

/**
 2017-08-09 19:54:03

 @return NSDate*
 */
- (NSDate *)dateFormFormaterStringForLongRequest:(NSString *)string;
@end
