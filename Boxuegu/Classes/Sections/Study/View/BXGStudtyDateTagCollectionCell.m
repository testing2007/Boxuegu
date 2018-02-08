//
//  BXGStudtyDataTagCollectionCell.m
//  Boxuegu
//
//  Created by HM on 2017/4/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGStudtyDateTagCollectionCell.h"

@interface BXGStudtyDateTagCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *bgimageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
@implementation BXGStudtyDateTagCollectionCell


-(void)setDateText:(NSString *)dateText {

    _dateText = dateText;
    self.dateLabel.text = dateText;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.bgimageView.hidden = true;
    self.isToday = false;
}

- (void)updateDisplay {
    
    if(self.selected) {
        
        self.dateLabel.textColor = [UIColor colorWithHex:0xFFFFFF];
        self.bgimageView.hidden = false;
    }
    else {
        
        if(self.isToday) {
            
            self.dateLabel.textColor = [UIColor colorWithHex:0xFF554C];
        } else {
            
            self.dateLabel.textColor = [UIColor colorWithHex:0x666666];
        }
        self.bgimageView.hidden = true;
    }
    
}

- (void)setIsToday:(BOOL)isToday {

    _isToday = isToday;
    
    [self updateDisplay];
}


-(void)setSelected:(BOOL)selected {

    [super setSelected:selected];
    
    [self updateDisplay];
}
@end
