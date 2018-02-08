//
//  BXGOrderConfirmBottomView.h
//  Boxuegu
//
//  Created by apple on 2017/10/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SubmitOrderBlockType)(void);

@interface BXGOrderConfirmBottomView : UIView

@property(nonatomic, weak) UILabel *payAmountLabel; 
@property(nonatomic, weak) UILabel *amountLabel;
@property(nonatomic, weak) UIButton *confirmBtn;
@property(nonatomic, copy) SubmitOrderBlockType submitOrderBlock;

-(void)confirmIsEnable:(BOOL)bEnable;


@end
