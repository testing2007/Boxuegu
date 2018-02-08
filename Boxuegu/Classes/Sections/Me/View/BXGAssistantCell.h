//
//  BXGAssistantCell.h
//  Boxuegu
//
//  Created by HM on 2017/6/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BXGMessageTool.h"

@interface BXGAssistantCell : UITableViewCell

@property (nonatomic, strong) BXGMessageModel *model;
@property (nonatomic, assign) NSInteger badgeNumber;
@end
