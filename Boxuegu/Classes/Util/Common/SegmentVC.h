//
//  InfoVC.h
//  ScrollViewPrj
//
//  Created by apple on 2017/8/5.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentVCDelegate.h"

@interface SegmentVC : UIViewController

@property(nonatomic, assign) CGFloat headerViewHeight;
@property(nonatomic, assign) CGFloat segmentHeight;
@property(nonatomic, assign) CGFloat segmentMiniTopInset;

-(instancetype) initWithControllers:(NSArray<UIViewController<SegmentVCDelegate>*> *)arrVC;

@end
