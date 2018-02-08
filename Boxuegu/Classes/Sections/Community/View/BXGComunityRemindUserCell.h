//
//  BXGComunityRemindUserCell.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGCommunityUserModel.h"

@interface BXGComunityRemindUserCell : UITableViewCell
@property (nonatomic, assign) BOOL isUserSelected;
@property (nonatomic, strong) BXGCommunityUserModel *model;
@end
