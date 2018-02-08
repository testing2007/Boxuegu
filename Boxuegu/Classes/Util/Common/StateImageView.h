//
//  StateImageVeiw.h
//  PraiseCtrlPrj
//
//  Created by apple on 2017/8/30.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StateImageView : UIImageView

-(instancetype)initWithInactiveImage:(UIImage*)inactiveImage
                     withActiveImage:(UIImage*)activeImage
                            isActive:(BOOL)bActive
                            isAnimal:(BOOL)bAnimal
                         activeBlock:(void(^)(void))activeBlock
                       inactiveBlock:(void(^)(void))inactiveBlock;

//@property (nonatomic, assign) BOOL isActive;

@end
