//
//  BXGConstrueReplayVC.h
//  Boxuegu
//
//  Created by wurenying on 2018/1/15.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGBaseRootVC.h"

@interface BXGConstrueReplayVC : BXGBaseRootVC
@property (nonatomic, strong) NSString *planId;
- (instancetype)initWithPlanId:(NSString *)planId;
@end
