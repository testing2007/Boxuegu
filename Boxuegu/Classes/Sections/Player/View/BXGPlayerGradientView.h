//
//  BXGPlayerGradientView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/11/7.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BXGPlayerGradientViewType) {
    BXGPlayerGradientViewTypeHeader,
    BXGPlayerGradientViewTypeFooter,
};


@interface BXGPlayerGradientView : UIView
- (instancetype)initWithType:(BXGPlayerGradientViewType)type;
@end
