//
//  BXGRealUncertificationCell.h
//  Boxuegu
//
//  Created by apple on 2018/1/16.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGRealUncertificationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *certifyHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *certifyHeaderLabel;

@property (weak, nonatomic) IBOutlet UILabel *knowsTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *knowsContentTxtView;

@end
