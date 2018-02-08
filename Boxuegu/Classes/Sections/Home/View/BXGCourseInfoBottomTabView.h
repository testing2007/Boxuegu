//
//  BXGCourseInfoBottomTabView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, BXGCourseInfoBottomTabType) {
    BXGCourseInfoBottomTabTypeApply,
    BXGCourseInfoBottomTabTypeFreeCourse,
    BXGCourseInfoBottomTabTypeMiniCourse,
    BXGCourseInfoBottomTabTypeProCourse,
    BXGCourseInfoBottomTabTypeProCourseNoSample,
};
typedef NS_ENUM(NSUInteger, BXGCourseInfoBottomTabResponseType) {
    BXGCourseInfoBottomTabResponseTypeSample,
    BXGCourseInfoBottomTabResponseTypeConsult,
    BXGCourseInfoBottomTabResponseTypeLearn,
    BXGCourseInfoBottomTabResponseTypeOrder,
};

@interface BXGCourseInfoBottomTabView : UIView
@property (nonatomic, assign) BXGCourseInfoBottomTabType type;
@property (nonatomic, copy) void(^didSelectedBtn)(BXGCourseInfoBottomTabResponseType type);
@end
