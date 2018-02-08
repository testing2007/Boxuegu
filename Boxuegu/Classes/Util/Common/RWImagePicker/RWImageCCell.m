//
//  RWImageCCell.m
//  demo-RWPhotosFramework
//
//  Created by RenyingWu on 2017/8/14.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "RWImageCCell.h"
#import "RWPhotoSelectedView.h"

@interface RWImageCCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
// @property (weak, nonatomic) IBOutlet RWPhotoSelectedView *selectdView;

@end

@implementation RWImageCCell

- (void)setIsSelectable:(BOOL)isSelectable {
    
    _isSelectable = isSelectable;
    if(isSelectable) {
        
        self.alpha = 1;
    }else {
        
        self.alpha = 0.4;
    }
}
- (void)setAsset:(PHAsset *)asset {

    if(_asset == asset){
    
        return;
    }
    _asset = asset;
    
//    PHImageRequestOptions *option= [[PHImageRequestOptions alloc]init];
//    option.resizeMode = PHImageRequestOptionsResizeModeExact;
//    
//    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGmax contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        self.image = result;
//    }];
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.image = result;
    }];
}

- (void)setImage:(UIImage *)image {

    _image = image;
    [self.imageView setImage:image];
}

- (void)setSelectedNumber:(NSInteger)selectedNumber {

    _selectedNumber = selectedNumber;
    // self.selectdView.selectedNumber = selectedNumber;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    // Initialization code
}


@end
