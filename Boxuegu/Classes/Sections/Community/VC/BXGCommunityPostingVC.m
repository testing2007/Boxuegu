//
//  BXGCommunityPostingVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/28.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommunityPostingVC.h"
#import <CoreLocation/CoreLocation.h>

// Lib
#import "RWTextView.h"
#import "RWImagePicker.h"

#import "BXGSelectedImageView.h"
#import "BXGChoiceTagView.h"
#import "BXGRequestLocationBtn.h"
#import "BXGLocationManager.h"
#import "BXGPostingViewModel.h"
#import "BXGPostingRemindWhoVC.h"
#import "BXGCommunityUploader.h"
#import "BXGCommunityAttentionView.h"
#import "RWDeviceInfo.h"

@interface BXGCommunityPostingVC () <UIImagePickerControllerDelegate, UITextViewDelegate, UINavigationControllerDelegate>


@property (nonatomic, weak) BXGSelectedImageView *seletedImageView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<UIImage *> *imageArray;
@property (nonatomic, weak) RWTextView *textView;
@property (nonatomic, strong) BXGPostingViewModel *viewModel;
@property (nonatomic, strong) UIAlertController *alerVC;
@property (nonatomic, strong) RWContentEditingController *editVC;
@property (nonatomic, strong) NSArray <BXGPostTopicModel *> *topicModelArray;

@property (nonatomic, strong) BXGChoiceTagView *choiceTagView;

@property (nonatomic, strong) BXGCommunityAttentionView *attentionView;
@property (nonatomic, weak) UIButton *commitBtn;

// 帖子相关缓存数据
@property (nonatomic, strong) NSString *currentLocation;
@property (nonatomic, strong) BXGPostTopicModel *currentPostTopicModel;
@end

@implementation BXGCommunityPostingVC

#pragma mark - Init / Getter / Setter
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
    
    }
    return self;
}

- (BXGPostingViewModel *)viewModel {

    if(!_viewModel){
    
        _viewModel = [BXGPostingViewModel new];
    }
    return _viewModel;
}

- (NSMutableArray<UIImage *> *)imageArray {

    if(!_imageArray){
    
        _imageArray = [NSMutableArray new];
    }
    return _imageArray;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布帖子";
    self.pageName = @"博学圈发帖页面";
    
    [self installUI];
    [self installNavigationItems];
    // [self installObeservers];
    
    [self loadData];
    
}
#pragma mark - Load Data

- (void)loadData {

    __weak typeof (self) weakSelf = self;
    [self.viewModel loadPostTopicListWithFinished:^(NSArray<BXGPostTopicModel *> *topicModelArray) {
        
        weakSelf.topicModelArray = topicModelArray;
        weakSelf.choiceTagView.modelArray = topicModelArray;
        // choiceTagView.modelArray = @[@"我是标签",@"我是标签",@"我是标签",@"我是标签",@"我是标签",@"我是标签",@"我是标签"];
    }];
}

#pragma mark - Install UI
- (void)installUI {

    self.automaticallyAdjustsScrollViewInsets = false;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchUpMainView)]];

    // *** Scroll View
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.showsVerticalScrollIndicator = false;
    scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.right.offset(0);
        make.bottom.offset(0);
    }];
    scrollView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    scrollView.alwaysBounceVertical = true;
    
    // *** Content View
    UIView *contentView = [UIView new];
    [scrollView addSubview:contentView];

    UIView *commitContentView = [UIView new];
    [contentView addSubview:commitContentView];
    
    commitContentView.backgroundColor = [UIColor whiteColor];
    
    // *** content view
    RWTextView *textView = [[RWTextView alloc]init];
    //textView.delegate = self;
    textView.minimumHeight = 130;
    textView.isAutoSizeFit = true;
    self.textView = textView;
    [commitContentView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
        make.height.offset(textView.minimumHeight);
    }];
    textView.backgroundColor = [UIColor whiteColor];
    textView.countNumber = 200;
    textView.placeHolder = @"分享你的心得和经验吧！";
    // text
    BXGSelectedImageView *seletedImageView = [BXGSelectedImageView new];
    
    
    if([RWDeviceInfo deviceScreenType] <= RWDeviceScreenTypeSE) {
    
        seletedImageView.lineItemMaxCount = 3;
    }else {
    
        seletedImageView.lineItemMaxCount = 4;
    }
    
    
    seletedImageView.horizontalMargin = 20;
    [commitContentView addSubview:seletedImageView];
    [seletedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(textView.mas_bottom);
    }];
    __weak typeof (self) weakSelf = self;
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"选择图片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    self.alerVC = alerVC;
    [alerVC addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[BXGBaiduStatistic share] statisticEventString:bxq_xcxz andParameter:nil];
        UIImagePickerController *pickerView = [UIImagePickerController new];
        pickerView.delegate = weakSelf;
        pickerView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [weakSelf presentViewController:pickerView animated:true completion:nil];
    }]];
    
    [alerVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[BXGBaiduStatistic share] statisticEventString:bxq_pz andParameter:nil];
        UIImagePickerController *pickerView = [UIImagePickerController new];
        pickerView.delegate = weakSelf;
        pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
        [weakSelf presentViewController:pickerView animated:true completion:nil];
    }]];
    
    [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        // [alerVC dismissViewControllerAnimated:true completion:nil];
    }]];
    
    
  
    
    seletedImageView.onClickAddBtnBlock = ^{
        [[BXGBaiduStatistic share] statisticEventString:bxq_tjtp andParameter:nil];
        [weakSelf presentViewController:alerVC animated:true completion:nil];
    };
    
    self.seletedImageView = seletedImageView;
    
    BXGRequestLocationBtn *locationButton = [BXGRequestLocationBtn new];
    [commitContentView addSubview:locationButton];

    [locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        // make.width.offset(80);
        make.height.offset(21);
        make.left.offset(15);
        make.top.equalTo(seletedImageView.mas_bottom).offset(15);
    }];
    locationButton.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    locationButton.stirng = @"开始定位";
    [locationButton addTarget:self action:@selector(onTouchDownLocationBtn:) forControlEvents:UIControlEventTouchDown];
    
    
    // *** tag view
    UIView *tagContentView = [UIView new];
    tagContentView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:tagContentView];
    
    
    
    UIView *tagTitleView = [UIView new];
    [tagContentView addSubview:tagTitleView];
    [tagTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.top.offset(0);
        make.height.offset(46);
    }];
    
    UILabel *tagTitleLabel = [UILabel new];
    tagTitleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    tagTitleLabel.textColor = [UIColor colorWithHex:0x666666];
    [tagTitleView addSubview:tagTitleLabel];
    tagTitleLabel.text = @"添加学科标签";
    [tagTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    
    BXGChoiceTagView *choiceTagView = [BXGChoiceTagView new];
    
    if([RWDeviceInfo deviceScreenType] <= RWDeviceScreenTypeSE) {
        
        choiceTagView.maxColCount = 3;
    }else {
        
        choiceTagView.maxColCount = 4;
    }
    
    
    // [BXGd]
    
    [tagContentView addSubview:choiceTagView];
    [choiceTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(tagTitleView.mas_bottom).offset(-5);
        make.left.right.offset(0);
        make.height.offset(0);
    }];
    self.choiceTagView = choiceTagView;
    
    
    choiceTagView.selectIndexBlock = ^(NSInteger index) {
      
        weakSelf.currentPostTopicModel = weakSelf.topicModelArray[index];
    };
    
    
    [tagContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.equalTo(commitContentView.mas_bottom).offset(9);
        make.bottom.equalTo(choiceTagView.mas_bottom).offset(0);
    }];

    // **** remind
    
    UIView *remindContentView = [UIView new];
    remindContentView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:remindContentView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapRemindView)];;
    [remindContentView addGestureRecognizer:tap];
    UILabel *remindTitle = [UILabel new];
    remindTitle.font = [UIFont bxg_fontRegularWithSize:16];
    remindTitle.textColor = [UIColor colorWithHex:0x666666];
    remindTitle.text = @"提醒谁看";
    

    
//    UIView *remindTitleView = [UIView new];
//    [remindContentView addSubview:remindTitleView];
//    [remindTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(0);
//        make.left.right.offset(0);
//        make.height.offset(46);
//        
//    }];
    [remindContentView addSubview:remindTitle];
    [remindTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    
    remindContentView.hidden = true;
    UIImageView *indicatorIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"个人-右箭头"]];
    [remindContentView addSubview:indicatorIcon];
    indicatorIcon.contentMode = UIViewContentModeScaleAspectFit;
    [indicatorIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(0);
        make.height.offset(15);
        make.width.offset(15);
    }];
    // who
    
    BXGCommunityAttentionView *attentionView = [BXGCommunityAttentionView new];
    
    attentionView.maxColNum = 5;
    [remindContentView addSubview:attentionView];
    self.attentionView = attentionView;
    [attentionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(remindTitle.mas_right).offset(15);
        make.right.equalTo(indicatorIcon.mas_left).offset(-15);
        make.height.offset(0);
        make.centerY.offset(0);
        
        // make.bottom.offset(0);
    }];
    
    // [UIImage new]
    
    [remindContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(tagContentView.mas_bottom).offset(9);
        make.left.right.offset(0);
        // make.bottom.equalTo(choiceTagView).offset(15);
        // make.height.offset(46);
        // make.height.equalTo(attentionView);
        make.height.greaterThanOrEqualTo(@46);
        make.bottom.equalTo(attentionView.mas_bottom).offset(0);
    }];
    
    [commitContentView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [commitContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.offset(0);
        // make.height.equalTo(commitContentView.superview).offset(-9);
        make.width.equalTo(commitContentView.superview);
        make.bottom.equalTo(locationButton.mas_bottom).offset(9);
        
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(9);
        make.left.right.bottom.offset(0);
        // make.height.equalTo(contentView.superview).offset(-9);
        make.width.equalTo(contentView.superview);
        make.bottom.equalTo(remindContentView.mas_bottom).offset(100);
    }];
   
}

- (void)installNavigationItems {
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    commitBtn.tintColor = [UIColor whiteColor];
    [commitBtn setTitle:@"发布"forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    [commitBtn sizeToFit];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:commitBtn];
    [commitBtn addTarget:self action:@selector(onClickCommitBtn) forControlEvents:UIControlEventTouchUpInside];
    self.commitBtn = commitBtn;
}

- (void)onTouchDownLocationBtn:(BXGRequestLocationBtn *)sender {
    Weak(weakSelf);
    // [[BXGHUDTool share] showLoadingHUDWithString:@"定位中..."];
    [[BXGBaiduStatistic share] statisticEventString:bxq_dw andParameter:nil];
    
    // 开始定位
    sender.stirng = @"定位中...";
    sender.enabled = false;
    [[BXGLocationManager share] requestCurrentProvinceAndCityStringWithFinishedBlock:^(NSString *string) {
    
        if(string){
        
            weakSelf.currentLocation = string;
            sender.stirng = string;
        }else {
        
            weakSelf.currentLocation = nil;
            
            sender.stirng = @"定位失败";
            if(CLLocationManager.authorizationStatus != kCLAuthorizationStatusNotDetermined) {
            
                BXGAlertController *vc = [BXGAlertController locationAuthorityWithconfirmHandler:nil cancleHandler:nil];
                [self presentViewController:vc animated:true completion:nil];
                
            }else {
            
                
            }
            
        }
        sender.enabled = true;
        // [[BXGHUDTool share] closeHUD];
    }];
}
- (void)onTapRemindView {

    [[BXGBaiduStatistic share] statisticEventString:bxq_ftan andParameter:nil];
    __weak typeof (self) weakSelf = self;
    // push
    BXGPostingRemindWhoVC *remindVC = [BXGPostingRemindWhoVC new];
    remindVC.viewModel = self.viewModel;
    remindVC.commitBlock = ^(NSArray<BXGCommunityUserModel *> *modelArray) {
        weakSelf.attentionView.cuModelArray = modelArray;
    };
    
    [self.navigationController pushViewController:remindVC animated:true];
}

- (void)onClickCommitBtn {
    
    [[BXGBaiduStatistic share] statisticEventString:bxq_ftfb andParameter:nil];
    [self actionForCommit];
}

#pragma mark - Response
- (void)touchUpMainView {
    [self.textView endEditing:true];
}
#pragma mark - Action

- (void)actionForCommit {

    Weak(weakSelf);
    NSString *text = self.textView.text;
    if(text){
        
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    if([self.textView hasEmoji]) {
        
        [[BXGHUDTool share] showHUDWithString:kBXGToastNoSupportEmoji];
        return;
    }
    
    if(!text || [text isEqualToString:@""]) {
        
        [[BXGHUDTool share] showHUDWithString:@"内容为空，写点什么吧！!"];
        return;
    }
    NSArray *imageArray = self.seletedImageView.imageArray;
    if(imageArray.count <= 0){
    
        [[BXGHUDTool share] showHUDWithString:@"至少上传一张图片哟！"];
        return;
    }
    
    if(!self.currentPostTopicModel) {
    
        [[BXGHUDTool share] showHUDWithString:@"选择一个话题，再发布吧！"];
        return;
    }
    
    [[BXGHUDTool share] showLoadingHUDWithString:@"发布中..." andView:self.view];
    
    BXGCommunityUploader *uploader = [BXGCommunityUploader share];
    self.commitBtn.enabled = false;
    if(imageArray && imageArray.count > 0) {
        
        // [[BXGHUDTool share] showLoadingHUDWithString:@"上传图片中..." andView:self.view];
        // [[BXGHUDTool share] showLodingHUDWithString:@"上传图片中..." andView:self.view];
        [uploader uploadCommunityImageArray:imageArray andFinishedBlock:^(NSArray<NSString *> *urlStringArray) {
            
            if(urlStringArray) {
                
                // [[BXGHUDTool share] closeHUD];
                [weakSelf postWithImageList:urlStringArray];
                
                // [[BXGHUDTool share] showHUDWithString:@"上传图片成功"];
            }else {
                
                [[BXGHUDTool share] closeHUD];
                [[BXGHUDTool share] showHUDWithString:@"发布失败,请稍后重试!"];
                self.commitBtn.enabled = true;
            }
        }];
        
    }else {
        
        [weakSelf postWithImageList:nil];
    }
    
    
}

#pragma mark -

- (void)uploadImageList {


    
    
}

- (void)postWithImageList:(NSArray *)imgUrlList {

//    [[BXGHUDTool share] showLoadingHUDWithString:@"发布中..." andView:self.view];
    Weak(weakSelf);
    // 图片url拼接
    NSMutableString *urlStringList;
    if(imgUrlList && imgUrlList.count > 0) {
        
        urlStringList = [NSMutableString new];
        [urlStringList appendString:imgUrlList[0]];
        
        
        for(NSInteger i = 1; i < imgUrlList.count; i ++){
            
            [urlStringList appendString:@","];
            [urlStringList appendString:imgUrlList[i]];
        }
        
    }
    
    // 提醒人id拼接
    NSMutableString *userIdList;
    if(weakSelf.attentionView.cuModelArray && weakSelf.attentionView.cuModelArray.count > 0) {
        
        userIdList = [NSMutableString new];
        
        [userIdList appendString:weakSelf.attentionView.cuModelArray[0].userId];
        
        for(NSInteger i = 1; i < weakSelf.attentionView.cuModelArray.count; i++) {
            
            [userIdList appendFormat:@","];
            [userIdList appendString:weakSelf.attentionView.cuModelArray[i].userId];
        }
    }
    
    // 参数
    
    NSNumber *uuid = [BXGUserCenter share].userModel.itcast_uuid;
    NSNumber *topicId = weakSelf.currentPostTopicModel.idx;
    NSString *content = weakSelf.textView.text;
    
    NSString *location = self.currentLocation;
    NSString *sign = [BXGUserCenter share].userModel.sign;
    
    [[BXGNetWorkTool sharedTool] requestSavePostWithUUID:uuid andTopicId:topicId andContent:content andImagePathList:urlStringList andLocation:location andUUIDList:userIdList.copy andSign:sign andFinished:^(id  _Nullable responseObject) {
        
        [BXGNetworkParser communityNetworkParser:responseObject andFinished:^(NSInteger status, NSString *message, id result) {
            
            if(status == 200) {
            
                [[BXGHUDTool share] closeHUD];
                [[BXGHUDTool share] showHUDWithString:@"发布成功"];
                
                [weakSelf.navigationController popViewControllerAnimated:true];
            }else {
            
                [[BXGHUDTool share] closeHUD];
                [[BXGHUDTool share] showHUDWithString:@"发布失败,请稍后重试!"];
            }
        }];
        
        RWLog(@"%@",responseObject);
        self.commitBtn.enabled = true;
    } Failed:^(NSError * _Nonnull error) {
        
        [[BXGHUDTool share] showHUDWithString:@"发布失败,请稍后重试!"];
        RWLog(@"%@",error);
        self.commitBtn.enabled = true;
    }];
}

#pragma mark - Image Picker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info; {
    
    __weak typeof (self) weakSelf = self;
    [picker dismissViewControllerAnimated:true completion:^{
        
        
        self.editVC = [RWContentEditingController new];
        self.editVC.commitBlock = ^(UIImage *image) {
            
            if(image) {
                [weakSelf.imageArray addObject:image];
                [weakSelf.seletedImageView addImage:image];
            }
        };
        // RWContentEditingController *editVC = [[RWContentEditingController alloc]init];
        self.editVC.image = nil;
        //self.editVC.image = info[UIImagePickerControllerOriginalImage];
        
        UIImage *imageOrigin = info[UIImagePickerControllerOriginalImage];
        
        //对原图片进行预裁剪
        CGFloat clipWndHeight = 700;
        CGFloat clipWndWidth = (imageOrigin.size.width / imageOrigin.size.height) * clipWndHeight;
        CGSize imageSize = CGSizeMake(clipWndWidth, clipWndHeight);
        
        self.editVC.image = [self imageWithImage:imageOrigin scaledToSize:imageSize];
        NSData * imageData = UIImageJPEGRepresentation(self.editVC.image,1);
        
        RWLog(@"%zd",[imageData length]/1024);
        [self presentViewController:self.editVC animated:true completion:nil];
    }];
    

    
    //     UIImagePickerControllerMediaType = "public.image";
    
    // UIImagePickerControllerOriginalImage = "<UIImage: 0x17409aea0> size {640, 1136} orientation 0 scale 1.000000";
    
    // UIImagePickerControllerReferenceURL = "assets-library://asset/asset.PNG?id=DB5DAACA-AB86-4C73-A8D2-DA686E2E8A05&ext=PNG";
    
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker; {

    [picker dismissViewControllerAnimated:true completion:^{
        
    }];
}
@end
