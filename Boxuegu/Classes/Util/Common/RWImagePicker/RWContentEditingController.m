//
//  RWContentEditingController.m
//  demo-RWPhotosFramework
//
//  Created by RenyingWu on 2017/8/28.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "RWContentEditingController.h"
#import "Masonry.h"

#import "RWImagePickerVC.h"

@interface RWContentEditingController() <UIScrollViewDelegate>
@property (nonatomic, weak) UIView *imgView;
@property (nonatomic, weak) UIScrollView *contentSize;
@property (nonatomic, assign) CGFloat fitWidth;
@property (nonatomic, assign) CGFloat fitHeight;
@property (nonatomic, assign) CGFloat frameHeight;
@end

@implementation RWContentEditingController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    UIScrollView *contentView = [UIScrollView new];
    contentView.alwaysBounceVertical = false;
    contentView.alwaysBounceHorizontal = false;
    contentView.bounces = false;
    contentView.minimumZoomScale = 1;
    contentView.maximumZoomScale = 3;
    
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.bottom.offset(0);
    }];
    self.contentSize = contentView;
    [contentView layoutIfNeeded];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:self.image];
    self.imgView = imgView;
    [imgView sizeToFit];
    [contentView addSubview:imgView];
    
    
    
    
    
    
    // *** 计算 ***
    
    CGFloat imgHeight = imgView.frame.size.height;
    CGFloat imgWidth = imgView.frame.size.width;
    CGFloat rate = imgWidth / imgHeight;
    CGFloat fitWidth;
    CGFloat fitHeight;
    CGFloat frameWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat frameHeight = frameWidth;
    self.frameHeight = frameWidth;
    CGFloat topMargin;
    CGFloat leftMargin;
    CGFloat bottomMargin;
    CGFloat rightMargin;
    
    // *** 判断 ***
    
    if(imgWidth == imgHeight) {
    
        fitWidth = frameWidth;
        fitHeight = frameHeight;
        
    }else if(imgWidth > imgHeight) {
    
        fitHeight = frameHeight;
        fitWidth = fitHeight * rate;
        
    }else {
    
        fitWidth = frameWidth;
        fitHeight = fitWidth / rate;
    }
    
    // *** 边距 ***
    
    topMargin = ([UIScreen mainScreen].bounds.size.height - fitHeight) / 2;
    if(topMargin < 15) {
    
        topMargin = 15;
    }
    bottomMargin = topMargin;
    
    leftMargin = ([UIScreen mainScreen].bounds.size.width - fitWidth) / 2;
    if(leftMargin < 15){
    
        leftMargin = 15;
    }
    rightMargin = leftMargin;
    
    
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.offset(0);
        make.left.offset(0);
        make.bottom.offset(0);
        make.right.offset(-0);
        
        // make.left.right.top.bottom.offset(0);
        make.height.offset(fitHeight);
        make.width.offset(fitWidth);
    }];
    
    topMargin = (([UIScreen mainScreen].bounds.size.height) - ([UIScreen mainScreen].bounds.size.width))/2;
    // leftMargin = (([UIScreen mainScreen].bounds.size.width) - ([UIScreen mainScreen].bounds.size.width - 30))/2;
    leftMargin = 0;
    bottomMargin = (([UIScreen mainScreen].bounds.size.height) - ([UIScreen mainScreen].bounds.size.width))/2;
    rightMargin = 0;
    
    contentView.contentInset = UIEdgeInsetsMake(topMargin,leftMargin,bottomMargin,rightMargin);
    contentView.delegate = self;
    contentView.zoomScale = 1.2;
    
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    // 截取框
    
    UIView *frameView = [UIView new];
    frameView.userInteractionEnabled = false;
    // frameView.backgroundColor = [UIColor blueColor];
    frameView.layer.borderColor = [UIColor whiteColor].CGColor;
    frameView.layer.borderWidth = 1;
    [self.view addSubview:frameView];
    [frameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.width.equalTo(frameView.superview.mas_width).offset(0);
        make.height.equalTo(frameView.mas_width);
        make.center.equalTo(frameView.superview);
    }];
    self.fitWidth = fitWidth;
    self.fitHeight = fitHeight;
    [self installNavigationItems];
    
    UIView *topMaskView = [UIView new];
    [self.view addSubview:topMaskView];
    topMaskView.backgroundColor = [UIColor blackColor];
    topMaskView.alpha = 0.2;
    [topMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.offset(0);
        make.bottom.equalTo(frameView.mas_top);
    }];
    
    UIView *bottomMaskView = [UIView new];
    [self.view addSubview:bottomMaskView];
    bottomMaskView.backgroundColor = [UIColor blackColor];
    bottomMaskView.alpha = 0.2;

    
    // 控制栏
    UIView *tabControlView = [UIView new];
    [self.view addSubview:tabControlView];
    tabControlView.backgroundColor = [UIColor blackColor];
    [tabControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.offset(0);
        make.height.offset(64);
    }];
    
    UIButton *tabControlCancleBtn = [UIButton new];
    [tabControlView addSubview:tabControlCancleBtn];
    [tabControlCancleBtn addTarget:self action:@selector(onClickCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    [tabControlCancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [tabControlCancleBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    tabControlCancleBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:18];
    [tabControlCancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    
    UIButton *tabControlCommitBtn = [UIButton new];
    [tabControlView addSubview:tabControlCommitBtn];
    [tabControlCommitBtn addTarget:self action:@selector(onClickCommitBtn) forControlEvents:UIControlEventTouchUpInside];
    [tabControlCommitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [tabControlCommitBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    tabControlCommitBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:18];
    [tabControlCommitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(0);
    }];
    
    
    [bottomMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.offset(0);
        make.bottom.equalTo(tabControlView.mas_top);
        make.top.equalTo(frameView.mas_bottom);
    }];
    
//    font-size: 36px;
//    color: #FFFFFF;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {

    return self.imgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2); {

}


- (void)installNavigationItems {

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(onClickCommitItem)];
}

- (void)onClickCommitItem {

    // 实际 大小
    CGSize imageSize = self.image.size;
    CGFloat rate = imageSize.width / self.fitWidth;
    // 比例 显示比例
    
    
    //
    CGFloat topMargin = (([UIScreen mainScreen].bounds.size.height) - ([UIScreen mainScreen].bounds.size.width - 30))/2;
    CGFloat leftMargin = (([UIScreen mainScreen].bounds.size.width) - ([UIScreen mainScreen].bounds.size.width - 30))/2;
    CGFloat bottomMargin = (([UIScreen mainScreen].bounds.size.height) - ([UIScreen mainScreen].bounds.size.width - 30))/2;
    CGFloat rightMargin = (([UIScreen mainScreen].bounds.size.width) - ([UIScreen mainScreen].bounds.size.width - 30))/2;
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.image.CGImage, CGRectMake((self.contentSize.contentOffset.x + leftMargin)  * rate / self.contentSize.zoomScale, (self.contentSize.contentOffset.y + topMargin) * rate / self.contentSize.zoomScale , self.frameHeight * rate / self.contentSize.zoomScale, self.frameHeight * rate / self.contentSize.zoomScale));
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    
    if([self.navigationController isKindOfClass:[RWImagePickerVC class]]) {
    // SelectedImageBlockType
        RWImagePickerVC *spVC = (RWImagePickerVC *)self.navigationController;
        if(spVC.selectedImageBlock){
        
            spVC.selectedImageBlock(thumbScale);
        }
    }
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)onClickCommitBtn {
    
    // 实际 大小
    CGSize imageSize = self.image.size;
    CGFloat rate = imageSize.width / self.fitWidth;
    // 比例 显示比例
    
    
    //
    CGFloat topMargin = (([UIScreen mainScreen].bounds.size.height) - ([UIScreen mainScreen].bounds.size.width - 30))/2;
    CGFloat leftMargin = (([UIScreen mainScreen].bounds.size.width) - ([UIScreen mainScreen].bounds.size.width - 30))/2;
    CGFloat bottomMargin = (([UIScreen mainScreen].bounds.size.height) - ([UIScreen mainScreen].bounds.size.width - 30))/2;
    CGFloat rightMargin = (([UIScreen mainScreen].bounds.size.width) - ([UIScreen mainScreen].bounds.size.width - 30))/2;
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.image.CGImage, CGRectMake((self.contentSize.contentOffset.x + leftMargin)  * rate / self.contentSize.zoomScale, (self.contentSize.contentOffset.y + topMargin) * rate / self.contentSize.zoomScale , self.frameHeight * rate / self.contentSize.zoomScale, self.frameHeight * rate / self.contentSize.zoomScale));
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef scale:1 orientation:self.image.imageOrientation];
    
    NSData * imageData = UIImageJPEGRepresentation(thumbScale,1);

    RWLog(@"%zd",[imageData length]/1024);
    
    CGImageRelease(imageRef);
    
    // thumbScale.imageOrientation = self.image.imageOrientation;
    
    if([self.navigationController isKindOfClass:[RWImagePickerVC class]]) {
        // SelectedImageBlockType
        RWImagePickerVC *spVC = (RWImagePickerVC *)self.navigationController;
        if(spVC.selectedImageBlock){
            
            spVC.selectedImageBlock(thumbScale);
        }
    }
    
    if(self.commitBlock) {
    
        self.commitBlock(thumbScale);
    }
    
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)onClickCancleBtn {

    // __weak weakSElf
    [self dismissViewControllerAnimated:true completion:^{
        if(self.cancleBlock){
        
            self.cancleBlock();
        }
    }];
    
}
@end
