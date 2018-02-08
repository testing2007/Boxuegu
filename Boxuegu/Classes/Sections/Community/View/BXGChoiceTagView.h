//
//  BXGChoiceTagView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGPostTopicModel.h"
#import "BXGReportTypeModel.h"

typedef void(^SelectIndexBlockType)(NSInteger index);
@interface BXGChoiceTagView : UIView
@property (nonatomic, strong) NSArray<BXGPostTopicModel *> *modelArray;
@property (nonatomic, strong) NSArray<BXGReportTypeModel *> *reportTypeArray;
@property (nonatomic, copy) SelectIndexBlockType selectIndexBlock;
@property (nonatomic, assign) NSInteger maxColCount;
@end
