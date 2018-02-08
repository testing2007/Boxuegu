//
//  BXGEditAutographVC.m
//  Boxuegu
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGEditAutographVC.h"
#import "BXGEditTextView.h"
#import "UIBarButtonItem+Common.h"

#define kEditAutographPlaceholder @"说点什么来彰显你的个性吧......"

@interface BXGEditAutographVC ()
@property (nonatomic, strong) UIBarButtonItem *saveBarButtonItem;
@property (nonatomic, weak) BXGEditTextView *textView;
@property (nonatomic, strong) NSString *origAutograph;
@end

@implementation BXGEditAutographVC

-(instancetype)initAutograph:(NSString*)autograph {
    self = [super init];
    if(self) {
        _origAutograph = autograph;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"编写签名";
    
    self.view.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
    [self installUI];
    
    
    _saveBarButtonItem = [UIBarButtonItem createBarButtonItemWithTitle:@"保存" withImage:nil withTarget:self withAction:@selector(saveAutograph)];
    self.navigationItem.rightBarButtonItem = _saveBarButtonItem;

    
}

- (void)installUI {
    BXGEditTextView *textView = [[BXGEditTextView alloc] initLimitCount:30
                                                             andContent:_origAutograph
                                                         andPlaceholder:kEditAutographPlaceholder
                                                 andFinishBlock:^(NSString *content) {
                                                     [self doModifyAutograph];
                                                 }];
    [self.view addSubview:textView];
    _textView = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(K_NAVIGATION_BAR_OFFSET+9);
        make.height.equalTo(@110);
    }];
}

- (void)saveAutograph {
    [self doModifyAutograph];
}

- (void)doModifyAutograph {
    NSString *strContent = [self.textView content];
    if([strContent stringContainsEmoji]) {
        [[BXGHUDTool share] showHUDWithString:kBXGToastNoSupportEmoji];
        return ;
    }
    if([NSString isEmpty:strContent]) {
        [[BXGHUDTool share] showHUDWithString:@"签名为空，请输入签名吧!"];
    } else {
        if(_finishModifyAutographBlock) {
            _finishModifyAutographBlock(strContent);
        }
    }
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
