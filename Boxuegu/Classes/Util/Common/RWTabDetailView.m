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
@synthesize selectedIndex = _selectedIndex;
#pragma mark - Init
- (instancetype)initWithDetailViewArrary:(NSArray<UIView *> *)detailViewArray; {

    self = [super initWithFrame:CGRectZero];
    if(self){
    
        self.detailViewArray = detailViewArray;
        
        [self installUI];
    }
    return self;
}
#pragma mark - Interface

- (void)setDetailViewArray:(NSArray<UIView *> *)detailViewArray {

    // 移除原先的view
    for (NSInteger i = 0; i < _detailViewArray.count; i++) {
        
        [_detailViewArray[i] removeFromSuperview];
    }
    _detailViewArray = nil;
    
    // 添加新的view
    _detailViewArray = detailViewArray;
    [self installUI];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {

    // selectedIndex 安全判断
    if(self.detailViewArray.count <= 0 || selectedIndex <= 0){
    
        selectedIndex = 0;
    }else if(selectedIndex >= self.detailViewArray.count) {
    
        selectedIndex = self.detailViewArray.count - 1;
    }
    
    // 滚动
    if(self.detailViewArray.count <= 0){
     
        return;
    }
    
    if(_selectedIndex == selectedIndex) {
    
        return;
    }
    _selectedIndex = selectedIndex;
    [self scrollToIndex:selectedIndex];
}

- (NSInteger)selectedIndex {

    return _selectedIndex;
}

#pragma mark - UI
- (void)installUI {

    self.delegate = self;
    
    // Detail
    UIView *lastView = nil;
    for (NSInteger i = 0; i < self.detailViewArray.count; i++) {
        
        UIView *view = self.detailViewArray[i];
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
        
        if(i == self.detailViewArray.count - 1){
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.offset(0);
            }];
        }
    }
}
#pragma mark Scroll View Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = ((scrollView.contentOffset.x + (scrollView.bounds.size.width / 2)) / scrollView.bounds.size.width);
    
    
    if(_selectedIndex != index) {
    
        _selectedIndex = index;
        
        if(self.indexChangedBlock &&  self.detailViewArray.count > 0) {
            
            
            self.indexChangedBlock(self.detailViewArray[index], index);
        }
    }
}

- (void)scrollToIndex:(NSInteger)index {
    
    if(index >= 0 && self.detailViewArray.count > 0){
    
        [self scrollRectToVisible:self.detailViewArray[index].frame animated:true];
    }

    // self scrollto
//    CGFloat y = self.contentOffset.y;
//    self.contentOffset = CGPointMake(index * self.bounds.size.width, y);
}
    
@end
