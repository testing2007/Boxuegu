//
//  BXGAlbumSelectObj.m
//  Boxuegu
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGAlbumSelectObj.h"
#import "RWContentEditingController.h"

@interface BXGAlbumSelectObj ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSString *titleTip;
@property (nonatomic, strong) NSString *messageTip;
@property (nonatomic, strong) NSString *cameraActionTitle;
@property (nonatomic, strong) NSString *albumActionTitle;
@property (nonatomic, copy) NSArray<NSString*> *actions;
@property (nonatomic, strong) RWContentEditingController *editVC;
@end

@implementation BXGAlbumSelectObj

- (instancetype)initWithVCDelegate:(UIViewController* _Nonnull)vcDelegate
                       andTitleTip:(NSString*)titleTip
                     andMessageTip:(NSString*)messageTip
              andCameraActionTitle:(NSString* _Nonnull)cameraActionTitle
               andAlbumActionTitle:(NSString* _Nonnull)albumActionTitle
             andConfirmActionBlock:(ConfirmActionBlockType)confirmActionBlock
              andCancelActionBlock:(CancelActionBlockType)cancelActionBlock
{
    self = [super init];
    if(self) {
        _vcDelegate = vcDelegate;
        _titleTip = titleTip;
        _messageTip = messageTip;
        _cameraActionTitle = cameraActionTitle;
        _albumActionTitle = albumActionTitle;
        _confirmActionBlock = confirmActionBlock;
        _cancelActionBlock = cancelActionBlock;
    }
    return self;
}

-(void)launchUI {
    if(!_vcDelegate || !_cameraActionTitle || !_albumActionTitle) {
        return ;
    }
    
    __weak typeof (self) weakSelf = self;
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:_titleTip
                                                                    message:_messageTip
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alerVC addAction:[UIAlertAction actionWithTitle:_cameraActionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerView = [UIImagePickerController new];
        pickerView.delegate = weakSelf;
        pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
        [weakSelf.vcDelegate presentViewController:pickerView animated:true completion:nil];
    }]];
    
    [alerVC addAction:[UIAlertAction actionWithTitle:_albumActionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerView = [UIImagePickerController new];
        pickerView.delegate = weakSelf;
        pickerView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [weakSelf.vcDelegate presentViewController:pickerView animated:true completion:nil];
    }]];
    
    [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_vcDelegate presentViewController:alerVC animated:true completion:nil];
    });
}

#pragma mark - Image Picker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info; {
    
    __weak typeof (self) weakSelf = self;
    [picker dismissViewControllerAnimated:true completion:^{
        self.editVC = [RWContentEditingController new];
        self.editVC.commitBlock = ^(UIImage *image) {
            if(weakSelf.confirmActionBlock) {

            if(image) {
                //上传图片, 上传完成后, editVC关闭, 最后刷新界面
                NSData *data ;
                if ( UIImagePNGRepresentation(image)==nil) {
                    data = UIImageJPEGRepresentation(image, 1);
                }else{
                    data = UIImagePNGRepresentation(image);
                }
                    weakSelf.confirmActionBlock(data);
                }
            }
            
        };
        self.editVC.image = nil;
        
        UIImage *imageOrigin = info[UIImagePickerControllerOriginalImage];
        
        //对原图片进行预裁剪
        CGFloat clipWndHeight = 700;
        CGFloat clipWndWidth = (imageOrigin.size.width / imageOrigin.size.height) * clipWndHeight;
        CGSize imageSize = CGSizeMake(clipWndWidth, clipWndHeight);
        
        self.editVC.image = [self imageWithImage:imageOrigin scaledToSize:imageSize];
        NSData * imageData = UIImageJPEGRepresentation(self.editVC.image,1);
        
        RWLog(@"%zd",[imageData length]/1024);
        [_vcDelegate presentViewController:self.editVC animated:true completion:nil];
    }];
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
        if(_cancelActionBlock) {
            _cancelActionBlock();
        }
    }];
}

@end
