//
//  BXGEditStudyDirectionVC.h
//  Boxuegu
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGBaseRootVC.h"
#import "BXGUserStudyTargetModel.h"

typedef void (^FinishModifyStudyDirectionBlockType)(BXGUserStudyTargetModel* newStudyDirection);

@interface BXGEditStudyDirectionVC : BXGBaseRootVC

- (instancetype)initDataSource:(NSArray<BXGUserStudyTargetModel*> *)dataSource
            andCurrentSelIndex:(NSNumber*)selIndex
andFinishModifyStudyDirectionBlock:(FinishModifyStudyDirectionBlockType)finishModifyStudyDirectionBlock;

@end
