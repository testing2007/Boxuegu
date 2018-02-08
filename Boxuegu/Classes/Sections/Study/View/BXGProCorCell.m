//
//  BXGProCorCell.m
//  Boxuegu
//
//  Created by Renying Wu on 2017/5/8.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGProCorCell.h"

@interface BXGProCorCell()

@property (nonatomic, weak) UILabel *pointTitleLabel;
@property (nonatomic, weak) UILabel *cellSubSecondLabel;
@property (nonatomic, weak) UILabel *cellSubFirstLabel;

@end

@implementation BXGProCorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(BXGProCourseModel *)model {

    _model = model;
    
    
    if(model) {
    
        self.cellSubFirstLabel.hidden = false;
        self.cellSubSecondLabel.hidden = false;
        if(model.video_count) {
        
            self.cellSubFirstLabel.text = [NSString stringWithFormat:@"共%@课时",model.video_count];
            
        }else {

            self.cellSubFirstLabel.text = @"共0课时";
        }
        
        
        if(model.learned_count) {
            
            self.cellSubSecondLabel.text = [NSString stringWithFormat:@"已学习%@课时",model.learned_count];
            
        }else {
            
            
            self.cellSubSecondLabel.text = @"已学习0课时";
        }
    }else {
    
        self.cellSubFirstLabel.hidden = true;
        self.cellSubSecondLabel.hidden = true;
    }
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        [self installUI];
    }
    return self;
}

- (void)setPointTitle:(NSString *)pointTitle {
    
    _pointTitle = pointTitle;
    self.pointTitleLabel.text = pointTitle;
}

- (void)installUI {
    
    UIImageView *cellIconImageView = [UIImageView new];
    [cellIconImageView setImage:[UIImage imageNamed:@"学习中心-列表轴"]];
    cellIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    //self.cellIconImageView = cellIconImageView;
    [self.contentView addSubview:cellIconImageView];
    
    [cellIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(15);
        make.bottom.offset(0);
        make.width.offset(12);
    }];
    
    // ==
    UIButton *studyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:studyBtn];
    
    [studyBtn setTitle:@"学习" forState:UIControlStateNormal];
    studyBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:12];
    studyBtn.layer.borderWidth = 1;
    
    
    [studyBtn setTitleColor:[UIColor colorWithHex:0x38ADFF] forState:UIControlStateNormal];
    studyBtn.layer.borderColor = [UIColor colorWithHex:0x38ADFF].CGColor;
    studyBtn.layer.cornerRadius = 20 / 5.0;
    [studyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.width.offset(47);
        make.height.offset(20);
        // make.left.equalTo(titleLable.mas_right).offset(15);
        //make.centerY.equalTo(titleLable.mas_bottom);
    }];
    studyBtn.layer.cornerRadius = 10;
    
    
    
//    [studyBtn layoutIfNeeded];
//    CGFloat btnHeight = studyBtn.frame.size.height;
    
    
    UILabel *titleLable = [UILabel new];
    
    [self addSubview:titleLable];
    self.pointTitleLabel = titleLable;
    titleLable.font = [UIFont bxg_fontRegularWithSize:15];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellIconImageView.mas_right).offset(10);
        make.top.equalTo(cellIconImageView).offset(0);
        make.height.offset(15);
        make.right.equalTo(studyBtn.mas_left).offset(-15);
    }];
    
    studyBtn.userInteractionEnabled = false;
    
    [studyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLable.mas_bottom);
    }];
    
    
    
    
//    UIView *separatView = [UIView new];
//    [self addSubview:separatView];
//    
//    
//    
//    
//
//    // separatView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
//    separatView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
//    [separatView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.offset(15);
//        make.height.offset(1.0 / [UIScreen mainScreen].scale);
//        make.right.offset(0);
//    }];
    
    
    UILabel *cellSubfirstLabel = [UILabel new];
    //self.cellSubfirstLabel = cellSubfirstLabel;
    [self.contentView addSubview:cellSubfirstLabel];
    
    
    
    UILabel *cellSubSecondLabel = [UILabel new];
    self.cellSubSecondLabel = cellSubSecondLabel;
    [self.contentView addSubview:cellSubSecondLabel];
    
    
    
     //cellSubfirstLabel.re
    [cellSubfirstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(titleLable);
        make.right.equalTo(cellSubSecondLabel.mas_left).offset(-15);
        make.top.equalTo(titleLable.mas_bottom).offset(8);
        make.height.offset(15);
        
        
    }];
    
    [cellSubfirstLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    
    cellSubfirstLabel.font = [UIFont bxg_fontRegularWithSize:13];
    cellSubfirstLabel.textColor = [UIColor colorWithHex:0x999999];
    cellSubfirstLabel.text = @"共16课时";
    self.cellSubFirstLabel = cellSubfirstLabel;
    
    
    [cellSubSecondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        // make.left.equalTo(cellSubfirstLabel.mas_right).offset(15);
        make.centerY.equalTo(cellSubfirstLabel);
        make.right.offset(-15);
        make.height.offset(15);
        
    }];
    
    cellSubSecondLabel.font = [UIFont bxg_fontRegularWithSize:13];
    cellSubSecondLabel.textColor = [UIColor colorWithHex:0x999999];
    cellSubSecondLabel.text = @"已学习2课时";
    cellSubSecondLabel.textAlignment = NSTextAlignmentLeft;
    self.cellSubSecondLabel = cellSubSecondLabel;
    
    
    UIButton *cellBtn = [UIButton new];
    //self.cellBtn = cellBtn;
    [self.contentView addSubview:cellBtn];
    
    
    
    
}

@end
