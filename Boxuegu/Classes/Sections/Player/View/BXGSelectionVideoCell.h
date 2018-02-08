//
//  BXGSelectionVideoCell.h
//  demo-CCMedia
//
//  Created by HM on 2017/6/7.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGCourseOutlineVideoModel.h"

@interface BXGSelectionVideoCell : UITableViewCell

@property (nonatomic, strong) BXGCourseOutlineVideoModel *model;
@property (nonatomic, strong) NSString *cellTitle;
@property (nonatomic, assign) BOOL isArrow;
@end
