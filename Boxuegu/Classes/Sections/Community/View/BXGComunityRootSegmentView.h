//
//  BXGComunityRootSegmentView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BXGComunityRootSegmentView;
typedef void(^ClickSegmentItemBlockType)(BXGComunityRootSegmentView *segmentView, NSInteger index);
@interface BXGComunityRootSegmentView : UIControl
- (void)setItems:(NSArray<NSString *> *)items;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) ClickSegmentItemBlockType clickSegmentItemBlock;
@end
