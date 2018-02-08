//
//  BXGDownloadedNoneditBottomView.h
//  Boxuegu
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGDownloadedNoneditBottomView : UIView

+(BXGDownloadedNoneditBottomView*)acquireCustomView;
-(void) installUI;

@property (weak, nonatomic) IBOutlet UILabel *totalSpaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *avaliableSpaceLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressSpace;

@end
