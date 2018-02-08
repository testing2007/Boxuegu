//
//  BXGCommentVC.m
//  Boxuegu
//
//  Created by apple on 2017/9/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommentVC.h"
#import "BXGCommentViewModel.h"
#import "RWTextView.h"
#import "UIBarButtonItem+Common.h"

typedef NS_ENUM(NSInteger, CommentType)
{
    CommentType_Comment,
    CommentType_Reply,
    CommentType_ReplyReply
};

@interface BXGCommentVC () <UIScrollViewDelegate>

@property(nonatomic, strong) BXGCommentViewModel *commentViewModel;

@property(nonatomic, weak) UIImageView *bgImageView;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) RWTextView *descTxtView;

@property(nonatomic, assign) CommentType commentType;

@property(nonatomic, strong) BXGCommunityDetailModel* postModel;
@property(nonatomic, strong) BXGCommunityPostModel* attentionPostModel;
@property(nonatomic, strong) BXGCommunityCommentDetailModel* commentModel;
@property(nonatomic, strong) BXGCommunityCommentReplyModel* replyModel;
@property (nonatomic, weak) UIBarButtonItem *postItem;
@property (nonatomic, weak) UIButton *postBtn;

@property(nonatomic, weak) UIScrollView *scrollView;
@property(nonatomic, weak) UIView *contentView;
@end

@implementation BXGCommentVC

#pragma mark - Interface

- (instancetype)initForPostCommentWithPostModel:(BXGCommunityDetailModel *)postModel; {

    self = [super init];
    if(self) {
    
        self.commentType = CommentType_Comment;
        self.postModel = postModel;
    }
    return self;
}
- (instancetype)initForPostCommentReplyCommentWithCommentModel:(BXGCommunityCommentDetailModel *)commentModel; {

    self = [super init];
    if(self) {
        
        self.commentType = CommentType_Reply;
        self.commentModel = commentModel;
    }
    return self;
}
- (instancetype)initForPostCommentReplyReplyWithReplyModel:(BXGCommunityCommentReplyModel *)replyModel; {

    self = [super init];
    if(self) {
        
        self.commentType = CommentType_ReplyReply;
        self.replyModel = replyModel;
    }
    return self;
}

- (instancetype)initForPostCommentWithAttentionPostModel:(BXGCommunityPostModel *)postModel; {
    
    self = [super init];
    if(self) {
        
        self.commentType = CommentType_Comment;
        self.attentionPostModel = postModel;
    }
    return self;
}

#pragma mark - Getter Setter

- (BXGCommentViewModel *)commentViewModel {

    if(!_commentViewModel){
    
        _commentViewModel = [BXGCommentViewModel new];
    }
    return _commentViewModel;
}

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评论";
    self.pageName = @"博学圈评论页";
    [self installUI];
    self.scrollView.delegate = self;
}



-(void)installUI
{
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    UIScrollView *scrollView = [UIScrollView new];
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
    }];
    
    UIView *contentView = [UIView new];
    self.contentView = contentView;
    
    [self.scrollView addSubview:contentView];
    self.scrollView.scrollEnabled = false;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.bottom.offset(0);
        make.width.equalTo(scrollView);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapView:)];;
    [contentView addGestureRecognizer:tap];
    contentView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
    UIView *spView = [UIView new];
    [contentView addSubview:spView];
    spView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"学习圈-评论背景"]];
    [contentView addSubview:bgImageView];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView = bgImageView;
    bgImageView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [_bgImageView addSubview:titleLabel];
    _titleLabel = titleLabel;
    _titleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    _titleLabel.tintColor = [UIColor colorWithHex:0x333333];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"点完赞, 发个评论, 才是真正的认可!";
    [_titleLabel sizeToFit];
    
    UIView *contentBlockView = [UIView new];
    [contentView addSubview:contentBlockView];
    
    contentBlockView.backgroundColor = [UIColor whiteColor];
    
    RWTextView *textView = [RWTextView new];
    [contentBlockView addSubview:textView];
    _descTxtView = textView;
    _descTxtView.countNumber = 200;
    _descTxtView.placeHolder = @"我也来说一句吧";
    _descTxtView.minimumHeight = 120;
    
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(0);
        make.left.right.offset(0);
        make.height.offset(9);
    }];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spView.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.height.offset(80);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_bgImageView);
    }];
    
    [_descTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(9);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(_descTxtView.minimumHeight);
        make.bottom.equalTo(contentBlockView).offset(-1000);
    }];
    
    [contentBlockView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bgImageView.mas_bottom).offset(9);
        make.left.right.bottom.offset(0);
        make.bottom.equalTo(contentView.mas_bottom).offset(9);
        
    }];
    
    UIButton *postBtn = [UIButton buttonWithType:0];
    [postBtn setTitle:@"发布" forState:UIControlStateNormal];
    [postBtn sizeToFit];
    
    postBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:15];
    UIBarButtonItem *commitItem = [[UIBarButtonItem alloc]initWithCustomView:postBtn];
    self.postBtn = postBtn;
    
    [postBtn addTarget:self action:@selector(postComment) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = commitItem;

}
#pragma mark - Event

- (void)onTapView:(UITapGestureRecognizer *)tap {
    
    [self.descTxtView endEditing:true];
}

- (void)postComment {
    
    [[BXGBaiduStatistic share] statisticEventString:bxq_plfb andParameter:nil];
    
    if(self.descTxtView.hasEmoji) {
        
        [[BXGHUDTool share] showHUDWithString:kBXGToastNoSupportEmoji];
        return;
    };
    
    void(^finished)(BOOL bSuccess, NSError *error) = ^(BOOL bSuccess, NSError *error) {
    
        if(bSuccess) {
        
            [[BXGHUDTool share] showHUDWithString:@"提交成功"];
            if(self.navigationController) {
            
                [self.navigationController popViewControllerAnimated:true];
            }
            
        }else {
        
            [[BXGHUDTool share] showHUDWithString:@"提交失败"];
        }
        
        if(self.commentFinishedBlock) {
            
            self.commentFinishedBlock(bSuccess);
        }
        self.postItem.enabled = true;
        self.postBtn.enabled = true;
    };
    
    if(self.commentType == CommentType_Comment) {
    
        NSNumber *postId;
        NSString *content;
        NSNumber *commentId;
        NSNumber *replyUserID;
        
        if(self.attentionPostModel) {
        
            postId = self.attentionPostModel.idx;
            content = self.descTxtView.text;
            commentId = self.attentionPostModel.idx;
            replyUserID = self.attentionPostModel.userId;
        }
        
        else if(self.postModel) {
        
            postId = self.postModel.idx;
            content = self.descTxtView.text;
            
            commentId = self.postModel.idx;
            replyUserID = self.postModel.userId;
        }
        
        BOOL isValidateCommentContent = [self isValidateCommentContent:content];
        if(!isValidateCommentContent) {
            return ;
        }
        

    
        self.postItem.enabled = false;
        self.postBtn.enabled = false;
        [[BXGHUDTool share] showLoadingHUDWithString:@"提交评论中..."];
        [self.commentViewModel postSaveCommentByPostId:postId
                                          andCommentId:commentId
                                        andReplyedUUID:replyUserID
                                            andContent:content
                                        andFinishBlock:finished];
    }
    
    else if(self.commentType == CommentType_Reply) {
    
        NSNumber *postId = self.commentModel.postId;
        NSString *content = self.descTxtView.text;
        NSNumber *commentId = self.commentModel.idx;
        NSNumber *replyUserId = self.commentModel.userId;
        
        BOOL isValidateCommentContent = [self isValidateCommentContent:content];
        if(!isValidateCommentContent) {
            return ;
        }
        self.postItem.enabled = false;
        self.postBtn.enabled = false;

        
        [[BXGHUDTool share] showLoadingHUDWithString:@"提交评论中..."];
        [self.commentViewModel postSaveReplyedCommentByPostId:postId andContent:content andCommentId:commentId andReplyedUserId:replyUserId andFinishBlock:finished];
        
    }
    
    else if(self.commentType == CommentType_ReplyReply) {
    
        NSNumber *postId = self.replyModel.postId;
        NSString *content = self.descTxtView.text;
        NSNumber *commentId = self.replyModel.commentId;
        NSNumber *replyUserId = self.replyModel.userId;
        NSNumber *replyId = self.replyModel.idx;
        
        BOOL isValidateCommentContent = [self isValidateCommentContent:content];
        if(!isValidateCommentContent) {
            return ;
        }
        self.postItem.enabled = false;
        self.postBtn.enabled = false;
        [[BXGHUDTool share] showLoadingHUDWithString:@"提交评论中..."];
        [self.commentViewModel postSaveReplyedReplyByPostId:postId andContent:content andCommentId:commentId andReplyId:replyId andReplyedId:replyUserId andFinishBlock:finished];
    }
}

-(BOOL)isValidateCommentContent:(NSString*)content
{
    NSString *text = content;
    if(text){
        
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }

    BOOL bValidate = YES;
    if(!text || text.length==0) {
        NSLog(@"输入内容为空,不能发表评论哦");
        [[BXGHUDTool share] showHUDWithString:@"内容为空，说点什么吧！"];
        bValidate = NO;
    }
    return bValidate;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.descTxtView endEditing:true];
}

#pragma mark - End
@end
