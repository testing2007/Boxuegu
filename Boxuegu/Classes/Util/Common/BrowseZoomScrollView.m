//
//  BrowseZoomScrollView.m
//  Boxuegu
//
//  Created by apple on 2017/9/13.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BrowseZoomScrollView.h"

@interface BrowseZoomScrollView ()

@property (nonatomic,copy)BrowseZoomScrollViewTapBlock tapBlock;
@property (nonatomic,assign)BOOL isSingleTap;

@end

@implementation BrowseZoomScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createZoomScrollView];
    }
    return self;
}

- (void)createZoomScrollView
{
    self.delegate = self;
    _isSingleTap = NO;
    self.minimumZoomScale = 1.0f;
    self.maximumZoomScale = 3.0f;
    self.bounces = NO;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    _zoomImageView = [[UIImageView alloc]initWithFrame:self.frame];
    _zoomImageView.contentMode = UIViewContentModeScaleAspectFit;
    _zoomImageView.userInteractionEnabled = YES;
    [self addSubview:_zoomImageView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _zoomImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    // 延中心点缩放
    CGRect rect = _zoomImageView.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    CGFloat scrollViewWidth = CGRectGetWidth(self.frame);
    CGFloat scrollViewHeight = CGRectGetHeight(self.frame);
    if (rect.size.width < scrollViewWidth) {
        rect.origin.x = floorf((scrollViewWidth - rect.size.width) / 2.0);
    }
    if (rect.size.height < scrollViewHeight) {
        rect.origin.y = floorf((scrollViewHeight - rect.size.height) / 2.0);
    }
    _zoomImageView.frame = rect;
}

- (void)tapClick:(BrowseZoomScrollViewTapBlock)tapBlock
{
    _tapBlock = tapBlock;
}

-(void)setImageURLPath:(NSURL*)imageURLPath
    andPlaceholderImage:(UIImage*)placeholderImage
          andImageIndex:(NSInteger)index
      andCompletedBlock:(void (^)(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL))completeBlock
{
    [self.zoomImageView sd_setImageWithURL:imageURLPath
                           placeholderImage:placeholderImage
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      if(completeBlock) {
                                          completeBlock(image, error, cacheType, imageURL);
                                      }
                                  }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    if(touch.tapCount == 1)
    {
        [self performSelector:@selector(singleTapClick) withObject:nil afterDelay:0.17];
    }
    else
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        // 防止先执行单击手势后还执行下面双击手势动画异常问题
        if(!_isSingleTap)
        {
            CGPoint touchPoint = [touch locationInView:_zoomImageView];
            [self zoomDoubleTapWithPoint:touchPoint];
        }
    }
}

- (void)singleTapClick
{
    _isSingleTap = YES;
    if(_tapBlock)
    {
        _tapBlock();
    }
}

- (void)zoomDoubleTapWithPoint:(CGPoint)touchPoint
{
    if(self.zoomScale > self.minimumZoomScale)
    {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }
    else
    {
        CGFloat width = self.bounds.size.width / self.maximumZoomScale;
        CGFloat height = self.bounds.size.height / self.maximumZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - width / 2, touchPoint.y - height / 2, width, height) animated:YES];
    }
}


@end
