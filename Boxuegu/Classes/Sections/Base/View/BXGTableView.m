//
//  BXGTableView.m
//  Boxuegu
//
//  Created by Renying Wu on 2018/2/2.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGTableView.h"

@implementation BXGTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if(self) {
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return self;
}
@end
