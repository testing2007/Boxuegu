//
//  SegmentVC.m
//  ScrollViewPrj
//
//  Created by apple on 2017/8/5.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "SegmentVC.h"

const void* CURRNTPAGE_SCROLLVIEWOFFSET = &CURRNTPAGE_SCROLLVIEWOFFSET;

@interface SegmentVC ()<UIScrollViewDelegate>

@property(nonatomic, weak) UIView *headerView;
@property(nonatomic, weak) UIView *segmentView;
@property(nonatomic, weak) UIView *indicatorView;

@property(nonatomic, weak) UIView *contentView;
@property(nonatomic, weak) UIScrollView *vcScrollView;

@property(nonatomic, strong) NSArray *arrSegmentView;

@property(nonatomic, strong) NSArray *vcControllers;
@property(nonatomic, strong) UIViewController<SegmentVCDelegate> *currentDisplayController;

@property(nonatomic, assign) NSInteger selVCIndex;

@end

@implementation SegmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;//滑动下拉显示tableView内容最后一条记录的时候,如果没有这条语句, 那么就有可能不能完整显示最后一条记录的情况.
//    self.extendedLayoutIncludesOpaqueBars = NO;
    //self.view.translatesAutoresizingMaskIntoConstraints = NO;
    //self.edgesForExtendedLayout = UIRectEdgeNone;//如果导航栏不透明的情况下:如果不加这个, headerView的高度就会从导航栏坐标开始计算(包括导航栏64高度);
    // self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(instancetype) initWithControllers:(NSArray<UIViewController<SegmentVCDelegate>*> *)arrVC
{
    self = [super init];
    if(self) {
        _headerViewHeight =  200;
        _segmentHeight =  40;
        self.segmentMiniTopInset = 80;
        _selVCIndex = -1;
        
        _vcControllers = [NSArray arrayWithArray:arrVC];
        _arrSegmentView = nil;
        
        [self installUI];
    }
    return self;
}

-(void)installUI
{
    //headerView
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0)
                                                 green:((float)arc4random_uniform(256) / 255.0)
                                                  blue:((float)arc4random_uniform(256) / 255.0)
                                                 alpha:1.0];
    _headerView = headerView;
    
    UIView *segmentView = [UIView new];
    segmentView.backgroundColor = [UIColor grayColor];
    _segmentView = segmentView;
    
    UIView *contentView = [UIView new];
    _contentView = contentView;
    
    UIScrollView *vcScrollView = [[UIScrollView alloc] init];
    vcScrollView.frame = CGRectZero;
    vcScrollView.backgroundColor = [UIColor yellowColor];
    vcScrollView.showsVerticalScrollIndicator = NO;
    vcScrollView.showsHorizontalScrollIndicator = NO;
    vcScrollView.pagingEnabled =  YES;
    vcScrollView.delegate = self;
    vcScrollView.scrollEnabled = YES;
    // contentView.alwaysBounceHorizontal = YES;
    _vcScrollView = vcScrollView;
    
    [self.view addSubview:contentView];
    [contentView addSubview:vcScrollView];
    [self.view addSubview:headerView];
    [self.view addSubview:segmentView];
    
    __block UIView *lastSegmentView = nil;
    __block UIView *lastVCView = nil;
    NSMutableArray *arrSegmentView = [NSMutableArray new];
    [self.vcControllers enumerateObjectsUsingBlock:^(UIViewController<SegmentVCDelegate> *controller,
                                        NSUInteger idx, BOOL *stop) {
        NSString *title = [controller title];
        lastSegmentView = [self addSegmentTitle:title atIndex:idx lastView:lastSegmentView];
        if(lastSegmentView!=nil)
        {
            [arrSegmentView addObject:lastSegmentView];
        }
        lastVCView = [self addVCAndLayout:controller lastView:lastVCView];
    }];
//    if(arrSegmentView.count>0)
//    {
//        _arrSegmentView = [NSArray arrayWithArray:arrSegmentView];
//        if(arrSegmentView.count>1)
//        {
//            UIView *indicatorView = [[UIView alloc] init];
//            indicatorView.backgroundColor = [UIColor redColor];
//            [self.segmentView addSubview:indicatorView];
//            self.indicatorView = indicatorView;
//        }
//    }
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.mas_equalTo(_headerViewHeight);
    }];
    [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.height.mas_equalTo(_segmentHeight);
    }];
    
//    if(_indicatorView)
//    {
//        NSInteger indicationViewHeight = 3;
//        [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@0);
//            // make.left.equalTo(_segmentView.mas_width).multipliedBy(0);
//            make.top.equalTo(_segmentView.mas_bottom).offset(-indicationViewHeight);
//            make.width.equalTo(_segmentView.mas_width).multipliedBy(1.0/arrSegmentView.count);
//            make.height.mas_equalTo(indicationViewHeight);
//        }];
//    }
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view.mas_height);
    }];
    [_vcScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(0);
        make.width.equalTo(_vcScrollView.superview.mas_width);
        make.height.equalTo(_vcScrollView.superview.mas_height);
    }];
    [self.vcScrollView setContentSize:CGSizeMake(self.view.bounds.size.width*_vcControllers.count,
                                                 self.view.bounds.size.height)];
    [self setSelVCIndex:0];
}

-(void)changeSegmentIndex:(UIButton*)button
{
    if(_selVCIndex!=button.tag)
    {
      [self setSelVCIndex:button.tag];
    }
}

-(UIView*)addSegmentTitle:(NSString*)title atIndex:(NSInteger)index lastView:(UIView*)lastView
{
    UIButton *segmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [segmentButton setTitle:title forState:UIControlStateNormal];
    [segmentButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    segmentButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    segmentButton.tag = index;
    [segmentButton addTarget:self action:@selector(changeSegmentIndex:) forControlEvents:UIControlEventTouchUpInside];
    [_segmentView addSubview:segmentButton];
    if(segmentButton.superview)
    {
        [segmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastView ? lastView.mas_right : @0);
            make.top.offset(0);
            make.width.equalTo(_segmentView.mas_width).multipliedBy(1.0 / self.vcControllers.count);
            make.height.mas_equalTo(_segmentHeight);
        }];
    }
    return segmentButton;
}

-(UIView*)addVCAndLayout:(UIViewController<SegmentVCDelegate>*)vcItem lastView:(UIView*)lastView
{
    UIView *currentView = vcItem.view;
    currentView.frame = CGRectZero;
    [self addChildViewController:vcItem];
    [self.vcScrollView addSubview:currentView];
    
    UIScrollView *scrollView = [self scrollViewInPageController:vcItem];
    if(scrollView)
    {
        [currentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastView ? lastView.mas_right : @0);
            make.top.offset(0);
            make.width.equalTo(currentView.superview.mas_width);
            make.height.equalTo(currentView.superview.mas_height);
        }];
        
        scrollView.contentInset = UIEdgeInsetsMake(_headerViewHeight+_segmentHeight-K_NAVIGATION_BAR_OFFSET, 0, 0, 0);
        scrollView.contentOffset = CGPointMake(0, -(_headerViewHeight+_segmentHeight-K_NAVIGATION_BAR_OFFSET));
        //scrollView.alwaysBounceVertical = YES;
    }
    else
    {
        [currentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastView ? lastView.mas_right : @0);
            make.top.equalTo(_segmentView.mas_bottom).offset(0);
            make.width.equalTo(currentView.superview.mas_width);
            make.height.equalTo(currentView.superview.mas_height);
        }];
        
    }
    return currentView;
}

-(void)setSelVCIndex:(NSInteger)index
{
    CGFloat y = self.vcScrollView.contentOffset.y;
    [self.vcScrollView setContentOffset:CGPointMake(_contentView.bounds.size.width*index, y)];
    
     [self removeObseverForPageController:_currentDisplayController];
    _currentDisplayController = ((UIViewController<SegmentVCDelegate> *)_vcControllers[index]);
     [self addObserverForPageController:_currentDisplayController];
    
    UIScrollView *scrollView = [self scrollViewInPageController:_currentDisplayController];
    if(scrollView)
    {
        scrollView.contentInset = UIEdgeInsetsMake(_headerViewHeight+_segmentHeight-64, 0, 0, 0);
        scrollView.contentOffset = CGPointMake(0, -(_headerViewHeight+_segmentHeight-64));
        //scrollView.alwaysBounceVertical = YES;
    }
    if(_indicatorView)
    {
        //index = 1;
//        UIView *subView = (UIView*)(_arrSegmentView[index]);
//        [UIView animateWithDuration:0.3 animations:^{
//            [self.indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
//                //make.left.equalTo(subView.mas_left).offset(0);
//                make.left.equalTo(_segmentView.mas_width).multipliedBy(1.0*index/_arrSegmentView.count);
//            }];
//        }];
    }
    
    _selVCIndex = index;
}

- (UIScrollView *)scrollViewInPageController:
(UIViewController<SegmentVCDelegate> *)controller {
    if ([controller respondsToSelector:@selector(streachScrollView)]) {
        return [controller streachScrollView];
    } else if ([controller.view isKindOfClass:[UIScrollView class]]) {
        return (UIScrollView *)controller.view;
    } else {
        return nil;
    }
}

-(void)addObserverForPageController:(UIViewController <SegmentVCDelegate> *)controller
{
    UIScrollView *scrollView = [self scrollViewInPageController:controller];
    if (scrollView != nil) {
        [scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew context:&CURRNTPAGE_SCROLLVIEWOFFSET];
    }
}

-(void)removeObseverForPageController:(UIViewController <SegmentVCDelegate> *)controller
{
    UIScrollView *scrollView = [self scrollViewInPageController:controller];
    if (scrollView != nil) {
        @try {
            [scrollView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
        }
        @catch (NSException *exception) {
            NSLog(@"exception is %@",exception);
        }
        @finally {
            
        }
    }
}

#pragma mark - obsever delegate methods

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == CURRNTPAGE_SCROLLVIEWOFFSET) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        CGFloat offsetY = offset.y + self.segmentHeight;
        if (offsetY < -self.segmentMiniTopInset) {
            [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(-offsetY);
            }];
        }else{
            [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.segmentMiniTopInset);
            }];
        }
    }
}

-(void)dealloc
{
    for(UIViewController<SegmentVCDelegate> *item in _vcControllers)
    {
        [item removeFromParentViewController];
    }
    [self removeObseverForPageController:self.currentDisplayController];
}

#pragma UIScrollViewDelegate begin
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating = %@", scrollView);
    if(self.vcControllers && self.vcControllers.count>0)
    {
        NSInteger curSelIndex = (scrollView.contentOffset.x+(scrollView.bounds.size.width/2)) / self.contentView.bounds.size.width;
        [self setSelVCIndex:curSelIndex];
    }
}
#pragma UIScrollViewDelegate end

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
