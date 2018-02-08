//
//  RWSelectPhotoDetailVC.m
//  demo-RWPhotosFramework
//
//  Created by RenyingWu on 2017/8/15.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "RWImagePickerVC.h"

#import "RWSelectPhotoDetailVC.h"
#import "RWImageCCell.h"
#import "Masonry.h"
#import "RWImagePickerPreviewVC.h"
#import "RWContentEditingController.h"


@interface RWSelectPhotoDetailVC () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) PHFetchResult<PHAsset *> *result;
@property (nonatomic, strong) NSMutableArray *mArray;
@end

@implementation RWSelectPhotoDetailVC

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
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 0 - 30) / 4.0;
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
    [doneBtn addTarget:self action:@selector(operationForDone) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *preview = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerView addSubview:preview];
    [preview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    [preview addTarget:self action:@selector(operationForPreview) forControlEvents:UIControlEventTouchUpInside];
    [preview setTitle:@"预览" forState:UIControlStateNormal];
    
    [self installNavBar];
}

- (void)operationForDone {

    // 判断有没有代理
    
    RWImagePickerVC *spVC = (RWImagePickerVC *)self.navigationController;
    
    if(!spVC) {
        
        return;
    }
    
    id <RWImagePickerDelegate>delegate = spVC.delegate;
    
    if(!delegate) {
    
        return;
    }
    
    if(![delegate respondsToSelector:@selector(selectedPhotoWithAssetArray:)]) {
    
        return;
    }
    // 判断代理有没有时间SEL
    
    // 获取所有image图片
    
    // 把数组打到代理方法中
    
    NSMutableArray *seletedImageList = [NSMutableArray new];
    
    PHImageManager *manager = [PHImageManager defaultManager];
    NSInteger __block progress = 0;
    NSInteger __block progressCount = self.result.count;
    for (NSInteger i = 0; i < self.result.count; i++){
    
//        [manager requestImageForAsset:self.result[i] targetSize:CGSizeZero contentMode:nil options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//            
//        }];
        
        [manager requestImageDataForAsset:self.result[i] options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            
            [seletedImageList addObject:[UIImage imageWithData:imageData]];
            progress ++;
            if(progress == progressCount) {
            
                [delegate selectedPhotoWithAssetArray:seletedImageList];
            }
        }];
    
    }
}

- (void)operationForPreview {

    RWImagePickerPreviewVC *previewVC = [RWImagePickerPreviewVC new];
    previewVC.result = self.result;
    [self.navigationController pushViewController:previewVC animated:true];
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
    
    

    //    [manager requestImageForAsset:self.result[indexPath.item] targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
    //
    //        cell.image = result;
    //
    //    }];
    cell.asset = self.result[indexPath.item];
    cell.isSelectable = false;
    if([self.mArray containsObject:self.result[indexPath.item]]) {
        
        
        cell.selectedNumber = 1;
        
        cell.isSelectable = true;
        
    }else {
        
        cell.selectedNumber = 0;
        
        if(self.mArray.count >= 9) {
         
            cell.isSelectable = false;
        }else {
            
            cell.isSelectable = true;
        }
        
    }
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    RWContentEditingController  *previewVC = [RWContentEditingController new];
    // RWImagePickerPreviewVC *previewVC = [RWImagePickerPreviewVC new];
    PHAsset *asset = [self.result objectAtIndex:indexPath.item];
    
    
    
    
//    [PHImageManager defaultManager] requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
//        
//        
//        // AVPlayerItem new
//        
//    }
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        
        previewVC.image = [UIImage imageWithData:imageData];
        [self.navigationController pushViewController:previewVC animated:true];
    }];
    // PHFetchResult<PHAsset *> *result;
    
    
    
    
    
//     RWImageCCell *cell = (RWImageCCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    
//
//    
//    if([self.mArray containsObject:self.result[indexPath.item]]) {
//        
//        [self.mArray removeObject:self.result[indexPath.item]];
//        
//    }else {
//        
//        if(self.mArray.count >= 9) {
//        
//        }else {
//        
//            [self.mArray addObject:self.result[indexPath.item]];
//        }
//        
//        
//    }
//    
//    
//    [collectionView reloadItemsAtIndexPaths:[collectionView indexPathsForVisibleItems]];
    
     // 3 [collectionView reloadData];
    
}

- (void)dealloc {
    
    NSLog(@"RWDetailVC dealloc");
}
- (void)installNavBar {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
}

- (void)cancle {
    
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
