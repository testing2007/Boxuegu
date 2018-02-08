//
//  BXGPlayListPointCell.m
//  Boxuegu
//
//  Created by HM on 2017/4/22.
//  Copyright © 2017年 itcast. All rights reserved.
//








#import "BXGPlayListPointCell.h"
#import "BXGCourseInfoSectionModel.h"
#import "BXGCourseOutlinePointModel.h"
#import "BXGCourseInfoPointModel.h"
@interface BXGPlayListPointCell()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *downloadBtn;
@end

@implementation BXGPlayListPointCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self installUI];
}
-(void)setTitle:(NSString *)title {
    
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSectionModel:(BXGCourseInfoSectionModel *)sectionModel {
    
    _sectionModel = sectionModel;
    self.title = sectionModel.name;
    self.downloadBtn.hidden = true;
}

- (void)setInfoPointModel:(BXGCourseInfoPointModel *)infoPointModel {
    _infoPointModel = infoPointModel;
    self.title = infoPointModel.name;
    self.downloadBtn.hidden = true;
}

- (void)setPointModel:(BXGCourseOutlinePointModel *)pointModel {
 
    _pointModel = pointModel;
    
    self.title = pointModel.name;
    if(pointModel.lock_status.integerValue == 1){
    // if(pointModel.lock_status.integerValue == 0){
        
        // 未锁
        self.downloadBtn.enabled = true;
        self.downloadBtn.layer.borderColor = [UIColor colorWithHex:0x38ADFF].CGColor;
        
    }else {
    
        // 解锁
        self.downloadBtn.enabled = false;
        self.downloadBtn.layer.borderColor = [UIColor colorWithHex:0xF5F5F5].CGColor;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
        [self installUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        [self installUI];
    }
    return self;
}
- (void)installUI {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    UIButton *downLoadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.downloadBtn = downLoadBtn;
    downLoadBtn.tintColor = [UIColor colorWithHex:0x38ADFF];
    downLoadBtn.backgroundColor = [UIColor clearColor];
    downLoadBtn.layer.borderColor = downLoadBtn.tintColor.CGColor;
    downLoadBtn.layer.borderWidth = 1;
    
    [downLoadBtn setTitle:@"下载" forState:UIControlStateNormal];
    downLoadBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:12];
    [self.contentView addSubview:downLoadBtn];
    [downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.offset(-15);
        make.width.offset(47);
        make.height.offset(20);
        
    }];
    // [downLoadBtn layoutIfNeeded];
    downLoadBtn.layer.cornerRadius = 10;
    
    
    
    [downLoadBtn addTarget:self action:@selector(clickDownloadBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;

    titleLabel.font = [UIFont bxg_fontSemiboldWithSize:15];
    titleLabel.textColor = [UIColor colorWithHex:0x666666];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.bottom.offset(-10);
        make.height.offset(15);
        make.right.equalTo(downLoadBtn.mas_left).offset(-15);
    }];
    titleLabel.textColor = [UIColor blackColor];
    
    [downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(titleLabel);
        
    }];
}

- (void)clickDownloadBtn:(UIButton *)sender {

    if(self.downloadBtnBlock) {
    
        self.downloadBtnBlock(self.pointModel);
    }
}

@end
