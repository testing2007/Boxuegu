//
//  BXGEditBindCellphoneVC.h
//  Boxuegu
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGBaseRootVC.h"

typedef void (^FinishModifyCellphoneBlockType)(NSString* newCellphone, NSString *vertifyCode);

@interface BXGEditBindCellphoneVC : BXGBaseRootVC

-(instancetype)initWithFinishModifyCellphoneBlock:(FinishModifyCellphoneBlockType)finishCellphoneBlock;
@property (nonatomic, copy) FinishModifyCellphoneBlockType finishCellphoneBlock;


@end
