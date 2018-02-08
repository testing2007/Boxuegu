//
//  BXGPraisePopVC.m
//  Boxuegu
//
//  Created by HM on 2017/5/8.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPraisePopVC.h"

@interface BXGPraisePopVC ()

@property(nonatomic, copy) void (^commentBlock)();
@property(nonatomic, copy) void (^feedbackBlock)();
@property(nonatomic, copy) void (^cancelBlock)();
@property (weak, nonatomic) IBOutlet UIView *popView;

@end

@implementation BXGPraisePopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.popView.layer.cornerRadius = 5;
    self.popView.layer.masksToBounds = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(instancetype)initWithCommenBlock:( void (^)() )commentBlock
                 withFeedbackBlock:( void (^)() )feedbackBlock
                   withCancelBlock:( void (^)() )cancelBlock
{
    self = [super init];
    if(self)
    {
        _commentBlock = commentBlock;
        _feedbackBlock = feedbackBlock;
        _cancelBlock = cancelBlock;
    }
    return self;
}

- (IBAction)cancel:(id)sender {
    if(_cancelBlock)
    {
        _cancelBlock();
    }
}

- (IBAction)comment:(id)sender {
    if(_commentBlock)
    {
        _commentBlock();
    }
}

- (IBAction)feedback:(id)sender {
    if(_feedbackBlock)
    {
        _feedbackBlock();
    }
}

/*
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(_cancelBlock)
    {
        _cancelBlock();
    }
}
//*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
