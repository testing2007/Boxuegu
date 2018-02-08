//
//  BXGBasePlayerContentVC.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/22.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewController.h"
#import "BXGCourseOutlinePointModel.h"
#import "BXGCourseDetailViewModel.h"

typedef void(^SettingPointModelArrayBlockType)(NSArray <BXGCourseOutlinePointModel *> *pointModelArray);
typedef void(^ClickVideoModelBlockType)(BXGCourseOutlineVideoModel *videoModel);
typedef void(^ReadyToPlayBlockType)(BXGCourseOutlineVideoModel *videoModel);

@interface BXGBasePlayerContentVC : BXGBaseViewController

@property (nonatomic, copy) SettingPointModelArrayBlockType settingPointModelArrayBlock;
@property (nonatomic, copy) ClickVideoModelBlockType clickVideoModelBlock;


- (void)updateHighlightVideoModel:(BXGCourseOutlineVideoModel *)videoModel;
@property (nonatomic, strong) BXGCourseDetailViewModel *viewModel;
- (void)scrollToModel:(id)model;
- (void)searchVideoModel:(BXGCourseOutlineVideoModel *)videoModel;

#warning -
typedef void(^SampleVideoPlayDoneBlockType)();
@property (nonatomic, copy) SampleVideoPlayDoneBlockType sampleVideoPlayDoneBlock;
@end
