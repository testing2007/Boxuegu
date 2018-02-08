//
//  NSString+Extension.m
//  Boxuegu
//
//  Created by apple on 2017/7/8.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+(BOOL)isEmpty:(NSString*)nsstring
{
    BOOL bEmpty = NO;
    if(!nsstring ||
       nsstring == NULL ||
       nsstring.length==0 ||
       [nsstring isEqual:[NSNull null]] ||
       [nsstring isEqualToString:@"(null)"])
    {
        bEmpty = YES;
    }
    
    return bEmpty;
}

-(BOOL)stringContainsEmoji
{
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    return returnValue;
}

-(NSString*)trimWhitespaceAndNewLineCharacterSet {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
