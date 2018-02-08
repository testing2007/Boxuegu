//
//  RWSlider.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/20.
//  Copyright © 2017年 rw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ValueChageBlockType)(UISlider *sender,float value);
typedef void(^TouchDownBlockType)(UISlider *sender,float value);
typedef void(^TouchUpBlockType)(UISlider *sender,float value);

@interface RWSlider : UISlider
@property (nonatomic, copy) ValueChageBlockType valueChangBlock;
@property (nonatomic, copy) TouchDownBlockType touchDownBlock;
@property (nonatomic, copy) TouchUpBlockType touchUpBlock;

@end
