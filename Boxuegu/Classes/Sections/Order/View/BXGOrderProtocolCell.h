//
//  BXGOrderProtocolCell.h
//  Boxuegu
//
//  Created by apple on 2017/10/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionImageView.h"

typedef void (^ReadProtocolBlockType)(void);

@interface BXGOrderProtocolCell : UITableViewCell

@property(nonatomic, weak) OptionImageView *optImageView;
@property(nonatomic, weak) UILabel *readedLabel;
@property(nonatomic, weak) UILabel *linkProtocolLabel;

@property(nonatomic, copy) ReadProtocolBlockType readProtocolBlock;

@end
