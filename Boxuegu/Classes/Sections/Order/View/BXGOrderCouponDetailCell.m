//
//  BXGOrderCouponDetailCell.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderCouponDetailCell.h"
#import "BXGOrderCouponModel.h"
#import "RWDeviceInfo.h"

@interface BXGOrderCouponDetailCell()

@property (weak, nonatomic) IBOutlet UILabel *headFirstLb;
@property (weak, nonatomic) IBOutlet UILabel *headSecondLb;
@property (weak, nonatomic) IBOutlet UIImageView *headImgV;

@property (weak, nonatomic) IBOutlet UILabel *centerFirstLb;
@property (weak, nonatomic) IBOutlet UILabel *centerSecondLb;
@property (weak, nonatomic) IBOutlet UILabel *centerThirdLb;
@property (weak, nonatomic) IBOutlet UIImageView *centerImgV;

@property (weak, nonatomic) IBOutlet UIImageView *tailImgV;
@property (weak, nonatomic) IBOutlet UILabel *tailFirstLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topOffset;

@end
@implementation BXGOrderCouponDetailCell


- (void)setCouponModel:(BXGOrderCouponModel *)couponModel {
    _couponModel = couponModel;
    if([couponModel.type isEqualToString:@"CASH"]) {
        // 代金券
        if(couponModel.discount) {
           
            self.centerFirstLb.text = @"课程券";
            self.headFirstLb.text = [NSString stringWithFormat:@"¥%.0f",couponModel.discount.doubleValue];
        }
    }else if ([couponModel.type isEqualToString:@"DISCOUNT"]) {
        // 折扣券
        self.centerFirstLb.text = @"课程券";
//        self.headFirstLb.text = [NSString stringWithFormat:@"%.1f折",couponModel.discount.doubleValue];
        if((NSInteger)couponModel.discount.doubleValue == couponModel.discount.doubleValue) {
            self.headFirstLb.text = [NSString stringWithFormat:@"%.0f折",couponModel.discount.doubleValue];;
        }else {
            self.headFirstLb.text = [NSString stringWithFormat:@"%.1f折",couponModel.discount.doubleValue];;
        }
        
    }else {
        self.centerFirstLb.text = @"";
        self.headFirstLb.text = @"";
    }
    
    if(couponModel.expireDay) {
        // 非空值
        self.headSecondLb.text = [NSString stringWithFormat:@"(%zd天后失效)",couponModel.expireDay.integerValue];
    }else {
        // 空值
        self.headSecondLb.text = @"";
    }
    
    if(couponModel.courseNames) {
        NSMutableString *string = [NSMutableString new];
//        [string appendString:@"使用课程:"];
        [string appendString:couponModel.courseNames];
        self.centerSecondLb.text = string;
    }else {
        self.centerSecondLb.text = @"";
    }
    
    // 日期
    if(couponModel.startTime && couponModel.endTime) {
        NSMutableString *string = [NSMutableString new];
        [string appendString:[couponModel.startTime converDateStringToFormat:@"yyyy年MM月dd日"]];
        [string appendString:@"-"];
        [string appendString:[couponModel.endTime converDateStringToFormat:@"yyyy年MM月dd日"]];
        if([RWDeviceInfo deviceScreenType] == RWDeviceScreenTypeSE || [RWDeviceInfo deviceScreenType] == RWDeviceScreenTypeLowerSE) {
//            NSMutableString *str = [NSMutableString new];
//            [str appendString: @"有效期至: "];
            
//            [str appendString:couponModel.endTime];
//            self.centerThirdLb.text = str;

            self.centerThirdLb.text = string;
            self.centerThirdLb.numberOfLines = 2;
            self.topOffset.constant = 10;
            self.bottomOffset.constant = 10;
        }else {
            self.centerThirdLb.text = string;
            self.centerThirdLb.numberOfLines = 2;
            self.topOffset.constant = 15;
            self.bottomOffset.constant = 15;
        }
        
        
    }else {
        self.centerThirdLb.text = @"";
    }
    
    switch (couponModel.enableType) {
        case BXGOrderCouponTypeEnable: {
            // 蓝色
            self.headImgV.image = [UIImage imageNamed:@"优惠券-蓝背景"];
            // 立即使用
            self.tailFirstLb.textColor = [UIColor colorWithHex:0x38ADFF];
            self.tailFirstLb.text = @"立\n即\n使\n用";
        }break;
        case BXGOrderCouponTypeExpired:
            // 灰色
            self.headImgV.image = [UIImage imageNamed:@"优惠券-灰背景"];
            // 显示已过期
            self.tailFirstLb.textColor = [UIColor colorWithHex:0x999999];
            self.tailFirstLb.text = @"已\n过\n期";
            break;
        case BXGOrderCouponTypeUsed:
            // 显示已使用
            self.headImgV.image = [UIImage imageNamed:@"优惠券-灰背景"];
            self.tailFirstLb.textColor = [UIColor colorWithHex:0x999999];
            self.tailFirstLb.text = @"已\n使\n用";
            break;
        case BXGOrderCouponTypeDisable:
            // 显示不可用
            self.headImgV.image = [UIImage imageNamed:@"优惠券-灰背景"];
            self.tailFirstLb.textColor = [UIColor colorWithHex:0x999999];
            self.tailFirstLb.text = @"不\n可\n用";
            // 显示不可用
            break;
    }
}

- (void)setIsArrow:(BOOL)isArrow {
    _isArrow = isArrow;
    if(isArrow){
        self.tailImgV.image = [UIImage imageNamed:@"优惠券-使用部分-选中状态"];
    }else {
        self.tailImgV.image = [UIImage imageNamed:@"优惠券-使用部分"];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // headFirstLb
    
    self.headFirstLb.font = [UIFont bxg_fontSemiboldWithSize:32];
    self.headFirstLb.textColor = [UIColor colorWithHex:0xFFFFFF];
    // headSecondLb
    self.headSecondLb.font = [UIFont bxg_fontRegularWithSize:13];
    self.headSecondLb.textColor = [UIColor colorWithHex:0xFFFFFF];
    //
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tailFirstLb.text = @"立\n即\n使\n用";
    self.headImgV.image = [UIImage imageNamed:@"优惠券-蓝背景"];
    // debug
    self.headFirstLb.text = @"￥50";
    self.headSecondLb.text = @"20天后失效";
    
    // ```
    self.centerFirstLb.text = @"课程卷";
    self.centerFirstLb.font = [UIFont bxg_fontRegularWithSize:18];
    self.centerFirstLb.textColor = [UIColor colorWithHex:0x333333];
    
    self.centerSecondLb.text = @"使用课程:云计算之大数据等";
    self.centerSecondLb.font = [UIFont bxg_fontRegularWithSize:13];
    self.centerSecondLb.textColor = [UIColor colorWithHex:0x666666];
    
    self.centerThirdLb.text = @"2017年12月22日23:00-2018年12月29日12:00";
    self.centerThirdLb.textColor = [UIColor colorWithHex:0x999999];
    self.centerThirdLb.font = [UIFont bxg_fontRegularWithSize:12];
    
    self.tailFirstLb.textColor = [UIColor colorWithHex:0x38ADFF];
    self.tailFirstLb.font = [UIFont bxg_fontRegularWithSize:13];
    self.tailImgV.image = [UIImage imageNamed:@"优惠券-使用部分-选中状态"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
