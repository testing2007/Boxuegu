//
//  RWContentEditingController.h
//  demo-RWPhotosFramework
//
//  Created by RenyingWu on 2017/8/28.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

typedef void(^CommitBlockType)(UIImage *image);
typedef void(^CancleBlockType)();

@interface RWContentEditingController :UIViewController 
@property (strong, nonatomic) PHFetchResult<PHAsset *> *result;
@property (strong, nonatomic) PHAsset *asset;
@property (strong, nonatomic) UIImage *image;

@property (nonatomic, copy) CommitBlockType commitBlock;
@property (nonatomic, copy) CancleBlockType cancleBlock;
@end
