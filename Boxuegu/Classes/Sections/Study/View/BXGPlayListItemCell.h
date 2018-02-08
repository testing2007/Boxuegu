//
//  BXGPlayListItemCell.h
//  Boxuegu
//
//  Created by HM on 2017/4/22.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGDownloader.h"


#import "BXGCourseOutlineVideoModel.h"

@interface BXGPlayListItemCell : UITableViewCell <BXGDownloadDelegate>
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) BXGCourseOutlineVideoModel *videoModel;
@property (nonatomic, assign) BOOL isPlaying;

// 暂不使用
@property (nonatomic, assign) BXGStudyPlayerStatusType *playerStatus;
@end
