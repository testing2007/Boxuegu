//
//  RWSelectPhotoVC.m
//  demo-RWPhotosFramework
//
//  Created by RenyingWu on 2017/8/15.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "RWImagePickerVC.h"
#import "RWSelectPhotoAlbumVC.h"

@interface RWImagePickerVC ()

@end

@implementation RWImagePickerVC
@synthesize delegate = _delegate;

- (void)setDelegate:(id<UINavigationControllerDelegate,RWImagePickerDelegate>)delegate {

    _delegate = delegate;
    super.delegate = delegate;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
    
        [self addChildViewController:[RWSelectPhotoAlbumVC new]];
        self.navigationBar.tintColor = [UIColor blackColor];;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
