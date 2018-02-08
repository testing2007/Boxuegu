//
//  BXGCommunityUserIconListView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGCommunityUserModel.h"

@interface BXGCommunityUserIconListView : UIView
@property (nonatomic, strong) NSArray <NSString *>* urlStringArray;
@property (nonatomic, strong) NSArray <BXGCommunityUserModel *>* cuModelArray;

@property (nonatomic, assign) NSInteger horizontalMargin;
@end
