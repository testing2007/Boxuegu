//
//  RWImagePickerPreviewVC.m
//  demo-RWPhotosFramework
//
//  Created by RenyingWu on 2017/8/16.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "RWImagePickerPreviewVC.h"
#import "Masonry.h"


@interface RWImagePickerPreviewVC () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation RWImagePickerPreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = self.view.frame.size;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.bottom.right.offset(0);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.result.count;
}

//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    return 
//}
@end
