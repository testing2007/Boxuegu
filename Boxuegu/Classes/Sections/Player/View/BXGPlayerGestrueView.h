//
//  BXGPlayerGestrueView.h
//  Boxuegu
//
//  Created by Renying Wu on 2017/7/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RWResponseView.h"

@interface BXGPlayerGestrueView : RWResponseView

typedef NS_ENUM(NSUInteger, BXGGestrueHorizontalDirectionType) {
    BXGGestrueHorizontalDirectionTypeNone,
    BXGGestrueHorizontalDirectionTypeTop,
    BXGGestrueHorizontalDirectionTypeBottom
};

typedef NS_ENUM(NSUInteger, BXGGestrueVerticalDirectionType) {
    BXGGestrueVerticalDirectionTypeNone,
    BXGGestrueVerticalDirectionTypeLeft,
    BXGGestrueVerticalDirectionTypeRight
};

@property (nonatomic, copy) void(^horizontalTouchMovedBlock)(BOOL isTop, float offset, BOOL isFirst, BOOL isLast);
//@property (nonatomic, copy) void(^horizontalTouchEndedBlock)();

@property (nonatomic, copy) void(^verticalTouchMovedBlock)(BOOL isLeft, float offset, BOOL isFirst, BOOL isLast);
//@property (nonatomic, copy) void(^verticalTouchEndedBlock)();

@property (nonatomic, copy) void(^tapBlock)(UIView *view);
@end
