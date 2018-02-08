//
//  RWSelectPhotoAlbumVC.m
//  demo-RWPhotosFramework
//
//  Created by RenyingWu on 2017/8/15.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "RWSelectPhotoAlbumVC.h"
#import "Masonry.h"
#import <Photos/Photos.h>
#import "RWSelectAlbumCell.h"
#import "RWSelectPhotoDetailVC.h"

@interface RWSelectPhotoAlbumVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PHFetchResult<PHAssetCollection *> *result;

@property (nonatomic, strong) NSMutableArray *albumCollectionArray;
@property (nonatomic, strong) NSMutableArray *albumAssetArray;
@end

@implementation RWSelectPhotoAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"照片";
    self.albumCollectionArray = [NSMutableArray new];
    self.albumAssetArray = [NSMutableArray new];
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    
    switch (status) {
        case PHAuthorizationStatusNotDetermined: {
            
            NSLog(@"还没确定");
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                NSLog(@"status : %zd",status);
                [self installUI];
                [self installNavBar];
            }];
            return;
        }break;
        case PHAuthorizationStatusRestricted:
            NSLog(@"不允许");
            break;
        case PHAuthorizationStatusDenied:
            NSLog(@"允许");
            break;
        case PHAuthorizationStatusAuthorized:
            NSLog(@"授权");
            break;
    }
    
    
    [self installUI];
    [self installNavBar];

    self.result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    
    for (NSInteger i = 0; i < self.result.count; i++) {
    
        PHAssetCollection * ac = self.result[i];
    
        PHFetchResult<PHAsset *> *assetResult = [PHAsset fetchAssetsInAssetCollection:ac options:nil];
        if(assetResult.count > 0){
        
            [self.albumCollectionArray addObject:ac];
            [self.albumAssetArray addObject:assetResult];
        }
    }
    
    self.result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
    for (NSInteger i = 0; i < self.result.count; i++) {
        
        PHAssetCollection * ac = self.result[i];
        
        PHFetchResult<PHAsset *> *assetResult = [PHAsset fetchAssetsInAssetCollection:ac options:nil];
        if(assetResult.count > 0){
            
            [self.albumCollectionArray addObject:ac];
            [self.albumAssetArray addObject:assetResult];
        }
    }

}

- (void)installUI {

    self.automaticallyAdjustsScrollViewInsets = false;
    UITableView *tableview = [UITableView new];
    [self.view addSubview:tableview];
    tableview.delegate = self;
    tableview.dataSource = self;
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.offset(0);
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.bottom.offset(0);
    }];
    
    [tableview registerNib:[UINib nibWithNibName:@"RWSelectAlbumCell" bundle:nil] forCellReuseIdentifier:@"RWSelectAlbumCell"];
    tableview.rowHeight = 60;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return self.albumCollectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    RWSelectAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RWSelectAlbumCell" forIndexPath:indexPath];

    PHAssetCollection *collection = self.albumCollectionArray[indexPath.row];
    PHFetchResult<PHAsset *> *result = self.albumAssetArray[indexPath.row];
    
        PHAsset *asset = result.firstObject;
        [[PHImageManager defaultManager] requestImageForAsset:asset  targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            cell.iconImage = result;
        }];
    
    cell.cellTitle = [collection.localizedTitle stringByAppendingString:[NSString stringWithFormat:@" (%zd)",result.count]];
    
    
    return cell;
}


- (void)installNavBar {

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
}

- (void)cancle {
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:true];
    RWSelectPhotoDetailVC *detailVC = [RWSelectPhotoDetailVC new];
    detailVC.ac = self.albumCollectionArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:true];
}
@end
