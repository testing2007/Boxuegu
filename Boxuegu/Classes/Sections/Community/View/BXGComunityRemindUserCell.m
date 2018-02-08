//
//  BXGComunityRemindUserCell.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGComunityRemindUserCell.h"
@interface BXGComunityRemindUserCell()
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIImageView *iconIV;
@property (nonatomic, strong) UILabel *nameLb;


@end
@implementation BXGComunityRemindUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self installUI];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self){
    
        [self installUI];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
    
        [self installUI];
    }
    return self;
}

- (void)setIsUserSelected:(BOOL)isUserSelected {

    _isUserSelected = isUserSelected;
    if(isUserSelected){
    
        //
        [self.checkBtn setImage:[UIImage imageNamed:@"多选-选中"] forState:UIControlStateNormal];
    }else {
    
        [self.checkBtn setImage:[UIImage imageNamed:@"多选-未选中"] forState:UIControlStateNormal];
        // 多选-选中
    }
}

- (void)setModel:(BXGCommunityUserModel *)model {

    if(_model == model){
    
        return;
    }
    _model = model;
    if(model){
    
        if(model.smallHeadPhoto) {
            
            [self.iconIV sd_setImageWithURL:[NSURL URLWithString:model.smallHeadPhoto] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        }else {
        
            [self.iconIV setImage:[UIImage imageNamed:@"默认头像"]];
        }
        
        if(model.userName) {
        
            self.nameLb.text = model.userName;
        }else {
        
            self.nameLb.text = @"";
        }
    }else {
    
        [self.iconIV setImage:[UIImage imageNamed:@"默认头像"]];
        self.nameLb.text = @"";
    }
}

- (void)installUI {
    
    UIButton *checkBtn = [UIButton new];
    checkBtn.userInteractionEnabled = false;
    [self.contentView addSubview:checkBtn];
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(15);
        make.centerY.offset(0);
        make.height.width.offset(20);
    }];
    
    UIImageView *iconIV = [UIImageView new];
    [self.contentView addSubview:iconIV];
//    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.equalTo(checkBtn.mas_right).offset(10);
//        make.centerY.offset(0);
//        make.height.width.offset(35);
//    }];
    [iconIV setImage:[UIImage imageNamed:@"默认头像"]];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(checkBtn.mas_right).offset(10);
        make.centerY.equalTo(self);
        make.height.width.offset(35);
    }];
    
    iconIV.layer.cornerRadius = 17.5;
    iconIV.layer.masksToBounds = true;
    UILabel *nameLb = [UILabel new];
    [self.contentView addSubview:nameLb];
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconIV.mas_right).offset(10);
        make.centerY.offset(0);
        make.right.offset(15);
    }];
    nameLb.text = @"阿萨德阿萨德阿达";
    nameLb.font = [UIFont bxg_fontRegularWithSize:16];
    nameLb.textColor = [UIColor colorWithHex:0x333333];
    self.checkBtn = checkBtn;
    self.iconIV = iconIV;
    self.nameLb = nameLb;
    
    UIView *spView = [UIView new];
    spView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [self.contentView addSubview:spView];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1);
    
    }];
    
    self.isUserSelected = false;
}
@end
