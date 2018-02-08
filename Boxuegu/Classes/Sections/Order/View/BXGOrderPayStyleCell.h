//
//  BXGOrderPayStyleCell.h
//  Boxuegu
//
//  Created by apple on 2017/10/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionImageView.h"

@interface BXGOrderPayStyleCell : UITableViewCell

@property(nonatomic, weak) UIImageView *identifyImageView;
@property(nonatomic, weak) UILabel *nameLabel;
@property(nonatomic, weak) OptionImageView *optionImageView;

@end
