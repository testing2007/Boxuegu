//
//  BXGCommunityAttentionView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGCommunityUserModel.h"

typedef void(^OnClickBtnBlockType)(NSInteger index);
@interface BXGCommunityAttentionView : UIView
@property (nonatomic, copy) OnClickBtnBlockType onClickBtnBlock;
@property (nonatomic, strong) NSArray<BXGCommunityUserModel *> *cuModelArray;
@property (nonatomic, assign) NSInteger maxColNum;
@end
