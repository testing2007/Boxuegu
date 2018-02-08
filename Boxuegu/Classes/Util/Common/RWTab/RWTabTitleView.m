//
//  RWTabTitleView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "RWTabTitleView.h"

static NSString *cellId = @"RWTabTitleViewCell";

@interface RWTabTitleView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSIndexPath *_currentIndexPath;
    UICollectionView *_collectionView;
    BOOL _didLoadCell;
    BOOL _didLoadView;
}
@end

@implementation RWTabTitleView


- (void)dealloc {
    
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    super.backgroundColor = backgroundColor;
    _collectionView.backgroundColor = backgroundColor;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        _flowLayout = flowLayout;
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.showsVerticalScrollIndicator = false;
        collectionView.showsHorizontalScrollIndicator = false;
        _collectionView = collectionView;
    }
    return self;
}
- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing {
    _flowLayout.minimumLineSpacing = minimumLineSpacing;
}
- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing {
    _flowLayout.minimumInteritemSpacing = minimumInteritemSpacing;
}
- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    _flowLayout.scrollDirection = scrollDirection;
}
- (void)setArrowView:(UIView *)arrowView {
    
    if(!arrowView) {
        if(self.arrowView) {
            [self.arrowView removeFromSuperview];
        }
    }else {
        _arrowView = arrowView;
        [_collectionView addSubview:self.arrowView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    switch (self.cellSizeType) {
        case RWTabCellSizeTypeDivide: {
            self.flowLayout.minimumLineSpacing = 0;
            self.flowLayout.minimumInteritemSpacing = 0;
            if(self.flowLayout.scrollDirection == UICollectionViewScrollDirectionVertical) {
                // 垂直
                self.flowLayout.itemSize =  CGSizeMake(_collectionView.frame.size.width, _tabTitleArray.count?_collectionView.frame.size.height / _tabTitleArray.count:0);
            }else {
                // 水平
                self.flowLayout.itemSize = CGSizeMake(_tabTitleArray.count?_collectionView.frame.size.width / _tabTitleArray.count:0, _collectionView.frame.size.height);
            }
        }break;
        case RWTabCellSizeTypeCustom: {
            self.flowLayout.itemSize =  self.cellSize;
        }break;
        case RWTabCellSizeTypeEstablish: {
            self.flowLayout.estimatedItemSize = self.cellSize;
        }break;
        default:
            break;
    }
}

- (void)setTabTitleArray:(NSArray *)tabTitleArray {
    _tabTitleArray = tabTitleArray;
    [_collectionView reloadData];
}


- (void)installUI {                        
    
    UICollectionView *collectionView = _collectionView;
    collectionView.backgroundColor = self.backgroundColor;
    collectionView.frame = self.bounds;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self addSubview:collectionView];
    
    if(_cellNibName){
        [collectionView registerNib:[UINib nibWithNibName:_cellNibName bundle:nil] forCellWithReuseIdentifier:cellId];
    }else if (_cellClassName) {
        [collectionView registerClass:NSClassFromString(_cellClassName) forCellWithReuseIdentifier:cellId];
    }
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    _collectionView = collectionView;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section; {
    return _tabTitleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    UICollectionViewCell<RWTabTitleCellProtocol> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    if([cell respondsToSelector:@selector(setTabTitleString:)]) {
        cell.tabTitleString = _tabTitleArray[indexPath.row];
    }
    if([cell respondsToSelector:@selector(setIsTabSelected:)]) {
        if([indexPath compare:_currentIndexPath] == NSOrderedSame) {
            cell.isTabSelected = true;
        }else {
            cell.isTabSelected = false;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    if(_didSelectedBlock) {
        _didSelectedBlock(collectionView,indexPath);
    }
    
    self.currentIndexPath = indexPath;
    
}

// 
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0); {
    
    if([self.currentIndexPath compare:indexPath] == kCFCompareEqualTo) {
        
        if(_didChangedArrowViewBlock && self.currentIndexPath) {
            _didChangedArrowViewBlock(_collectionView,cell,indexPath,self.arrowView);
        }
    }
}

// 设置当前选项
- (void)setCurrentIndexPath:(NSIndexPath *)currentIndexPath {
    
    if(_currentIndexPath != currentIndexPath){
        
        NSIndexPath *lastIndexPath = _currentIndexPath;
        
        if(lastIndexPath) {
            
            
            UICollectionViewCell<RWTabTitleCellProtocol> *lastCell = (UICollectionViewCell<RWTabTitleCellProtocol> *)[_collectionView cellForItemAtIndexPath:lastIndexPath];
            if(lastCell && [lastCell respondsToSelector:@selector(setIsTabSelected:)]) {
                lastCell.isTabSelected = false;
            } else {
                UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:lastIndexPath];
                if(cell) {
                    [_collectionView reloadItemsAtIndexPaths:@[lastIndexPath]];
                }
            }
        }
        UICollectionViewCell<RWTabTitleCellProtocol> *cell = (UICollectionViewCell<RWTabTitleCellProtocol> *)[_collectionView cellForItemAtIndexPath:currentIndexPath];
        if(cell && [cell respondsToSelector:@selector(setIsTabSelected:)]) {
            cell.isTabSelected = true;
        }
        _currentIndexPath = currentIndexPath;
        
        if(_didChangedBlock) {
            _didChangedBlock(_collectionView,currentIndexPath);
        }
        if(cell) {
            _didChangedArrowViewBlock(_collectionView,cell,currentIndexPath,self.arrowView);
        }
    }
}

// 懒加载UI控件
- (void)willMoveToWindow:(nullable UIWindow *)newWindow; {
    [super willMoveToWindow:newWindow];
    if(newWindow && _didLoadView == false) {
        [self installUI];
        _didLoadView = true;
    }
}


@end
