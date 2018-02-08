//
//  BXGCategoryDetailView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/17.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCategoryDetailView.h"

#import "BXGCategoryHeaderView.h"
#import "BXGCategorySectionHeaderView.h"
#import "BXGCategoryDetailCCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "BXGOrderFreeCoursePopVC.h"

static NSString *cellID = @"BXGCategoryDetailCCell";

@interface BXGCategoryDetailView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSString *headerUrl;
@property (nonatomic, strong) NSArray *firstSectionTitles;
@property (nonatomic, strong) NSArray *secondSectionTitles;
@property (nonatomic, strong) BXGCategoryHeaderView *headerView;
//@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@end

@implementation BXGCategoryDetailView

#pragma mark - Interface

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    UICollectionViewFlowLayout *flowLayout;
    flowLayout = [UICollectionViewLeftAlignedLayout new];;
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (@available(iOS 10.0, *)) {
        flowLayout.estimatedItemSize = CGSizeMake(0,1);
        flowLayout.itemSize = CGSizeMake(50, 30);
    }else {
        // iOS10以下 estimatedItemSize 出现崩溃问题
    }
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    [self installUI];
    return self;
}

#pragma mark - Getter Setter

- (void)setHeaderURL:(NSString *)headerURL
andFirstSectionTitles:(NSArray<NSString *>*) firstTitles
andSecondSectionTitles:(NSArray<NSString *>*) secondTitles; {
    
    self.headerUrl = headerURL;
    self.firstSectionTitles = firstTitles;
    self.secondSectionTitles = secondTitles;
    
    if (@available(iOS 11.0, *)) {
        [self reloadData];
    }else {
        // 解决iOS11以下 estimatedItemSize 出现崩溃问题
        [self reloadData];[self reloadData]; // 必须写两个
    }
}

#pragma mark - UI

- (void)installUI {
    
    self.dataSource = self;
    self.delegate = self;
    self.backgroundColor = [UIColor whiteColor];
    [self registerClass:[BXGCategoryHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BXGCategoryHeaderView"];
    [self registerClass:[BXGCategorySectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BXGCategorySectionHeaderView"];
    [self registerClass:[BXGCategoryDetailCCell class] forCellWithReuseIdentifier:cellID];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [collectionView deselectItemAtIndexPath:indexPath animated:true];
    });
    
    if(self.didSelectedTagBlock) {
        self.didSelectedTagBlock(indexPath);
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if(self.firstSectionTitles.count + self.secondSectionTitles.count > 0) {
        return 3;
    }else {
        return 0;
    }
}

- (void)tapHeaderView:(UITapGestureRecognizer *)tap {
    if(self.didSelectedHeaderViewBlock){
        self.didSelectedHeaderViewBlock();
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: { // 标头
            BXGCategoryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BXGCategoryHeaderView" forIndexPath:indexPath];
            if(self.headerUrl){
                 [headerView.imageView sd_setImageWithURL:[NSURL URLWithString:self.headerUrl] placeholderImage:[UIImage imageNamed:@"默认加载图-分类"]];
            }else {
                [headerView.imageView setImage:[UIImage imageNamed:@"默认加载图-分类"]];
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeaderView:)];
            [headerView addGestureRecognizer:tap];
            return headerView;
        }break;
        case 1: {
            BXGCategorySectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BXGCategorySectionHeaderView" forIndexPath:indexPath];
            view.sectionTitle = @"就业课";
            return view;
        }break;
        case 2: { // 微课
            BXGCategorySectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BXGCategorySectionHeaderView" forIndexPath:indexPath];
            view.sectionTitle = @"精品微课";
            return view;
        }break;
    }
    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeaderView" forIndexPath:indexPath];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section; {
    if(section == 1){
        return self.firstSectionTitles.count;
    }
    if(section == 2){
        return self.secondSectionTitles.count;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    BXGCategoryDetailCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if(indexPath.section == 1){
        cell.tagTitle = self.firstSectionTitles[indexPath.row];
    } else if(indexPath.section == 2) {
        cell.tagTitle = self.secondSectionTitles[indexPath.row];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 给iOS8.0 - iOS9.0 提供默认大小
    return CGSizeMake((collectionView.frame.size.width - 30 - 15) * 0.5, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section; {

    if(section == 0){
        if(self.headerUrl){
            // return CGSizeMake(0, collectionView.frame.size.width * 100 / 255.0);
            return CGSizeMake(0, 0);
        }else {
            return CGSizeMake(0, 0);
        }
    }
    if(section == 1) { // 就业课
        if(self.firstSectionTitles.count > 0){
            return CGSizeMake(0, 45);
        } else {
            return CGSizeMake(0, 0);
        }
    }
    if(section == 2){ // 微课
        if(self.secondSectionTitles.count > 0){
            return CGSizeMake(0, 45);
        } else {
            return CGSizeMake(0, 0);
        }
    }
    return CGSizeMake(0, 0);
}
#pragma mark - End
@end
