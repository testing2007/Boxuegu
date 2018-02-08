//
//  BXGPlayerSelectVideoView.h
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/16.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXGCourseOutlineVideoModel;
@class BXGConstrueReplayModel;




@interface BXGPlayerSelectVideoView : UIButton

//@property (nonatomic, strong) NSArray <BXGCourseOutlineVideoModel *> *videoModels;
//@property (nonatomic, strong) NSArray <BXGConstrueReplayModel *> *replayModels;
@property (nonatomic, strong) NSArray <NSString *> *titleArray;
@property (nonatomic, strong) NSString *currentVideoId;
@property (nonatomic, copy) void(^didSelectedBlock)(NSInteger index);
@property (nonatomic, copy) id<UITableViewDelegate> delegate;
@property (nonatomic, copy) id<UITableViewDataSource> dataSource;
@property (nonatomic, strong) UITableView *tableView;
@end
