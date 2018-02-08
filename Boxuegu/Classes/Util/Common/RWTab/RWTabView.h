//
//  RWTabView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/17.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWTabView : UIView
- (instancetype)initWithTitles:(NSArray<NSString *>*)titles andDetailViews:(NSArray<UIView *>*)views;
@property (nonatomic, copy) void(^DidChangedIndex)(RWTabView *tab,NSInteger index,NSString *title,UIView *view);
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL bounces;
@end
