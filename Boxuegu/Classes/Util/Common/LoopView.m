//
//  LoopView.m
//  Boxuegu
//
//  Created by apple on 2017/7/12.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "LoopView.h"
#import "BXGPageControl.h"
#import "UIColor+Extension.h"

@interface LinkImageView()

@end

@implementation LinkImageView
-(instancetype)initWithImage:(UIImage *)image
                      andTag:(NSInteger)tag
                 andTapBlock:(TapImageBlock)tapBlock
{
    self = [super init];
    if(self) {
        self.image = image;
        self.tag = tag;
        _tapImageBlock = tapBlock ? [tapBlock copy] : nil;
    }
    return self;
}

-(instancetype)initWithImageURL:(NSURL*)imageURL
            andPlaceholderImage:(UIImage*)placeholderImage
                         andTag:(NSInteger)tag
                    andTapBlock:(TapImageBlock)tapBlock
{
    self = [super init];
    if(self) {
        [self sd_setImageWithURL:imageURL placeholderImage:placeholderImage];
        self.tag = tag;
        _tapImageBlock = tapBlock ? [tapBlock copy] : nil;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
        [tap addTarget:self action:@selector(tapImageView:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)tapImageView:(UITapGestureRecognizer*)tap {
    if(_tapImageBlock) {
        _tapImageBlock(self.tag);
    }
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    if (self.clipsToBounds) {
//        return nil;
//    }
//    if (self.hidden) {
//        return nil;
//    }
//    if (self.alpha == 0) {
//        return nil;
//    }
//    for (UIView *subview in self.subviews.reverseObjectEnumerator) {
//        CGPoint subPoint = [subview convertPoint:point fromView:self];
//        UIView *result = [subview hitTest:subPoint withEvent:event];
//        if (result) {
//            return result;
//        }
//    }
//    return nil;
//}

@end

@interface LoopView()<UIScrollViewDelegate>

@property(nonatomic, weak) id<LoopViewDelegate> delegate;
@property(nonatomic, strong) NSArray<LinkImageView*> *arrLinkImageView;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, assign) NSInteger curSelIndex;
@property(nonatomic, strong) BXGPageControl *pageControl;
@property(nonatomic, strong) UIButton *skipButton;

@property(nonatomic, strong) NSTimer *imageChangeTimer;
//@property(nonatomic, assign) BOOL bPauseTimer;

@property(nonatomic, assign) LoopViewMode mode;

@end

#define kDelayTimerSeconds 3

@implementation LoopView

-(instancetype)initLinkImageViews:(NSArray*)arrLinkImageView
                       andRunMode:(LoopViewMode)loopViewMode
                      andDelegate:(id<LoopViewDelegate>)delegate
{
    self = [super init];
    if(self)
    {
        _mode = loopViewMode;
        _curSelIndex = -1;
        self.delegate = delegate;
        
        //self.backgroundColor = [UIColor grayColor];
        //无限轮播图
        if(arrLinkImageView && arrLinkImageView.count>0)
        {
            if(loopViewMode==LoopViewMode_Recycle)
            {
                NSMutableArray* arrTemp = nil;
                if(arrLinkImageView.count==1)
                {
                    arrTemp = [NSMutableArray arrayWithArray:arrLinkImageView];
                    _curSelIndex = 0;
                }
                else
                {
                    arrTemp = [NSMutableArray new];
                    LinkImageView* origFirst = (LinkImageView*)arrLinkImageView[arrLinkImageView.count-1];
                    LinkImageView* linkImageFirst = [[LinkImageView alloc] initWithImage:origFirst.image
                                                                                  andTag:origFirst.tag
                                                                             andTapBlock:origFirst.tapImageBlock];
                    
                    LinkImageView* origLast = (LinkImageView*)arrLinkImageView[0];
                    LinkImageView* linkImageLast = [[LinkImageView alloc] initWithImage:origLast.image
                                                                                 andTag:origLast.tag
                                                                            andTapBlock:origLast.tapImageBlock];
                    [arrTemp addObject:linkImageFirst];
                    [arrTemp addObjectsFromArray:arrLinkImageView];
                    [arrTemp addObject:linkImageLast];
                    _curSelIndex = 1;
                    [self setupTimer];//只有大于1张图片的时候才启动定时器
                }
                _arrLinkImageView = [NSArray arrayWithArray:arrTemp];
                [self installUI];
            }
            else
            {
                _arrLinkImageView = [NSArray arrayWithArray:arrLinkImageView];
                _curSelIndex = 0;
                [self installUI];
            }
        }
    }
    return self;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

-(void)addLinkImageViews:(NSArray*)arrLinkImageView
              andRunMode:(LoopViewMode)loopViewMode
             andDelegate:(id<LoopViewDelegate>)delegate
{
    //先清除子视图
    for(UIView *view in self.subviews) {
        [view removeFromSuperview];
    }

    _mode = loopViewMode;
    _curSelIndex = -1;
    self.delegate = delegate;
    
    //self.backgroundColor = [UIColor grayColor];
    //无限轮播图
    if(arrLinkImageView && arrLinkImageView.count>0)
    {
        if(loopViewMode==LoopViewMode_Recycle)
        {
            NSMutableArray* arrTemp = nil;
            if(arrLinkImageView.count==1)
            {
                arrTemp = [NSMutableArray arrayWithArray:arrLinkImageView];
                _curSelIndex = 0;
            }
            else
            {
                arrTemp = [NSMutableArray new];
                LinkImageView* origFirst = (LinkImageView*)arrLinkImageView[arrLinkImageView.count-1];
                LinkImageView* linkImageFirst = [[LinkImageView alloc] initWithImage:origFirst.image
                                                                              andTag:origFirst.tag
                                                                         andTapBlock:origFirst.tapImageBlock];
                
                LinkImageView* origLast = (LinkImageView*)arrLinkImageView[0];
                LinkImageView* linkImageLast = [[LinkImageView alloc] initWithImage:origLast.image
                                                                             andTag:origLast.tag
                                                                        andTapBlock:origLast.tapImageBlock];
                [arrTemp addObject:linkImageFirst];
                [arrTemp addObjectsFromArray:arrLinkImageView];
                [arrTemp addObject:linkImageLast];
                _curSelIndex = 1;
//                [self setupTimer]; //只有大于1张图片的时候才启动定时器
            }
            _arrLinkImageView = [NSArray arrayWithArray:arrTemp];
            [self installUI];
        }
        else
        {
            _arrLinkImageView = [NSArray arrayWithArray:arrLinkImageView];
            _curSelIndex = 0;
            [self installUI];
        }
        
        if(_mode == LoopViewMode_Recycle) {
            if(_arrLinkImageView.count>1) {
                [self setupTimer];
            }
            else {
                if(_imageChangeTimer) {
                    [_imageChangeTimer invalidate];
                    _imageChangeTimer = nil;
                }
            }
        }
        
    }
}


-(void)dealloc
{
    if(_imageChangeTimer!=nil)
    {
        [_imageChangeTimer invalidate];
        _imageChangeTimer = nil;
    }
}

-(void) installUI
{
    if(_arrLinkImageView && _arrLinkImageView.count==0)
        return ;
    
    _scrollView = [UIScrollView new];
     _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled =  YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    //将图片加载到scrollView上面
    [self addImageIntoScrollView];

    _pageControl = [[BXGPageControl alloc] init];
    if(_mode == LoopViewMode_Recycle)
    {
//        NSAssert(_arrLinkImageView.count>3, @"image count isn't larger than 3");
        _pageControl.currentPage = [self getCurPageIndex];
        _pageControl.numberOfPages = _arrLinkImageView.count>3 ? _arrLinkImageView.count-2 : _arrLinkImageView.count;
    }
    else
    {
        _pageControl.currentPage = [self getCurPageIndex];
        _pageControl.numberOfPages = _arrLinkImageView.count;
    }
    [_pageControl activeColor:[UIColor colorWithHex:0x38ADFF]];
    [_pageControl inactiveColor:[UIColor colorWithHex:0xCCCCCC]];
    //_pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    //_pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:_pageControl];
    CGSize pageSize = [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.offset(-10);
        make.width.mas_equalTo(pageSize.width);
        make.height.mas_equalTo(4);
    }];
    if(_pageControl.numberOfPages <= 1)
    {
        _pageControl.hidden = YES;
    }
    else
    {
        _pageControl.hidden = NO;
    }
}

-(void)onStartApp:(id)sender
{
    NSLog(@"onStartApp");
    if(_delegate && [_delegate respondsToSelector:@selector(onFinishIntroduce)])
    {
        [_delegate onFinishIntroduce];
    }
}

-(void)setupTimer
{
//    return;
//    __weak __typeof (self) weakSelf = self;
//    _bPauseTimer = NO;
    if(_imageChangeTimer!=nil)
    {
        [_imageChangeTimer invalidate];
        _imageChangeTimer = nil;
    }
    _imageChangeTimer = [NSTimer timerWithTimeInterval:kDelayTimerSeconds target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
//    }];
//    _imageChangeTimer = [NSTimer scheduledTimerWithTimeInterval:3
//                                                        repeats:YES
//                                                          block:^(NSTimer * _Nonnull timer) {
//                                                              if(!weakSelf.bPauseTimer) {
//                                                                  NSInteger tempNextIndex = weakSelf.curSelIndex;
//                                                                  weakSelf.curSelIndex = ++tempNextIndex;
//                                                                  weakSelf.pageControl.currentPage = [weakSelf getCurPageIndex];
//                                                                  [weakSelf.scrollView setContentOffset:CGPointMake(_curSelIndex*weakSelf.frame.size.width, 0)];
//                                                              }
//                                                          }];
    [[NSRunLoop currentRunLoop] addTimer:_imageChangeTimer forMode:NSRunLoopCommonModes];
}

-(void)onTimer {
//    if(!self.bPauseTimer) {
        NSInteger tempNextIndex = self.curSelIndex;
        self.curSelIndex = ++tempNextIndex;
        self.pageControl.currentPage = [self getCurPageIndex];
        [self.scrollView setContentOffset:CGPointMake(_curSelIndex*self.frame.size.width, 0)];
//    }
}

-(void)addImageIntoScrollView
{
    LinkImageView *linkImageViewFirst = [self.arrLinkImageView objectAtIndex:0];
    [self.scrollView addSubview:linkImageViewFirst];
    [linkImageViewFirst mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.scrollView);
        make.top.equalTo(@0);
        make.left.equalTo(@0);
    }];
    for (NSInteger i = 1; i <self.arrLinkImageView.count ; i++) {
        [self.scrollView addSubview:[self.arrLinkImageView objectAtIndex:i]];
        UIImageView *previous = [self.arrLinkImageView objectAtIndex:i-1];
        [[self.arrLinkImageView objectAtIndex:i] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.scrollView);
            make.top.equalTo(@0);
            make.left.equalTo(previous.mas_right);
        }];
    }
    
    if(_mode == LoopViewMode_Introduce)
    {
        LinkImageView *linkImageViewLast;
        if(self.arrLinkImageView.count==1)
        {
            linkImageViewLast = linkImageViewFirst;
        }
        else
        {
            linkImageViewLast = [self.arrLinkImageView objectAtIndex:self.arrLinkImageView.count-1];
        }
        
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_skipButton.titleLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
        [_skipButton setTitle:@"立即体验" forState:UIControlStateNormal];
        [_skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _skipButton.layer.cornerRadius = 15;
        [_skipButton setBackgroundColor:[UIColor colorWithHex:0x38ADFF]];
        [_skipButton addTarget:self action:@selector(onStartApp:) forControlEvents:UIControlEventTouchUpInside];
        [linkImageViewLast addSubview:_skipButton];
        [_skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.bottom.offset(IS_IPHONE_5?-55:-65);
            make.width.mas_equalTo(170);
            make.height.mas_equalTo(30);
        }];
    }
}

-(void)setCurSelIndex:(NSInteger)newCurSelIndex
{
    if(_curSelIndex==newCurSelIndex)
    {
        return ;
    }
    if(self.arrLinkImageView && self.arrLinkImageView.count>0)
    {
        if(_mode == LoopViewMode_Recycle)
        {
            //对于轮播情况
            if(self.arrLinkImageView.count==1)
            {
                NSAssert(newCurSelIndex<self.arrLinkImageView.count, @"new sel index is equal or larger than the number of the arrayLinkImageView");
                NSAssert(newCurSelIndex>0, @"new sel index is less than zero");
                _curSelIndex = newCurSelIndex;
            }
            else
            {
                if(newCurSelIndex==0)
                {
                    _curSelIndex = self.arrLinkImageView.count-2;
                }
                else if(newCurSelIndex==self.arrLinkImageView.count-1)
                {
                    _curSelIndex = 1;
                }
                else
                {
                    _curSelIndex = newCurSelIndex;
                }
            }
        }
        else
        {
            _curSelIndex = newCurSelIndex;
        }
    }
    else
    {
        _curSelIndex = -1;
    }
}

-(NSInteger)getCurPageIndex
{
    //循环轮播模式
    if(_mode == LoopViewMode_Recycle)
    {
        return _curSelIndex-1<0 ? 0 : _curSelIndex-1;
    }
    else if(_mode == LoopViewMode_Introduce)
    {
        return _curSelIndex<0 ? 0: _curSelIndex;
    }
    else
    {
        //do nothing
        return _curSelIndex<0 ? 0: _curSelIndex;
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if(_imageChangeTimer) {
//        _bPauseTimer = YES;
        //关闭定时器
        [_imageChangeTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating = %@", scrollView);
    if(self.arrLinkImageView && self.arrLinkImageView.count>0)
    {
        self.curSelIndex = scrollView.contentOffset.x / self.frame.size.width;
      //  NSLog(@"self.curSelIndex=%ld", self.curSelIndex);
        self.pageControl.currentPage = [self getCurPageIndex];
        [self.scrollView setContentOffset:CGPointMake(_curSelIndex*self.frame.size.width, 0)];
    }
    if(_imageChangeTimer) {
//        _bPauseTimer = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelayTimerSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_imageChangeTimer setFireDate:[NSDate distantPast]];//开启定时器
        });
    }
}


-(void)layoutSubviews
{
    //NSLog(@"the frame=%@", self);
    if(self.arrLinkImageView && self.arrLinkImageView.count>0)
    {
        [self.scrollView setContentSize:CGSizeMake(self.arrLinkImageView.count*self.frame.size.width, self.frame.size.height)];
        if(_curSelIndex!=-1)
        {
            [self.scrollView setContentOffset:CGPointMake(_curSelIndex*self.frame.size.width, 0)];
        }
    }
}

@end
