//
//  BXGEditPasswordVC.h
//  Boxuegu
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGBaseRootVC.h"

typedef void (^FinishModifyPasswordBlockType)(NSString* newPassword, NSString* code);

@interface BXGEditPasswordVC : BXGBaseRootVC

- (instancetype)initCellphone:(NSString*)cellphone
andFinishModifyPasswordBlockType:(FinishModifyPasswordBlockType)finishModifyPasswordBlock;

@property (nonatomic, copy) FinishModifyPasswordBlockType finishModifyPasswordBlock;

@end
