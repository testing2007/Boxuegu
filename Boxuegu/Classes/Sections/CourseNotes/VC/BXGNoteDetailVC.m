//
//  BXGNoteDetailVC.m
//  Boxuegu
//
//  Created by apple on 2017/8/17.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGNoteDetailVC.h"

@interface BXGNoteDetailVC ()

@property (weak, nonatomic) UITextView *contentTextView;

@end

@implementation BXGNoteDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"笔记详情";
    self.pageName = @"笔记详情页";
    
    UIView *spView = [UIView new];
    [self.view addSubview:spView];
    spView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.right.offset(0);
        make.height.offset(9);
    }];
    
    UITextView *textView = [UITextView new];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName: [UIFont bxg_fontRegularWithSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSForegroundColorAttributeName:[UIColor colorWithHex:0x333333],
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:_content attributes:attributes];
    textView.scrollEnabled = YES;
    textView.editable = NO;
    [self.view addSubview:textView];
    _contentTextView = textView;
    
    [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spView.mas_bottom).offset(0);//debug iPhone6s 490
        make.left.offset(15);
        make.right.bottom.offset(-15);
    }];
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
