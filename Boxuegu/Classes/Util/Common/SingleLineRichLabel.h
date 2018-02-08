//
//  SingleLineRichLabel.h
//  ImageTextViewPrj
//
//  Created by apple on 2017/8/14.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SingleLineRichLabel;
typedef void(^ActiveBlock)(SingleLineRichLabel*, void (^)(BOOL bSuccess));
typedef void(^InactiveBlock)(SingleLineRichLabel*, void (^)(BOOL bSuccess));

@interface SingleLineRichLabel : UILabel

@property(nonatomic, assign) NSInteger value;

//创建 图片+数字 复合控件, 支持交互, 点亮+1, 非点亮-1
+(instancetype) createRichLabelActiveImage:(UIImage *)activeImage
                             inactiveImage:(UIImage *)inactiveImage
                                     value:(NSInteger)value
                                   bActive:(BOOL)bActive
                               activeBlock:(ActiveBlock)activeBlock
                             inactiveBlock:(InactiveBlock)inactiveBlock;

-(void) setRichLabelActiveImage:(UIImage *)activeImage
                             inactiveImage:(UIImage *)inactiveImage
                                     value:(NSInteger)value
                                   bActive:(BOOL)bActive
                               activeBlock:(ActiveBlock)activeBlock
                             inactiveBlock:(InactiveBlock)inactiveBlock;

//创建 图片+数字 复合控件, 不支持交互, 相当于只读显示
+(instancetype) createRichLabelImage:(UIImage *)image
                               value:(NSInteger)value;
-(void) setRichLabelImage:(UIImage *)activeImage
                    value:(NSInteger)value;

//创建 纯图片控件 支持交互
+(instancetype) createRichLabelActiveImage:(UIImage *)activeImage
                             inactiveImage:(UIImage *)inactiveImage
                                   bActive:(BOOL)bActive
                               activeBlock:(ActiveBlock)activeBlock
                             inactiveBlock:(InactiveBlock)inactiveBlock;
-(void) setRichLabelActiveImage:(UIImage *)activeImage
                             inactiveImage:(UIImage *)inactiveImage
                                   bActive:(BOOL)bActive
                               activeBlock:(ActiveBlock)activeBlock
                             inactiveBlock:(InactiveBlock)inactiveBlock;
@end
