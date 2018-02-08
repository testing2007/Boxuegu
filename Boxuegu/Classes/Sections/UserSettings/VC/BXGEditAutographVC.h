//
//  BXGEditAutographVC.h
//  Boxuegu
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGBaseRootVC.h"

typedef void (^FinishModifyAutographBlockType)(NSString* newAutograph);

@interface BXGEditAutographVC : BXGBaseRootVC

-(instancetype)initAutograph:(NSString*)autograph;
@property (nonatomic, copy) FinishModifyAutographBlockType finishModifyAutographBlock;

@end
