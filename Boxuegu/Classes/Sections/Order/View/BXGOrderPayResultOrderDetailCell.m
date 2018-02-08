//
//  BXGOrderPayResultOrderDetailCell.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/26.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderPayResultOrderDetailCell.h"

@implementation BXGOrderPayResultOrderDetailCell

- (void)setResultModel:(BXGOrderPayResultModel *)resultModel {
    _resultModel = resultModel;
    if(resultModel.order_no.length > 0) {
        self.detailFirstContentLb.text = resultModel.order_no;
    }else {
        self.detailFirstContentLb.text = @" ";
    }
    
    if(resultModel.orderContent.length > 0) {
        self.detailSecondContentLb.text = resultModel.orderContent;
    }else {
        self.detailSecondContentLb.text = @" ";
    }
    
    if(resultModel.actual_pay.length > 0) {
        NSString *str = @"¥ ";
        NSString *value = [NSString stringWithFormat:@"%.2f",resultModel.actual_pay.doubleValue];
        self.detailThirdContentLb.text = [str stringByAppendingString:value];
        
    }else {
        self.detailThirdContentLb.text = @" ";
    }
    
    if(resultModel.pay_type){
        NSString *payType;
        switch (resultModel.pay_type.integerValue) {
            case 0:
                payType = @"微信";
                break;
            case 1:
                payType = @"支付宝";
                break;
            case 2:
                payType = @"银行卡";
                break;
            default:
                payType = @"未知";
                break;
        }
        self.detailFourthContentLb.text = payType;
    }else {
        self.detailFourthContentLb.text = @"未知";
    }
    if(resultModel.pay_time) {
        self.detailFifthContentLb.text = resultModel.pay_time;
    }else {
        self.detailFifthContentLb.text = @" ";
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-25);
    }];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.headerFirstTagLb.numberOfLines = 0;
    self.headerSecondTagLb.numberOfLines = 0;
    
    self.detailFirstTagLb.numberOfLines = 0;
    self.detailFirstContentLb.numberOfLines = 0;
    self.detailFirstContentLb.text = @"121312312121312312121312312121312312121312312121312312121312312121312312121312312121312312121312312121312312";
    self.detailSecondTagLb.numberOfLines = 0;
    self.detailSecondContentLb.numberOfLines = 0;
    
    self.detailThirdTagLb.numberOfLines = 0;
    self.detailThirdContentLb.numberOfLines = 0;
    
    self.detailFourthTagLb.numberOfLines = 0;
    self.detailFourthContentLb.numberOfLines = 0;
    self.detailFifthTagLb.numberOfLines = 0;
    self.detailFifthContentLb.numberOfLines = 0;
    self.tipLb.numberOfLines = 0;
    
    self.spView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    
    self.headerFirstTagLb.font = [UIFont bxg_fontRegularWithSize:16];
    self.headerFirstTagLb.textColor = [UIColor colorWithHex:0x333333];
    
    self.headerSecondTagLb.font = [UIFont bxg_fontRegularWithSize:12];
    self.headerSecondTagLb.textColor = [UIColor colorWithHex:0x999999];
    
    
    self.detailFirstTagLb.font = [UIFont bxg_fontRegularWithSize:15];
    self.detailFirstTagLb.textColor = [UIColor colorWithHex:0x666666];
    
    self.detailFirstContentLb.font = [UIFont bxg_fontRegularWithSize:15];
    self.detailFirstContentLb.textColor = [UIColor colorWithHex:0x666666];
    
    self.detailSecondTagLb.font = [UIFont bxg_fontRegularWithSize:15];
    self.detailSecondTagLb.textColor = [UIColor colorWithHex:0x666666];
    self.detailSecondContentLb.font = [UIFont bxg_fontRegularWithSize:15];
    self.detailSecondContentLb.textColor = [UIColor colorWithHex:0x666666];
    
    self.detailThirdTagLb.font = [UIFont bxg_fontRegularWithSize:15];
    self.detailThirdTagLb.textColor = [UIColor colorWithHex:0x666666];
    self.detailThirdContentLb.font = [UIFont bxg_fontRegularWithSize:15];
    self.detailThirdContentLb.textColor = [UIColor colorWithHex:0x666666];
    
    self.detailFourthTagLb.font = [UIFont bxg_fontRegularWithSize:15];
    self.detailFourthTagLb.textColor = [UIColor colorWithHex:0x666666];
    self.detailFourthContentLb.font = [UIFont bxg_fontRegularWithSize:15];
    self.detailFourthContentLb.textColor = [UIColor colorWithHex:0x666666];
    
    self.detailFifthTagLb.font = [UIFont bxg_fontRegularWithSize:15];
    self.detailFifthTagLb.textColor = [UIColor colorWithHex:0x666666];
    self.detailFifthContentLb.font = [UIFont bxg_fontRegularWithSize:15];
    self.detailFifthContentLb.textColor = [UIColor colorWithHex:0x666666];
    
    self.detailFirstContentLb.text = @"121312312121312312121312312121312312121312312121312312121312312121312312121312312121312312121312312121312312";

//    font-family: PingFangSC-Regular;
//    font-size: 30px;
//color: #;
    
    self.tipLb.font = [UIFont bxg_fontRegularWithSize:13];
    self.tipLb.textColor = [UIColor colorWithHex:0x999999];
    
    self.actionFirstBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:15];
    self.actionFirstBtn.tintColor = [UIColor colorWithHex:0x38ADFF];
    
    self.actionSecondBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:15];
    self.actionSecondBtn.tintColor = [UIColor colorWithHex:0x38ADFF];
    
    self.actionFirstBtn.layer.borderWidth = 1;
    self.actionSecondBtn.layer.borderWidth = 1;
    self.actionFirstBtn.layer.cornerRadius = 15;
    self.actionSecondBtn.layer.cornerRadius = 15;
    self.actionFirstBtn.layer.borderColor = [UIColor colorWithHex:0x38ADFF].CGColor;
    self.actionSecondBtn.layer.borderColor = [UIColor colorWithHex:0x38ADFF].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
     [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onClickFirstBtn:(id)sender {
    if(self.onClickFirstBtnBlock) {
        self.onClickFirstBtnBlock();
    }
}
- (IBAction)onClickSecondBtn:(id)sender {
    if(self.onClickSecondBtnBlock) {
        self.onClickSecondBtnBlock();
    }
}
@end
