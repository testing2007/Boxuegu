//
//  BXGSampleOutlineViewModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"

@interface BXGSampleOutlineViewModel : BXGBaseViewModel
- (instancetype)initWithCourseId:(NSString *)courseId;
- (void)loadDataForSampleOutline;
@end
