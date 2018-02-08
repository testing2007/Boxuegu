//
//  BXGDownloadingEditBottomView.m
//  Boxuegu
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGDownloadingEditBottomView.h"

@interface BXGDownloadingEditBottomView()

@property (weak, nonatomic) IBOutlet UIButton *confirmDeleteBtn;

@end

@implementation BXGDownloadingEditBottomView

+(BXGDownloadingEditBottomView*)acquireCustomView
{
    NSArray* objs = [[UINib nibWithNibName:@"BXGDownloadingEditBottomView" bundle:nil] instantiateWithOwner:nil options:nil];
    BXGDownloadingEditBottomView *rootView = objs.lastObject;
    [rootView installUI];
    
    return rootView;
}

-(void) installUI
{
//    _confirmDeleteBtn.titleLabel.textColor = [UIColor grayColor];
    [_confirmDeleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _confirmDeleteBtn.userInteractionEnabled = NO;
}

-(void)setEnableDelete:(BOOL)bEnable
{
    if(bEnable)
    {
//        _confirmDeleteBtn.titleLabel.textColor = [UIColor colorWithRed:255 green:85 blue:76];
        [_confirmDeleteBtn setTitleColor:[UIColor colorWithRed:255 green:85 blue:76] forState:UIControlStateNormal];
        _confirmDeleteBtn.userInteractionEnabled = YES;
    }
    else
    {
        [_confirmDeleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _confirmDeleteBtn.userInteractionEnabled = NO;
    }
}

- (IBAction)onClickDelete:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(confirmDelete)])
    {
        [_delegate confirmDelete];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
