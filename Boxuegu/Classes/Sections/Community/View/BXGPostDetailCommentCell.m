//
//  BXGPostDetailCommentCell.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPostDetailCommentCell.h"
#import "BXGCommentReplyView.h"
#import "UIControl+Custom.h"
#import "UIButton+Extension.h"
#import "UIView+Extension.h"

@interface BXGPostDetailCommentCell()

// userBlockView
@property (weak, nonatomic) IBOutlet UIView *userBlockView;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *usrNameLb;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLb;
@property (weak, nonatomic) IBOutlet UIButton *thumbBtn;
@property (weak, nonatomic) IBOutlet UILabel *thumbLb;

@property (weak, nonatomic) IBOutlet UIButton *msgBtn;
@property (weak, nonatomic) IBOutlet UILabel *msgLb;

@property (weak, nonatomic) IBOutlet UIButton *reportBtn;




@property (weak, nonatomic) IBOutlet UIView *contentBlockView;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;

@property (weak, nonatomic) IBOutlet UIView *replyBlockView;


@end

@implementation BXGPostDetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self installUI];
    
}
- (IBAction)onClickReportCommentBtn:(UIButton *)sender {
    
    Weak(weakSelf);
    // self sele
    if(self.clickReportCommentBtnBlock) {
    
        self.clickReportCommentBtnBlock(weakSelf.model);
    }
    
    
}
- (IBAction)onClickMsgBtn:(UIButton *)sender {
    
    Weak(weakSelf);
    // self sele
    if(self.clickMsgBtnBlock) {
        
        self.clickMsgBtnBlock(weakSelf.model);
    }
}

- (IBAction)onClickPraiseBtn:(id)sender {
    Weak(weakSelf);
    if(self.clickPraiseThumbBtnBlock) {
        
        BXGBaseViewController *baseVC = (BXGBaseViewController*)[self findOwnerVC];
        if(baseVC)
        {
            if([baseVC isNeedPresentLoginBlock:nil])
            {
                return;
            }
        }
        BOOL bPraise = self.model.isPraise;
        self.clickPraiseThumbBtnBlock(self.model);
        [self.thumbBtn animationImage:bPraise?[UIImage imageNamed:@"点赞-未选中"] : [UIImage imageNamed:@"点赞-选中"]
                              bZoomIn:!bPraise
                   andCompletionBlock:^{
                   }];
    }//endif
}

- (void)installUI {
 
    self.userIcon.layer.cornerRadius = 17;
    self.userIcon.layer.masksToBounds = true;

    self.usrNameLb.font = [UIFont bxg_fontRegularWithSize:14];
    self.usrNameLb.textColor = [UIColor colorWithHex:0x666666];
    
    self.postTimeLb.font = [UIFont bxg_fontRegularWithSize:12];
    self.postTimeLb.textColor = [UIColor colorWithHex:0x999999];
    
    [self.thumbBtn setImage:[UIImage imageNamed:@"点赞-未选中"] forState:UIControlStateNormal];
    self.thumbBtn.custom_acceptEventInterval = 1;
    [self.msgBtn setImage:[UIImage imageNamed:@"学习圈-评论"] forState:UIControlStateNormal];
    [self.reportBtn setImage:[UIImage imageNamed:@"学习圈-举报"] forState:UIControlStateNormal];

    self.thumbLb.font = [UIFont bxg_fontRegularWithSize:13];
    self.thumbLb.textColor = [UIColor colorWithHex:0x666666];
    
    self.msgLb.font = [UIFont bxg_fontRegularWithSize:13];
    self.msgLb.textColor = [UIColor colorWithHex:0x666666];
    
    [self.contentBlockView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.userIcon.mas_right);
    }];
    
    self.contentLb.numberOfLines = 0;
    self.contentLb.font = [UIFont bxg_fontRegularWithSize:15];
    self.contentLb.textColor = [UIColor colorWithHex:0x333333];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BXGCommunityCommentDetailModel *)model {

    _model = model;
    
    if(model.smallHeadPhoto) {
    
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:model.smallHeadPhoto] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }else {
    
        [self.userIcon setImage:[UIImage imageNamed:@"默认头像"]];
    }
    
    if(model.username) {
    
        self.usrNameLb.text = model.username;
    }else {
    
        self.usrNameLb.text = @"";
    }
    
    if(model.createTime){
    
        
        self.postTimeLb.text = model.createTime;
    }else {
    
        self.postTimeLb.text = @"";
    }

    if(model.content) {
        
        self.contentLb.text = model.content;
    }else {
    
        self.contentLb.text = @"";
    }
    
    if(model.praiseSum && [model.praiseSum integerValue] > 0){
    
        if([model.praiseSum integerValue] >= 100){
        
            self.thumbLb.text = @"99+";
        }else {
        
            self.thumbLb.text = [model.praiseSum stringValue];
        }
       
    }else {
    
        self.thumbLb.text = @"0";
    }
    
    if(model.isPraise) {
        
        [self.thumbBtn setImage:[UIImage imageNamed:@"点赞-选中"] forState:UIControlStateNormal];
    }else {
        
        [self.thumbBtn setImage:[UIImage imageNamed:@"点赞-未选中"] forState:UIControlStateNormal];
    }
    
    if(model.replySum && [model.replySum integerValue] > 0){
        
        if([model.replySum integerValue] >= 100){
            
            self.msgLb.text = @"99+";
        }else {
            
            self.msgLb.text = [model.replySum stringValue];
        };
    }else {
        
        self.msgLb.text = @"0";
    }
    
    for (UIView *view in self.replyBlockView.subviews) {
    
        if([view isKindOfClass:[BXGCommentReplyView class]]) {
        
            [view removeFromSuperview];
        }
        
    }
    if(model.replyList && model.replyList.count > 0) {
    
        UIView *lastView = nil;
        for (NSInteger i = 0; i < model.replyList.count; i++) {
        
            BXGCommentReplyView *replyView = [BXGCommentReplyView new];
            replyView.tapViewBlock = self.tapReplyViewBlock;
            
            [self.replyBlockView addSubview:replyView];
            
            replyView.model = model.replyList[i];
            if(!lastView) {
            
                // 第一个
                [replyView mas_makeConstraints:^(MASConstraintMaker *make) {
                   
                    make.top.offset(0);
                }];
            }else {
            
                [replyView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(lastView.mas_bottom).offset(0);
                }];
            }
            
            
            [replyView mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.left.right.offset(0);
            }];
            
            if(i == model.replyList.count - 1){
            
                [replyView mas_makeConstraints:^(MASConstraintMaker *make) {
                   
                    make.bottom.offset(0);
                }];
                // 最后一个
            }
            lastView = replyView;
        }
    }
}

- (void)reportComment:(BXGCommunityCommentDetailModel *)commentModel {

    if(self.clickReportCommentBtnBlock){
    
        self.clickReportCommentBtnBlock(commentModel);
    }
}

@end
