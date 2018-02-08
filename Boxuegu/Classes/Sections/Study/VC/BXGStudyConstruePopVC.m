//
//  BXGStudyConstrueInfoController.m
//  Boxuegu
//
//  Created by HM on 2017/4/22.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGStudyConstruePopVC.h"

@interface BXGStudyConstruePopVC ()
@property (weak, nonatomic) IBOutlet UILabel *construeName;
@property (weak, nonatomic) IBOutlet UILabel *construeTeacher;
@property (weak, nonatomic) IBOutlet UILabel *construeRoomLink;
@property (weak, nonatomic) IBOutlet UILabel *constureDuration;
@property (weak, nonatomic) IBOutlet UILabel *constureStartTime;
@property (weak, nonatomic) IBOutlet UIView *windowView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popWindowWidthConstrainit;
@property (weak, nonatomic) IBOutlet UILabel *construeEndTime;


@end

@implementation BXGStudyConstruePopVC

#pragma mark - Life Cycle

- (BOOL)shouldAutorotate {
    return true;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self installUI];
}

#pragma mark - install UI
- (void)installUI {

    self.view.backgroundColor = [UIColor clearColor];
    
    // 适配 6sPlus and 7sPlus 机型约束
    if([UIScreen mainScreen].scale == 3){
        
        [self.popWindowWidthConstrainit setValue:@(0.70) forKey:@"multiplier"];
    }
    // 判断数据是否正常
    if(self.model) {
        
        // 逻辑: 数据正常
        
        self.windowView.layer.cornerRadius = 10;
        self.windowView.layer.masksToBounds = true;
        // 逻辑: 展示串讲信息
        self.construeName.text = self.model.chuanjiang_name;
        self.construeTeacher.text = self.model.teacher_name;
        self.construeRoomLink.text = self.model.chuanjiang_room_link;
        self.constureDuration.text = [self.model.chuanjiang_duration stringByAppendingString:@"小时"];
        NSString *startTime = [[BXGDateTool share] shortTimeformatFromLong:self.model.chuanjiang_start_time];
        if(startTime) {
            
            self.constureStartTime.text = startTime;
        }else {
            
            self.constureStartTime.text = @"";
        }
        
        NSString *endTime = [[BXGDateTool share] shortTimeformatFromLong:self.model.chuanjiang_end_time];
        if(startTime) {
            
            self.construeEndTime.text = endTime;
        }else {
            
            self.construeEndTime.text = @"";
        }
        
    }else {
        
        // 逻辑: 数据异常
    }
}

#pragma mark - Response

- (IBAction)toConstrueBtn:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        if(self.toConstrueBlock && self.model){
            
            self.toConstrueBlock(self.model);
        }
    }];
}

- (IBAction)clickCancleBtn:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


@end
