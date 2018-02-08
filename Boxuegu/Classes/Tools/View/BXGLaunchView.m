//
//  BXGLaunchView.m
//  LaunchPagePrj
//
//  Created by apple on 2017/10/31.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "BXGLaunchView.h"
#import "BXGPageControl.h"

@implementation BXGLaunchRes
@end

@interface BXGLaunchItemView()
@property(nonatomic, weak) UIImageView *topicImageView;
@property(nonatomic, weak) UIImageView *textImageView;
@end

@implementation BXGLaunchItemView

-(instancetype)initWithLaunchRes:(BXGLaunchRes*)launchRes {
    self  = [super initWithFrame:CGRectZero];
    if(self) {
        UIImageView *topicImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchRes.topicImagePath]];
        _topicImageView = topicImageView;
        UIImageView *textImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchRes.textImagePath]];
        _textImageView = textImageView;
        [self addSubview:topicImageView];
        [self addSubview:textImageView];
        
//        [textImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.offset(-33-68);
//            make.centerX.equalTo(self.mas_centerX);
//        }];
//
//        [topicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(textImageView.mas_top).offset(-57);
//            make.centerX.equalTo(self.mas_centerX);
//            make.left.offset(33);
//        }];
        [topicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(SCREEN_HEIGHT*1.0f/6.0f));
            make.left.offset(32);
            make.right.offset(-32);
            make.height.equalTo(@(510.0f/620.0f * (SCREEN_WIDTH-64)));
            make.width.equalTo(@(SCREEN_WIDTH-64));
        }];
        
        [textImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topicImageView.mas_bottom).offset(57);
            make.centerX.equalTo(self.mas_centerX);
//            make.bottom.offset(-33-68);
        }];
        
    }
    return self;
}

- (BXGLaunchItemView*)duplicate
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

@end

@interface BXGLaunchView()<UIScrollViewDelegate>
@property(nonatomic, strong) NSMutableArray *arrLaunchItemViews;
@property(nonatomic, weak) UIScrollView *scrollView;

@property(nonatomic, weak) BXGPageControl *pageControl;
@property(nonatomic, assign) NSInteger curSelIndex;
@property(nonatomic, weak) UIButton *skipButton;

@property(nonatomic, strong) NSTimer *imageChangeTimer;

@end

@implementation BXGLaunchView

-(instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _arrLaunchItemViews = [NSMutableArray new];
        _curSelIndex = -1;

        [self installUI];
    }
    return self;
}

-(void)installUI {
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled =  YES;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    _scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
}

-(void)addLaunchItemView:(BXGLaunchItemView*)launchItemView {
    [_arrLaunchItemViews addObject:launchItemView];
    [_scrollView addSubview:launchItemView];
}

-(void)layout {
    if(_mode == LaunchViewMode_Recycle) {
        if(_arrLaunchItemViews && _arrLaunchItemViews.count>1) {
            BXGLaunchItemView *headView = [_arrLaunchItemViews[0] duplicate];
            BXGLaunchItemView *tailView = [_arrLaunchItemViews[_arrLaunchItemViews.count-1] duplicate];
            [_scrollView addSubview:headView];
            [_scrollView addSubview:tailView];
            [_arrLaunchItemViews insertObject:tailView atIndex:0];
            [_arrLaunchItemViews addObject:headView];
            _curSelIndex = 1;
        } else {
            _curSelIndex = 0;
        }
    } else {
        _curSelIndex = 0;
    }
    if(_arrLaunchItemViews && _arrLaunchItemViews.count>1) {
        BXGPageControl *pageControl = [[BXGPageControl alloc] init];
        [self addSubview:pageControl];
        _pageControl = pageControl;
        [pageControl activeColor:[UIColor colorWithHex:0x38ADFF]];
        [pageControl inactiveColor:[UIColor colorWithHex:0xCCCCCC]];
    }

    if(_arrLaunchItemViews && _arrLaunchItemViews.count>0) {
        BXGLaunchItemView *prevItemView = nil;
        for (BXGLaunchItemView *itemView in _arrLaunchItemViews) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                if(prevItemView) {
                    make.left.equalTo(prevItemView.mas_right);
                } else {
                    make.left.offset(0);
                }
                make.top.offset(0);
                make.width.equalTo(self.mas_width);
                make.height.equalTo(self.mas_height);
            }];
            prevItemView = itemView;
        }
        //自动扩充contentSize
        [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(prevItemView.mas_right);
        }];
        
        if(_mode == LaunchViewMode_Recycle)
        {
//            NSAssert(_arrLaunchItemViews.count>3, @"image count isn't larger than 3");
            _pageControl.currentPage = [self getCurPageIndex];
            _pageControl.numberOfPages = _arrLaunchItemViews.count>3 ? _arrLaunchItemViews.count-2 : _arrLaunchItemViews.count;
        }
        else
        {
            _pageControl.currentPage = [self getCurPageIndex];
            _pageControl.numberOfPages = _arrLaunchItemViews.count;
        }
        
        [_pageControl setCurrentPage:self.curSelIndex];
        CGSize pageSize = [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.bottom.offset(-33);
            make.width.mas_equalTo(pageSize.width);
            make.height.mas_equalTo(4);
        }];
        
        if(_mode == LaunchViewMode_Introduce) {
            UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _skipButton = skipButton;
            [_skipButton.titleLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
            [_skipButton setTitle:@"立即体验" forState:UIControlStateNormal];
            [_skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _skipButton.layer.cornerRadius = 15;
            [_skipButton setBackgroundColor:[UIColor colorWithHex:0x38ADFF]];
            [_skipButton addTarget:self action:@selector(onStartApp:) forControlEvents:UIControlEventTouchUpInside];
            [prevItemView addSubview:_skipButton];
            [_skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.offset(0);
                make.bottom.offset(-55);
                make.width.mas_equalTo(170);
                make.height.mas_equalTo(30);
            }];
        }
    }
    
    if(_mode == LaunchViewMode_Recycle) {
        if(_arrLaunchItemViews.count>1) {
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

- (void)onStartApp:(UIButton*)btn {
    NSLog(@"onStartApp");
    if(_delegate && [_delegate respondsToSelector:@selector(onFinishIntroduce)])
    {
        [_delegate onFinishIntroduce];
    }
}

-(void)dealloc {
    if(_imageChangeTimer) {
        [_imageChangeTimer invalidate];
        _imageChangeTimer = nil;
    }
}

-(void)setupTimer
{
    __weak __typeof (self) weakSelf = self;
    if(_imageChangeTimer) {
        [_imageChangeTimer invalidate];
        _imageChangeTimer = nil;
    }
    _imageChangeTimer = [NSTimer timerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSInteger tempNextIndex = weakSelf.curSelIndex;
        weakSelf.curSelIndex = ++tempNextIndex;
        weakSelf.pageControl.currentPage = [weakSelf getCurPageIndex];
        [weakSelf.scrollView setContentOffset:CGPointMake(_curSelIndex*weakSelf.frame.size.width, 0)];
    }];
    [[NSRunLoop currentRunLoop] addTimer:_imageChangeTimer forMode:NSRunLoopCommonModes];
}

-(void)setCurSelIndex:(NSInteger)newCurSelIndex
{
    if(_curSelIndex==newCurSelIndex)
    {
        return ;
    }
    if(self.arrLaunchItemViews && self.arrLaunchItemViews.count>0)
    {
        if(_mode == LaunchViewMode_Recycle)
        {
            //对于轮播情况
            if(self.arrLaunchItemViews.count==1)
            {
                NSAssert(newCurSelIndex<self.arrLaunchItemViews.count, @"new sel index is equal or larger than the number of the arrayLinkImageView");
                NSAssert(newCurSelIndex>0, @"new sel index is less than zero");
                _curSelIndex = newCurSelIndex;
            }
            else
            {
                if(newCurSelIndex==0)
                {
                    _curSelIndex = self.arrLaunchItemViews.count-2;
                }
                else if(newCurSelIndex==self.arrLaunchItemViews.count-1)
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
    if(_mode == LaunchViewMode_Recycle)
    {
        return _curSelIndex-1<0 ? 0 : _curSelIndex-1;
    }
    else if(_mode == LaunchViewMode_Introduce)
    {
        return _curSelIndex<0 ? 0: _curSelIndex;
    }
    else
    {
        //do nothing
        return _curSelIndex<0 ? 0: _curSelIndex;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDecelerating = %@", scrollView);
    if(self.arrLaunchItemViews && self.arrLaunchItemViews.count>0)
    {
        self.curSelIndex = scrollView.contentOffset.x / self.frame.size.width;
        //  NSLog(@"self.curSelIndex=%ld", self.curSelIndex);
        self.pageControl.currentPage = [self getCurPageIndex];
        [self.scrollView setContentOffset:CGPointMake(_curSelIndex*self.frame.size.width, 0)];
    }
}


@end

