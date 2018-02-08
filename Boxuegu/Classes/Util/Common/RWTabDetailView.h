//
//  RWTabDetailView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/28.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IndexChangedBlockType)(UIView *detailView, NSInteger index);

@interface RWTabDetailView : UIScrollView
- (instancetype)initWithDetailViewArrary:(NSArray<UIView *> *)detailViewArray;
@property (nonatomic, strong) NSArray<UIView *> *detailViewArray;
@property (nonatomic) NSInteger selectedIndex;
@property IndexChangedBlockType indexChangedBlock;
@end
