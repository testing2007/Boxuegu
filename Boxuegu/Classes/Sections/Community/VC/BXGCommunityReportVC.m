//
//  BXGCommunityReportVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommunityReportVC.h"
#import "BXGNetWorkTool+Community.h"
#import "BXGNetworkParser.h"
#import "BXGReportTypeModel.h"
#import "BXGReportViewModel.h"
#import "BXGChoiceTagBtn.h"
#import "BXGChoiceTagView.h"
#import "RWTextView.h"
#import "BXGRoundedBtn.h"
#import "BXGMaskView.h"


@interface BXGCommunityReportVC () <UIScrollViewDelegate>
@property (nonatomic, strong) BXGReportViewModel *viewModel;
@property (nonatomic, weak) BXGChoiceTagView *reportTagView;
@property (nonatomic, weak) UIImageView *userIconView;
@property (nonatomic, weak) UILabel *usrNameLb;
@property (nonatomic, weak) RWTextView *textView;
@property (nonatomic, strong) NSNumber *currentReportTypeId;
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation BXGCommunityReportVC

- (instancetype)init {

    self = [super init];
    if(self) {
        
        [self installUI];
    }
    return self;
}

- (BXGReportViewModel *)viewModel {

    if(!_viewModel) {
    
        _viewModel = [BXGReportViewModel new];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    self.title = @"举报";
    [self installObeservers];
    
    // [self.view installLoadingMaskViewWithInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    [self loadData];
    
    
}
/**
 响应 键盘将要显示
 
 @param noti 通知
 */
- (void)keyBoardWillHide:(NSNotification *)noti {
    
    self.scrollView.contentOffset = CGPointMake(0, 0);
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.scrollView layoutIfNeeded];
        
    }];
}

/**
 响应 键盘将要隐藏
 
 @param noti 通知
 */
- (void)keyBoardWillShow:(NSNotification *)noti {
    
    NSValue *value = noti.userInfo[@"UIKeyboardBoundsUserInfoKey"];
    CGRect rect = [value CGRectValue];
    NSLog(@"%@",noti);
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-rect.size.height);
        }];
        self.scrollView.contentOffset = CGPointMake(0, self.textView.frame.origin.y - 15);
    }];
}
- (void)dealloc {
    
    [self unInstallObservers];
}

- (void)installObeservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}

- (void)unInstallObservers {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadData {
    Weak(weakSelf);
    
    
    [self.viewModel loadReportTypeListWithFinished:^(NSArray<BXGReportTypeModel *> *modelArray) {
        
        
        weakSelf.reportTagView.reportTypeArray = modelArray;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
            // [weakSelf.view removeMaskView];
        });
        
    }];
    
}

- (void)setModel:(BXGCommunityPostModel *)model {

    _model = model;
    
    
    if(model.smallHeadPhoto) {
        
        [self.userIconView sd_setImageWithURL:[NSURL URLWithString:model.smallHeadPhoto] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }else {
        
        [self.userIconView setImage:[UIImage imageNamed:@"默认头像"]];
    }
    
    if(model.userName) {
    
        self.usrNameLb.text = model.userName;
        
    }else {
    
        self.usrNameLb.text = @"";
    }
    
    // self.reportType = ReportTypePost;

}



- (void)setDetailModel:(BXGCommunityDetailModel *)detailModel {

    _detailModel = detailModel;
    
    
    if(detailModel.smallHeadPhoto) {
        
        [self.userIconView sd_setImageWithURL:[NSURL URLWithString:detailModel.smallHeadPhoto] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }else {
        
        [self.userIconView setImage:[UIImage imageNamed:@"默认头像"]];
    }
    
    if(detailModel.userName) {
        
        self.usrNameLb.text = detailModel.userName;
        
    }else {
        
        self.usrNameLb.text = @"";
    }
    
    // self.reportType = ReportTypePost;
}

- (void)setCommentModel:(BXGCommunityCommentDetailModel *)commentModel {

    _commentModel = commentModel;
    
    if(commentModel.smallHeadPhoto) {
        
        [self.userIconView sd_setImageWithURL:[NSURL URLWithString:commentModel.smallHeadPhoto] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }else {
        
        [self.userIconView setImage:[UIImage imageNamed:@"默认头像"]];
    }
    
    if(commentModel.username) {
        
        self.usrNameLb.text = commentModel.username;
        
    }else {
        
        self.usrNameLb.text = @"";
    }
}

- (void)installUI {

    // *** User View
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    scrollView.scrollEnabled = false;
    scrollView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];

    scrollView.delegate = self;
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 200, 0);
    [self.view addSubview:scrollView];
    
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:contentView];
    self.scrollView = scrollView;
    
    UIView *userView = [UIView new];
    userView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:userView];
    
    UIImageView *userIconView = [UIImageView new];
    [userView addSubview:userIconView];
    self.userIconView = userIconView;
    
    UILabel *usrNameLb = [UILabel new];
    [userView addSubview:usrNameLb];
    self.usrNameLb = usrNameLb;
    
    [userIconView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(15);
        make.centerY.offset(0);
        make.height.width.offset(32);
    }];
    
    userIconView.layer.cornerRadius = 16;
    userIconView.layer.masksToBounds = true;
    // userIconView.backgroundColor = [UIColor grayColor];
    
    [usrNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(userIconView.mas_right).offset(15);
        make.centerY.offset(0);
    }];
    
    usrNameLb.font = [UIFont bxg_fontRegularWithSize:16];
    usrNameLb.textColor = [UIColor colorWithHex:0x333333];
    
    Weak(weakSelf);
    
    
    UIView *topSpView = [UIView new];
    [contentView addSubview:topSpView];
    topSpView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    
    [topSpView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(0);
        make.top.equalTo(userView.mas_bottom);
        make.right.offset(0);
        make.height.offset(9);
    }];
    
    BXGChoiceTagView *reportTagView = [BXGChoiceTagView new];
    reportTagView.backgroundColor = [UIColor whiteColor];
    reportTagView.maxColCount = 3;
    reportTagView.selectIndexBlock = ^(NSInteger index) {
      
        weakSelf.currentReportTypeId = weakSelf.reportTagView.reportTypeArray[index].idx;
    };
    [contentView addSubview:reportTagView];
    
    UIView *spView = [UIView new];
    [contentView addSubview:spView];
    
    RWTextView *textView = [RWTextView new];
    textView.minimumHeight = 140;
    textView.countNumber = 100;
    // textView.isAutoSizeFit = true;
    textView.placeHolder = @"请详细描述被举报人的行为，确保能被受理！";
    textView.placeHolderLabel.font = [UIFont bxg_fontRegularWithSize:16];

    [contentView addSubview:textView];
    
    BXGRoundedBtn *reportBtn = [BXGRoundedBtn buttonWithType:UIButtonTypeSystem withTitle:@"举报"];

    [reportBtn addTarget:self action:@selector(onClickReportBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:reportBtn];
    
    
    self.reportTagView = reportTagView;
    
    // *** Layout
    
    [userView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
        make.height.offset(62);
    }];
    
    [reportTagView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.offset(0);
        make.top.equalTo(topSpView.mas_bottom).offset(30);
        make.height.offset(0);
    }];
    
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.offset(0);
        make.top.equalTo(reportTagView.mas_bottom);
        make.height.offset(9);
    }];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(reportTagView.mas_bottom).offset(30);
        make.height.offset(140);
    }];
    
    [reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(40);
        make.top.equalTo(textView.mas_bottom).offset(30);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.offset(9);
        make.left.right.offset(0);
        make.width.equalTo(scrollView);
        make.bottom.offset(0);
        make.bottom.equalTo(reportBtn.mas_bottom).offset(500);
    }];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        // make.bottom.equalTo(contentView.mas_bottom);
        make.bottom.offset(0);
        make.left.right.offset(0);
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
    }];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.textView = textView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapView:)];
    [self.view addGestureRecognizer:tap];
}

- (void)onTapView:(UITapGestureRecognizer *)tap; {

    [self.textView endEditing:true];
}
- (void)onClickReportBtn:(UIButton *)sender; {

    NSString *text = self.textView.text;
    if(text){
        
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    if(self.textView.hasEmoji) {
        
        [[BXGHUDTool share] showHUDWithString:kBXGToastNoSupportEmoji];
        return;
    };
    
    if(!self.currentReportTypeId) {
    
        [[BXGHUDTool share] showHUDWithString:@"请选择举报类型"];
        return;
    }
    
    if(!text || text.length <= 0) {
        
        [[BXGHUDTool share] showHUDWithString:@"请详细描述被举报人的行为！"];
        return;
    }
    
    void(^finishedBlock)(BOOL succeed) = ^(BOOL succeed){
    
        if(succeed) {
        
            [[BXGHUDTool share] showHUDWithString:@"举报成功，我们会尽快受理！"];
            
            [self.navigationController popViewControllerAnimated:true];
        }else {
        
            [[BXGHUDTool share] showHUDWithString:@"举报失败!"];
        }
        sender.enabled = true;

    };
    
    
    if(self.reportType == ReportTypePost) {
    
        if(self.model) {
            
            sender.enabled = false;
            [[BXGHUDTool share] showLoadingHUDWithString:@"提交中..." andView:self.view];
            [self.viewModel reportPostWithReportTypeId:self.currentReportTypeId content: self.textView.text reportUserId:self.model.userId postId:self.model.idx finished:finishedBlock];
        }
        
        if(self.detailModel) {
        
            sender.enabled = false;
            [[BXGHUDTool share] showLoadingHUDWithString:@"提交中..." andView:self.view];
            [self.viewModel reportPostWithReportTypeId:self.currentReportTypeId content: self.textView.text reportUserId:self.detailModel.userId postId:self.detailModel.idx finished:finishedBlock];
        }
        
    }
    
    if(self.reportType == ReportTypeComment) {
        
        if(self.commentModel) {
        
            sender.enabled = false;
            [[BXGHUDTool share] showLoadingHUDWithString:@"提交中..." andView:self.view];
            [self.viewModel reportCommentWithReportTypeId:self.currentReportTypeId  content:self.textView.text reportUserId:self.commentModel.userId postId:self.commentModel.postId commentId:self.commentModel.idx finished:finishedBlock];
        }

    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.textView endEditing:true];
}
@end
