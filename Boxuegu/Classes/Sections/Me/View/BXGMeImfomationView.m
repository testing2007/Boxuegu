#import "BXGStudyViewModel.h"
#import "BXGMeImfomationView.h"
#import "BXGMeViewModel.h"

#import "BXGDownloadManagerVC.h"
#import "BXGMeLearnedHistoryVC.h"
#import "BXGMeMyMessageVC.h"
//#import "UIView+Extension.h"

#import "BXGBaseNaviController.h"

@interface BXGMeImfomationView()
@property (nonatomic, weak) UIView *loginView;
@property (nonatomic, weak) UIView *noLoginView;

//@property (nonatomic, strong) UIButton *downloadManagerBtn;
//@property (nonatomic, strong) UIButton *viewRecordBtn;
//@property (nonatomic, strong) UIButton *messageBtn;

@property (nonatomic,weak) UIImageView *userIconImageView;
@property (nonatomic,weak) UILabel *nickNameLabel;
@property (nonatomic,weak) UILabel *userNameLabel;

@property (nonatomic,strong) BXGStudyViewModel *viewModel;

@end


@implementation BXGMeImfomationView

#pragma mark - Getter Setter

- (BXGStudyViewModel *)viewModel {

    if(!_viewModel) {
        
        _viewModel = [BXGStudyViewModel share];
    }
    return _viewModel;
}

-(void)setIsLogin:(BOOL)isLogin {

    _isLogin = isLogin;
    if(isLogin){
        [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:[BXGUserDefaults share].userModel.head_img] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        self.nickNameLabel.text = [BXGUserDefaults share].userModel.nickname;
        self.userNameLabel.text = [BXGUserDefaults share].userModel.username;
//        self.loginView.hidden = false;
//        self.noLoginView.hidden = true;
    }
    else {
        [self.userIconImageView setImage:[UIImage imageNamed:@"默认头像"]];
        self.nickNameLabel.text = @"点击登录";
        self.userNameLabel.text = @"开启学习之旅";
//        self.loginView.hidden = true;
//        self.noLoginView.hidden = false;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
    
        [self installUI];
    }
    return self;
}

- (void)installUI {
    
    self.backgroundColor = [UIColor colorWithHex:0x38ADFF];

    UIView *loginView = [self installLoginView];
    [self addSubview:loginView];
    
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.bottom.offset(0);
    }];
}

- (UIView *)installLoginView {

    UIView* superview = [UIView new];
    self.loginView = superview;
    /*
    //初始化button
    self.downloadManagerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.downloadManagerBtn setBackgroundColor:[UIColor clearColor]];
    [self.downloadManagerBtn setImage:[UIImage imageNamed:@"导航栏-下载"] forState:UIControlStateNormal];
    self.viewRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.viewRecordBtn setBackgroundColor:[UIColor clearColor]];
    [self.viewRecordBtn setImage:[UIImage imageNamed:@"导航栏-观看记录"] forState:UIControlStateNormal];
    self.messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.messageBtn setBackgroundColor:[UIColor clearColor]];
    [self.messageBtn setImage:[UIImage imageNamed:@"导航栏-我的消息"] forState:UIControlStateNormal];
    //给button添加事件
    [self.downloadManagerBtn addTarget:self action:@selector(operationDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.viewRecordBtn addTarget:self action:@selector(operationViewRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.messageBtn addTarget:self action:@selector(operationMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [superview addSubview:self.downloadManagerBtn];
    [superview addSubview:self.viewRecordBtn];
    [superview addSubview:self.messageBtn];
    
    [_messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(33);
        make.right.offset(-16);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    [_viewRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_messageBtn.mas_top);
        make.right.equalTo(_messageBtn.mas_left).offset(-15);
        make.width.equalTo(_messageBtn.mas_width);
        make.height.equalTo(_messageBtn.mas_height);
    }];
    [_downloadManagerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewRecordBtn.mas_top);
        make.right.equalTo(_viewRecordBtn.mas_left).offset(-15);
        make.width.equalTo(_viewRecordBtn.mas_width);
        make.height.equalTo(_viewRecordBtn.mas_height);
    }];
    //*/
    
    UIImageView *userIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
    [userIconImageView setImage:[UIImage imageNamed:@"默认头像"]];
    userIconImageView.layer.cornerRadius = userIconImageView.frame.size.width * 0.5;
    userIconImageView.layer.masksToBounds = true;
    userIconImageView.clipsToBounds = true;
    
    self.userIconImageView = userIconImageView;
    [superview addSubview:userIconImageView];
    
    userIconImageView.layer.borderWidth = 1;
    userIconImageView.layer.borderColor = [UIColor colorWithHex:0xF5F5F5].CGColor;
    
    [userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0); //equalTo.(_downloadManagerBtn.mas_bottom).offset(15);
        make.left.offset(15);
        make.height.offset(64);
        make.width.offset(64);
    }];
    
    UILabel *nickNameLabel = [[UILabel alloc]init];
    UILabel *userNameLabel = [[UILabel alloc]init];
    
    [superview addSubview:userNameLabel];
    [superview addSubview:nickNameLabel];
    
    if(self.viewModel.userModel){
        //nickNameLabel.text = self.viewModel.userModel.nickname;
        
        [userIconImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.userModel.head_img] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        nickNameLabel.text = self.viewModel.userModel.nickname;
        userNameLabel.text = self.viewModel.userModel.username;
    
    }else {
        
        nickNameLabel.text = @"点击登录";
        userNameLabel.text = @"开启学习之旅";
        //nickNameLabel.text = @"";
        //userNameLabel.text = @"";
    }
    
    
    self.nickNameLabel = nickNameLabel;
    self.userNameLabel = userNameLabel;
    nickNameLabel.textAlignment =  NSTextAlignmentLeft;
    userNameLabel.textAlignment =  NSTextAlignmentLeft;
    nickNameLabel.font = [UIFont bxg_fontRegularWithSize:18];
    userNameLabel.font = [UIFont bxg_fontRegularWithSize:13];
    nickNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.textColor = [UIColor colorWithHex:0xFFFFFF];
    userNameLabel.alpha = 0.8;
    [nickNameLabel sizeToFit];
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userIconImageView.mas_right).offset(15);
        make.right.offset(-15);
        make.top.equalTo(userIconImageView.mas_centerY).offset(-18-2);
        make.height.mas_equalTo(20);
    
    }];
    [userNameLabel sizeToFit];
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickNameLabel.mas_left);
        make.right.equalTo(nickNameLabel.mas_right);
        make.top.equalTo(nickNameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(13);
    }];
    return superview;
}

- (void)updateImfomation
{
    BXGUserModel *userModel = [BXGUserDefaults share].userModel;
    if(userModel){
        
        [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:userModel.head_img] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        if(userModel.nickname && ![userModel.nickname isEqualToString:@""]) {
        
            self.nickNameLabel.text = userModel.nickname;
        }
        
        if(userModel.username && ![userModel.username isEqualToString:@""]) {
        
            self.userNameLabel.text = userModel.username;
        }
    }else {
        self.userIconImageView.image = [UIImage imageNamed:@"默认头像"];
    }
}
/*
- (void)operationDownload
{
    UIViewController *parentVC = [self findOwnerVC];
    if(parentVC)
    {
        RWLog(@"跳转到下载");
        BXGDownloadManagerVC *vc = [BXGDownloadManagerVC new];
        [parentVC.navigationController pushViewController:vc animated:true];
    }
}

- (void)operationViewRecord
{
    UIViewController *parentVC = [self findOwnerVC];
    if(parentVC)
    {
        RWLog(@"跳转到观看记录");
        BXGMeLearnedHistoryVC *vc = [BXGMeLearnedHistoryVC new];
        [parentVC.navigationController pushViewController:vc animated:true];
    }
}

- (void)operationMessage
{
    UIViewController *parentVC = [self findOwnerVC];
    if(parentVC)
    {
        RWLog(@"跳转到我的消息");
        BXGMeMyMessageVC *vc = [BXGMeMyMessageVC new];
        [parentVC.navigationController pushViewController:vc animated:true];
    }
}
//*/

@end
