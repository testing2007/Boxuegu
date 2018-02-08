//
//  BXGSquareContentCCell.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGSquareContentCCell.h"
#import "StateImageView.h"

@interface BXGSquareContentCCell()
@property (weak, nonatomic) UIImageView *titleImageView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIImageView *iconImageView;
@property (weak, nonatomic) UILabel *userLabel;
//@property (weak, nonatomic) UIImageView *praiseView;
//@property (weak, nonatomic) UILabel *praiseLabel;

@property (weak, nonatomic) UIImageView *browseImageView;
@property (weak, nonatomic) UILabel *browseNumLabel;


@end

@implementation BXGSquareContentCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self installUI];
}

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
    
        [self installUI];
    }
    return self;
}

- (void)installUI {

    // *** Config
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = true;
    
    UIImageView *titleImageView = [UIImageView new];
    [self.contentView addSubview:titleImageView];
    titleImageView.contentMode = UIViewContentModeScaleAspectFill;
    titleImageView.layer.masksToBounds = true;
    [titleImageView setImage:[UIImage imageNamed:@"默认加载图"]];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.contentMode = UIViewContentModeTop;
    [self.contentView addSubview:titleLabel];
    titleLabel.numberOfLines = 2;
    titleLabel.font = [UIFont bxg_fontRegularWithSize:13];
    titleLabel.text = @"#锻炼崖#要";
    
    UIImageView *userIcon = [UIImageView new];
    [self.contentView addSubview:userIcon];
    [userIcon setImage:[UIImage imageNamed:@"默认头像"]];
    userIcon.contentMode = UIViewContentModeScaleAspectFit;
    
    
    UILabel *userNameLabel = [UILabel new];
    [self.contentView addSubview:userNameLabel];
    userNameLabel.numberOfLines = 1;
    userNameLabel.font = [UIFont bxg_fontRegularWithSize:13];
    userNameLabel.text = @"大笑";
    
    userNameLabel.textColor = [UIColor colorWithHex:0x999999];
    UIImageView *browseImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"学习圈-浏览"]];
    
    [self.contentView addSubview:browseImageView];
    
    
    UILabel *browseNumLabel = [UILabel new];
    browseNumLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:browseNumLabel];
    browseNumLabel.font = [UIFont bxg_fontRegularWithSize:13];
    browseNumLabel.textColor = [UIColor colorWithHex:0x999999];
    
    // *** Layout
    
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.right.offset(0);
        // make.width.offset(width - 15 - 7.5);
        make.height.equalTo(titleImageView.mas_width);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(titleImageView);
        make.top.equalTo(titleImageView.mas_bottom).offset(5);
        // make.height.offset(40);
        make.right.equalTo(titleImageView);
    }];
   
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(titleLabel.mas_top).offset(45);
        // make.top.equalTo(titleLabel.mas_bottom).offset(-10);
        make.left.equalTo(titleImageView);
        make.height.width.offset(20);
        make.bottom.offset(-10);
    }];
    userIcon.layer.cornerRadius = 20 /2.0;
    userIcon.layer.masksToBounds = true;
    
    [browseNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(userIcon);
        make.right.equalTo(titleImageView);
        // make.width.offset(25);
    }];
    
    
    [browseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userIcon);
        make.right.equalTo(browseNumLabel.mas_left).offset(-5);
        make.height.width.offset(20);
    }];
    
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(userIcon);
        make.left.equalTo(userIcon.mas_right).offset(5);
        make.right.equalTo(browseImageView.mas_left).offset(-5);
    }];
    [browseNumLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [browseNumLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    // *** Interface
    
    self.titleImageView = titleImageView;
    self.titleLabel = titleLabel;
    self.iconImageView = userIcon;
    self.userLabel = userNameLabel;
    self.browseImageView = browseImageView;
    self.browseNumLabel = browseNumLabel;

}

- (void)setModel:(BXGCommunityPostModel *)model {

    if(model.imgPathList && model.imgPathList.count > 0) {
    
        NSString *last = _model.imgPathList.firstObject;
        NSString *current = model.imgPathList.firstObject;
        if(![last isEqualToString:current]){
            
            [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:current] placeholderImage:[UIImage imageNamed:@"默认加载图"]];
        }else {
            
            RWLog(@"忽略");
        }
        
    }else {
    
        [self.titleImageView setImage:[UIImage imageNamed:@"默认加载图"]];
    }
    
    NSMutableAttributedString *amString;
    NSMutableAttributedString *topicString;
    if(model.content && model.content.length > 0) {
        
        NSDictionary *att = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0x151515],NSFontAttributeName:[UIFont bxg_fontRegularWithSize:13]};
        amString = [[NSMutableAttributedString alloc]initWithString:model.content attributes:att];
    }else {
    
        self.titleLabel.text = @"";
    }
    
    if(model.topicName && model.topicName.length > 0) {
    
        NSDictionary *topicAtt = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0x38ADFF],NSFontAttributeName:[UIFont bxg_fontRegularWithSize:13]};
        NSString *string = [NSString stringWithFormat:@"#%@# ",model.topicName];
        topicString = [[NSMutableAttributedString alloc]initWithString:string attributes:topicAtt];;
        
    }else {
    
        topicString = [[NSMutableAttributedString alloc]initWithString:@"" attributes:nil];
    }
    
    if(amString) {
    
        [topicString appendAttributedString:amString];
    }
    
    self.titleLabel.attributedText = topicString;
    
    if(model.smallHeadPhoto){
    
        if(model.smallHeadPhoto != model.smallHeadPhoto) {
            
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.smallHeadPhoto] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        }
        
    }else {
    
        [self.iconImageView setImage:[UIImage imageNamed:@"默认头像"]];
    }
    
    if(model.userName) {
     
        self.userLabel.text = model.userName;
    }else {
    
        self.userLabel.text = @"";
    }
    
    if(model.browseSum && [model.browseSum integerValue] > 0){
    
        if([model.browseSum integerValue] >= 100) {
            
            self.browseNumLabel.text = @"99+";
        
        }else {
        
            self.browseNumLabel.text = @([model.browseSum integerValue]).description;
        }
        
    }else {
    
        self.browseNumLabel.text = @"0";
    }
    
//    if(model.isPraise){
//
//        [self.praiseView setImage:[UIImage imageNamed:@"点赞-选中"]];
//    }else {
//
//        [self.praiseView setImage:[UIImage imageNamed:@"点赞-未选中"]];
//    }
    
    _model = model;
}

- (void)setIsLeft:(BOOL)isLeft {

    _isLeft = isLeft;
    if(isLeft) {
    
        [self.titleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.left.offset(15);
            make.right.offset(-7.5);
        }];
    }else {
    
        [self.titleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(7.5);
            make.right.offset(-15);
        }];
    }
}
@end
