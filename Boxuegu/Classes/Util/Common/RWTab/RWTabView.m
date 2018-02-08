//
//  RWTabView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/17.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "RWTabView.h"
#import "RWTabTitleView.h"
#import "RWTabDetailView.h"

@interface RWTabView()
@property (nonatomic, strong) RWTabDetailView *tabDetailView;
@property (nonatomic, strong) RWTabTitleView *tabTitlelView;
@property (nonatomic, strong) NSArray<UIView *> *views;
@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, assign) BOOL isLoaded;
@end
@implementation RWTabView


//- (void)didMoveToWindow {
//    [super didMoveToWindow];
//    
//    if(self.window) {
//        
//    }else {
//        
//    }
//}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if(self.superview) {
        
    }else {
        self.views = nil;
        self.titles = nil;
        [self.tabDetailView setDetailViews:nil];
        [self.tabTitlelView setTabTitleArray:nil];
        [self.tabDetailView removeFromSuperview];
        [self.tabTitlelView removeFromSuperview];
        self.tabDetailView = nil;
        self.tabTitlelView  = nil;
    }
}

- (void)dealloc {
    
}

- (BOOL)bounces {
    return self.tabDetailView.bounces;
}

- (void)setBounces:(BOOL)bounces {
    self.tabDetailView.bounces = bounces;
}

- (NSInteger)currentIndex {
    return self.tabTitlelView.currentIndexPath.item;
}
- (void)setCurrentIndex:(NSInteger)currentIndex {
    self.tabTitlelView.currentIndexPath = [NSIndexPath indexPathForItem:currentIndex inSection:0];
    self.tabDetailView.currentIndex = currentIndex;
}

- (instancetype)initWithTitles:(NSArray<NSString *>*)titles andDetailViews:(NSArray<UIView *>*)views {
    self = [super initWithFrame:CGRectZero];
    if(self) {
        NSAssert(titles.count == views.count, @"标题和控件数量不匹配");
        self.titles = titles;
        self.views = views;
        _tabDetailView = [[RWTabDetailView alloc]initWithDetailViews:views];
        _tabDetailView.pagingEnabled = true;
        _tabTitlelView = [[RWTabTitleView alloc]init];
        _tabTitlelView.tabTitleArray = titles;
        [self installUI];
    }
    return self;
}

- (void)installUI{
    __weak typeof (self) weakSelf = self;
    
    RWTabTitleView *titleView = _tabTitlelView;
    [self addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.offset(0);
        make.height.offset(44);
    }];
    UIView *spView = [UIView new];
    [self addSubview:spView];
    spView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom);
        make.left.equalTo(titleView);
        make.right.equalTo(titleView);
        make.height.offset(9);
    }];
    [self addSubview:_tabDetailView];
    [_tabDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spView.mas_bottom);
        make.left.equalTo(titleView);
        make.right.equalTo(titleView);
        make.bottom.offset(0);
    }];
    
    UIView *arrowView = [[UIView alloc]initWithFrame:CGRectZero];
    arrowView.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    arrowView.layer.cornerRadius = 1.5;
    
    titleView.cellClassName = @"RWTabTitleNormolCell";
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    titleView.arrowView = arrowView;
    
    titleView.didSelectedBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        if(weakSelf.DidChangedIndex){
            weakSelf.DidChangedIndex(weakSelf, indexPath.item, weakSelf.titles[indexPath.item], weakSelf.views[indexPath.item]);
        }
        weakSelf.tabDetailView.currentIndex = indexPath.item;
    };

    titleView.didChangedBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        
        
    };
    
    _tabDetailView.indexChangedBlock = ^(UIView *detailView, NSInteger index) {
        if(weakSelf.DidChangedIndex){
            weakSelf.DidChangedIndex(weakSelf, index, weakSelf.titles[index], weakSelf.views[index]);
        }
        
        weakSelf.tabTitlelView.currentIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
    };
    
    titleView.currentIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    titleView.didChangedArrowViewBlock = ^(UICollectionView *collectionView, UICollectionViewCell *cell, NSIndexPath *indexPath, UIView *arrowView) {
        [arrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell);
            make.width.offset(45);
            make.centerX.equalTo(cell);
            make.height.offset(3);
        }];
        // 第一次没有动画
        if(self.isLoaded) {
            [UIView animateWithDuration:0.2 animations:^{
                [collectionView layoutIfNeeded];
            }];
        }else {
            self.isLoaded = true;
            [collectionView layoutIfNeeded];
        }
    };
}
@end
