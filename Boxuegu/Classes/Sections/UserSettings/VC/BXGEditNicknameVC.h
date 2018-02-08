//
//  BXGEditNicknameVC.h
//  Boxuegu
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGBaseRootVC.h"

typedef void (^FinishModifyBlockType)(NSString* newNickname);

@interface BXGEditNicknameVC : BXGBaseRootVC

-(instancetype)initNickname:(NSString*)nickname;

@property (nonatomic, copy) FinishModifyBlockType finishModifyBlock;

@end
