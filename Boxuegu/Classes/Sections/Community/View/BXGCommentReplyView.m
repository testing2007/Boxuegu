//
//  BXGCommentReplyView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommentReplyView.h"
@interface BXGCommentReplyView()
@property (nonatomic, strong) UILabel *replyContentLb;
@end

@implementation BXGCommentReplyView

- (void)setModel:(BXGCommunityCommentReplyModel *)model {

    _model = model;
    
    NSString * replyUserName = self.model.username;
    NSString * replytagString = @" 回复: ";
    NSString * replyContentString = self.model.content;
    // self.replyContentLb.text = [[replyUserName stringByAppendingString:replytagString] stringByAppendingString:replyContentString];
    
    NSDictionary *userNameAtt = @{NSFontAttributeName: [UIFont bxg_fontRegularWithSize:12],
                                  NSForegroundColorAttributeName: [UIColor colorWithHex:0x4289D6]};
    NSDictionary *tagAtt = @{NSFontAttributeName: [UIFont bxg_fontRegularWithSize:12],
                                  NSForegroundColorAttributeName: [UIColor colorWithHex:0x2A2A2A]};
    NSDictionary *contentAtt = @{NSFontAttributeName: [UIFont bxg_fontRegularWithSize:12],
                                  NSForegroundColorAttributeName: [UIColor colorWithHex:0x151515]};
    NSMutableAttributedString *userName = [[NSMutableAttributedString alloc]initWithString:replyUserName attributes:userNameAtt];
    NSMutableAttributedString *tag = [[NSMutableAttributedString alloc]initWithString:replytagString attributes:tagAtt];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:replyContentString attributes:contentAtt];
    [userName appendAttributedString:tag];
    [userName appendAttributedString:content];
    self.replyContentLb.attributedText = userName;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self installUI];
    }
    return self;
}

- (void)installUI {

    
    UIView *topSpView = [UIView new];
    [self addSubview:topSpView];
    [topSpView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.offset(0);
        make.top.offset(0);
        make.height.offset(1);
    }];
    topSpView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    
    
    UILabel *replyContentLb = [UILabel new];
    replyContentLb.numberOfLines = 0;
    [self addSubview:replyContentLb];
    
    [replyContentLb mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.offset(-15);
        make.left.offset(0);
        make.top.offset(9);
        make.bottom.offset(-9);
    }];
    self.replyContentLb = replyContentLb;
    self.replyContentLb.font = [UIFont bxg_fontRegularWithSize:12];
    self.replyContentLb.textColor = [UIColor colorWithHex:0x000000];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    [self addGestureRecognizer:tap];
    
    


}

- (void)tapView {

    Weak(weakSelf)
    if(self.tapViewBlock) {
        
        self.tapViewBlock(weakSelf.model);
    }
}
@end
