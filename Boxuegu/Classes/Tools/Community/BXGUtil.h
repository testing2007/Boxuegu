//
//  BXGUtil.h
//  CommunityPrj
//
//  Created by apple on 2017/9/2.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXGUtil : NSObject

+(instancetype)shareInstance;
-(CGFloat)calculateFontWidthByString:(NSString*)strContent font:(UIFont*)font limitMaxWidth:(CGFloat)limitMaxWidth;

@end
