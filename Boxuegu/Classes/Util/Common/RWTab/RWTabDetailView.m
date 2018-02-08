//
//  RWTabDetailView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/28.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "RWTabDetailView.h"

@interface RWTabDetailView() <UIScrollViewDelegate>
@end

@implementation RWTabDetailView
#pragma mark - Init
- (instancetype)initWithDetailViews:(NSArray<UIView *> *)detailViews; {
    self = [super initWithFrame:CGRectZero];
    if(self){

        self.detailViews = detailViews;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return self;
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    if(self.superview) {
        
    }else {
        self.detailViews = nil;
    }
}

- (void)dealloc {
    
}

#pragma mark - Interface
- (void)setDetailViews:(NSArray<UIView *> *)detailViews {
    // 移除原先的view
    for (NSInteger i = 0; i < _detailViews.count; i++) {
        [_detailViews[i] removeFromSuperview];
    }
    _detailViews = nil;
    
    // 添加新的view
    _detailViews = detailViews;
    [self installUI];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    // currentIndex 安全判断
    if(self.detailViews.count <= 0 || currentIndex <= 0){
        currentIndex = 0;
    }else if(currentIndex >= self.detailViews.count) {
        currentIndex = self.detailViews.count - 1;
    }
    if(self.detailViews.count <= 0){
        return;
    }
    if(_currentIndex == currentIndex) {
        return;
    }
    
    // 滚动
    _currentIndex = currentIndex;
    [self scrollToIndex:currentIndex];
}

#pragma mark - UI
- (void)installUI {
    
    self.showsVerticalScrollIndicator = false;
    self.showsHorizontalScrollIndicator = false;
    self.delegate = self;
    // Detail
    UIView *lastView = nil;
    for (NSInteger i = 0; i < self.detailViews.count; i++) {
        UIView *view = self.detailViews[i];
        [self addSubview:view];
        if(!lastView) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(0);
            }];
        }else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right);
            }];
        }
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.offset(0);
            make.top.offset(0);
            make.width.equalTo(view.superview.mas_width);
            make.height.equalTo(view.superview.mas_height);
        }];
        lastView = view;
        if(i == self.detailViews.count - 1){
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(0);
            }];
        }
    }
}

#pragma mark Scroll View Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 计算当前显示页面标签
    NSInteger index = ((scrollView.contentOffset.x + (scrollView.bounds.size.width / 2)) / scrollView.bounds.size.width);
    if(_currentIndex != index) {
        _currentIndex = index;
        if(_indexChangedBlock && _detailViews.count > 0) {
            _indexChangedBlock(_detailViews[index], index);
        }
    }
}

/// 滚动到指定页面
- (void)scrollToIndex:(NSInteger)index {
    
    [self layoutIfNeeded];
    
    if(index >= 0 && self.detailViews.count > 0){
        [self setContentOffset:_detailViews[index].frame.origin animated:true];
        // [self scrollRectToVisible:_detailViews[index].frame animated:true];
    }
}
@end
