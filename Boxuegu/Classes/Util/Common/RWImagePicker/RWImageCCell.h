//
//  RWImageCCell.h
//  demo-RWPhotosFramework
//
//  Created by RenyingWu on 2017/8/14.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface RWImageCCell : UICollectionViewCell
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, assign) UIImage *image;
@property (nonatomic, assign) NSInteger selectedNumber;
@property (nonatomic, assign) BOOL isSelectable;
@end
