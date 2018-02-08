//
//  BXGLiveChatView.m
//  SetupCCLive
//
//  Created by wurenying on 2018/1/10.
//  Copyright © 2018年 Renying Wu. All rights reserved.
//

#import "BXGLiveChatView.h"
#import "BXGLiveBottomChatView.h"
#import <Masonry.h>

#define kBXGLiveChatViewInputViewHeight 54

@interface BXGLiveChatView ()
@property (nonatomic, strong) UITableView *chatListView;
@property (nonatomic, strong) MYBottomChatView *chatInputView;

@property (nonatomic, strong) UIView *emojiView;
@property (nonatomic, strong) UIView *offsetView;


@end

@implementation BXGLiveChatView

#pragma mark - life cycle

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false];
    [self uninstallObservers];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true];
    [self installObservers];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self installUI];
}

#pragma mark - ui

- (void)installUI {
//    kBXGLiveChatViewInputViewHeight

    UIView *offsetView = self.offsetView;
    [self.view addSubview:offsetView];
    [offsetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(0);
    }];
    
    UIView *chatInputView = self.chatInputView;
    [self.view addSubview:chatInputView];
    [chatInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.offsetView.mas_top);
        make.left.right.offset(0);
        make.height.offset(kBXGLiveChatViewInputViewHeight);
    }];
    
    UIView *chatListView = self.chatListView;
    [self.view addSubview:chatListView];
    [chatListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.equalTo(self.chatInputView.mas_top);
        make.top.offset(0);
    }];
}

- (UIView *)offsetView {
    
    if(_offsetView == nil) {
        
        _offsetView = [UIView new];
//        _offsetView.backgroundColor = [UIColor orangeColor];
    }
    return _offsetView;
}

- (MYBottomChatView *)chatInputView {
    
    if(_chatInputView == nil) {
        _chatInputView = [MYBottomChatView new];
    }
    return _chatInputView;
}

- (UIView *)emojiView {
    
    if(_emojiView == nil) {
        _emojiView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        _emojiView.backgroundColor = [UIColor brownColor];
    }
    return _emojiView;
}

#pragma mark - Observers

- (void)installObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboadWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboadWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)uninstallObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboadWillShow:(NSNotification *)noti {
    NSValue *value = noti.userInfo[@"UIKeyboardBoundsUserInfoKey"];
    CGRect rect = value.CGRectValue;
    
    [self.offsetView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(rect.size.height);
    }];
}

- (void)keyboadWillHide:(NSNotification *)noti {
    [self.offsetView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0);
    }];
}

@end
