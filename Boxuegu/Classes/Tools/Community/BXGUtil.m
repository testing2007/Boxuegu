//
//  BXGUtil.m
//  CommunityPrj
//
//  Created by apple on 2017/9/2.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "BXGUtil.h"

@implementation BXGUtil

+(instancetype)shareInstance
{
    static BXGUtil *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BXGUtil new];
    });
    return instance;
}

-(CGFloat)calculateFontWidthByString:(NSString*)strContent font:(UIFont*)font limitMaxWidth:(CGFloat)limitMaxWidth
{
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentLeft;
    label.text = strContent;
    label.font = font;
    CGSize labelSize = [label sizeThatFits:CGSizeMake(limitMaxWidth, MAXFLOAT)];
    CGFloat height = ceil(labelSize.height) + 1;
    return height;
}

@end
