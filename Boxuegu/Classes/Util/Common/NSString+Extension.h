//
//  NSString+Extension.h
//  Boxuegu
//
//  Created by apple on 2017/7/8.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

+(BOOL)isEmpty:(NSString*)nsstring;
-(BOOL)stringContainsEmoji;
-(NSString*)trimWhitespaceAndNewLineCharacterSet;

@end
