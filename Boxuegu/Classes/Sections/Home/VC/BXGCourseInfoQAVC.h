//
//  BXGCourseInfoQAVC.h
//  boxueguDemo
//
//  Created by RenyingWu on 2017/10/17.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGCourseInfoVC.h"

@interface BXGCourseInfoQAVC : UIViewController 
@property (nonatomic, weak) id<BXGCourseInfoFoldable> foldDelegate;
- (instancetype)initWithCourseId:(NSString *)courseId;
@end
