//
//  BXGConfirmPopVC.m
//  Boxuegu
//
//  Created by HM on 2017/5/8.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGConfirmPopVC.h"

@interface BXGConfirmPopVC ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@end

@implementation BXGConfirmPopVC

-(void)awakeFromNib {

    [super awakeFromNib];

    self.view.layer.masksToBounds = true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.layer.masksToBounds = true;
    self.messageLabel.text = self.message;
    
    
    
    if([UIScreen mainScreen].scale == 3){
    
        // [self.popWindowWidthConstrainit setValue:@(0.70) forKey:@"multiplier"];
    }
    
}

- (IBAction)clickConfrimBtn:(UIButton *)sender {
    
   [self dismissViewControllerAnimated:true completion:^{
        if(self.confirmBlock) {
            
            self.confirmBlock();
        }
    }];
}

- (IBAction)clickCancleBtn:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:true completion:^{
        if(self.cancleBlock) {
            
            self.cancleBlock();
        }
    }];
}
@end
