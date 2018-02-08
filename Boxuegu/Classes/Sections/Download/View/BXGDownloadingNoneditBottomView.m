//
//  BXGDownloadingNoneditBottomView.m
//  Boxuegu
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGDownloadingNoneditBottomView.h"
#import "UIControl+Custom.h"

@interface BXGDownloadingNoneditBottomView()
@property (weak, nonatomic) IBOutlet UIButton *allPauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *allStartBtn;

@end

@implementation BXGDownloadingNoneditBottomView

+(BXGDownloadingNoneditBottomView*)acquireCustomView
{
    NSArray* objs = [[UINib nibWithNibName:@"BXGDownloadingNoneditBottomView" bundle:nil] instantiateWithOwner:nil options:nil];
    BXGDownloadingNoneditBottomView *rootView = objs.lastObject;
    [rootView installUI];
    
    return rootView;
}

-(void) installUI
{
    self.spLine.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [_allPauseBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [_allPauseBtn addTarget:self action:@selector(onClickAllPauseDown:) forControlEvents:UIControlEventTouchDown];
    [_allPauseBtn addTarget:self action:@selector(onClickAllPauseUpInside:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    //_allPauseBtn.custom_acceptEventInterval = 0.2;

    [_allStartBtn setTitleColor:[UIColor colorWithHex:0x38adff] forState:UIControlStateNormal];
    [_allStartBtn addTarget:self action:@selector(onClickAllStartDown:) forControlEvents:UIControlEventTouchDown];
    [_allStartBtn addTarget:self action:@selector(onClickAllStartUpInside:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    //_allStartBtn.custom_acceptEventInterval = 0.2;
}

-(void)onClickAllPauseDown:(id)sender
{
    //#666
    [_allPauseBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
}

-(void)onClickAllPauseUpInside:(id)sender
{
    [_allPauseBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    if(_delegate && [_delegate respondsToSelector:@selector(allPause)])
    {
        [_delegate allPause];
    }
}

-(void)onClickAllStartDown:(id)sender
{
    //#9ED7FF
    [_allStartBtn setTitleColor:[UIColor colorWithHex:0x9ED7FF] forState:UIControlStateNormal];
}

-(void)onClickAllStartUpInside:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(allStart)])
    {
        [_delegate allStart];
    }
    [_allStartBtn setTitleColor:[UIColor colorWithHex:0x38adff] forState:UIControlStateNormal];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
