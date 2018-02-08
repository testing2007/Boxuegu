//
//  RWStarView.h
//  RWStarView
//
//  Created by RenyingWu on 2017/7/20.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StarDidChageBlockType)(NSInteger stars);
typedef void(^TouchUpInsideBlockType)(NSInteger stars);
@interface RWStarView : UIView
@property (nonatomic, copy) StarDidChageBlockType starDidChageBlock;
@property (nonatomic, copy) TouchUpInsideBlockType touchUpInsideBlock;
@property (nonatomic, assign) NSInteger stars;
@property (nonatomic, assign) BOOL changeStarEnable;

//@property (nonatomic, assign) NSInteger minimumStars;
//@property (nonatomic, assign) NSInteger maximumStars;
@end
