//
//  BXGEditStudyDirectionView.h
//  Boxuegu
//
//  Created by apple on 2018/1/13.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGFilterBaseView.h"

@interface BXGEditStudyDirectionView : BXGFilterBaseView


-(instancetype)initDataSource:(NSArray<NSString*>*)dataSource
           andCurrentSelIndex:(NSNumber*)curSelIndex;

@end
