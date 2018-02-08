//
//  BXGCommunityUserIconCCell.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommunityUserIconCCell.h"

@interface BXGCommunityUserIconCCell()
@property (nonatomic, weak) UIImageView *iconImageView;
@end
@implementation BXGCommunityUserIconCCell
- (void)setUserModel:(BXGCommunityUserModel *)userModel {

    if(userModel && userModel.smallHeadPhoto) {
    
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:userModel.smallHeadPhoto] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }else {
    
        [self.iconImageView setImage:[UIImage imageNamed:@"默认头像"]];
    }
        
    
}

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
    
        [self installUI];
    }
    return self;
}

- (void)installUI {

    UIImageView *iconImageView = [UIImageView new];
    [self.contentView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(self);
        make.height.width.offset(34);
    }];
    
    iconImageView.layer.cornerRadius = 17;
    iconImageView.layer.masksToBounds = true;
    
    [iconImageView setImage:[UIImage imageNamed:@"默认头像"]];
    self.iconImageView = iconImageView;
}
@end
