//
//  BXGOrderPayResultOrderDetailCell.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/26.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGOrderPayResultModel.h"

@interface BXGOrderPayResultOrderDetailCell : UITableViewCell

@property (nonatomic, strong) BXGOrderPayResultModel *resultModel;

@property (weak, nonatomic) IBOutlet UILabel *headerFirstTagLb;
@property (weak, nonatomic) IBOutlet UILabel *headerSecondTagLb;

@property (weak, nonatomic) IBOutlet UILabel *detailFirstTagLb;
@property (weak, nonatomic) IBOutlet UILabel *detailFirstContentLb;

@property (weak, nonatomic) IBOutlet UILabel *detailSecondTagLb;
@property (weak, nonatomic) IBOutlet UILabel *detailSecondContentLb;

@property (weak, nonatomic) IBOutlet UILabel *detailThirdTagLb;
@property (weak, nonatomic) IBOutlet UILabel *detailThirdContentLb;
@property (weak, nonatomic) IBOutlet UIView *spView;

@property (weak, nonatomic) IBOutlet UILabel *detailFourthTagLb;
@property (weak, nonatomic) IBOutlet UILabel *detailFourthContentLb;

@property (weak, nonatomic) IBOutlet UILabel *detailFifthTagLb;
@property (weak, nonatomic) IBOutlet UILabel *detailFifthContentLb;
@property (weak, nonatomic) IBOutlet UILabel *tipLb;

@property (weak, nonatomic) IBOutlet UIButton *actionFirstBtn;
@property (weak, nonatomic) IBOutlet UIButton *actionSecondBtn;
//
@property (nonatomic, copy) void(^onClickFirstBtnBlock)();
@property (nonatomic, copy) void(^onClickSecondBtnBlock)();
@end
