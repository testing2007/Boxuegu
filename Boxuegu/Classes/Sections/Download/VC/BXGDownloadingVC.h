//
//  BXGDownloadingVC.h
//  Boxuegu
//
//  Created by apple on 2017/8/3.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGBaseRootVC.h"

@interface BXGDownloadingVC : BXGBaseViewController

-(void)adjustLayout;
-(UIBarButtonItem*)rightBarButtonItem;
-(UIBarButtonItem*)leftBarButtonItem;

-(void)doConfirmDelete;
-(void)doAllPause;
-(void)doAllStart;

-(void)reloadEmptyView;

@end
