//
//  BXGCommunityAttentionVC.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/28.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ShowTypeAttention = 0,
    ShowTypeHome,
} ShowType;

@interface BXGCommunityAttentionVC : BXGBaseViewController
-(instancetype)initWithType:(ShowType)type;
@end
