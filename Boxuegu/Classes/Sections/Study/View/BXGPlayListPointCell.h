//
//  BXGPlayListPointCell.h
//  Boxuegu
//
//  Created by HM on 2017/4/22.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BXGCourseOutlinePointModel;
@class BXGCourseInfoSectionModel;
@class BXGCourseInfoPointModel;
@interface BXGPlayListPointCell : UITableViewCell
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) BXGCourseOutlinePointModel *pointModel;
@property (nonatomic, strong) BXGCourseInfoPointModel *infoPointModel;
@property (nonatomic, strong) BXGCourseInfoSectionModel *sectionModel;
@property (nonatomic, strong) void(^downloadBtnBlock)(BXGCourseOutlinePointModel *pointModel);
@end
