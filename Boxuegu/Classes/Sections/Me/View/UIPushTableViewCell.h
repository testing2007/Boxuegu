//
//  UIPushTableViewCell.h
//  Boxuegu
//
//  Created by HM on 2017/6/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *idOfUIPushTableViewCell = @"idOfUIPushTableViewCell";
@interface UIPushTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger bedgeNumber;
@end
