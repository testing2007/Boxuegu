//
//  RWTab.h
//  RWTab
//
//  Created by RenyingWu on 2017/7/17.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RWTab;
@protocol RWTabDelegate <NSObject>

-(void)onChangeAction:(RWTab*)tab;

@end
typedef void(^OnChangeActionBlockType)(RWTab * tab);
@interface RWTab : UIView

// @property (nonatomic, assign) CGFloat titleHeight;
@property(nonatomic, weak) id<RWTabDelegate> delegate;

// - (void)addDetailViewController:(UIViewController *)controller andTitle:(NSString *)title;
// - (void)addDetailView:(UIView *)view andTitle:(NSString *)title;
 @property (nonatomic, assign) BOOL scrollEnabled;
// 封装思想 - (UIView *)makeTitleBtnWithTitle:(NSString *)title 使用block的方式实现

- (NSInteger)selectedSegmentIndex;

- (instancetype)initWithDetailViewArrary:(NSArray<UIView *> *)detailViewArray andTitleArray:(NSArray <NSString *>*)titleArray andCount:(NSInteger)count;

- (instancetype)initWithDetailViewArrary:(NSArray<UIView *> *)detailViewArray;
@property(nonatomic, copy) OnChangeActionBlockType onChangeActionBlock;
@end
