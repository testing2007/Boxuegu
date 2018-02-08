//
//  BXGHomeHeaderView.h
//  CollectionViewPrj
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGHome.h"

typedef void (^MoreBlock)(int type);

@interface BXGHomeHeaderView : UICollectionReusableView
@property(nonatomic, assign) COURSE_TYPE type;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, copy) MoreBlock moreBlock;
@end
