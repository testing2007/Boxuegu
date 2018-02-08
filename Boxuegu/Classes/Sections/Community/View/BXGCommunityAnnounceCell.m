//
//  BXGCommunityAnnounceCell.m
//  Boxuegu
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommunityAnnounceCell.h"

@interface BXGCommunityAnnounceCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *announceLabel;

@end

@implementation BXGCommunityAnnounceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCell
{
    _announceLabel.text = @"haha";
}

@end
