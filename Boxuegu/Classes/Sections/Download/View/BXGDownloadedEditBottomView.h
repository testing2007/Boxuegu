//
//  BXGDownloadedEditBottomView.h
//  Boxuegu
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGDownloadManagerDelegate.h"

@interface BXGDownloadedEditBottomView : UIView

+(BXGDownloadedEditBottomView*)acquireCustomView;
-(void) installUI;
@property (weak, nonatomic) IBOutlet UILabel *spLine;

@property(nonatomic, weak) id<BXGDownloadManagerDelegate> delegate;

-(void)setEnableDelete:(BOOL)bEnable;

@property (weak, nonatomic) IBOutlet UIButton *confirmDeleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalSpaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableSpaceLabel;

//-(void)updateShowChoiceSpaceInBytes:(CGFloat)choiceSpaceInBytes
//          withAvailableSpaceInBytes:(CGFloat)availableSpaceInBytes;
//
//-(void)updateShowChoiceSpaceString:(NSString*)choiceSpaceString
//          withAvailableSpaceString:(NSString*)availableSpaceString;

@end
