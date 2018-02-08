//
//  BXGMessageNotiModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@class BXGMessageModel;
@interface BXGMessageNotiModel : BXGBaseModel
@property (nonatomic, strong) NSString *unReadCount;
@property (nonatomic, strong) BXGMessageModel *lastMessage;
@end
