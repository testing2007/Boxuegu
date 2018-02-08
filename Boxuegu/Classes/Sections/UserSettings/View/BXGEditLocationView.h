//
//  BXGEditLocationView.h
//  Boxuegu
//
//  Created by apple on 2018/1/13.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGUserSettingsViewModel.h"

typedef void (^FinishModifyLocationBlockType)(BXGLocationProvince *newCurrentProvince);

@interface BXGEditLocationView : UIView

- (instancetype)initCurrentProvince:(BXGLocationProvince*)currentProvince
                andandUserSettingVM:(BXGUserSettingsViewModel*)settingVM
       andFinishModifyLocationBlock:(FinishModifyLocationBlockType)finishModifyLocationBlock;


@end
