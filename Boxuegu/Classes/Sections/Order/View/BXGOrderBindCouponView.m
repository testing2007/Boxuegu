//
//  BXGOrderBindCouponView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderBindCouponView.h"
#import "BXGOrderBindCouponViewModel.h"
#import "BXGToast.h"

@interface BXGOrderBindCouponView()

@property (nonatomic, strong) BXGOrderBindCouponViewModel *viewModel;
@property (nonatomic, strong) NSString *courseId;

@end
@implementation BXGOrderBindCouponView

#pragma mark - Interface
- (instancetype)initWithBind:(void(^)(bool success, NSString *msg,NSString *serialNo))bindSerialNoBlock andCourseId:(NSString *)courseId {
    self = [super initWithFrame:CGRectZero];
    if(self) {
        self.bindSerialNoBlock = bindSerialNoBlock;
        self.courseId = courseId;
        [self installUI];
    }
    return self;
}

- (BXGOrderBindCouponViewModel *)viewModel {
    if(_viewModel == nil) {
        _viewModel = [[BXGOrderBindCouponViewModel alloc]init];
    }
    return _viewModel;
}

- (void)textFieldDidEnd:(UIButton *)sender {
    [self.inputTF endEditing:true];
}
#pragma mark - UI
- (void)installUI {
    // 1.
    UILabel *tagLabel = [UILabel new];
    tagLabel.text = @"兑换码:";
    tagLabel.font = [UIFont bxg_fontRegularWithSize:16];
    tagLabel.textColor = [UIColor colorWithHex:0x666666];
    // 2.
    UITextField *inputTF = [UITextField new];
    inputTF.borderStyle = UITextBorderStyleNone;
    inputTF.placeholder = @"请输入优惠券码";
    inputTF.clearButtonMode = UITextFieldViewModeAlways;
    inputTF.font = [UIFont bxg_fontRegularWithSize:16];
    self.inputTF = inputTF;
    self.inputTF.placeholder = @"请输入优惠券码";
    [inputTF addTarget:self action:@selector(textFieldDidEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
    // 3.
    UIButton *actionBtn = [UIButton new];
    actionBtn.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    actionBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:13];
    actionBtn.tintColor = [UIColor colorWithHex:0xFFFFFF];
    actionBtn.layer.cornerRadius = 10;
    [actionBtn setTitle:@"兑换" forState:UIControlStateNormal];
    [actionBtn addTarget:self action:@selector(onClickBindBtn:) forControlEvents:UIControlEventTouchUpInside];
    // 4.
    UIView *spView = [UIView new];
    spView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    // add subview
    [self addSubview:tagLabel];
    [self addSubview:inputTF];
    [self addSubview:actionBtn];
    [self addSubview:spView];
    
    // layout
    [tagLabel sizeToFit];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    [tagLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [tagLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tagLabel.mas_right).offset(5);
        make.centerY.equalTo(tagLabel);
    }];
    [actionBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [actionBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputTF.mas_right).offset(15);
        make.centerY.equalTo(tagLabel);
        make.right.offset(-15);
        make.width.offset(50);
        make.height.offset(20);
    }];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.equalTo(tagLabel);
        make.right.offset(0);
        make.height.offset(1);
    }];
}

- (void)onClickBindBtn:(UIButton *)sender {
    Weak(weakSelf);
    [[BXGBaiduStatistic share] statisticEventString:kBXGStatMeCouponEventTypeBindCoupon andLabel:kBXGStatMeCouponEventTypeBindCoupon];
    if(self.inputTF.text.length <= 0) {
        // 提示为空
        [[BXGHUDTool share] showHUDWithString:kBXGToastCouponNoSerialNumber];
    }else {
        [[BXGHUDTool share] showLoadingHUDWithString:nil];
        [self.viewModel performBindCouponWithSerialNo:self.inputTF.text andCourseId:_courseId andFinished:^(BOOL succeed, NSString *couponId, NSNumber *isCouver, NSString *msg) {
            if(weakSelf.bindSerialNoBlock) {
                weakSelf.bindSerialNoBlock(succeed, msg, couponId);
            }
            [[BXGHUDTool share]showHUDWithString:msg];
        }];
    }
    self.inputTF.text = nil;
}
@end
