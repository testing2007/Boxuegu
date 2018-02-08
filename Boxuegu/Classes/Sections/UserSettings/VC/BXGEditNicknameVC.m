//
//  BXGEditNicknameVC.m
//  Boxuegu
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGEditNicknameVC.h"
#import "BXGEditTextView.h"
#import "UIBarButtonItem+Common.h"

@interface BXGEditNicknameVC ()
@property (nonatomic, strong) UIBarButtonItem *saveBarButtonItem;
@property (nonatomic, strong) NSString *origNickname;
@property (nonatomic, weak) BXGEditTextView *textView;
@end

@implementation BXGEditNicknameVC

-(instancetype)initNickname:(NSString*)nickname {
    self = [super init];
    if(self) {
        _origNickname = nickname;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改昵称";
    self.view.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [self installUI];
    
    _saveBarButtonItem = [UIBarButtonItem createBarButtonItemWithTitle:@"保存" withImage:nil withTarget:self withAction:@selector(saveNickname)];
    self.navigationItem.rightBarButtonItem = _saveBarButtonItem;
}

- (void)installUI {
    BXGEditTextView *textView = [[BXGEditTextView alloc] initLimitCount:10
                                                             andContent:_origNickname
                                                         andPlaceholder:@"请输入您的昵称"
                                                         andFinishBlock:^(NSString *content) {
                                                             [self doFinishModifyBlock];
                                                         }];
    [self.view addSubview:textView];
    _textView = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(K_NAVIGATION_BAR_OFFSET+9);
        make.height.equalTo(@71);
    }];
}

- (void)saveNickname {
    [self doFinishModifyBlock];
}

- (void)doFinishModifyBlock {
    NSString *strContent = [_textView.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([strContent stringContainsEmoji]) {
        [[BXGHUDTool share] showHUDWithString:kBXGToastNoSupportEmoji];
        return ;
    }
    if([NSString isEmpty:strContent] || strContent.length<2) {
        [[BXGHUDTool share] showHUDWithString:@"请输入2-10个字"];
        return ;
    }
    if(_finishModifyBlock) {
        _finishModifyBlock(strContent);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
