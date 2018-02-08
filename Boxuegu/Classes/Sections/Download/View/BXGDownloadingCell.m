//
//  BXGDownloadingCell.m
//  Demo
//
//  Created by apple on 17/6/10.
//  Copyright © 2017年 com.bokecc.www. All rights reserved.
//@interface BXGDownloadingCell()
//@property(nonatomic, copy) BXGDownloadModel* model; //toresearch 设置成copy结果并没有copy出一个新的.
//@end

#import "BXGDownloadingCell.h"
#import "BXGDownloader.h"
#import "UIControl+Custom.h"

@interface BXGDownloadingCell()<BXGDownloadDelegate>
@end

@implementation BXGDownloadingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.statusButton.custom_acceptEventInterval = 0.2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)showSelectImage:(UIImage*)newImage
{
    if(newImage==nil)
    {
        _editSelImageView.hidden = YES;
        return ;
    }
    _editSelImageView.hidden = NO;
    _editSelImageView.image = newImage;
}

-(void)setupCell:(BXGDownloadModel *)model withIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    _model = model;
    [self _setupCellPrivate:model.downloadBaseModel];
}

-(void)_setupCellPrivate:(BXGDownloadBaseModel*)model
{
    self.videoIdx.text = model.videoModel.idx;
    self.titleLabel.text = model.videoModel.name;
    BXGResourceManager* resource = [BXGResourceManager shareInstance];
    self.downloadByteProgressLabel.text = [NSString stringWithFormat:@"%@/%@",
                                           [resource bytesToString:model.totalBytesWritten],
                                           [resource bytesToString:model.totalBytesExpectedToWrite]];
    self.downloadSpeedLabel.text = [[BXGResourceManager shareInstance] bytesToString:model.speed];
    self.downloadProgressView.progress = model.progress;
    self.downloadProgressView.progressTintColor = [UIColor colorWithHex:0x38ADFF];
    self.downloadProgressView.trackTintColor = [UIColor colorWithHex:0xCCCCCC];
    [self updateDownloadStatus:model.state];
}

- (void)updateDownloadStatus:(DWDownloadState)state
{
    _downloadSpeedLabel.text = [[BXGDownloader shareInstance] downloadText:self.model.downloadBaseModel
                                                              fromPageCell:CALL_FROM_PAGE_DOWNLOADING_CELL];
    
    NSString *filename = nil;
    switch (state) {
        case DWDownloadStateReadying:
            filename = @"正在下载";
            break;
            
        case DWDownloadStateNone:
            filename = @"正在下载";
            break;
            
        case DWDownloadStateRunning:
            filename = @"下载暂停";
            break;
            
        case DWDownloadStateSuspended:
            filename = @"正在下载";
            break;
            
        case DWDownloadStateFailed:
            filename = @"下载失败";
            break;
            
        case  DWDownloadStateCompleted:
            if(_delegate && [_delegate respondsToSelector:@selector(downloadCompleted)])
            {
                [_delegate downloadCompleted];
            }
            break;
            
        default:
            break;
    }
    if(filename!=nil)
    {
        [self.statusButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateNormal];
    }
}

- (IBAction)clickStatusButton:(id)sender
{
    if(!_editSelImageView.hidden)
    {
        //编辑模式
        return ;
    }
    //检测无网络情况
    BXGReachabilityStatus status= [[BXGNetWorkTool sharedTool] getReachState];
    if(status == BXGReachabilityStatusReachabilityStatusNotReachable) {
        [[BXGHUDTool share]showHUDWithString:kBXGToastNonNetworkTip];
        return ;
    }

    if(_model!=nil)
    {
        BXGDownloader *downloader = [BXGDownloader shareInstance];
        switch (_model.downloadBaseModel.state) {
            case DWDownloadStateReadying:
                //需要将之前下载中的视频暂停,然后开始下载
                [downloader pausePreDownloadingVideoAndRunSpecificDownloadModel:_model];
                break;
                
            case DWDownloadStateNone:
            {
                _model.downloadBaseModel.state = DWDownloadStateReadying;//todo 这个直接就改变了下载中的存储信息嘛?
                [downloader pausePreDownloadingVideoAndRunSpecificDownloadModel:_model];
            }
                break;
                
            case DWDownloadStateRunning:
            {
                [downloader suspendDownloadModel:_model];
                [downloader downloadNextWaitingVideo];
            }
                break;
                
            case DWDownloadStateSuspended:
            {
                [downloader pausePreDownloadingVideo];
                [downloader resumeDownloadModel:_model];
            }
                break;
                
            case DWDownloadStateFailed:
            {
                [downloader pausePreDownloadingVideo];
                [downloader startDownloadModel:_model];
            }
                break;
                
            case  DWDownloadStateCompleted:
                //TODO 不应该显示在这里
                break;
                
            default:
                break;
        }
        
        [self updateDownloadStatus:_model.downloadBaseModel.state];
    }
}

-(void)downloadProgressModel:(BXGDownloadBaseModel*)downloadModel
{
    [self _setupCellPrivate:downloadModel];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

- (void)updateConstraints
{
    __weak typeof(BXGDownloadingCell*) weakSelf = self;
    [self.editSelImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.editSelImageView.hidden ? CGSizeZero : CGSizeMake(19, 19));
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.mas_equalTo(15);
    }];
//    @property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//    @property (weak, nonatomic) IBOutlet UIButton *statusButton;
//    @property (weak, nonatomic) IBOutlet UILabel *downloadByteProgressLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *downloadSpeedLabel;
//    @property (weak, nonatomic) IBOutlet UIProgressView *downloadProgressView;
    //*
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.editSelImageView.mas_right).offset(weakSelf.editSelImageView.hidden ? 0 : 15);
        make.top.mas_equalTo(17);
    }];
    /*
    [self.statusButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-15);
        make.top.mas_equalTo(weakSelf.titleLabel.mas_top).offset(0);
        make.width.mas_equalTo(21);
        make.height.mas_equalTo(21);
    }];
    [self.downloadByteProgressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.titleLabel.mas_left).offset(0);
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(12);
    }];
    [self.downloadSpeedLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.statusButton.mas_right).offset(0);
        make.top.mas_equalTo(weakSelf.downloadByteProgressLabel.mas_top).offset(0);
    }];
    [self.downloadProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.titleLabel.mas_left).offset(0);
        make.right.mas_equalTo(weakSelf.statusButton.mas_top).offset(0);
        make.top.mas_equalTo(weakSelf.downloadByteProgressLabel.mas_bottom).offset(6);
    }];
    //*/
    
    [super updateConstraints];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"state"])
    {
//        NSLog(@"the keyPath=%@, object=%@", keyPath, object);
        if([object isKindOfClass:[BXGDownloadBaseModel class]])
        {
            [self _setupCellPrivate:((BXGDownloadBaseModel*)object)];
        }
        
    }
    else if([keyPath isEqualToString:@"totalBytesWritten"])
    {
        if([object isKindOfClass:[BXGDownloadBaseModel class]])
        {
            [self _setupCellPrivate:((BXGDownloadBaseModel*)object)];
        }
    }
}

@end
