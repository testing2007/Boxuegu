//
//  BXGLearnStatusTable.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/8.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGLearnStatusModel.h"

@interface BXGLearnStatusTable : NSObject
+ (BOOL)createTable;
- (BOOL)addOneRecord:(BXGLearnStatusModel *)model;
- (BOOL)updateOneRecord:(BXGLearnStatusModel *)model;
- (BOOL)deleteOneRecord:(NSString *)idx;
- (BOOL)existRecord:(NSString *)idx;
- (BOOL)deleteAllRecord;
- (NSArray<BXGLearnStatusModel *> *)searchAllRecord;
@end
