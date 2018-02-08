//
//  BXGCommunityCell.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/11.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommunityCell.h"

@implementation BXGCommunityCell


- (void)setImagesCount:(NSInteger)imagesCount {

    _imagesCount = imagesCount;
    if(imagesCount <= 0) {
    
        return;
    }
    
    if(imagesCount == 1 || imagesCount == 2 || imagesCount == 4) {
    
        return;
    }
    
    
    
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
