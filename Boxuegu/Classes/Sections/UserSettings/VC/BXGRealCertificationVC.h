//
//  BXGRealCertificationVC.h
//  Boxuegu
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGBaseRootVC.h"
#import "BXGUserSettingsViewModel.h"

@interface BXGRealCertificationVC : BXGBaseRootVC

- (instancetype)initHaveCertify:(BOOL)bCertify
                   andViewModel:(BXGUserSettingsViewModel*)userBaseInfoModel;

@end
