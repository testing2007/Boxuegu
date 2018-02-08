//
//  RWDetailVC.m
//  demo-RWPhotosFramework
//
//  Created by RenyingWu on 2017/8/14.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "RWDetailVC.h"
#import "RWImageCCell.h"
#import "Masonry.h"

@interface RWDetailVC () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) PHFetchResult<PHAsset *> *result;
@property (nonatomic, strong) NSMutableArray *mArray;
@end

@implementation RWDetailVC

- (void)setAc:(PHAssetCollection *)ac {

    _ac = ac;
    self.result = [PHAsset fetchAssetsInAssetCollection:self.ac options:nil];
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentSize.height - self.collectionView.frame.size.height) animated:false];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mArray = [NSMutableArray new];
    // Do any additional setup after loading the view from its nib.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 0 - 50) / 4.0;
    CGFloat height = width;
    layout.itemSize = CGSizeMake(width, height);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.automaticallyAdjustsScrollViewInsets = false;
    self.collectionView= [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 1, 1) collectionViewLayout:layout];
    self.collectionView.bounces = true;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
    }];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"RWImageCCell" bundle:nil] forCellWithReuseIdentifier:@"RWImageCCell"];
    self.collectionView.alwaysBounceVertical = true;
    
    
    
    UIView *footerView = [UIView new];
    [self.view addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.collectionView.mas_bottom);
        make.left.right.offset(0);
        make.bottom.offset(0);
        make.height.offset(46);
    }];
    footerView.backgroundColor = [UIColor blackColor];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerView addSubview:doneBtn];
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.offset(-15);
        make.centerY.offset(0);
    }];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    
    UIButton *preview = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerView addSubview:preview];
    [preview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    [preview setTitle:@"预览" forState:UIControlStateNormal];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    
    return self.result.count;
    
//    
//    manager requestImageForAsset:self.ac targetSize:CGSizeMake(50, 50) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        
//    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    RWImageCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RWImageCCell" forIndexPath:indexPath];
    // cell.image =
    // PHImageManager *manager = [PHImageManager defaultManager];
    
//    [manager requestImageForAsset:self.result[indexPath.item] targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        
//        cell.image = result;
//        
//    }];
    cell.asset = self.result[indexPath.item];
    
    if([self.mArray containsObject:self.result[indexPath.item]]) {
    
        cell.selectedNumber = 1;
        
    }else {
    
        cell.selectedNumber = 0;
    }
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    // RWImageCCell *cell = (RWImageCCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if([self.mArray containsObject:self.result[indexPath.item]]) {
        
        [self.mArray removeObject:self.result[indexPath.item]];
        
    }else {
        [self.mArray addObject:self.result[indexPath.item]];
        
    }
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)dealloc {

    NSLog(@"RWDetailVC dealloc");
}


@end
