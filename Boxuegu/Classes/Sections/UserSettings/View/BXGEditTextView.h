//
//  BXGEditTextView.h
//  Boxuegu
//
//  Created by apple on 2018/1/13.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FinishBlockType)(NSString* content);

@interface BXGEditTextView : UIView

/**
 <#Description#>

 @param limitCount 如果传0, 表示使用默认大小
 @param placeholder 默认描述文字
 @return 返回创建的对象
 */
- (instancetype)initLimitCount:(NSInteger)limitCount
                    andContent:(NSString*)content
                andPlaceholder:(NSString*)placeholder
                andFinishBlock:(FinishBlockType)finishBlock;

- (NSString*)content;

- (void)finishEdit;

@end
