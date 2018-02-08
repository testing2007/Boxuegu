//
//  BXGPlayerSelectSpeedView.h
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/16.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXGSelectionCell;

@interface BXGPlayerSelectSpeedView : UIButton
//@property (nonatomic, strong) NSString *desc;
//@property (nonatomic, strong) float rate;
@property (nonatomic, copy) void(^didSelectedBlock)(NSInteger index ,NSString *desc, float speed);
@end
