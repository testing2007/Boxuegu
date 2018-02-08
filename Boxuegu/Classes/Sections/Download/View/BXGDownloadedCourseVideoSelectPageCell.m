//
//  BXGDownloadedCourseVideoSelectPageCell.m
//  Boxuegu
//
//  Created by apple on 2017/6/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGDownloadedCourseVideoSelectPageCell.h"
#import "BXGCourseOutlineVideoModel.h"

@implementation BXGDownloadedCourseVideoSelectPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCell:(BXGCourseOutlineVideoModel*)model
{
    self.nameLabel.text = model.name;
}

-(void)showSelectImage:(UIImage*)newImage
{
    if(newImage==nil)
    {
        _selImageView.hidden = YES;
        return ;
    }
    _selImageView.hidden = NO;
    _selImageView.image = newImage;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

- (void)updateConstraints
{
    [self.selImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_selImageView.hidden ? CGSizeZero : CGSizeMake(19, 19));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(10);
    }];
    [super updateConstraints];
}

@end
