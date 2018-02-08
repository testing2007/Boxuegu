//
//  RWTabTitleView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

typedef void(^DidSelectedBlockType)(UICollectionView *collectionView, NSIndexPath *indexPath);
typedef void(^DidChangedBlockType)(UICollectionView *collectionView, NSIndexPath *indexPath);
typedef void(^DidChangedArrowViewBlockType)(UICollectionView *collectionView, UICollectionViewCell *cell, NSIndexPath *indexPath,UIView *arrowView);

typedef NS_ENUM(NSUInteger, RWTabCellSizeType) {
    RWTabCellSizeTypeDivide = 0,
    RWTabCellSizeTypeCustom = 1,
    RWTabCellSizeTypeEstablish = 2,
};

@protocol RWTabTitleCellProtocol
- (void)setTabTitleString:(NSString *)tabTitleString;
- (void)setIsTabSelected:(BOOL)isTabSelected;
@end

@interface RWTabTitleView : UIView
@property (nonatomic, strong) NSArray *tabTitleArray;
@property (nonatomic, copy) NSString *cellNibName;
@property (nonatomic) NSString *cellClassName;
@property (nonatomic, assign) RWTabCellSizeType cellSizeType;
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic) UIView *arrowView;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, copy) DidSelectedBlockType didSelectedBlock; // optional
@property (nonatomic, copy) DidChangedBlockType didChangedBlock; // optional
@property (nonatomic, copy) DidChangedArrowViewBlockType didChangedArrowViewBlock; // optional

@property (nonatomic, readonly) UICollectionViewFlowLayout *flowLayout;
@end
