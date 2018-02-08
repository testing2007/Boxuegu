//
//  BXGCommunityReportVC.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseRootVC.h"
#import "BXGCommunityPostModel.h"
#import "BXGCommunityDetailModel.h"
#import "BXGCommunityCommentDetailModel.h"

typedef enum : NSUInteger {
    ReportTypeNone,
    ReportTypePost,
    ReportTypeComment,
    ReportTypeReply,
} ReportType;

@interface BXGCommunityReportVC : BXGBaseRootVC
@property (nonatomic, strong) BXGCommunityPostModel *model;
@property (nonatomic, strong) BXGCommunityDetailModel *detailModel;
@property (nonatomic, strong) BXGCommunityCommentDetailModel *commentModel;
@property (nonatomic, assign) ReportType reportType;
@end
