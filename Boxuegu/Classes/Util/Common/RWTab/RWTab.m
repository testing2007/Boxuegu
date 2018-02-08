//
//  RWTab.m
//  RWTab
//
//  Created by RenyingWu on 2017/7/17.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "RWTab.h"

@interface RWTab() <UIScrollViewDelegate>

/**
 Tab头部视图
 */
@property (nonatomic, weak) UIView *tabTitleView;

/**
 Tab详情视图
 */
@property (nonatomic, strong) UIScrollView *tabDetailView;
@property (nonatomic, weak) UIView *tabArrowView;
@property (nonatomic, strong) NSMutableArray *tabTitleBtnArray;
@property (nonatomic, assign) NSInteger detailCount;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSMutableArray *subViewArray;

- (void)selectIndex:(NSInteger)index;

@end

@implementation RWTab

- (void)setScrollEnabled:(BOOL)scrollEnabled {

    _scrollEnabled = scrollEnabled;
    self.tabDetailView.scrollEnabled = scrollEnabled;
}

- (instancetype)initWithDetailViewArrary:(NSArray<UIView *> *)detailViewArray andTitleArray:(NSArray <NSString *>*)titleArray andCount:(NSInteger)count{

    self = [super initWithFrame:CGRectZero];
    for(NSInteger i = 0; i < count; i++) {
    
        [self addDetailView:detailViewArray[i] andTitle:titleArray[i]];
        self.detailCount = count;
    }
    [self installUI];
    return self;
}

- (instancetype)initWithDetailViewArrary:(NSArray<UIView *> *)detailViewArray; {
 
    self = [super initWithFrame:CGRectZero];
    
    for(NSInteger i = 0; i < detailViewArray.count; i++) {
        
        [self addDetailView:detailViewArray[i]];
    }
    self.detailCount = detailViewArray.count;
    [self installUI];
    return self;
}

#pragma mark - Getter Setter

- (NSMutableArray *)subViewArray {

    if(_subViewArray == nil) {
    
        _subViewArray = [[NSMutableArray alloc]init];
    }
    return _subViewArray;
}

- (NSMutableArray *)tabTitleBtnArray {
    
    if(_tabTitleBtnArray == nil) {
        
        _tabTitleBtnArray = [[NSMutableArray alloc]init];
    }
    return _tabTitleBtnArray;
}

#pragma mark - Public

- (void)addDetailViewController:(UIViewController *)controller andTitle:(NSString *)title; {
    
    // 添加到该View存在的VC上

    [self addDetailView: controller.view andTitle:title];
}

- (void)addDetailView:(UIView *)view andTitle:(NSString *)title; {
    
    UIView *btn = [self makeTitleBtnWithTitle:title];
    if(!view) {
    
        view = [UIView new];
    }
    
    [self.tabTitleBtnArray addObject:btn];
    [self.subViewArray addObject:view];
}

- (void)addDetailView:(UIView *)view; {

    if(!view) {
        
        view = [UIView new];
    }
    
    [self.subViewArray addObject:view];
}

#pragma mark - install UI

- (void)installUI {

    __weak typeof (self) weakSelf = self;
    // Weak(weakSelf);

#pragma mark install UI Frame
    
    // 声明
    UIView *tabTitleView = [UIView new];
    UIScrollView *tabDetailView = [UIScrollView new];
    UIView *tabArrowView = [UIView new];
    UIView *spView = [UIView new];
    
    
    tabDetailView.delegate = self;
    // 配置
    tabDetailView.pagingEnabled = true;
    // 接口
    self.tabTitleView = tabTitleView;
    self.tabDetailView = tabDetailView;
    self.tabArrowView = tabArrowView;
    self.tabDetailView.contentSize = CGSizeMake(1000, 1000);
    // 添加子视图
    [self addSubview:self.tabTitleView];
    [self addSubview:self.tabDetailView];
    [self.tabTitleView addSubview:tabArrowView];
    [self addSubview:spView];

    tabArrowView.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    tabArrowView.layer.cornerRadius = 1.5;
    // 设置约束
    CGFloat height = 44;
    [self.tabTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(0);
        make.left.right.offset(0);
        // make.height.equalTo(self.tabTitleView.superview).multipliedBy(0.2);
        // make.height.equalTo(self.tabTitleView.superview);
        make.height.offset(height);
        make.width.equalTo(tabTitleView.superview.mas_width);
    }];
    
    spView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.tabTitleView.mas_bottom);
        make.height.offset(9);
        make.left.right.offset(0);
    }];
    
    [self.tabDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(spView.mas_bottom);
        make.left.right.offset(0);
        make.bottom.offset(0);
    }];
    
#pragma mark install UI Elements
    
    // Detail
    UIView *lastView = nil;
    for (NSInteger i = 0; i < self.subViewArray.count; i++) {
    
        UIView *view = self.subViewArray[i];
        [self.tabDetailView addSubview:view];
        if(!lastView) {
        
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(0);
                // make.right.offset(0);
            }];
        }else {
        
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                //make.left.equalTo(view.superview.mas_right).multipliedBy(i);
                //make.right.equalTo(view.superview.mas_right).multipliedBy(i + 1);
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
        
        if(i == self.subViewArray.count - 1){
        
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
            
                make.right.offset(0);
            }];
        }
    }
    
#pragma mark Title View
    
    if(self.tabTitleBtnArray.count == 0) {
        
        return;
    }else {
    
        UIView *lastView = nil;
        for(NSInteger i = 0; i < self.tabTitleBtnArray.count; i++) {
            
            UIView *subView = self.tabTitleBtnArray[i];
            [self.tabTitleView addSubview:subView];
            if(!lastView) {
                
                
                [self.tabTitleBtnArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(0);
                    make.width.equalTo(subView.superview.mas_width).multipliedBy(1.0 / self.tabTitleBtnArray.count);
                }];
                
            }else {
                
                [self.tabTitleBtnArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(lastView.mas_right);
                    make.width.equalTo(self.tabTitleBtnArray[i - 1]);
                }];
                
            }
            
            [self.tabTitleBtnArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.bottom.offset(0);
                make.height.equalTo(self.tabTitleView);
            }];
            
            if(i == self.tabTitleBtnArray.count - 1){
                
                [self.tabTitleBtnArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(0);
                }];
            }else {
            
                UIView *spView = [UIView new];
                spView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
                [self.tabTitleView addSubview:spView];
                [spView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(11);
                    make.width.offset(1);
                    make.left.equalTo(subView.mas_right);
                    make.centerY.offset(0);
                }];
                lastView = spView;
                
            }
            // lastView = self.tabTitleBtnArray[i];
        }
    }
    
    

    
#pragma mark Install Arrow View

    if(weakSelf.tabTitleBtnArray.count > 0) {
    
        UIView *subView = weakSelf.tabTitleBtnArray[0];
        [weakSelf.tabArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
            make.height.offset(3);
            make.width.equalTo(weakSelf.tabArrowView.superview).multipliedBy(1.0 / weakSelf.tabTitleBtnArray.count * 0.2);
            make.centerX.equalTo(subView.mas_centerX);
        }];
    }
}

- (UIView *)makeTitleBtnWithTitle:(NSString *)title {

    UIButton *btn = [UIButton buttonWithType:0];
    if(!title) {
    
        title = @"";
    }
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    btn.tag = self.tabTitleBtnArray.count;
    [btn addTarget:self action:@selector(clickTitleTab:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - Response

- (void)clickTitleTab:(UIButton *)sender {
    
    NSInteger index = sender.tag;
    [self selectIndex:index];
}

#pragma mark Scroll View Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = ((scrollView.contentOffset.x + (scrollView.bounds.size.width / 2)) / scrollView.bounds.size.width);
    
    [self arrowIndex:index];
}

#pragma mark - Action

- (void)selectIndex:(NSInteger)index; {
    
    if(index >= self.detailCount) {
        
        return;
    }
    
    [self scrollToIndex:index];
    [self arrowIndex:index];
}

- (void)scrollToIndex:(NSInteger)index {
    
    CGFloat y = self.tabDetailView.contentOffset.y;
    self.tabDetailView.contentOffset = CGPointMake(index * self.tabDetailView.bounds.size.width, y);
}

- (void)arrowIndex:(NSInteger )index
{
    if(index == _currentIndex)
        return ;
    
    __weak typeof (self) weakSelf =self;
    if(index < self.tabTitleBtnArray.count)
    {
        UIView *subView = weakSelf.tabTitleBtnArray[index];
        
        [UIView animateWithDuration:0.2 animations:^
        {
            [weakSelf.tabArrowView mas_remakeConstraints:^(MASConstraintMaker *make)
            {
                
                make.bottom.offset(0);
                make.height.offset(3);
                make.width.equalTo(weakSelf.tabArrowView.superview).multipliedBy(1.0 / weakSelf.tabTitleBtnArray.count * 0.2);
                make.centerX.equalTo(subView.mas_centerX);
            }];
            [self.tabTitleView layoutIfNeeded];
        }];
    }

    for(NSInteger i = 0; i < self.tabTitleBtnArray.count; i++)
    {
        UIButton *btn = self.tabTitleBtnArray[i];
        if(i == index)
        {
            [btn setTitleColor:[UIColor colorWithHex:0x38ADFF] forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        }
        
    }
    self.currentIndex = index;
    
    if(_delegate!=nil && [_delegate respondsToSelector:@selector(onChangeAction:)])
    {
        [_delegate onChangeAction:self];
    }
    if(self.onChangeActionBlock)
    {
        self.onChangeActionBlock(self);
    }
}

- (NSInteger)selectedSegmentIndex
{
    return self.currentIndex;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self selectIndex:self.currentIndex];
}

- (void)dealloc {

}
@end
