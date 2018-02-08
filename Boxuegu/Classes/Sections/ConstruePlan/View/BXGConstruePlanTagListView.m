//
//  BXGConstruePlanTagListView.m
//  Boxuegu
//
//  Created by wurenying on 2018/1/11.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGConstruePlanTagListView.h"
#define kBXGConstruePlanTagCellId  @"BXGConstruePlanTagCell"

@interface BXGConstruePlanTagCell: UICollectionViewCell

@property (nonatomic, strong) BXGConstruePlanTagModel *model;
@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation BXGConstruePlanTagCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        [self installUI];
    }
    return self;
}

- (UIButton *)titleBtn {
    
    if(_titleBtn == nil) {
        
        _titleBtn = [UIButton new];
        _titleBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:12];
    }
    return _titleBtn;
}

- (void)setModel:(BXGConstruePlanTagModel *)model {
    _model = model;
    if(model) {
        [self.titleBtn setTitle:model.title forState:UIControlStateNormal];

        self.bgView.backgroundColor = model.color;
    }else {
        [self.titleBtn setTitle:@"" forState:UIControlStateNormal];

    }
}

- (UIView *)bgView {
    
    if(_bgView == nil) {
        
        _bgView = [UIView new];
    }
    return _bgView;
}

- (void)installUI {
    
    UIButton *titleBtn = self.titleBtn;
    [self.bgView addSubview:titleBtn];
    
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.right.offset(-5);
        make.centerY.offset(0);
        make.height.offset(15);
    }];
    
    
    UIView *bgView = self.bgView;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.left.offset(0);
        make.centerY.offset(0);
        make.height.equalTo(titleBtn);
    }];
    
    [bgView layoutIfNeeded];
    bgView.layer.cornerRadius = 3;
}
@end


@implementation BXGConstruePlanTagModel
- (instancetype)initWithTitle:(NSString *)title andColor:(UIColor *)color {
    self = [super init];
    if(self) {
        _title = title;
        _color = color;
    }
    return self;
}
@end

@interface BXGConstruePlanTagListView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation BXGConstruePlanTagListView

- (void)setModelArray:(NSArray<BXGConstruePlanTagModel *> *)modelArray {
    _modelArray = modelArray;
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    
    if(_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        if (@available(iOS 10.0, *)) {
            layout.estimatedItemSize = CGSizeMake(0,1);
            layout.itemSize = CGSizeMake(50, 30);
        }else {
            // iOS10以下 estimatedItemSize 出现崩溃问题--待验证
        }
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 15;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[BXGConstruePlanTagCell class] forCellWithReuseIdentifier:kBXGConstruePlanTagCellId];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.bounces = false;
    }
    return _collectionView;
}

- (void)installUI {
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = false;
    UICollectionView *collectionView = self.collectionView;
    collectionView.allowsSelection = false;
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self installUI];
    }
    return self;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BXGConstruePlanTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBXGConstruePlanTagCellId forIndexPath:indexPath];
    cell.model = self.modelArray[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.modelArray.count;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;


@end
