//
//  BXGConstrueChatView.m
//  Boxuegu
//
//  Created by wurenying on 2018/1/12.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGConstrueChatView.h"
#import "BXGConstrueChatLeftCell.h"
#import "BXGConstrueChatRightCell.h"
#import "BXGConstrueKeyboardView.h"
#import "BXGLiveManager.h"

@interface BXGConstrueChatView() <UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BXGConstrueKeyboardView *chatView;
@property (nonatomic, strong) UIView *emojiView;
@property (nonatomic, strong) UIView *offsetView;
@end
@implementation BXGConstrueChatView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        [self installUI];
        
    }
    return self;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if(self.window) {
        // install
        [self installObservers];
    }else {
        // uninstsall
        [self uninstallObservers];
    }
}
- (void)dealloc {
    
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
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
    
    NSInteger count = [self.tableView numberOfRowsInSection:0];
    if(count > 1) {

        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:true];
    }
}

- (void)keyboadWillHide:(NSNotification *)noti {
    [self.offsetView mas_updateConstraints:^(MASConstraintMaker *make) {
        if(K_IS_IPHONE_X){
            make.height.offset(K_BOTTOM_SAFE_OFFSET);
        }else {
            make.height.offset(0);
        }
        
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - interface

- (void)setModelArray:(NSArray<BXGLiveDialogModel *> *)modelArray {
    
    _modelArray = modelArray;
    [self.tableView reloadData];
    
    NSInteger count = [self.tableView numberOfRowsInSection:0];
    if(count > 1) {
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:true];
    }
    
//    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height) animated:true];
}


#pragma mark - ui

- (void)installUI {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = self.tableView;
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
    }];
    
    UIView *chatView = self.chatView;
    [self addSubview:chatView];
    [chatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(54);
        make.top.equalTo(tableView.mas_bottom);
    }];

    UIView *offsetView = self.offsetView;
    [self addSubview:offsetView];
    
    [offsetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        if(K_IS_IPHONE_X){
            make.height.offset(K_BOTTOM_SAFE_OFFSET);
        }else {
            make.height.offset(0);
        }
        make.top.equalTo(chatView.mas_bottom);
        make.bottom.offset(0);
    }];
}

- (BXGConstrueKeyboardView *)chatView {
    
    if(_chatView == nil) {
        
        _chatView = [BXGConstrueKeyboardView new];
    }
    return _chatView;
}

- (void)setSendMessageBlock:(void (^)(NSString *))sendMessageBlock {
    
    self.chatView.sendMessageBlock = sendMessageBlock;
}

- (void (^)(NSString *))sendMessageBlock {
    return self.chatView.sendMessageBlock;
}

- (UIView *)offsetView {
    
    if(_offsetView == nil) {
        
        _offsetView = [UIView new];
    }
    return _offsetView;
}

- (UIView *)emojiView {
    
    if(_emojiView == nil) {
        _emojiView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        _emojiView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    }
    return _emojiView;
}

- (UITableView *)tableView {
    
    if(_tableView == nil) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[BXGConstrueChatRightCell class] forCellReuseIdentifier:BXGConstrueChatRightCell.description];
        [_tableView registerClass:[BXGConstrueChatLeftCell class] forCellReuseIdentifier:BXGConstrueChatLeftCell.description];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapChatView:)];
        [_tableView addGestureRecognizer:tap];
    }
    return _tableView;
}

#pragma mark - Response

- (void)tapChatView:(UITapGestureRecognizer *)tap {
    if(self.chatView.textView.isFirstResponder) {
        [self.chatView.textView resignFirstResponder];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BXGLiveDialogModel *model = self.modelArray[indexPath.row];
    
    if([model.userId isEqualToString:[BXGUserCenter share].userModel.user_id]) {
        BXGConstrueChatRightCell *cell = [tableView dequeueReusableCellWithIdentifier:BXGConstrueChatRightCell.description forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }else {
        BXGConstrueChatLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:BXGConstrueChatLeftCell.description forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.modelArray.count;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if(self.chatView.textView.isFirstResponder) {
        [self.chatView.textView resignFirstResponder];
    }
}

@end
