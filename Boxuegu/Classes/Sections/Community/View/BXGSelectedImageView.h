//
//  BXGSelectedImageView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/30.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^OnClickAddBtnBlockType)();
typedef void(^OnClickCloseBtnBlockType)(NSInteger index);

@interface BXGSelectedImageView : UIView
@property (nonatomic, assign) NSInteger currentCount;
@property (nonatomic, strong) NSMutableArray<UIImage *> *imageArray;

- (void)addImage:(UIImage *)image;
@property (nonatomic, copy) OnClickAddBtnBlockType onClickAddBtnBlock;
@property (nonatomic, copy) OnClickCloseBtnBlockType onClickCloseBtnBlock;
@property (nonatomic, assign) NSInteger horizontalMargin;
@property (nonatomic, assign) NSInteger lineItemMaxCount;

@end
