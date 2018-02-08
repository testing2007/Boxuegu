//
//  RWImagePickerPreviewVC.h
//  demo-RWPhotosFramework
//
//  Created by RenyingWu on 2017/8/16.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface RWImagePickerPreviewVC : UIViewController

@property (strong, nonatomic) PHFetchResult<PHAsset *> *result;
@property (strong, nonatomic) PHAsset *asset;

// @property (nonatomic, strong)
@end
