//
//  BXGBaseNaviController.h
//  Boxuegu
//
//  Created by RW on 2017/4/12.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarElement : NSObject
@property(nonatomic, weak) id target;
@property(nonatomic, assign) SEL sel;
@property(nonatomic, weak) NSString *imageName;
@property(nonatomic, weak) NSString *text;
@property(nonatomic, assign) CGSize size;
@property(nonatomic, weak) UIColor *tintColor;
@end

@interface BXGBaseNaviController : UINavigationController
- (UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void(^)())completion;
- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
                withTarget:(id)target
                backAction:(SEL)backAction;


-(NSArray<UIBarButtonItem*>*)createNaviBarItemsWithBarElements:(NSArray<BarElement*>*)arrBarElements andBarItemSpace:(CGFloat)diffSpace;
;
@end

@interface UINavigationController(BXGBaseNaviController)
- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
                 needLogin:(BOOL)needLogin;

@end
