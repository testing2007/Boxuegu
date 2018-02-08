//
//  BXGOrderFooterView.h
//  Boxuegu
//
//  Created by apple on 2017/10/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RightBtnBlock)(void);

@interface BXGOrderFooterView : UITableViewHeaderFooterView

@property(nonatomic, weak) UILabel *leftTitle;
@property(nonatomic, weak) UIButton *rightBtn;
@property(nonatomic, weak) UIView *seperateLineView;

@property(nonatomic, copy) RightBtnBlock rightBtnBlock;

- (void)setRightBtnEnable:(BOOL)bEnable;

@end
