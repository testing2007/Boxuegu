//
//  BXGLearnStatusModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/8.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGLearnStatusModel : BXGBaseModel
@property (nonatomic, strong) NSString *video_id;
@property (nonatomic, strong) NSString *studyStatus;
@property (nonatomic, strong) NSString *last_learn_time;
@property (nonatomic, strong) NSString *course_id;
@end
