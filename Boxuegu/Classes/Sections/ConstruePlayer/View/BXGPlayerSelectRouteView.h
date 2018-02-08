//
//  BXGPlayerSelectRouteView.h
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/19.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGPlayerSelectRouteView : UIView
@property (nonatomic, copy) void(^didSelectedCell)(UITableView *tableView, NSIndexPath *indexPath);
@end
