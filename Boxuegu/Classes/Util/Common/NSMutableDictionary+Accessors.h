//
//  NSDictionary+Accessors.h
//  Belle
//
//  Created by Allen Hsu on 1/11/14.
//  Copyright (c) 2014 Allen Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Accessors)

- (BOOL)isKindOfClass:(Class)aClass forKey:(NSString *)key;
- (BOOL)isMemberOfClass:(Class)aClass forKey:(NSString *)key;
- (BOOL)isArrayForKey:(NSString *)key;
- (BOOL)isDictionaryForKey:(NSString *)key;
- (BOOL)isStringForKey:(NSString *)key;
- (BOOL)isNumberForKey:(NSString *)key;
//get
- (NSArray *)arrayForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
- (NSNumber *)numberForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key;
- (int)intForKey:(NSString *)key;
- (unsigned int)unsignedIntForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (NSUInteger)unsignedIntegerForKey:(NSString *)key;
- (long long)longLongForKey:(NSString *)key;
- (unsigned long long)unsignedLongLongForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;

//*
//update
- (BOOL)updateArray:(NSArray*)array forKey:(NSString *)key;
- (BOOL)updateDictionary:(NSDictionary*)dict forKey:(NSString *)key;
- (BOOL)updateString:(NSString*)string forKey:(NSString *)key;
- (BOOL)updateNSNumber:(NSNumber*)number forKey:(NSString *)key;
- (BOOL)updateDouble:(double)doubleValue forKey:(NSString *)key;
- (BOOL)updateFloat:(float)floatValue forKey:(NSString *)key;
- (BOOL)updateInt:(int)intValue forKey:(NSString *)key;
- (BOOL)updateUnsignedInt:(unsigned int)unsignedIntValue forKey:(NSString *)key;
- (BOOL)updateNSInteger:(NSInteger)integerValue forKey:(NSString *)key;
- (BOOL)updateNSUInteger:(NSUInteger)unsignedIntegerValue forKey:(NSString *)key;
- (BOOL)updateLongLong:(long long)longLongValue forKey:(NSString *)key;
- (BOOL)updateUnsignedLongLong:(unsigned long long)unsignedLongLongValue forKey:(NSString *)key;
- (BOOL)updateBool:(BOOL)boolValue forKey:(NSString *)key;
//*/
@end
