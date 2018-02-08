//
//  BXGCourseFilterCC.m
//  ImageTextLayoutButtonPrj
//
//  Created by apple on 2017/10/17.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "BXGCourseFilterCC.h"
//#import "BXGChoiceTagBtn.h"

@interface BXGCourseFilterCC()

@property(nonatomic, weak) UIButton *tagBtn;

@end

@implementation BXGCourseFilterCC

-(instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self installUI];
    }
    return self;
}

- (void)installUI {
    UIButton *tagBtn = [UIButton new];
    tagBtn.titleLabel.adjustsFontSizeToFitWidth = true;
    tagBtn.titleLabel.minimumScaleFactor = 0.5;
    tagBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:13];
    // [btn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    // [btn setTitle:self.modelArray[i] forState:UIControlStateNormal];
    tagBtn.layer.borderWidth = 1;
    tagBtn.layer.cornerRadius = 3;
    tagBtn.userInteractionEnabled = NO;
//    [tagBtn setIsSelected:NO];
    [self setSel:NO];
    [self addSubview:tagBtn];
    _tagBtn = tagBtn;

    [_tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
    }];
}

- (void)setString:(NSString*)strTitle {
//    [_tagBtn setModel:strTitle];
    if(strTitle) {
        [_tagBtn setTitle:strTitle forState:UIControlStateNormal];
    }else {
        [_tagBtn setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)setSel:(BOOL)bSelect {
    if(bSelect){
        [_tagBtn setTitleColor:[UIColor colorWithHex:0x38ADFF] forState:UIControlStateNormal];
        _tagBtn.layer.borderColor = [UIColor colorWithHex:0x38ADFF].CGColor;
        _tagBtn.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
        
    }else {
   
        [_tagBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
        _tagBtn.layer.borderColor = [UIColor colorWithHex:0xF0F2F5].CGColor;
        _tagBtn.backgroundColor = [UIColor colorWithHex:0xF0F2F5];
    }
   //  [_tagBtn setIsSelected:bSelect];
}

@end
