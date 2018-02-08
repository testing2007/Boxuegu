//
//  BXGCourseOutlineTryCell.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseOutlineTryCell.h"
#import "BXGCourseInfoVideoModel.h"

@interface BXGCourseOutlineTryCell()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *playImageView;
@property (nonatomic, weak) UIButton *actionBtn;
@end

@implementation BXGCourseOutlineTryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setTitle:(NSString *)title {
    
    _title = title;
    self.titleLabel.text = title;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    
}

-(void)setIsPlaying:(BOOL)isPlaying {
    
    _isPlaying = isPlaying;
    if(isPlaying) {
        
        self.titleLabel.textColor = [UIColor colorWithHex:0x38ADFF];
        
        // [self.playImageView setImage:[UIImage imageNamed:@"课程详情-播放"]];
        
        // self.playImageView.highlighted = true;
    }else {
        
        self.titleLabel.textColor = [UIColor colorWithHex:0x999999];
        // self.playImageView.highlighted = false;
        //[self.playImageView setImage:[UIImage imageNamed:@"课程详情列表-未播放"]];
    }
}

- (void)setModel:(BXGCourseOutlineVideoModel *)model {
    
    _model = model;
    self.title = model.name;
    [self.playImageView setImage:[UIImage imageNamed:@"课程大纲-解锁"]];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
        [self installUI];
    }
    return self;
}

- (void)installUI {
    
    UIImageView *imageView = [UIImageView new];
    //    [imageView setImage:[UIImage imageNamed:@"课程详情列表-未播放"]];
    //    [imageView setHighlightedImage:[UIImage imageNamed:@"课程详情-播放"]];
    
    [self.contentView addSubview:imageView];
    
    self.playImageView = imageView;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(15);
        make.centerY.offset(0);
        make.width.height.offset(18);
    }];
    
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.actionBtn = actionBtn;
    actionBtn.tintColor = [UIColor colorWithHex:0x38ADFF];
    actionBtn.backgroundColor = [UIColor clearColor];
    actionBtn.layer.borderColor = actionBtn.tintColor.CGColor;
    actionBtn.layer.borderWidth = 1;
    
    [actionBtn setTitle:@"试学" forState:UIControlStateNormal];
    actionBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:12];
    [self.contentView addSubview:actionBtn];
    [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-15);
        make.width.offset(47);
        make.height.offset(20);
        make.centerY.offset(0);
        
    }];
    // [downLoadBtn layoutIfNeeded];
    actionBtn.layer.cornerRadius = 10;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    UILabel *titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    titleLabel.font = [UIFont bxg_fontRegularWithSize:14];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(15);
        make.centerY.offset(0);
        make.height.offset(14);
        make.right.equalTo(actionBtn.mas_left).offset(-15);
    }];
    titleLabel.textColor = [UIColor colorWithHex:0x999999];
    
    UIView *spview = [UIView new];
    [self addSubview:spview];
    spview.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [spview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1.0 / [UIScreen mainScreen].scale);
        make.left.offset(15);
        make.right.offset(0);
        make.bottom.offset(0);
    }];
}
@end
