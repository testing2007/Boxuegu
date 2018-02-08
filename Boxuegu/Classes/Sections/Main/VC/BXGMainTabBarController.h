//
//  BXGMainTabBarController.h
//  Boxuegu
//
//  Created by RW on 2017/4/12.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, BXGRootNavigationType) {
    BXGRootNavigationTypeHome = 0,
    BXGRootNavigationTypeCategory = 1,
    BXGRootNavigationTypeCommunity = 99999,
    BXGRootNavigationTypeStudy = 2,
    BXGRootNavigationTypeMe = 3,
};
@class BXGBaseNaviController;
@interface BXGMainTabBarController : UITabBarController
- (BXGBaseNaviController *)rootNavigationVCWithType:(BXGRootNavigationType)type;
- (void)pushToMeOrderDoneVC;
- (void)pushToMeOrderFailedVC;
- (void)pushToStudyRootVC;
- (void)pushToHomeRootVC;
+ (BXGMainTabBarController *)mainViewController;
@end
