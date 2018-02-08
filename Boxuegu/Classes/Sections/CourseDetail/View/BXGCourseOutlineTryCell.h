//
//  BXGCourseOutlineTryCell.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BXGCourseInfoVideoModel;

@interface BXGCourseOutlineTryCell : UITableViewCell
//@property (nonatomic, strong) BXGCourseInfoVideoModel *model;
//@property (nonatomic, assign) BOOL isArrow;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) BXGCourseOutlineVideoModel *model;
@property (nonatomic, assign) BOOL isPlaying;
@end
