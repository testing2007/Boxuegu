//
//  BXGOrderFreeCoursePopVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderFreeCoursePopVC.h"
#import "BXGHomeCourseModel.h"
#import "RWDeviceInfo.h"

@interface BXGOrderFreeCoursePopVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIImageView *courseImgV;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLb;
@property (weak, nonatomic) IBOutlet UILabel *courseAccountLb;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIView *spView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *cententView;
@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation BXGOrderFreeCoursePopVC

- (void)setCourseModel:(BXGHomeCourseModel *)courseModel {
    if(self.view) {
        self.courseNameLb.text = courseModel.courseName;
        [self.courseImgV sd_setImageWithURL:[NSURL URLWithString:courseModel.courseImg] placeholderImage:[UIImage imageNamed:@"默认加载图"]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self installUI];
}
- (void)installUI {
    
    self.titleLb.text = @"报名课程";
    self.titleLb.font = [UIFont bxg_fontRegularWithSize:18];
    self.titleLb.textColor = [UIColor colorWithHex:0xffffff];
    
    self.courseNameLb.text = @"";
    self.courseNameLb.textColor = [UIColor colorWithHex:0x333333];
    self.courseAccountLb.text = @"免费";
    self.courseAccountLb.textColor = [UIColor colorWithHex:0xff554c];
    
    self.cancleBtn.tintColor = [UIColor colorWithHex:0x999999];
    self.acceptBtn.tintColor = [UIColor colorWithHex:0xffffff];
    self.acceptBtn.backgroundColor = [UIColor themeColor];
    self.acceptBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:18];
    self.cancleBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:18];
    [self.acceptBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.spView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    self.headerView.backgroundColor = [UIColor themeColor];
    self.courseImgV.contentMode = UIViewContentModeScaleAspectFill;
    self.courseImgV.layer.masksToBounds = true;
    if([RWDeviceInfo deviceScreenType] == RWDeviceScreenTypePlus) {
        // plus
        self.popView.layer.cornerRadius = 10;
        self.courseNameLb.font = [UIFont bxg_fontRegularWithSize:16];
        self.courseAccountLb.font = [UIFont bxg_fontRegularWithSize:16];
        
    }else {
        // not plus
        self.popView.layer.cornerRadius = 8;
        self.courseNameLb.font = [UIFont bxg_fontRegularWithSize:14];
        self.courseAccountLb.font = [UIFont bxg_fontRegularWithSize:14];
    }
    
    self.popView.layer.masksToBounds = true;
}
- (IBAction)onClickCancleBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:^{
        if(self.clickCancleBtnBlock) {
            self.clickCancleBtnBlock();
        }
    }];
}
- (IBAction)onClickAcceptBtn:(UIButton *)sender {
    
    if(self.clickAcceptBtnBlock) {
        self.clickAcceptBtnBlock();
    }
}



@end
