//
//  BXGPostDetailPostCell.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPostDetailPostCell.h"
#import "BXGNineGridView.h"
#import "BXGCommunityUserIconListView.h"
#import "UIView+Extension.h"
#import "PreviewImageVC.h"
#import "BXGPraisePersonVC.h"
#import "BXGUserCenter.h"
#import "UIControl+Custom.h"
#import "UIButton+Extension.h"
#import "BXGRequestLocationBtn.h"

@interface BXGPostDetailPostCell()
/// userBlockView
@property (weak, nonatomic) IBOutlet UIView *userBlockView;

@property (weak, nonatomic) IBOutlet UIImageView *userIconImgV;
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLb;


/// contentBlockView
@property (weak, nonatomic) IBOutlet UIView *contentBlockView;

@property (weak, nonatomic) IBOutlet UILabel *contentLb;

/// centerComponentsBlockView
@property (weak, nonatomic) IBOutlet UIView *centerComponentsBlockView;

@property (weak, nonatomic) IBOutlet UIButton *reportBtn;
//@property (weak, nonatomic) IBOutlet UIButton *starBtn;
//@property (weak, nonatomic) IBOutlet UILabel *starLb;
// @property (weak, nonatomic) IBOutlet UILabel *locationLb;
@property (weak, nonatomic) IBOutlet BXGRequestLocationBtn *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property (weak, nonatomic) IBOutlet UILabel *eyeLb;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

/// ImageDisplayView
@property (weak, nonatomic) IBOutlet BXGNineGridView *ImageDisplayView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageDisplayHeightCons;

/// bottomBlockView
@property (weak, nonatomic) IBOutlet UIView *bottomBlockView;

@property (weak, nonatomic) IBOutlet UIButton *thumbBtn;
@property (weak, nonatomic) IBOutlet UILabel *thumbLb;
@property (weak, nonatomic) IBOutlet BXGCommunityUserIconListView *thumbListView;
@property (weak, nonatomic) IBOutlet UIButton *thumbListMoreBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomSpView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *praiseIconListCostraints;

@end

@implementation BXGPostDetailPostCell

- (IBAction)onClickReportBtn:(id)sender {
    if(self.clickReportBtnBlock){
    
        Weak(weakSelf);
        self.clickReportBtnBlock(weakSelf.detailModel);
    }
    
}

- (void)setDetailModel:(BXGCommunityDetailModel *)detailModel {
    
    self.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.frame.size.height);
    if(self.superview) {
        
        [self.superview layoutIfNeeded];
    }
    
    if(detailModel.userName) {
        
        self.userNameLb.text = detailModel.userName;
    }else {
        
        self.userNameLb.text = @"";
    }
    
    if(detailModel.createTime) {
        
        self.postTimeLb.text = detailModel.createTime;
    }else {
        
        self.postTimeLb.text = @"";
    }
    
    if(detailModel.smallHeadPhoto) {
        
        if(detailModel.smallHeadPhoto != _detailModel.smallHeadPhoto) {
            
            [self.userIconImgV sd_setImageWithURL:[NSURL URLWithString:detailModel.smallHeadPhoto] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        }
        
    }else {
    
        [self.userIconImgV setImage:[UIImage imageNamed:@"默认头像"]];
    }
    
    
    
    if(detailModel.location && detailModel.location.length > 0) {
        
        self.locationBtn.hidden = false;
        self.locationBtn.stirng =  detailModel.location;
    }else {
        self.locationBtn.hidden = true;
        self.locationBtn.stirng =  @"未知";
    }
    
    if(detailModel.userList && detailModel.userList.count > 0) {
    
        self.thumbListView.cuModelArray = detailModel.userList;
        self.thumbListMoreBtn.hidden = false;
    }else {
    
        self.thumbListMoreBtn.hidden = true;
        self.thumbListView.cuModelArray = nil;
    }
    self.praiseIconListCostraints.constant = self.thumbListView.frame.size.width;
    
    // noticeUserList
    NSMutableAttributedString *amString;
    NSMutableAttributedString *topicString;
    NSMutableAttributedString *notiString;
    if(detailModel.content && detailModel.content.length > 0) {
        
        NSDictionary *att = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0x151515],NSFontAttributeName:[UIFont bxg_fontRegularWithSize:15]};
        amString = [[NSMutableAttributedString alloc]initWithString:detailModel.content attributes:att];
    }else {
        
        self.contentLb.text = @"";
    }
    
    if(detailModel && detailModel.topicName.length > 0) {
        
        NSDictionary *topicAtt = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0x38ADFF],NSFontAttributeName:[UIFont bxg_fontRegularWithSize:15]};
        NSString *string = [NSString stringWithFormat:@"#%@# ",detailModel.topicName];
        topicString = [[NSMutableAttributedString alloc]initWithString:string attributes:topicAtt];;
        
    }else {
        
        topicString = [[NSMutableAttributedString alloc]initWithString:@"" attributes:nil];
    }
    if(detailModel.noticeUserList && detailModel.noticeUserList.count > 0) {
    
        NSMutableString *baseString = [NSMutableString new];
        
        [baseString appendString:@"\n\n@"];
        
        NSDictionary *notiAtt = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0x38ADFF],NSFontAttributeName:[UIFont bxg_fontRegularWithSize:15]};
        
        for(NSInteger i = 0; i < detailModel.noticeUserList.count; i++) {
        
            if(detailModel.noticeUserList[i].nickname && detailModel.noticeUserList[i].nickname.length > 0){
                
                [baseString appendString:[NSString stringWithFormat:@"%@%@",detailModel.noticeUserList[i].nickname,
                                          i!=detailModel.noticeUserList.count-1?@",":@""]];
            }
            
        }
        notiString = [[NSMutableAttributedString alloc]initWithString:baseString attributes:notiAtt];
    }
    
    if(amString) {
    
        [topicString appendAttributedString:amString];
    }
    if(notiString) {
    
        // [topicString appendAttributedString:notiString];
    }
    
    self.contentLb.attributedText = topicString;
    
    //    if(model.content) {
    //
    //        self.contentLb.text = model.content;
    //    }else {
    //
    //        self.contentLb.text = @"";
    //    }
    
    if(detailModel.praiseSum && [detailModel.praiseSum integerValue] > 0) {
        
        self.thumbLb.text = [detailModel.praiseSum stringValue];
    }else {
        
        self.thumbLb.text = @"0";
    }
    
    if(detailModel.browseSum && [detailModel.browseSum integerValue] > 0) {
        
        self.eyeLb.text = [detailModel.browseSum stringValue];
    }else {
        
        self.eyeLb.text = @"0";
    }
    
    //    if(model.commentSum && [model.commentSum integerValue] > 0) {
    //
    //        self.msgLb.text = [model.commentSum stringValue];
    //    }else {
    //
    //        self.msgLb.text = @"0";
    //    }
    
    if(detailModel.praiseSum && [detailModel.praiseSum integerValue] > 0) {
        
        self.thumbLb.text = [[detailModel.praiseSum stringValue] stringByAppendingString:@"个赞"];
    }else {
        
        self.thumbLb.text = @"0个赞";
    }
    
    if(detailModel.userList) {
        
        self.thumbListView.cuModelArray = detailModel.userList ;
        self.thumbListMoreBtn.hidden = false;
        
    }else {
        
        self.thumbListView.cuModelArray = nil;
        self.thumbListMoreBtn.hidden = true;
    }
    
    if(detailModel.isPraise) {
    
        
        [self.thumbBtn setImage:[UIImage imageNamed:@"点赞-选中"] forState:UIControlStateNormal];
        // [self.thumbBtn setTitleColor:[UIColor colorWithHex:0x38ADFF] forState:UIControlStateNormal];
    }else {
    
        [self.thumbBtn setImage:[UIImage imageNamed:@"点赞-未选中"] forState:UIControlStateNormal];
        //[self.thumbBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    }
    
    if([BXGUserCenter share].userModel && [detailModel.userId isEqual:[BXGUserCenter share].userModel.itcast_uuid]) {
    
        // 隐藏关注
        self.attentionBtn.hidden = true;
    }else {
    
        // 显示关注
        self.attentionBtn.hidden = false;
    }
    
    if(detailModel.isAttention) {
    
        self.attentionBtn.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
        [self.attentionBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];

    }else {
        [self.attentionBtn setTitle:@"＋关注" forState:UIControlStateNormal];
        [self.attentionBtn setTitleColor:[UIColor colorWithHex:0x38ADFF] forState:UIControlStateNormal];
        self.attentionBtn.layer.borderColor = [UIColor colorWithHex:0x38ADFF].CGColor;
        // self.attentionBtn.layer.cornerRadius = 15;
    }
        
    
    
    __weak typeof(self) weakSelf = self;
    
    
    if(detailModel.imgPathList) {
    
        if(detailModel.imgPathList != _detailModel.imgPathList) {
         
            self.ImageDisplayView.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.ImageDisplayView.bounds.size.height);
            [self.ImageDisplayView setImages:detailModel.imgPathList andTapImageBlock:^(NSInteger index, NSArray *imageURLs) {
                [weakSelf loadPreviewBigImage:index andImageURLs:imageURLs];
            }];
            
            self.imageDisplayHeightCons.constant = self.ImageDisplayView.frame.size.height;
            
        }
        
    }else {
    
        self.ImageDisplayView.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.ImageDisplayView.bounds.size.height);
        
        [self.ImageDisplayView setImages:nil andTapImageBlock:^(NSInteger index, NSArray *imageURLs) {
            [weakSelf loadPreviewBigImage:index andImageURLs:imageURLs];
        }];
        
        self.imageDisplayHeightCons.constant = 0;
    }
    
    self.eyeLb.hidden = true;
    self.eyeBtn.hidden = true;
    
    
    _detailModel = detailModel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bottomSpView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.offset(0);
    }];
    
    [self installUI];
}


- (IBAction)onClickThumbListBtn:(UIButton *)sender {
    
    Weak(weakSelf);
    
    if(self.clickThumbListBlock){
    
        self.clickThumbListBlock(weakSelf.detailModel);
    }
}


-(void)loadPreviewBigImage:(NSInteger)index andImageURLs:(NSArray*)imageURLs
{
    __weak typeof(self) weakSelf = self;
    if(imageURLs && imageURLs.count>0)
    {
        if(index>imageURLs.count)
            index = 0;
        
        UIViewController *vc = [weakSelf findOwnerVC];
        if(vc)
        {
            PreviewImageVC *previewVC = [[PreviewImageVC alloc] initWithImageStrURLs:imageURLs
                                                                        atStartIndex:index
                                                                    placeholderImage:[UIImage imageNamed:@"默认加载图-正方形"]];
            [vc presentViewController:previewVC animated:YES completion:nil];
        }
    }
}

- (void)clickReportBtn:(UIButton *)sender; {
    
    Weak(weakSelf);
    if(self.clickReportBtnDetailModelBlock) {
        
        self.clickReportBtnDetailModelBlock(weakSelf.detailModel);
    }
}

- (void)installUI{
    
    self.userIconImgV.layer.cornerRadius = 20;
    self.userIconImgV.layer.masksToBounds = true;
    
    self.userNameLb.font = [UIFont bxg_fontRegularWithSize:14];
    self.userNameLb.textColor = [UIColor colorWithHex:0x333333];
    
    
    self.postTimeLb.font = [UIFont bxg_fontRegularWithSize:12];
    self.postTimeLb.textColor = [UIColor colorWithHex:0x999999];
    
    self.locationBtn.userInteractionEnabled = false;
    self.locationBtn.backgroundColor = [UIColor whiteColor];
//    self.locationBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:12];
//    [self.locationBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    // self.locationLb.font =
    //self.locationBtn.titleLabel.textColor = [UIColor colorWithHex:0x999999];
    
    self.contentLb.font = [UIFont bxg_fontRegularWithSize:15];
    self.contentLb.textColor = [UIColor colorWithHex:0x151515];
    
    self.contentLb.numberOfLines = 0;
    
//    self.starLb.font = [UIFont bxg_fontRegularWithSize:13];
//    self.starLb.textColor = [UIColor colorWithHex:0x999999];
    
    self.eyeLb.font = [UIFont bxg_fontRegularWithSize:13];
    self.eyeLb.textColor = [UIColor colorWithHex:0x999999];
    
//    self.msgLb.font = [UIFont bxg_fontRegularWithSize:13];
//    self.msgLb.textColor = [UIColor colorWithHex:0x999999];
    
    self.thumbLb.font = [UIFont bxg_fontRegularWithSize:13];
    self.thumbLb.textColor = [UIColor colorWithHex:0x999999];
    
//    [self.starBtn setImage:[UIImage imageNamed:@"收藏-未选中"] forState:UIControlStateNormal];
    [self.eyeBtn setImage:[UIImage imageNamed:@"学习圈-浏览"] forState:UIControlStateNormal];
//    [self.msgBtn setImage:[UIImage imageNamed:@"学习圈-评论"] forState:UIControlStateNormal];
    [self.reportBtn setImage:[UIImage imageNamed:@"学习圈-举报"] forState:UIControlStateNormal];
    [self.reportBtn addTarget:self action:@selector(clickReportBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.thumbBtn setImage:[UIImage imageNamed:@"点赞-未选中"] forState:UIControlStateNormal];
    //self.thumbBtn.custom_acceptEventInterval = 1;
    [self.thumbListMoreBtn setImage:[UIImage imageNamed:@"学习圈-用户-更多"] forState:UIControlStateNormal];
    self.thumbListView.horizontalMargin = 10;
    //  // 60 50
    
    self.attentionBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:14];
    [self.attentionBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    self.attentionBtn.layer.borderColor = [UIColor colorWithHex:0xCCCCCC].CGColor;
    self.attentionBtn.layer.borderWidth = 1;
    self.attentionBtn.layer.cornerRadius = 12.5;
}
- (IBAction)onClickAttentionBtn:(UIButton *)sender {
    Weak(weakSelf);
    
    if(self.clickAttentionBlock){
    
        self.clickAttentionBlock(weakSelf.detailModel);
    }
}
- (IBAction)onClickThumbBtn:(id)sender {
    
    Weak(weakSelf);
        
    if(self.clickPraiseBtnBlock){
        BXGBaseViewController *baseVC = (BXGBaseViewController*)[self findOwnerVC];
        if(baseVC)
        {
            if([baseVC isNeedPresentLoginBlock:nil])
            {
                return;
            }
        }
        BOOL bPraise = self.detailModel.isPraise;
        self.clickPraiseBtnBlock(weakSelf.detailModel);
        [self.thumbBtn animationImage:bPraise?[UIImage imageNamed:@"点赞-未选中"] : [UIImage imageNamed:@"点赞-选中"]
                              bZoomIn:!bPraise
                   andCompletionBlock:^{
        }];
    }//endif
}

@end
