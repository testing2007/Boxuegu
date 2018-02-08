//
//  BXGSwitchScrollView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGSwitchScrollView.h"
#import "UIColor+Extension.h"
#import "Masonry.h"

@interface BXGSelectBtn : UIButton

@property (nonatomic, strong) UIView *buttomBar;
@property (nonatomic, copy) NSString *btnTitle;
@property (nonatomic, weak) UILabel *selectTitleLabel;

@end

@implementation BXGSelectBtn

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self installUI];
    }
    return self;
}
#pragma mark - Getter Setter
- (void)setBtnTitle:(NSString *)btnTitle{

    _btnTitle = btnTitle;
    if(btnTitle){
    
        self.selectTitleLabel.text = btnTitle;
    }else {
        self.selectTitleLabel.text = @"";
    }
    
    
}

#pragma mark - install UI

/**
 搭建UI主函数
 */
- (void) installUI {
    
    // 文本
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont bxg_fontRegularWithSize:14];
    titleLabel.textColor = [UIColor colorWithHex:0x333333];
    titleLabel.textColor = [UIColor colorWithHex:0x999999];
    self.selectTitleLabel = titleLabel;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    
    
}


#pragma mark - install SubViews


#pragma mark - Response

/**
 监听按钮被点击
 
 @param selected 是否被点击
 */
-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if(selected) {
        // self.buttomBar.hidden = false;
        // self.buttomBar.backgroundColor = [UIColor colorWithHex:0x38ADFF];
        self.selectTitleLabel.textColor = [UIColor colorWithHex:0x333333];
    }else {
        //self.buttomBar.hidden = true;
        self.selectTitleLabel.textColor = [UIColor colorWithHex:0x999999];
        // self.buttomBar.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    }
    
}

@end



@interface BXGSwitchScrollView()

@property (nonatomic, weak) BXGSelectBtn *leftBtn;
@property (nonatomic, weak) BXGSelectBtn *rightBtn;
@property (nonatomic, weak) UIView *leftView;
@property (nonatomic, weak) UIView *rightView;
@property (nonatomic, copy) NSString *leftTitle;
@property (nonatomic, copy) UIView *rightTitle;
@property (nonatomic, weak) UIView *arrowView;
@property (nonatomic, weak) UIScrollView *detailScrollView;
@property (nonatomic, assign) BOOL isSelectedRight;
@end

@implementation BXGSwitchScrollView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self){
    
        [self installUI];
    }
    return self;
}

- (void)setLeft:(NSString *)title andView:(UIView *)view{

    self.leftBtn.btnTitle = title;
    [self installLeftDetailView:view];
}

- (void)setRight:(NSString *)title andView:(UIView *)view{
    
    self.rightBtn.btnTitle = title;
    [self installRightDetailView:view];
}

- (void)installUI {

    UIView *selectView = [self installSelectView];
    [self addSubview:selectView];
    
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.offset(0);
        make.height.offset(40);
    }];
    
    UIView *separateView = [UIView new];
    [self addSubview:separateView];
    separateView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(selectView.mas_bottom);
        make.height.offset(9);
        make.left.right.offset(0);
    }];
    
    UIView *detailScrollView = [self installDetailScrollView];
    
    [self addSubview:detailScrollView];
    [detailScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separateView.mas_bottom);
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
    }];

}
- (UIView *) installSelectView {
    
    // 创建父控件
    UIView *superView = [UIView new];
    // 头部分割线
     superView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
    // 创建子控件
    BXGSelectBtn *leftBtn = [BXGSelectBtn new];
    BXGSelectBtn *rightBtn = [BXGSelectBtn new];
    leftBtn.backgroundColor = [UIColor whiteColor];
    rightBtn.backgroundColor = [UIColor whiteColor];
    self.leftBtn = leftBtn;
    self.rightBtn = rightBtn;
    // 添加关联
    [superView addSubview:leftBtn];
    [superView addSubview:rightBtn];
    
    leftBtn.selected = true;
    // 配置信息

    // 布局
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        // make.height.equalTo(professionalCource.superview);
        make.top.offset(1);
        make.bottom.offset(0);
    }];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.left.equalTo(leftBtn.mas_right).offset(0);
        // make.height.equalTo(professionalCource.superview);
        make.top.offset(1);
        make.bottom.offset(0);
        make.width.equalTo(leftBtn);
    }];
    
    UIView *arrowView = [UIView new];
    [superView addSubview:arrowView];
    
    arrowView.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.height.offset(3);
        make.width.offset((70.0 / 750) * [UIScreen mainScreen].bounds.size.width);
        make.centerX.equalTo(leftBtn);
    }];
    
    arrowView.layer.cornerRadius = 3.0 / 2.0;
    
    // 监听
    [leftBtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    
    // 接口
    self.arrowView = arrowView;
    
    /* 中间分割线
    UIView *centerSplitLine = [UIView new];
    [superView addSubview:centerSplitLine];
    centerSplitLine.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [centerSplitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.offset(1);
        make.height.offset(15);
    }];
    //*/
    return superView;
}

- (UIView *) installDetailScrollView {
    
    UIScrollView *superView = [UIScrollView new];
    superView.backgroundColor = [UIColor whiteColor];
    
    superView.pagingEnabled = true;
    superView.scrollEnabled = false;
    // superView.contentSize = CGSizeMake(0, 0);
    superView.contentSize = CGSizeMake(100, 100);
    self.detailScrollView = superView;
    return superView;
}

- (void)installLeftDetailView:(UIView *)view{

    UIView *superView = self.detailScrollView;
    [superView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
        make.bottom.offset(0);
        make.height.equalTo(superView);
        make.width.equalTo(superView);
    }];


}

- (void)installRightDetailView:(UIView *)view{
    
    UIView *superView = self.detailScrollView;
    [superView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_right);
        make.right.equalTo(superView).multipliedBy(2);
        make.top.offset(0);
        make.bottom.offset(0);
        make.height.equalTo(superView);
        make.width.equalTo(superView);
    }];
    
    
}

-(NSInteger)selectedSegmentIndex
{
    return self.leftBtn.selected ? 0 : 1;
}

#pragma mark - Response

 - (void)addTarget:(id)target action:(nonnull SEL)action
{
    _target = target;
    _action = action;
}

- (void)clickLeftBtn {
    
    self.detailScrollView.contentOffset = CGPointMake(0,0);
    self.leftBtn.selected = true;
    self.rightBtn.selected = false;
    //    [self.courceArrowView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(self.professionalCourceBtn);
    //    }];
    
//    CGPoint formPoint = self.rightBtn.center;
    CGPoint toPoint = self.leftBtn.center;

    
    [UIView animateWithDuration:0.3 animations:^{
        self.arrowView.center = CGPointMake(toPoint.x, self.arrowView.center.y);
    }];
    
    [self actionCallback];
}
- (void)clickRightBtn {
    
    self.detailScrollView.contentOffset = CGPointMake(self.detailScrollView.bounds.size.width,0);
    self.leftBtn.selected = false;
    self.rightBtn.selected = true;
    CGPoint formPoint = self.arrowView.center;
    CGPoint toPoint = self.rightBtn.center;
    [UIView animateWithDuration:0.3 animations:^{
        self.arrowView.center = CGPointMake(toPoint.x, self.arrowView.center.y);
    }];
    
    [self actionCallback];
}

-(void)actionCallback
{
    if(_target!=nil && _action!=nil)
    {
        [_target performSelector:_action withObject:self];
    }
}


@end
