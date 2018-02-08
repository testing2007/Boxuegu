//
//  SegmentVCDelegate.h
//  ScrollViewPrj
//
//  Created by apple on 2017/8/5.
//  Copyright © 2017年 itheima. All rights reserved.
//

#ifndef SegmentVCDelegate_h
#define SegmentVCDelegate_h

@protocol SegmentVCDelegate <NSObject>

-(NSString*)title;

@optional
-(UIScrollView *)streachScrollView;

@end

#endif /* SegmentVCDelegate_h */
