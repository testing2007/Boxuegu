//
//  BXGOrderCancelObject.h
//  Boxuegu
//
//  Created by apple on 2017/10/30.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ContinuePayBlockType)(void);
typedef void (^CancelPayBlockType)(BOOL bSuccess, NSError *error);

@interface BXGOrderCancelObject : NSObject

- (void)loadCancelMenuViewContraint:(void (^)(MASConstraintMaker *make))constrintBlock
                         andOwnerVC:(UIViewController*)ownerVC
                         andOrderNo:(NSString*)orderNo
                andContinuePayBlock:(ContinuePayBlockType)continePayBlock
                  andCancelPayBlock:(CancelPayBlockType)cancelPayBlock;

@end
