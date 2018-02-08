//
//  BXGAssistantCell.m
//  Boxuegu
//
//  Created by RW on 2017/6/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGAssistantCell.h"
#import "BXGVerifyTool.h"
#import "RWBadgeView.h"

@interface BXGAssistantCell()
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellIconImageView;
@property (weak, nonatomic) IBOutlet RWBadgeView *bedgeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badgeViewWidth;


@end

@implementation BXGAssistantCell

- (void)setBadgeNumber:(NSInteger)badgeNumber {

    _badgeNumber = badgeNumber;
    _bedgeView.badgeNumber = badgeNumber;
    if(badgeNumber > 0){
    
        self.badgeViewWidth.constant = 40;
    }else {
     
        self.badgeViewWidth.constant = 0;
    }
}

- (void)setModel:(BXGMessageModel *)model {
    
    _model = model;
    
    if(model) {
        
        //1 课程消息 0.系统消息
        
//        NSString *htmlString = model.content;
//        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//        self.cellContentLabel.attributedText = attrStr;
//        self.cellContentLabel.font = [UIFont bxg_fontRegularWithSize:13];
//        self.cellContentLabel.textColor = [UIColor colorWithHex:0x999999];
        
        NSString *centext = [BXGVerifyTool getZZwithString:model.content];
        self.cellContentLabel.text = centext;
        self.cellDateLabel.text = model.timeStamp;
        if(model.type.integerValue == 1) {
            
            self.cellTitleLabel.text = @"课程消息";
            // 设置icon
            [self.cellIconImageView setImage:[UIImage imageNamed:@"我的消息-直播串讲"]];
            
        }else if(model.type.integerValue == 0) {
            
            self.cellTitleLabel.text = @"系统消息";
            
            // 设置icon
            [self.cellIconImageView setImage:[UIImage imageNamed:@"我的消息-博学谷助理"]];
            
            
        }else if(model.type.integerValue == 5) {
            
            self.cellTitleLabel.text = @"学习反馈";
            
            // 设置icon
            [self.cellIconImageView setImage:[UIImage imageNamed:@"我的消息-学习反馈"]];
            
            
        }
        
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
