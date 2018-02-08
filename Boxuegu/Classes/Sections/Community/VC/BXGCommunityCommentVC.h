//
//  BXGCommunityCommentVC.h
//  Boxuegu
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewController.h"
#import "BXGCommunityCommentDetailModel.h"

@interface BXGCommunityCommentVC : BXGBaseViewController


-(void)loadData:(NSArray<BXGCommunityCommentDetailModel*>*)arrCommentDetailModel;

@end
