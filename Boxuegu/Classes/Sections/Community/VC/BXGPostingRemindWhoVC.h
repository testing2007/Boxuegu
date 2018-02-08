//
//  BXGPostingRemindWhoVC.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseRootVC.h"
#import "BXGCommunityUserModel.h"
#import "BXGPostingViewModel.h"
#import "BXGUserCenter.h"

typedef void(^CommitSelectedModelBlockType)(NSArray <BXGCommunityUserModel *>*modelArray);
@interface BXGPostingRemindWhoVC : BXGBaseRootVC
@property (nonatomic, strong) NSMutableArray <BXGCommunityUserModel *>* userModelArray;
@property (nonatomic, strong) BXGPostingViewModel *viewModel;
@property (nonatomic, copy) CommitSelectedModelBlockType commitBlock;

//
@end
