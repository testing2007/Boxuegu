//
//  BXGCategoryTitleViewCell.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/17.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWTabTitleView.h"

@interface BXGCategoryTitleViewCell : UICollectionViewCell <RWTabTitleCellProtocol>
@property (nonatomic, copy) NSString *tabTitleString;
@property (nonatomic, assign) BOOL isTabSelected;
@end
