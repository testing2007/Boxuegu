//
//  BXGConstrueChatView.h
//  Boxuegu
//
//  Created by wurenying on 2018/1/12.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXGLiveDialogModel;

@interface BXGConstrueChatView : UIView

@property (nonatomic, strong) NSArray<BXGLiveDialogModel *>*modelArray;
@property (nonatomic, copy) void(^onDidScroll)(UIScrollView *scrollView);
@property (nonatomic, copy) void(^sendMessageBlock)(NSString *msg);
@end
