//
//  RWSelectPhotoVC.h
//  demo-RWPhotosFramework
//
//  Created by RenyingWu on 2017/8/15.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
typedef void(^SelectedImageBlockType)(UIImage * _Nullable image);
@protocol RWImagePickerDelegate <NSObject>
- (void)selectedPhotoWithAssetArray:(NSArray<PHAsset*> *_Nullable)assetArray;
@end



@interface RWImagePickerVC : UINavigationController
@property(nullable,nonatomic,weak) id <UINavigationControllerDelegate, RWImagePickerDelegate> delegate;
@property(nullable,copy) SelectedImageBlockType selectedImageBlock;
@end
