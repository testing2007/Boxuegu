//
//  RWResponseView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/3.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SubResponseBlockType)(UIView *view);
typedef void(^ResponseBlockType)(UIView *view);

typedef void(^TouchBeganBlockType)(CGPoint point);
typedef void(^TouchesEndedBlockType)();
typedef void(^TouchesMovedBlockType)(CGPoint point);

@interface RWResponseView : UIView
@property (nonatomic, copy) SubResponseBlockType subResponseBlock;
@property (nonatomic, copy) ResponseBlockType responseBlock;

@property (nonatomic, copy) TouchBeganBlockType touchBeganBlock;
@property (nonatomic, copy) TouchesEndedBlockType touchesEndedBlock;
@property (nonatomic, copy) TouchesMovedBlockType touchesMovedBlock;
@end
