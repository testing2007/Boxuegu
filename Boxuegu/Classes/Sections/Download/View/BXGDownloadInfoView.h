//
//  BXGDownloadInfoView.h
//  Boxuegu
//
//  Created by apple on 2017/6/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGDownloadManagerDelegate.h"

@interface BXGDownloadInfoView : UIView

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *leaveSpaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalSpaceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperateLineConstraint;

@property (weak, nonatomic) id<BXGDownloadManagerDelegate> delegate;

-(void)setEnableDownload:(BOOL)bEnable;

+(BXGDownloadInfoView*)acquireCustomView;

@end
