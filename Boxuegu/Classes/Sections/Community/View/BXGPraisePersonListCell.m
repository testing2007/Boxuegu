//
//  BXGPraisePersonListCell.m
//  Boxuegu
//
//  Created by apple on 2017/9/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPraisePersonListCell.h"
#import "BXGCommunityUserModel.h"
#import "UIView+Extension.h"
#import "BXGUserCenter.h"

@interface BXGPraisePersonListCell()
@property(nonatomic, weak) BXGCommunityUserModel *userModel;
@property(nonatomic, weak) UIImageView *portraitImageView;
@property(nonatomic, weak) UILabel *nickNameLabel;
@property(nonatomic, weak) UIButton *concernBtn;
@end

@implementation BXGPraisePersonListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self installUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self installUI];
    }
    return self;
}

-(void)installUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *portraitImageView = [UIImageView new];
    [self.contentView addSubview:portraitImageView];
    _portraitImageView = portraitImageView;
    _portraitImageView.layer.cornerRadius = 17;
    _portraitImageView.layer.masksToBounds = YES;
    
    UILabel *nickNameLabel = [UILabel new];
    [self.contentView addSubview:nickNameLabel];
    _nickNameLabel = nickNameLabel;
    [_nickNameLabel setFont:[UIFont bxg_fontRegularWithSize:16]];
    [_nickNameLabel setTextColor:[UIColor colorWithHex:0x333333]];
    
    UIButton *concernBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:concernBtn];
    _concernBtn = concernBtn;
    [_concernBtn addTarget:self action:@selector(onConcern:) forControlEvents:UIControlEventTouchUpInside];
    _concernBtn.layer.borderWidth = 1;
    _concernBtn.layer.cornerRadius = 12.5;
    _concernBtn.layer.masksToBounds = YES;
    [_concernBtn.titleLabel setFont:[UIFont bxg_fontRegularWithSize:14]];
    
    if(_portraitImageView)
    {
        [_portraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.left.offset(15);
            //make.top.offset(15);
            make.width.equalTo(@34);
            make.height.equalTo(@34);
            make.centerY.equalTo(self.mas_centerY);
            make.left.offset(15);
        }];
    }
    if(_nickNameLabel)
    {
        [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_portraitImageView.mas_right).offset(10);
            make.centerY.equalTo(_portraitImageView.mas_centerY);
            make.right.equalTo(_concernBtn.mas_left).offset(-10);
        }];
    }
    if(_concernBtn)
    {
        [_concernBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.centerY.equalTo(_portraitImageView.mas_centerY);
            make.width.equalTo(@60);
            make.height.equalTo(@25);
        }];
    }
}

-(void)setModel:(BXGCommunityUserModel*)model
    andDelegate:(id<BXGPraisePersonListCellDelegate>)delegate
{
    _userModel = model;
    _delegate = delegate;
    [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:model.smallHeadPhoto] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.nickNameLabel.text = model.userName;
    [self updateCocernBtn];
}

-(void)updateCocernBtn
{
    BXGUserCenter *userCenter = [BXGUserCenter share];
    if(userCenter &&
       userCenter.userModel &&
       _userModel.userId.integerValue == userCenter.userModel.itcast_uuid.integerValue)
    {
        self.concernBtn.hidden = YES;
        return ;
    }
    
    if(_userModel.isAttention)
    {
        [self.concernBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        self.concernBtn.layer.borderColor = [UIColor colorWithHex:0x999999].CGColor;
        [self.concernBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }
    else
    {
        [self.concernBtn setTitleColor:[UIColor colorWithHex:0x38ADFF] forState:UIControlStateNormal];
        self.concernBtn.layer.borderColor = [UIColor colorWithHex:0x38ADFF].CGColor;
        [self.concernBtn setTitle:@"＋关注" forState:UIControlStateNormal];
    }
}

-(void)onConcern:(UIButton*)btn
{
    if(self.userModel.isAttention)
    {
        
        BXGAlertController *alert = [BXGAlertController confirmWithTitle:kBXGToastCancelAttention message:nil confirmHandler:^{
            
            if(self.userModel.isAttention)
            {
                if(self.delegate && [self.delegate respondsToSelector:@selector(cancelAttention:)])
                {
                    [self.delegate cancelAttention:_userModel.userId];
                }
                self.userModel.isAttention = !self.userModel.isAttention;
                [self updateCocernBtn];
            }
            
        } cancleHandler:^{
            
        }];
        
        UIViewController *vc = [self findOwnerVC];
        if(vc)
        {
            [vc presentViewController:alert animated:YES completion:nil];
        }
        
    }
    else
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(confirmAttention:)])
        {
            [self.delegate confirmAttention:_userModel.userId];
        }
        self.userModel.isAttention = !self.userModel.isAttention;
        [self updateCocernBtn];
    }
}

@end
