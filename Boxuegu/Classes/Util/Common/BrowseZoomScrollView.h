//
//  BrowseZoomScrollView.h
//  Boxuegu
//
//  Created by apple on 2017/9/13.
//  Copyright © 2017年 itcast. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^BrowseZoomScrollViewTapBlock)(void);

@interface BrowseZoomScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic,strong)UIImageView *zoomImageView;

- (void)tapClick:(BrowseZoomScrollViewTapBlock)tapBlock;

-(void) setImageURLPath:(NSURL*)imageURLPath
    andPlaceholderImage:(UIImage*)placeholderImage
          andImageIndex:(NSInteger)index
      andCompletedBlock:(void (^)(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL))completeBlock;
@end
