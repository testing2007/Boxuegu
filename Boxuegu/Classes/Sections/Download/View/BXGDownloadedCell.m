//
//  BXGDownloadedCell.m
//  Demo
//
//  Created by apple on 17/6/10.
//  Copyright © 2017年 com.bokecc.www. All rights reserved.
//

#import "BXGDownloadedCell.h"
#import "BXGDownloadModel.h"
#import "BXGCourseModel.h"
#import "BXGCourseOutlinePointModel.h"
#import "BXGCourseOutlineVideoModel.h"
#import "BXGResourceManager.h"

@implementation BXGDownloadedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCell:(BXGDownloadedRenderModel*)model
{
    if(model.courseModel.smallimg_path){
        [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:model.courseModel.smallimg_path] placeholderImage:[UIImage imageNamed:@"默认加载图"]];
    }else {
        [self.thumbnailImageView setImage:[UIImage imageNamed:@"默认加载图"]];
    }
    self.courseNameLabel.text = model.courseModel.course_name;
    
    CGFloat totalSizeInBytes = [model allVideoTotalSpace];
    self.downloadedTotalVideoNumsLabel.text = [NSString stringWithFormat:@"已下载%lu课时", model.arrDownloadModel.count];
    NSString* strSize = [[BXGResourceManager shareInstance] bytesToString:totalSizeInBytes];
    self.downloadedTotalSizeLabel.text = strSize;
}

-(void)showSelectImage:(UIImage*)newImage
{
    if(newImage==nil)
    {
        _selImageView.hidden = YES;
        return ;
    }
    _selImageView.hidden = NO;
    _selImageView.image = newImage;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

- (void)updateConstraints
{
    __weak typeof(BXGDownloadedCell) *weakSelf = self;
    [self.selImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.selImageView.hidden ? CGSizeZero : CGSizeMake(19, 19));
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.mas_equalTo(15);
    }];
    
    [self.thumbnailImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.selImageView.mas_right).offset(weakSelf.selImageView.hidden ? 0 : 15);
        //make.top.mas_equalTo(17);
    }];
    
//    @property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
//    @property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *downloadedTotalVideoNumsLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *downloadedTotalSizeLabel;
//    self.thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_selImageView.hidden ? 0 : )
//    }
    
    [super updateConstraints];
}

@end
