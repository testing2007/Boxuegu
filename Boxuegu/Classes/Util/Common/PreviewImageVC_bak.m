//
//  PreviewImageVC.m
//  Boxuegu
//
//  Created by apple on 2017/8/29.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "PreviewImageVC.h"
#import "ImageScrollView.h"
#import "UIViewController+MOPopWindow.h"
#import "UIView+Frame.h"

@interface PreviewImageVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) NSArray *arrImagesStrURL;
@property(nonatomic, strong) NSMutableArray *arrImages;
@property(nonatomic, assign) NSInteger startIndex;
@property(nonatomic, strong) UIImage *placeholderImage;

@property(nonatomic, strong) UICollectionView *collectionView;
//@property(nonatomic, strong) ImageScrollView *imageScrollView;
@property(nonatomic, strong) UIPageControl *pageController;

@property(nonatomic, strong) NSMutableArray *arrLongPressSelImage;

@end

@implementation PreviewImageVC

-(instancetype) initWithImageStrURLs:(NSArray*)arrImagesStrURL
                        atStartIndex:(NSInteger)startIndex
                    placeholderImage:(UIImage*)placeholderImage
{
    self = [super init];
    if(self)
    {
        _arrImagesStrURL = arrImagesStrURL;
        _arrImages = [NSMutableArray new];
        _startIndex = startIndex;
        _placeholderImage = placeholderImage?:[UIImage imageNamed:@"默认加载图-正方形"];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:[UICollectionViewLayout new]];
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
//        _imageScrollView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0,
//                                                                             0,
//                                                                             SCREEN_WIDTH,
//                                                                             SCREEN_HEIGHT)];
//        _imageScrollView.delegate = self;
//        _imageScrollView.showsHorizontalScrollIndicator = NO;
//        _imageScrollView.showsVerticalScrollIndicator = NO;
        
        _arrLongPressSelImage = [NSMutableArray new];
    }
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageScrollView.subviews[self.pageController.currentPage];
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    CGFloat zoomScale = _imageScrollView.zoomScale;
    zoomScale = (zoomScale == 1.0) ? 2.0 : 1.0;
    CGRect zoomRect = [self zoomRectForScale:zoomScale withCenter:[gesture locationInView:gesture.view]];
    [_imageScrollView zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = _imageScrollView.frame.size.height / scale;
    zoomRect.size.width  = _imageScrollView.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    
    [self.view addSubview:self.imageScrollView];
    [self.view addSubview:self.pageController];
    for (NSString* strUrlPath in _arrImagesStrURL) {
        UIImageView *imageView = [[UIImageView alloc] init];
        if([strUrlPath rangeOfString:@"http://" options:NSCaseInsensitiveSearch].location != NSNotFound ||
           [strUrlPath rangeOfString:@"https://" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [imageView sd_setImageWithURL:[NSURL URLWithString:strUrlPath]
                         placeholderImage:_placeholderImage];
        }
        else
        {
            [imageView sd_setImageWithURL:[NSURL fileURLWithPath:strUrlPath]
                         placeholderImage:_placeholderImage];
        }
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTapGesture setNumberOfTapsRequired:2];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:doubleTapGesture];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImageToAlbum:)];
        imageView.tag = self.pageController.numberOfPages;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:longPress];
        [_arrImages addObject:imageView.image];
        
        [self.imageScrollView addImageView:imageView];
        
        self.pageController.numberOfPages++;
    }
    
    
    [self.imageScrollView setCurrentIndex:_startIndex];
    
    CGSize pageSize = [_pageController sizeForNumberOfPages:_pageController.numberOfPages];
    CGFloat originX = (SCREEN_WIDTH-pageSize.width)/2.0;
    CGFloat originY = (self.view.centerY+SCREEN_WIDTH/2.0) - 10;
    self.pageController.frame = CGRectMake(originX, originY, pageSize.width, pageSize.height);
    self.pageController.currentPage = _startIndex;
    if(self.pageController.numberOfPages<=1)
    {
        self.pageController.hidden = YES;
    }
}

-(UIPageControl*)pageController
{
    if(!_pageController)
    {
        _pageController = [[UIPageControl alloc] init];
        _pageController.pageIndicatorTintColor = [UIColor colorWithHex:0x3A3A3A];
        _pageController.currentPageIndicatorTintColor = [UIColor colorWithHex:0xFFFFFF];
        _pageController.numberOfPages = 0;
    }
    return _pageController;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating = %@", scrollView);
    if(self.pageController && self.pageController.numberOfPages>0)
    {
        NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
        if(index!=self.pageController.currentPage && index<self.pageController.numberOfPages)
        {
            [self.imageScrollView setCurrentIndex:index];
            self.pageController.currentPage = index;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveImageToAlbum:(UILongPressGestureRecognizer*)longPress
{
    if(_arrImages && _arrImages.count>0 && longPress.view.tag<_arrImages.count)
    {
        UIImage *curImage = _arrImages[longPress.view.tag];
        if([_arrLongPressSelImage containsObject:curImage])
        {
            return ;
        }
        [_arrLongPressSelImage addObject:curImage];
        if(curImage)
        {
            [self saveImageToPhotos:curImage];
        }
    }
}

- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
//    [self showViewController:alert sender:nil];
    [[BXGHUDTool share] showHUDWithString:@"图片保存成功"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrImagesStrURL.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    if(!cell) {
        cell = [[UICollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    
    return cell;
}



@end
