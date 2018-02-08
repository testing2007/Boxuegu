//
//  BXGDownloadedEditBottomVeiw.m
//  Boxuegu
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGDownloadedEditBottomView.h"
#import "BXGResourceManager.h"

@implementation BXGDownloadedEditBottomView

+(BXGDownloadedEditBottomView*)acquireCustomView
{
    NSArray* objs = [[UINib nibWithNibName:@"BXGDownloadedEditBottomView" bundle:nil] instantiateWithOwner:nil options:nil];
    BXGDownloadedEditBottomView *rootView = objs.lastObject;
    [rootView installUI];
    
    return rootView;
}

-(void) installUI
{
    self.spLine.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    self.totalSpaceLabel.text = [[BXGResourceManager shareInstance] totalSizeInString];
    self.availableSpaceLabel.text =  [[BXGResourceManager shareInstance] freeSizeInString];
//    [self updateShowChoiceSpaceString:@"0B" withAvailableSpaceString:[BXGResourceManager shareInstance].freeSizeInString];
}

- (IBAction)onClickDelete:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(confirmDelete)])
    {
        [_delegate confirmDelete];
    }
}

-(void)setEnableDelete:(BOOL)bEnable
{
    if(bEnable)
    {
        [_confirmDeleteBtn setTitleColor:[UIColor colorWithRed:255 green:85 blue:76] forState:UIControlStateNormal];
        _confirmDeleteBtn.userInteractionEnabled = YES;
    }
    else
    {
        [_confirmDeleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _confirmDeleteBtn.userInteractionEnabled = NO;
    }
}

-(void)updateShowChoiceSpaceInBytes:(CGFloat)choiceSpaceInBytes
          withAvailableSpaceInBytes:(CGFloat)availableSpaceInBytes
{
//    self.choiceSpaceLabel.text = [[BXGResourceManager shareInstance] bytesToString:choiceSpaceInBytes];
//    self.availableSpaceLabel.text =  [[BXGResourceManager shareInstance] bytesToString:availableSpaceInBytes];
}

-(void)updateShowChoiceSpaceString:(NSString*)choiceSpaceString
          withAvailableSpaceString:(NSString*)availableSpaceString
{
//    self.choiceSpaceLabel.text = choiceSpaceString;
//    self.availableSpaceLabel.text = availableSpaceString;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
