//
//  BXGPraiseCoursePopView.h
//  demo-PopView
//
//  Created by RenyingWu on 2017/7/20.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGCourseDetailViewModel.h"

typedef void(^CommitBlockType)(NSInteger star,NSString *text);
typedef void(^CloseBlockType)();

@interface BXGPraiseCoursePopView : UIView

@property (nonatomic, copy) CommitBlockType commitBlock;
@property (nonatomic, copy) CloseBlockType closeBlock;

@end
