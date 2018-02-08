//
//  BXGSearchRecommendHeaderView.h
//  Boxuegu
//
//  Created by apple on 2017/12/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TapCleanHistoryBlock)(void);

@interface BXGSearchRecommendHeaderView : UICollectionReusableView

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *cleanBtn;
@property (nonatomic, copy) TapCleanHistoryBlock tapCleanHistory;

@end
