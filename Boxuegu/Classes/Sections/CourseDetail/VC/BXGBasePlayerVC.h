//
//  BXGBasePlayerVC.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseRootVC.h"

#import "BXGCourseOutlinePointModel.h"
#import "BXGCourseOutlineVideoModel.h"

#import "BXGPlayerViewModel.h"

#import "BXGBasePlayerContentVC.h"

typedef enum : NSUInteger {
    PlayConditionStart,
    PlayConditionEnd,
    PlayConditionError,
} PlayConditionType;

typedef NS_ENUM(NSUInteger, BXGCoursePlayType) {
    BXGCoursePlayTypeNone = 0,
    BXGCoursePlayTypeProCourse,
    BXGCoursePlayTypeMiniCourse,
    BXGCoursePlayTypeSampleCourse,
    BXGCoursePlayTypeLocalCourse,
};

typedef void(^ErrorBlockType)(NSString *errorMessage, BXGCourseOutlineVideoModel *model);
typedef void(^EndBlockType)(BOOL isEnd, double seekPercent, BXGCourseOutlineVideoModel *model);
typedef void(^StartBlockType)(BXGCourseOutlineVideoModel *model);
typedef void(^ReadyToPlayBlockType)(BXGCourseOutlineVideoModel *model);

@interface BXGBasePlayerVC : BXGBaseRootVC

// 详情视图


// @property (nonatomic, strong) BXGCourseOutlinePointModel *pointModel;
// @property (nonatomic, strong) BXGCourseOutlineVideoModel *videoModel;

@property (nonatomic, copy) ErrorBlockType errorBlock;
@property (nonatomic, copy) EndBlockType endBlock;
@property (nonatomic, copy) StartBlockType startBlock;
@property (nonatomic, copy) ReadyToPlayBlockType readyToPlayBlock;

//@property (nonatomic, strong) BXGPlayerViewModel *playerViewModel;
@property (nonatomic, strong) BXGCourseModel *courseModel;


- (void)playWithVideoModel:(BXGCourseOutlineVideoModel *)videoModel;

- (instancetype)initWithCourseModel:(BXGCourseModel *)courseModel ContentVC:(BXGBasePlayerContentVC *)contentVC;
- (instancetype)initWithCourseId:(NSString *)courseId andContentVC:(BXGBasePlayerContentVC *)contentVC andPlayType:(BXGCoursePlayType)type;
@property (nonatomic, strong) NSArray *pointModelArray;


- (void)autoPlayWithPointId:(NSString *)pointId andVideoId:(NSString *)videoId;
- (instancetype)initWithVideoModel:(BXGCourseOutlineVideoModel *)videoModel andCourseModel:(BXGCourseModel *)courseModel;
@end
