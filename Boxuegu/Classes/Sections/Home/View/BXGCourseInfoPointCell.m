//
//  BXGCourseInfoPointCell.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseInfoPointCell.h"
#import "BXGCourseOutlinePointModel.h"

@interface BXGCourseInfoPointCell()
@property (nonatomic, strong) UILabel *label;
@end
@implementation BXGCourseInfoPointCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
        [self installUI];
    }
    return self;
}

- (void)setPointModel:(BXGCourseOutlinePointModel *)pointModel {
    _pointModel = pointModel;
    self.label.text = pointModel.name;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)installUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *label = [UILabel new];
    label.font = [UIFont bxg_fontRegularWithSize:15];
    label.textColor = [UIColor colorWithHex:0x333333];
    self.label = label;
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.centerY.offset(0);
    }];
    
    UIView *spView = [UIView new];
    [self.contentView addSubview:spView];
    spView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(0);
        make.bottom.offset(0);
        make.height.offset(1);
    }];
}

@end
