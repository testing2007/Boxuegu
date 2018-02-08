//
//  RWSelectAlbumCell.m
//  demo-RWPhotosFramework
//
//  Created by RenyingWu on 2017/8/15.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "RWSelectAlbumCell.h"

@interface RWSelectAlbumCell();
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation RWSelectAlbumCell



- (void)setIconImage:(UIImage *)iconImage {

    _iconImage = iconImage;
    [self.iconImageView setImage:iconImage];
}

- (void)setCellTitle:(NSString *)cellTitle {

    _cellTitle = cellTitle;
    self.cellTitleLabel.text = cellTitle;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
