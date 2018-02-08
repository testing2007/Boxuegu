//
//  BXGAttentionContentCell.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGAttentionContentCell.h"
#import "BXGCommunityUserIconListView.h"
#import "BXGNineGridView.h"
#import "PreviewImageVC.h"
#import "UIView+Extension.h"
#import "UIControl+Custom.h"
#import "UIButton+Extension.h"
#import "BXGRequestLocationBtn.h"

@interface BXGAttentionContentCell()
/// userBlockView
@property (weak, nonatomic) IBOutlet UIView *userBlockView;

@property (weak, nonatomic) IBOutlet UIImageView *userIconImgV;
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLb;
@property (weak, nonatomic) IBOutlet BXGRequestLocationBtn *locationBtn;

/// contentBlockView
@property (weak, nonatomic) IBOutlet UIView *contentBlockView;

@property (weak, nonatomic) IBOutlet UILabel *contentLb;

/// centerComponentsBlockView
@property (weak, nonatomic) IBOutlet UIView *centerComponentsBlockView;

@property (weak, nonatomic) IBOutlet UIButton *reportBtn;
@property (weak, nonatomic) IBOutlet UIButton *starBtn;
@property (weak, nonatomic) IBOutlet UILabel *starLb;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property (weak, nonatomic) IBOutlet UILabel *eyeLb;
@property (weak, nonatomic) IBOutlet UIButton *msgBtn;
@property (weak, nonatomic) IBOutlet UILabel *msgLb;

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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attentionCons;

@end
@implementation BXGAttentionContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.bottomSpView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.offset(0);
    }];
    [self installUI];
    
    
}
- (UITableViewCellSelectionStyle)selectionStyle {

    return UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    // self.locationLb.font = [UIFont bxg_fontRegularWithSize:12];
    // self.locationLb.textColor = [UIColor colorWithHex:0x999999];

    self.contentLb.font = [UIFont bxg_fontRegularWithSize:15];
    self.contentLb.textColor = [UIColor colorWithHex:0x151515];

    self.contentLb.numberOfLines = 0;
    
    self.starLb.font = [UIFont bxg_fontRegularWithSize:13];
    self.starLb.textColor = [UIColor colorWithHex:0x999999];
    
    self.eyeLb.font = [UIFont bxg_fontRegularWithSize:13];
    self.eyeLb.textColor = [UIColor colorWithHex:0x999999];
    
    self.msgLb.font = [UIFont bxg_fontRegularWithSize:13];
    self.msgLb.textColor = [UIColor colorWithHex:0x999999];
    
    self.thumbLb.font = [UIFont bxg_fontRegularWithSize:13];
    self.thumbLb.textColor = [UIColor colorWithHex:0x999999];
    
    [self.starBtn setImage:[UIImage imageNamed:@"收藏-未选中"] forState:UIControlStateNormal];
    [self.eyeBtn setImage:[UIImage imageNamed:@"学习圈-浏览"] forState:UIControlStateNormal];
    [self.msgBtn setImage:[UIImage imageNamed:@"学习圈-评论"] forState:UIControlStateNormal];
    [self.reportBtn setImage:[UIImage imageNamed:@"学习圈-更多"] forState:UIControlStateNormal];
    [self.reportBtn addTarget:self action:@selector(clickReportBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.thumbBtn setImage:[UIImage imageNamed:@"点赞-未选中"] forState:UIControlStateNormal];
    self.thumbBtn.custom_acceptEventInterval = 1;
    [self.thumbListMoreBtn setImage:[UIImage imageNamed:@"学习圈-用户-更多"] forState:UIControlStateNormal];
    self.thumbListView.horizontalMargin = 10;
    self.starBtn.hidden = true;
    self.starLb.hidden = true;
    self.eyeBtn.hidden = true;
    self.eyeLb.hidden = true;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapBottomBlockView:)];
    [self.bottomBlockView addGestureRecognizer:tap];
    
}

- (void)onTapBottomBlockView:(UITapGestureRecognizer *)tap {

    
}


- (void)setModel:(BXGCommunityPostModel *)model {

    Weak(weakSelf);
    
    self.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.frame.size.height);
    if(self.superview) {
    
         [self.superview layoutIfNeeded];
    }
    
    if(model.userName) {
    
        self.userNameLb.text = model.userName;
    }else {
        
        self.userNameLb.text = @"";
    }
    
    if(model.createTime) {
        
        self.postTimeLb.text = model.createTime;
    }else {
        
        self.postTimeLb.text = @"";
    }
    
    if(model.smallHeadPhoto) {
        
        [self.userIconImgV sd_setImageWithURL:[NSURL URLWithString:model.smallHeadPhoto] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }else {
        
        [self.userIconImgV setImage:[UIImage imageNamed:@"默认头像"]];
    }

    if(model.location && model.location.length > 0) {
        
        self.locationBtn.hidden = false;
        self.locationBtn.stirng = model.location;
    }else {
        self.locationBtn.hidden = true;
        
    }
    
    if(model.content) {
        
        self.contentLb.text = model.content;
    }else {
        
        self.contentLb.text = @"";
    }
    
//    if(model.praiseSum && [model.praiseSum integerValue] > 0) {
//        
//        self.starLb.text = [NSString stringWithFormat:@"%@个赞", [model.praiseSum stringValue]];
//    }else {
//        
//        self.starLb.text = @"0个赞";
//    }
    
    if(model.browseSum && [model.browseSum integerValue] > 0) {
        
        self.eyeLb.text = [model.browseSum stringValue];
    }else {
        
        self.eyeLb.text = @"0";
    }
    
    if(model.commentSum && [model.commentSum integerValue] > 0) {
        
        self.msgLb.text = [model.commentSum stringValue];
    }else {
        
        self.msgLb.text = @"0";
    }
    
    if(model.praiseSum && [model.praiseSum integerValue] > 0) {
        self.thumbLb.text = [NSString stringWithFormat:@"%@个赞", [model.praiseSum stringValue]];
    }else {
        self.thumbLb.text = @"0个赞";
    }
    
    if(model.praisedUserList && model.praisedUserList.count > 0) {
    
        self.thumbListView.cuModelArray = model.praisedUserList ;
        self.thumbListMoreBtn.hidden = false;
        self.attentionCons.constant = self.thumbListView.bounds.size.width;
        
    }else {
    
        self.thumbListView.cuModelArray = nil;
        self.thumbListMoreBtn.hidden = true;
    }

    if(model.isPraise) {
        
        [self.thumbBtn setImage:[UIImage imageNamed:@"点赞-选中"] forState:UIControlStateNormal];
    }else {
        
        [self.thumbBtn setImage:[UIImage imageNamed:@"点赞-未选中"] forState:UIControlStateNormal];
    }
    
    NSMutableAttributedString *amString;
    NSMutableAttributedString *topicString;
    if(model.content && model.content.length > 0) {
        
        NSDictionary *att = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0x151515],NSFontAttributeName:[UIFont bxg_fontRegularWithSize:15]};
        amString = [[NSMutableAttributedString alloc]initWithString:model.content attributes:att];
    }else {
        
        self.contentLb.text = @"";
    }
    
    if(model && model.topicName.length > 0) {
        
        NSDictionary *topicAtt = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0x38ADFF],NSFontAttributeName:[UIFont bxg_fontRegularWithSize:15]};
        NSString *string = [NSString stringWithFormat:@"#%@# ",model.topicName];
        topicString = [[NSMutableAttributedString alloc]initWithString:string attributes:topicAtt];;
        
    }else {
        
        topicString = [[NSMutableAttributedString alloc]initWithString:@"" attributes:nil];
    }
    if(amString) {
        
        [topicString appendAttributedString:amString];
        
        self.contentLb.attributedText = topicString;
    
    }
    
    if(model.imgPathList){
        if(model.imgPathList != _model.imgPathList) {
            __weak typeof(self) weakSelf = self;
            self.ImageDisplayView.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.ImageDisplayView.bounds.size.height);
            [self.ImageDisplayView setImages:model.imgPathList andTapImageBlock:^(NSInteger index, NSArray *imageURLs) {
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
    _model  = model;
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
- (IBAction)onClickThumbBtn:(id)sender {
    
    Weak(weakSelf);
    if(self.clickPraiseBtnBlock) {
        BOOL bPraise = self.model.isPraise;
        self.clickPraiseBtnBlock(weakSelf.model);
        [self.thumbBtn animationImage:bPraise?[UIImage imageNamed:@"点赞-未选中"] : [UIImage imageNamed:@"点赞-选中"]
                              bZoomIn:!bPraise
                   andCompletionBlock:^{
                       // weakSelf.model.isPraise = !weakSelf.model.isPraise;
                   }];
    }
    
//    if(self.clickPraiseBtnBlock) {
//        
//        weakSelf.clickPraiseBtnBlock(weakSelf.model);
//    }
    
    
//        if(!weakSelf.model.isPraise) {
//            [UIView animateWithDuration:1.0f animations:^{
//                [self.thumbBtn setImage:[UIImage imageNamed:@"点赞-选中"] forState:UIControlStateNormal];
//                self.thumbBtn.transform = CGAffineTransformScale(self.transform, 2.0, 2.0);
//            } completion:^(BOOL finished) {
//                self.thumbBtn.transform = CGAffineTransformIdentity;
//                self.clickPraiseBtnBlock(weakSelf.model);
//            }];
//        }else {
//            [UIView animateWithDuration:1.0f animations:^{
//                [self.thumbBtn setImage:[UIImage imageNamed:@"点赞-未选中"] forState:UIControlStateNormal];
//                self.thumbBtn.transform = CGAffineTransformScale(self.transform, 0.5, 0.5);
//            } completion:^(BOOL finished) {
//                self.thumbBtn.transform = CGAffineTransformIdentity;
//                self.clickPraiseBtnBlock(weakSelf.model);
//            }];
//        }
    //endif
}

- (IBAction)onClickMsgBtn:(id)sender {
    
    Weak(weakSelf);
    if(self.clickMsgBtnBlock) {
    
        self.clickMsgBtnBlock(weakSelf.model, (UIButton*)sender);
    }
}

- (IBAction)onClickThumbListBtn:(UIButton *)sender {
    
    Weak(weakSelf);
    if(self.clickThumbListBlock) {
        
        self.clickThumbListBlock(weakSelf.model);
    }
}

- (void)clickReportBtn:(UIButton *)sender; {

    Weak(weakSelf);
    if(self.clickReportBtnBlock) {
    
        self.clickReportBtnBlock(weakSelf.model);
    }
}

@end
