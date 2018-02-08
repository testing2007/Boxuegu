//
//  BXGStudtyDataTagCollectionCell.h
//  Boxuegu
//
//  Created by HM on 2017/4/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGStudtyDateTagCollectionCell : UICollectionViewCell
@property(nonatomic, assign) BOOL isToday;
@property(nonatomic, copy) NSString *dateText;
@property(nonatomic, assign) BOOL isTargeted;
@end
