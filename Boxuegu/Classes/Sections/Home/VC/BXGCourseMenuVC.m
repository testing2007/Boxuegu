//
//  BXGCourseMenuVC.m
//  ImageTextLayoutButtonPrj
//
//  Created by apple on 2017/10/17.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "BXGCourseMenuVC.h"
#import "BXGCourseFilterHeaderView.h"
#import "BXGCourseFilterCC.h"
#import "UICollectionViewLeftAlignedLayout.h"

@interface BXGCourseMenuVC ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic, weak) UICollectionView *collectionView;
@end

static NSString *BXGCourseFilterCCId = @"BXGCourseFilterCC";
static NSString *BXGCourseFilterHeaderViewId = @"BXGCourseFilterHeaderView";

@implementation BXGCourseMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor= [UIColor grayColor];
    
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    layout.minimumLineSpacing = 30;
    layout.minimumInteritemSpacing = 30;
    layout.estimatedItemSize = CGSizeMake(120, 50);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 50);
    UICollectionView *homeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    homeCollectionView.delegate = self;
    homeCollectionView.dataSource = self;
    homeCollectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = homeCollectionView;
    [self.view addSubview:homeCollectionView];
    
    [homeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.equalTo(@400);
    }];
    
    [_collectionView registerClass:[BXGCourseFilterHeaderView class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:BXGCourseFilterHeaderViewId];
    [_collectionView registerClass:[BXGCourseFilterCC class]
        forCellWithReuseIdentifier:BXGCourseFilterCCId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BXGCourseFilterCC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BXGCourseFilterCCId forIndexPath:indexPath];
    NSString* title = @"";
    switch (indexPath.section) {
        case 0:
            title = [NSString stringWithFormat:@"方向方向%ld", indexPath.row];
            break;
        case 1:
            title = [NSString stringWithFormat:@"学科%ld", indexPath.row];
            break;
        case 2:
            title = [NSString stringWithFormat:@"分类%ld", indexPath.row];
            break;
        default:
            break;
    }
    [cell setString:title];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    BXGCourseFilterHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                               withReuseIdentifier:BXGCourseFilterHeaderViewId
                                                                                      forIndexPath:indexPath];
    NSString* title = @"";
    switch (indexPath.section) {
        case 0:
            title = @"方向";
            break;
        case 1:
            title = @"学科";
            break;
        case 2:
            title = @"分类";
            break;
        default:
            break;
    }
    headerView.titleLabel.text = title;
    return headerView;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BXGCourseFilterCC *cc = (BXGCourseFilterCC*)[collectionView cellForItemAtIndexPath:indexPath];
    [cc setSel:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    BXGCourseFilterCC *cc = (BXGCourseFilterCC*)[collectionView cellForItemAtIndexPath:indexPath];
    [cc setSel:NO];
}






@end
