//
//  BXGDownloadedNoneditBottomView.m
//  Boxuegu
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGDownloadedNoneditBottomView.h"
#import "BXGResourceManager.h"

@implementation BXGDownloadedNoneditBottomView

+(BXGDownloadedNoneditBottomView*)acquireCustomView
{
    NSArray* objs = [[UINib nibWithNibName:@"BXGDownloadedNoneditBottomView" bundle:nil] instantiateWithOwner:nil options:nil];
    BXGDownloadedNoneditBottomView *rootView = objs.lastObject;
    [rootView installUI];
    
    return rootView;
}

-(void) installUI
{
    BXGResourceManager* resourceManager = [BXGResourceManager shareInstance];
    _avaliableSpaceLabel.text =  [resourceManager freeSizeInString];
    _totalSpaceLabel.text = [resourceManager totalSizeInString];
    _progressSpace.progress = (resourceManager.totalSizeInBytes-resourceManager.freeSizeInBytes) / resourceManager.totalSizeInBytes;
    [_progressSpace setProgressTintColor:[UIColor colorWithRed:56.0f/255.0f green:173.0f/255.0f blue:255.0f/255.0f alpha:1]];
    [_progressSpace setTrackTintColor:[UIColor colorWithRed:198.0f/255.0f green:214.0f/255.0f blue:227.0f/255.0f alpha:1]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
