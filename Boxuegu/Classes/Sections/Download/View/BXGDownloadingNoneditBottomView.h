//
//  BXGDownloadingNoneditBottomView.h
//  Boxuegu
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGDownloadManagerDelegate.h"

@interface BXGDownloadingNoneditBottomView : UIView

+(BXGDownloadingNoneditBottomView*)acquireCustomView;
-(void) installUI;

@property(weak, nonatomic) id<BXGDownloadManagerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *spLine;

@end
