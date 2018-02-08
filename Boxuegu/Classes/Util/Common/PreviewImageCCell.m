//
//  PreviewImageCCell.m
//  Boxuegu
//
//  Created by apple on 2017/9/13.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "PreviewImageCCell.h"
#import "UIView+Extension.h"
#import "BrowseZoomScrollView.h"

@implementation ImageInfo
@end

@interface PreviewImageCCell()<UIScrollViewDelegate>
@property(weak, nonatomic) BrowseZoomScrollView *zoomScrollView;
@end

@implementation PreviewImageCCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self installUI];
    }
    return self;
}

-(void)installUI
{
    BrowseZoomScrollView *scrollView = [[BrowseZoomScrollView alloc] initWithFrame:self.bounds];
    [scrollView tapClick:^{
        UIViewController *vc = [self findOwnerVC];
        if(vc)
        {
            [vc dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [self.contentView addSubview:scrollView];
    self.zoomScrollView = scrollView;
}


- (void)setupCellImagePath:(NSString *)imagePath
       andPlaceholderImage:(UIImage*)placeholderImage
             andImageIndex:(NSInteger)index
   andFinishLoadImageBlock:(void (^)(ImageInfo* imageinfo, NSInteger index))finishLoadImageBlock
{
    __weak typeof(self) weakSelf = self;
    if([imagePath rangeOfString:@"http://" options:NSCaseInsensitiveSearch].location != NSNotFound ||
       [imagePath rangeOfString:@"https://" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        [self.zoomScrollView setImageURLPath:[NSURL URLWithString:imagePath]
                      andPlaceholderImage:placeholderImage
                            andImageIndex:index
                             andCompletedBlock:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                 if(finishLoadImageBlock)
                                 {
                                     ImageInfo *imageInfo = [ImageInfo new];
                                     imageInfo.image = image;
                                     imageInfo.imagePath = imagePath;
                                     finishLoadImageBlock(imageInfo, index);
                                 }
                             }];
//        [self.zoomScrollView.zoomImageView sd_setImageWithURL:[NSURL URLWithString:imagePath]
//                      placeholderImage:placeholderImage
//                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                 if(finishLoadImageBlock)
//                                 {
//                                     ImageInfo *imageInfo = [ImageInfo new];
//                                     imageInfo.image = _imageView.image;
//                                     imageInfo.imagePath = imagePath;
//                                     finishLoadImageBlock(imageInfo, index);
//                                 }
//                             }];
    }
    else
    {
        [self.zoomScrollView setImageURLPath:[NSURL fileURLWithPath:imagePath]
                         andPlaceholderImage:placeholderImage
                               andImageIndex:index
                           andCompletedBlock:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                               if(finishLoadImageBlock)
                               {
                                   ImageInfo *imageInfo = [ImageInfo new];
                                   imageInfo.image = image;
                                   imageInfo.imagePath = imagePath;
                                   finishLoadImageBlock(imageInfo, index);
                               }
                           }];
//        [self.zoomScrollView.zoomImageView sd_setImageWithURL:[NSURL fileURLWithPath:imagePath]
//                      placeholderImage:placeholderImage
//                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                 if(finishLoadImageBlock)
//                                 {
//                                     ImageInfo *imageInfo = [ImageInfo new];
//                                     imageInfo.image = weakSelf.zoo _imageView.image;
//                                     imageInfo.imagePath = imagePath;
//                                     finishLoadImageBlock(imageInfo, index);
//                                 }
//                             }];
    }
}

@end
