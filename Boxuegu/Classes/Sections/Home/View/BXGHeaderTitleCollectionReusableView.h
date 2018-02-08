//
//  BXGHeaderTitleCollectionReusableView.h
//  CollectionViewPrj
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGHome.h"

@interface BXGHeaderTitleCollectionReusableView : UICollectionReusableView
@property(nonatomic, assign) COURSE_TYPE type;
@property(nonatomic, weak) UILabel *titleLabel;
@end
