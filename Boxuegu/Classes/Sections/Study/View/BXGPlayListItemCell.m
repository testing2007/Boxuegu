//
//  BXGPlayListItemCell.m
//  Boxuegu
//
//  Created by HM on 2017/4/22.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPlayListItemCell.h"
#import "BXGDownloader.h"

@interface BXGPlayListItemCell()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *playImageView;
@property (nonatomic, weak) UILabel *downloadInfoLabel;
@end

@implementation BXGPlayListItemCell

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


- (void) setPlayerStatus:(BXGStudyPlayerStatusType *)playerStatus {

    _playerStatus = playerStatus;
    
}

- (void)setVideoModel:(BXGCourseOutlineVideoModel *)videoModel {

    _videoModel = videoModel;
    self.title = videoModel.name;
    if(videoModel.lock_status.integerValue == 0){
    
        // 未解锁状态
        [self.playImageView setImage:[UIImage imageNamed:@"课程大纲-锁"]];
    }else if(videoModel.study_status.integerValue == 1) {
    
        // 已学习状态
        [self.playImageView setImage:[UIImage imageNamed:@"课程大纲-学完"]];
        
    }else if (videoModel.study_status.integerValue == 2){
    
        //2.学习中状态
        [self.playImageView setImage:[UIImage imageNamed:@"课程大纲-未学完"]];
    }else {
        
        //0 未学习
        [self.playImageView setImage:[UIImage imageNamed:@"课程大纲-解锁"]];
    }
    
    
    if(videoModel.idx){
    
        NSMutableString *stirng = [NSMutableString new];
        BOOL result = [[BXGResourceManager shareInstance] isDownloadFileExistInLocalByVideoIdx:videoModel.idx withReturnLocalPath:&stirng];
        
        if(result) {
        
            self.downloadInfoLabel.text = @"已下载";
        }else {
            NSDictionary *dictDownloading  = [[BXGResourceManager shareInstance] dictDownloading];
            if(dictDownloading && [dictDownloading objectForKey:videoModel.idx])
            {
                BXGDownloadModel *downloadModel = dictDownloading[videoModel.idx];
                NSString *strText = [[BXGDownloader shareInstance] downloadText:downloadModel.downloadBaseModel
                                                                   fromPageCell:CALL_FROM_PAGE_PLAY_LIST_CELL];
                
                self.downloadInfoLabel.text = strText;
            }
            else
            {
                self.downloadInfoLabel.text = @"";
            }
        }
        
    }
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
    
    //begin下载信息显示
    UILabel *downloadInfoLabel = [UILabel new];
    [self.contentView addSubview:downloadInfoLabel];
    self.downloadInfoLabel = downloadInfoLabel;
    downloadInfoLabel.font = [UIFont bxg_fontRegularWithSize:14];
    [downloadInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(-15);
        make.width.offset(47);
        make.height.offset(20);
    }];
    downloadInfoLabel.textColor = [UIColor colorWithHex:0x999999];
    //end
    
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
        make.right.equalTo(downloadInfoLabel.mas_left).offset(-15);
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

-(void)downloadProgressModel:(BXGDownloadBaseModel*)downloadModel
{
//    NSLog(@"#####the downloadModel, progress=%2lf", downloadModel.progress);
    
    self.downloadInfoLabel.text = [[BXGDownloader shareInstance] downloadText:downloadModel
                                                       fromPageCell:CALL_FROM_PAGE_PLAY_LIST_CELL];
    
    //NSString *strText = [[BXGDownloader shareInstance] downloadText:downloadModel.state];
    /*
    if(strText)
    {
        _downloadInfoLabel.text = strText;
    }
    if(downloadModel.state == DWDownloadStateRunning)
    {
        NSString *strProgress = [NSString stringWithFormat:@"%.1f%%", downloadModel.progress*100];
        _downloadInfoLabel.text = strProgress;
    }
     
    if(downloadModel.state == DWDownloadStateCompleted) {
    
        self.downloadInfoLabel.text = @"已下载";
    }
      //*/
//    [self.contentView setNeedsLayout];
//    [self.contentView layoutIfNeeded];
//    [self layoutIfNeeded];
}


@end
