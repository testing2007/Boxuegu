//
//  BXGCouseDayPlanCell.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/30.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCouseDayPlanCell.h"

@interface BXGCouseDayPlanCell()
@property (nonatomic, weak) UILabel *cellTitleLabel;
@property (nonatomic, weak) UILabel *cellSubfirstLabel;
@property (nonatomic, weak) UILabel *cellSubSecondLabel;
@property (nonatomic, weak) UIButton *cellBtn;
@property (nonatomic, weak) UIImageView *cellIconImageView;
@end

@implementation BXGCouseDayPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self installUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.textLabel.font = [UIFont bxg_fontRegularWithSize:16];
        self.textLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    return self;
    
}


- (void)installUI {
    
    
    UILabel *cellTitleLabel = [UILabel new];
    self.cellTitleLabel = cellTitleLabel;
    [self.contentView addSubview:cellTitleLabel];
    
    
    UILabel *cellSubfirstLabel = [UILabel new];
    self.cellSubfirstLabel = cellSubfirstLabel;
    [self.contentView addSubview:cellSubfirstLabel];
    
    UILabel *cellSubSecondLabel = [UILabel new];
    self.cellSubSecondLabel = cellSubSecondLabel;
    [self.contentView addSubview:cellSubSecondLabel];
    
    UIButton *cellBtn = [UIButton new];
    self.cellBtn = cellBtn;
    [self.contentView addSubview:cellBtn];
    
    UIImageView *cellIconImageView = [UIImageView new];
    [cellIconImageView setImage:[UIImage imageNamed:@"学习中心-列表轴"]];
    
    self.cellIconImageView = cellIconImageView;
    [self.contentView addSubview:cellIconImageView];
    
    [cellIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(-15);
        make.left.offset(15);
        make.bottom.offset(0);
        make.width.offset(12);
    }];
    
}

@end
