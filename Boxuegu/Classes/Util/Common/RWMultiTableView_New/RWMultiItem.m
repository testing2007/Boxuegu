//
//  RWMTVItem.m
//  RWMuiltyTableView-Demo
//
//  Created by HM on 2017/4/21.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "RWMultiItem.h"

@implementation RWMultiItem
- (BOOL)isEqualToItem:(RWMultiItem *)item;{
    
    if(item.level == self.level && item.tag == self.tag){
    
        return true;
    }else {
    
        return false;
    }
}
@end
