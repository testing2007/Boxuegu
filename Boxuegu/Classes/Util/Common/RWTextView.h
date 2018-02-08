//
//  RWTextView.h
//  RW
//
//  Created by RenyingWu on 2017/7/20.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OverMaxCountBlockType)();

@interface RWTextView : UITextView

@property (nonatomic, strong) UILabel *placeHolderLabel; /// 占位Label
@property (nonatomic, strong) UILabel *counterLabel; /// 文字限制数量Label


@property(nonatomic, assign) NSInteger countNumber; /// 文字数量限制
@property(nonatomic, assign) NSString *placeHolder; /// 占位文字



@property (nonatomic, assign) CGFloat minimumHeight;
@property (nonatomic, assign) CGFloat maximumHeight;
@property (nonatomic, assign) BOOL isAutoSizeFit;
@property (nonatomic, readonly) BOOL hasEmoji;


@property (nonatomic, copy) OverMaxCountBlockType overMaxCountBlock;


@end
