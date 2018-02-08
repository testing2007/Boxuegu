//
//  UIFont+Extension.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "UIFont+Extension.h"

@implementation UIFont (Extension)

#pragma mark - Interface

+ (UIFont *)bxg_fontRegularWithSize:(CGFloat)fontSize {
    
    return [self fontRegularWithSize:fontSize];
}

+ (UIFont *)bxg_fontMediumWithSize:(CGFloat)fontSize {
    
    return [self fontMediumWithSize:fontSize];
}

+ (UIFont *)bxg_fontSemiboldWithSize:(CGFloat)fontSize {
    
    return [self fontSemiboldWithSize:fontSize];
}

#pragma mark - Function

+ (UIFont *)fontRegularWithSize:(CGFloat)fontSize {
    
    if(@available (iOS 9.0, *)) {
        
        return [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];
    } else {
        
        return [UIFont systemFontOfSize:fontSize];
    }
}

+ (UIFont *)fontMediumWithSize:(CGFloat)fontSize {
    
    if(@available (iOS 9.0, *)) {
        
        return [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize];
    } else {
        
        return [UIFont systemFontOfSize:fontSize];
    }
}

+ (UIFont *)fontSemiboldWithSize:(CGFloat)fontSize {
    
    if(@available (iOS 9.0, *)) {
        
        return [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize];
    } else {
        
        return [UIFont systemFontOfSize:fontSize];
    }
}
@end
