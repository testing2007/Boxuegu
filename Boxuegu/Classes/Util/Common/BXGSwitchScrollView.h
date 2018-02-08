//
//  BXGSwitchScrollView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGSwitchScrollView : UIView
{
    __weak id _target;
    SEL _action;
}
- (void)setLeft:(NSString *_Nullable)title andView:(UIView *)view;
- (void)setRight:(NSString *)title andView:(UIView *)view;
- (void)addTarget:(id)target action:(nonnull SEL)action;

@property(nonatomic, assign, readonly) NSInteger selectedSegmentIndex; //0-代表左边, 1-代表右边

#pragma mark - Operation
- (void)clickLeftBtn;
- (void)clickRightBtn;
@end
