//
//  BXGConstruePlanTagListView.h
//  Boxuegu
//
//  Created by wurenying on 2018/1/11.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGConstruePlanTagModel: NSObject
- (instancetype)initWithTitle:(NSString *)title andColor:(UIColor *)color;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *color;
@end

@interface BXGConstruePlanTagListView : UIView
@property (nonatomic, strong) NSArray<BXGConstruePlanTagModel *> *modelArray;
@end
