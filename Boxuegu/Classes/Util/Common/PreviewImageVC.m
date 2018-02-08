//
//  PreviewImageVC.m
//  Boxuegu
//
//  Created by apple on 2017/8/29.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "PreviewImageVC.h"
#import "UIViewController+MOPopWindow.h"
#import "UIView+Frame.h"
#import "PreviewImageCCell.h"
#import <Photos/Photos.h>

NSString *g_albumFolderName = @"博学谷";
@interface PreviewImageVC ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) NSArray *arrImagesStrURL; //图片URL
@property(nonatomic, strong) NSMutableDictionary<NSNumber*/*imageIndex*/, ImageInfo* /*ImageInfo*/> *dictLoadedImage;   //与完成URL加载后的图片数组
@property(nonatomic, assign) NSInteger startIndex; //图片数组里面第一个开始索引值
@property(nonatomic, strong) UIImage *placeholderImage; //默认图片

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UIPageControl *pageController;

@property(nonatomic, strong) UIButton *btnSaveImage;
@property(nonatomic, strong) NSMutableArray *arrSaveImage; //已保存的图片
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
        _startIndex = startIndex;
        _placeholderImage = placeholderImage?:[UIImage imageNamed:@"默认加载图-正方形"];
        _arrSaveImage = [NSMutableArray new];
        _dictLoadedImage = [NSMutableDictionary new];
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = self.view.bounds.size;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[PreviewImageCCell class] forCellWithReuseIdentifier:@"PreviewImageCCellID"];
    [_collectionView reloadData];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.pageController];
    
    if(_arrImagesStrURL && _arrImagesStrURL.count>_startIndex)
    {
        self.pageController.numberOfPages = _arrImagesStrURL.count;
        CGSize pageSize = [_pageController sizeForNumberOfPages:_pageController.numberOfPages];
        CGFloat originX = (self.view.bounds.size.width-pageSize.width)/2.0;
        //CGFloat originY = (self.view.centerY+self.view.bounds.size.width/2.0) - 10;
        CGFloat originY = self.view.bounds.size.height-50-9;
        self.pageController.frame = CGRectMake(originX, originY, pageSize.width, pageSize.height);
        self.pageController.currentPage = _startIndex;
        if(self.pageController.numberOfPages<=1)
        {
            self.pageController.hidden = YES;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_startIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }//end if
    
    _btnSaveImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.btnSaveImage];
    [_btnSaveImage setFrame:CGRectMake(self.view.bounds.size.width-50-15, self.view.bounds.size.height-50-15, 50, 50)];
    [_btnSaveImage setImage:[UIImage imageNamed:@"导航栏-下载"] forState:UIControlStateNormal];
    [_btnSaveImage addTarget:self action:@selector(onClickSaveImage:) forControlEvents:UIControlEventTouchUpInside];
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
        NSInteger index = scrollView.contentOffset.x / self.view.frame.size.width;
        if(index!=self.pageController.currentPage && index<self.pageController.numberOfPages)
        {
            self.pageController.currentPage = index;
        }
    }
}

-(NSString*)isExistAlbumInPhone
{
    __block NSString *albumIdentifer = nil;
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        if([collection.localizedTitle isEqualToString:g_albumFolderName]) {
            albumIdentifer = collection.localIdentifier;
        }
        
    }];
    return  albumIdentifer;
}

- (void)saveImageToPhotos:(UIImage*)savedImage
{
    if(savedImage)
    {
        if(![_arrSaveImage containsObject:savedImage])
        {
            [_arrSaveImage addObject:savedImage];
            
            PHPhotoLibrary* photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
            [photoLibrary performChanges:^{
                PHFetchResult* fetchCollectionResult;
                PHAssetCollectionChangeRequest* collectionRequest;
                NSString *albumIdenifier = [self isExistAlbumInPhone];
                if(albumIdenifier){
                    fetchCollectionResult = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[albumIdenifier] options:nil];
                    PHAssetCollection* exisitingCollection = fetchCollectionResult.firstObject;
                    collectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:exisitingCollection];
                }else{
//                    fetchCollectionResult = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[albumIdenifier] options:nil];
//                    // Create a new album
//                    if ( !fetchCollectionResult || fetchCollectionResult.count==0 ){
                        collectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:g_albumFolderName];
//                    }
                }
                PHAssetChangeRequest* createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:savedImage];
                [collectionRequest addAssets:@[createAssetRequest.placeholderForCreatedAsset]];
                
            } completionHandler:^(BOOL success, NSError *error){
                if(![NSThread isMainThread])
                {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if(success){
                            [[BXGHUDTool share] showHUDWithString:@"图片保存成功"];
                        }else{
                            [_arrSaveImage removeObject:savedImage];
                            [[BXGHUDTool share] showHUDWithString:@"图片保存失败"];
                        }
                    });
                }
                else
                {
                    if(success){
                        [[BXGHUDTool share] showHUDWithString:@"图片保存成功"];
                    }else{
                        [_arrSaveImage removeObject:savedImage];
                        [[BXGHUDTool share] showHUDWithString:@"图片保存失败"];
                    }
                }
            }];//end completionHandler
        } else {
            [[BXGHUDTool share] showHUDWithString:@"此图片已下载"];
        }
    }
}

-(void)onClickSaveImage:(UIButton*)btn
{
    if(self.dictLoadedImage && [self.dictLoadedImage.allKeys containsObject:[NSNumber numberWithInteger:self.pageController.currentPage]] /*&& self.pageController.currentPage<self.dictLoadedImage.count*/)
    {
        ImageInfo* imageInfo = self.dictLoadedImage[[NSNumber numberWithInteger:self.pageController.currentPage]];
        [self saveImageToPhotos:imageInfo.image];
    }
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrImagesStrURL.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PreviewImageCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PreviewImageCCellID" forIndexPath:indexPath];
    [cell setupCellImagePath:self.arrImagesStrURL[indexPath.row]
         andPlaceholderImage:_placeholderImage
               andImageIndex:indexPath.row
     andFinishLoadImageBlock:^(ImageInfo *imageInfo, NSInteger index) {
         [self.dictLoadedImage setObject:imageInfo forKey:[NSNumber numberWithInteger:index]];
     }];
    return cell;
}

#pragma mark --屏幕旋转相关
- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
