//
//  BXGFilterSubjectView.h
//  Boxuegu
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGHome.h"

//typedef void (^ResetBlock)(void);
typedef void (^ConfirmBlock)(NSNumber *directionId, NSNumber *subjectId, NSNumber *tagId, NSString *directionName, NSString *subjectName, NSString *tagName);

@interface BXGFilterSubjectView : UIView

- (void)loadRequestType:(COURSE_TYPE)type
         andDirectionId:(NSNumber*)directionId
           andSubjectId:(NSNumber*)subjectId
               andTagId:(NSNumber*)tagId;

//@property(nonatomic, copy) ResetBlock resetBlock;
@property(nonatomic, copy) ConfirmBlock confirmBlock;

//外部传入的参数
@property(nonatomic, weak) NSNumber *directionId;
@property(nonatomic, weak) NSNumber *subjectId;
@property(nonatomic, weak) NSNumber *tagId;

@end
