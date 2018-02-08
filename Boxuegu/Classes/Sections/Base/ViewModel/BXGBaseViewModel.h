//
//  BXGBaseViewModel.h
//  Boxuegu
//
//  Created by RW on 2017/5/11.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGNetWorkTool+Community.h"
#import "BXGUserCenter.h"
#import "BXGNetworkParser.h"

@interface BXGBaseViewModel : NSObject

@property (nonatomic, weak) BXGNetWorkTool *networkTool;
@property (nonatomic, weak) BXGUserModel *userModel;

-(void)requstIsBannedFinishedBlock:(void (^)(BannerType bannerType, NSString *errorMessage))finishedBlock
                         isRefresh:(BOOL)bRefresh;

@end
