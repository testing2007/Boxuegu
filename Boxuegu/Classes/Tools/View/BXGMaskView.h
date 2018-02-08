//
//  BXGMaskView.h
//  Boxuegu
//
//  Created by RW on 2017/6/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BXGMaskView;

typedef enum : NSUInteger {
    BXGMaskViewTypeStudyCenterEmpty,
    BXGMaskViewTypeLoadFailed,
    BXGMaskViewTypeDownloadEmpty,
    BXGMaskViewTypeDownloadedEmpty,
    BXGMaskViewTypeDownloadingEmpty,
    BXGMaskViewTypeNoPlan,
    BXGMaskViewTypeRest,
    BXGMaskViewTypeCourseEmpty,
    BXGMaskViewTypeNoMessage,
    BXGMaskViewTypeNoRecentLearned,
    BXGMaskViewTypeNoNetwork,
    BXGMaskViewTypeNoPraise,
    BXGMaskViewTypeNoLogin,
    BXGMaskViewTypeNoNote,
    BXGMaskViewTypeNoTopicPage,
    BXGMaskViewTypeNoPraisePerson,
    BXGMaskViewTypeNoRemindPerson,
    BXGMaskViewTypeNoAttentionPerson,
    BXGMaskViewTypeNoCoupon,
    BXGMaskViewTypeNoData,
    BXGMaskViewTypeNoSearchInfo,
    BXGMaskViewTypeNoConstruePlan,
} BXGMaskViewType;

typedef enum : NSUInteger {
    BXGButtonMaskViewTypeNoOrder,
    BXGButtonMaskViewTypeLoadFailed,
    BXGButtonMaskViewTypeNoLogin,
    BXGButtonMaskViewTypeNoFilterCourse,
} BXGButtonMaskViewType;

typedef enum : NSUInteger {
    BXGLoadingMaskViewTypeNormal,
} BXGLoadingMaskViewType;

@interface UIView (MaskView)

// Loading Mask
- (void)installLoadingMaskView;
- (void)installLoadingMaskViewWithInset:(UIEdgeInsets)inset;

// Normal Mask
- (void)installMaskView:(BXGMaskViewType)type;
- (void)installMaskView:(BXGMaskViewType)type andInset:(UIEdgeInsets)inset;

// Button Mask
- (void)installMaskView:(BXGButtonMaskViewType)type buttonBlock:(void (^)())buttonBlock;
- (void)installMaskView:(BXGButtonMaskViewType)type andInset:(UIEdgeInsets)inset buttonBlock:(void (^)())buttonBlock;

// Remove
- (void)removeMaskView;
@end


