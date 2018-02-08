//
//  BXGMessageCell.h
//  Boxuegu
//
//  Created by HM on 2017/6/16.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGMessageModel.h"

@interface BXGMessageCell : UITableViewCell
@property (nonatomic, strong) BXGMessageModel *model;

@property (nonatomic, strong) NSString *text1;
@property (nonatomic, strong) NSString *text2;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *liveId;
@end
