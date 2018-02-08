//
//  BXGDownloadingEditBottomView.h
//  Boxuegu
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGDownloadManagerDelegate.h"

@interface BXGDownloadingEditBottomView : UIView

+(BXGDownloadingEditBottomView*)acquireCustomView;
-(void) installUI;
-(void)setEnableDelete:(BOOL)bEnable;

@property(weak, nonatomic) id<BXGDownloadManagerDelegate> delegate;

@end
