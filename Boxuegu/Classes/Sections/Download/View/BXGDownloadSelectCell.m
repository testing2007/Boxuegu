//
//  BXGDownloadSelectCell.m
//  Boxuegu
//
//  Created by apple on 2017/6/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGDownloadSelectCell.h"

@interface BXGDownloadSelectCell ()
//@property (nonatomic, assign) BOOL bEdit;
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation BXGDownloadSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.didSetupConstraints = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(nullable NSString *)reuseIdentifier
                    bEditMode:(BOOL)bEditMode
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        _txtLabel = [UILabel new];
        _txtLabel.font = [UIFont bxg_fontRegularWithSize:16];
        [self.contentView addSubview:_txtLabel];
        _selectImageView = [UIImageView new];
        [self.contentView addSubview:_selectImageView];
        _didSetupConstraints = NO;
        _selectImageView.contentMode = UIViewContentModeScaleAspectFit;
//        if(bEditMode)
//        {
//            _selectImageView.hidden = NO;
//            [self showSelectImage:[UIImage imageNamed:@"多选-未选中"]];
//        }
//        else
//        {
//            _selectImageView.hidden = YES;
//        }
    }
    return self;
}

-(void)showSelectImage:(UIImage*)newImage
{
    if(newImage==nil)
    {
        _selectImageView.hidden = YES;
        return ;
    }
    _selectImageView.hidden = NO;
    _selectImageView.image = newImage;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

- (void)updateConstraints
{
//    if(self.hidden)
//    {
//        [super updateConstraints];
//        return ;
//    }
    if (!self.didSetupConstraints) {
        [self.selectImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(_selectImageView.hidden?CGSizeZero:CGSizeMake(19, 19));
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(10);
        }];
        [self.txtLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(_selectImageView.hidden?CGSizeMake(self.contentView.frame.size.width-2*15, 19) :
                                  CGSizeMake(self.contentView.frame.size.width-2*15-_selectImageView.frame.size.width-15, 19));
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(_selectImageView.mas_right).offset(_selectImageView.hidden?0:15);
        }];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
