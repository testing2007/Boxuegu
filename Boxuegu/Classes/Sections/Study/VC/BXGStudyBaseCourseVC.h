//
//  BXGStudyCourceBaseController.h
//  Boxuegu
//
//  Created by HM on 2017/4/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface BXGStudyBaseCourseVC : BXGBaseViewController
// @property (nonatomic, assign) BOOL contentEmpty;
@property (nonatomic, weak) UITableView *maskForNoCourseView;
@property (nonatomic, weak) UITableView *maskloadFailedView;
@property (nonatomic, weak) UITableView *maskView;
@property (nonatomic, strong) UIView *loadingMaskView;
@property (nonatomic, strong) UIActivityIndicatorView *aiView;

- (void)installNoCourseMaskView:(NSString *)courseDesString;
- (void)installLoadFailedMaskView;
@end
