//
//  PreviewImageCCell.h
//  Boxuegu
//
//  Created by apple on 2017/9/13.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageInfo : NSObject
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) NSString *imagePath;
@end

@interface PreviewImageCCell : UICollectionViewCell

- (void)setupCellImagePath:(NSString *)imagePath
       andPlaceholderImage:(UIImage*)placeholderImage
             andImageIndex:(NSInteger)index
   andFinishLoadImageBlock:(void (^)(ImageInfo* imageinfo, NSInteger index))finishLoadImageBlock;

@end
