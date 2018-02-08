//
//  BXGAllNotesCell.h
//  Boxuegu
//
//  Created by apple on 2017/8/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleLineRichLabel.h"

@interface BXGAllNotesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userPortraitImageView;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteDetailLabel;
@property (weak, nonatomic) IBOutlet SingleLineRichLabel *leftRichLable;
@property (weak, nonatomic) IBOutlet SingleLineRichLabel *rightRichLabel;

@end
