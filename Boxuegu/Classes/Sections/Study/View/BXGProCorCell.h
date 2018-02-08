//
//  BXGProCorCell.h
//  Boxuegu
//
//  Created by HM on 2017/5/8.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGProCourseModel.h"

@interface BXGProCorCell : UITableViewCell
@property (nonatomic, strong) NSString *pointTitle;
@property (nonatomic, strong) BXGProCourseModel *model;
@end
