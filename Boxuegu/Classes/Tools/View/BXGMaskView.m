//
//  BXGMaskView.m
//  Boxuegu
//
//  Created by RW on 2017/6/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMaskView.h"
@interface BXGMaskView : UIView
- (instancetype)initWithType:(BXGMaskViewType)type;
- (instancetype)initWithButtonType:(BXGButtonMaskViewType)type buttonBlock:(void (^)())buttonBlock;
- (instancetype)initWithLoadingType:(BXGLoadingMaskViewType)type;
@property (nonatomic, copy) void(^buttonBlock)() ;
@end

@implementation BXGMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        self.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    }
    return self;
}

- (instancetype)initWithButtonType:(BXGButtonMaskViewType)type buttonBlock:(void(^)())buttonBlock {
    self = [self initWithFrame:CGRectZero];
    _buttonBlock = buttonBlock;
    switch (type) {
        case BXGButtonMaskViewTypeLoadFailed:
        {
            [self installMaskView:@"空白页-加载失败" andMessage:@"加载失败!" andButtonText:@"重新加载"];
        }break;
        case BXGButtonMaskViewTypeNoOrder:{
            [self installMaskView:@"空白页-没有课程" andMessage:@"高薪就业从博学谷开启,快去选课吧!" andButtonText:@"热门课程"];
        }break;
        case BXGButtonMaskViewTypeNoLogin:{
            [self installMaskView:@"空白页-没有课程" andMessage:@"开启学习之旅!" andButtonText:@"点击登录"];
        }break;
        case BXGButtonMaskViewTypeNoFilterCourse:{
            [self installMaskView:@"空白页-没有课程" andMessage:@"老师正在进行备课中..." andButtonText:@"热门课程"];
        }break;
        default:
            break;
    }
    return self;
}

- (instancetype)initWithLoadingType:(BXGLoadingMaskViewType)type; {
    self = [self initWithFrame:CGRectZero];
    if(self) {
        switch (type) {
            case BXGLoadingMaskViewTypeNormal:
            {
                [self installLoadingMaskView];
                self.backgroundColor = [UIColor whiteColor];
            }break;
            default:
                break;
        }
    }
    return self;
}

- (instancetype)initWithType:(BXGMaskViewType)type{
    
    self = [self initWithFrame:CGRectZero];
    if(self) {
        
        switch (type) {
            case BXGMaskViewTypeLoadFailed:
            {
                [self installMaskView:@"空白页-加载失败" andMessage:@"加载失败!"];
            }break;
            
            case BXGMaskViewTypeStudyCenterEmpty:
            {
                [self installMaskView:@"空白页-没有课程" andMessage:@"您还没有课程，马上开启高薪之路!"];
            }break;
            case BXGMaskViewTypeDownloadEmpty:
            {
                [self installMaskView:@"空白页-下载" andMessage:@"您还没有下载记录!"];
            }break;
            case BXGMaskViewTypeDownloadedEmpty:
            {
                [self installMaskView:@"空白页-下载" andMessage:@"您还没有已下载记录!"];
            }break;
            case BXGMaskViewTypeDownloadingEmpty:
            {
                [self installMaskView:@"空白页-下载" andMessage:@"您还没有正在下载记录!"];
            }break;
            case BXGMaskViewTypeNoPlan:
            {
                [self installMaskView:@"空白页-加载失败" andMessage:@"老师正在加班加点制定学习计划,敬请期待~"];
            }break;
            case BXGMaskViewTypeRest:
            {
                [self installMaskView:@"空白页-没有课程" andMessage:@"今天休息一下吧，劳逸结合!"];
            }break;
            case BXGMaskViewTypeCourseEmpty:
            {
                [self installMaskView:@"空白页-没有课程" andMessage:@"您还没有课程，马上开启高薪之路!"];
            }break;
            case BXGMaskViewTypeNoMessage:
            {
                [self installMaskView:@"空白页-无消息" andMessage:@"暂时没有消息哟!"];
            }break;
            case BXGMaskViewTypeNoRecentLearned:
            {
                [self installMaskView:@"空白页-无学习记录" andMessage:@"没有观看记录!"];
            }break;
            case BXGMaskViewTypeNoNetwork:
            {
                [self installMaskView:@"空白页-暂无网络" andMessage:@"网络异常"];
            }break;
            case BXGMaskViewTypeNoPraise:
            {
                [self installMaskView:@"空白页-无笔记" andMessage:@"暂无评论哟！"];
            }break;
            case BXGMaskViewTypeNoLogin:
            {
                [self installMaskView:@"空白页-没有课程" andMessage:@"点击登录博学谷,开启学习之旅!"];
            }break;
            case BXGMaskViewTypeNoNote: {
                [self installMaskView:@"空白页-无笔记" andMessage:@"没有笔记数据"];
            }break;
            case BXGMaskViewTypeNoTopicPage: {
                [self installMaskView:@"空白页-无笔记" andMessage:@"还没有帖子哟，快来发帖吧！"];
            }break;
            case BXGMaskViewTypeNoPraisePerson: {
                [self installMaskView:@"空白页-无笔记" andMessage:@"还没有点赞的人！"];
            }break;
            case BXGMaskViewTypeNoRemindPerson: {
                [self installMaskView:@"空白页-无笔记" andMessage:@"还没有要提醒的人！"];
            }break;
            case BXGMaskViewTypeNoAttentionPerson:
            {
                [self installMaskView:@"空白页-无笔记" andMessage:@"还没有关注的人,快去关注吧!"];
            }break;
            case BXGMaskViewTypeNoCoupon:{
                [self installMaskView:@"空白页-没有优惠券" andMessage:@"无相关的优惠券"];
            }break;
            case BXGMaskViewTypeNoData:{
                [self installMaskView:@"空白页-没有课程" andMessage:@"暂无数据哟！"];
            }break;
            case BXGMaskViewTypeNoSearchInfo: {
                [self installMaskView:@"空白页-没有课程" andMessage:@"没有搜索到相关内容！"];
            }break;
            case BXGMaskViewTypeNoConstruePlan: {
                [self installMaskView:@"空白页-没有课程" andMessage:@"今天没有直播课,快去学习录播课程吧!"];
            }break;
            default:
                break;
        }
    }
    return self;
}
#pragma mark - Setting

- (void)installMaskView:(NSString *)imageString andMessage:(NSString *)message {
    [self installMaskView:imageString andMessage:message andButtonText:nil];
}

- (void)installMaskView:(NSString *)imageString andMessage:(NSString *)message andButtonText:(NSString*)buttonText {
    
    self.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.font = [UIFont bxg_fontRegularWithSize:15];
    label.textColor = [UIColor colorWithHex:0x333333];
    [self addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.centerY.offset(15);
    }];
    
    UIImageView *imageView = [UIImageView new];
    [imageView setImage:[UIImage imageNamed:imageString]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(label.mas_top).offset(0);
        make.centerX.offset(0);
    }];
    label.text = message;
    
    if(buttonText) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor colorWithHex:0x38ADFF];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:buttonText forState:UIControlStateNormal];
        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(15);
            make.centerX.offset(0);
            make.width.equalTo(@165);
            make.height.equalTo(@30);
        }];
    }
}

- (void)btnAction {
    if(_buttonBlock) {
        _buttonBlock();
    }
}

- (void)installLoadingMaskView; {
    
    UIActivityIndicatorView *aiview = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:aiview];
    self.backgroundColor = [UIColor whiteColor];
    [aiview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [aiview startAnimating];
}

@end

@implementation UIView (MaskView)

// Loding Mask View

- (void)installLoadingMaskView {
    [self installLoadingMaskViewWithInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)installLoadingMaskViewWithInset:(UIEdgeInsets)inset; {
    
    UIView *maskView = [[BXGMaskView alloc]initWithLoadingType:BXGLoadingMaskViewTypeNormal];
    [self layoutMaskView:maskView andInset:inset];
}

// Normol Mask View

- (void)installMaskView:(BXGMaskViewType)type{
    [self installMaskView:type andInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
}
- (void)installMaskView:(BXGMaskViewType)type andInset:(UIEdgeInsets)inset{

    UIView *maskView = [[BXGMaskView alloc]initWithType:type];
    [self layoutMaskView:maskView andInset:inset];
}

// Button Mask View

- (void)installMaskView:(BXGButtonMaskViewType)type buttonBlock:(void (^)())buttonBlock {
    [self installMaskView:type andInset:UIEdgeInsetsMake(0, 0, 0, 0) buttonBlock:buttonBlock];
}

- (void)installMaskView:(BXGButtonMaskViewType)type andInset:(UIEdgeInsets)inset buttonBlock:(void (^)())buttonBlock {
    
    UIView *maskView = [[BXGMaskView alloc]initWithButtonType:type buttonBlock:buttonBlock];
    [self layoutMaskView:maskView andInset:inset];
}

// Remove Mask View

- (void)removeMaskView; {
    
    NSArray *subviews = self.subviews;
    for(NSInteger i = 0; i < subviews.count; i++) {
        
        UIView *subview = subviews[i];
        if([subview isKindOfClass:[BXGMaskView class]]){
            
            [subview removeFromSuperview];
        }
    }
}

// Layout Mask View

- (void)layoutMaskView:(UIView *)maskView andInset:(UIEdgeInsets)inset {
    [self removeMaskView];
    [self addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(+inset.top);
        make.left.offset(+inset.left);
        make.bottom.offset(-inset.bottom);
        make.right.offset(-inset.right);
        make.width.equalTo(self).offset(-inset.left -inset.right);
        make.height.equalTo(self).offset(-inset.top -inset.bottom);
    }];
}
@end
