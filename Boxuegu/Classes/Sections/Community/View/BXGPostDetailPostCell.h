//
//  BXGPostDetailPostCell.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "BXGCommunityPostModel.h"
#import "BXGCommunityDetailModel.h"

typedef void(^ClickReportBtnBlockType)(BXGCommunityDetailModel *model);
typedef void(^ClickReportBtnDetailModelBlockType)(BXGCommunityDetailModel *model);
typedef void(^ClickPraiseBtnBlockType)(BXGCommunityDetailModel *model);
typedef void(^ClickAttentionBlockType)(BXGCommunityDetailModel *model);
typedef void(^ClickThumbListBlockType)(BXGCommunityDetailModel *model);

@interface BXGPostDetailPostCell : UITableViewCell
// @property (nonatomic, strong) BXGCommunityPostModel *model;
@property (nonatomic, strong) BXGCommunityDetailModel *detailModel;
@property (nonatomic, copy) ClickReportBtnBlockType clickReportBtnBlock;
@property (nonatomic, copy) ClickReportBtnDetailModelBlockType clickReportBtnDetailModelBlock;
@property (nonatomic, copy) ClickPraiseBtnBlockType clickPraiseBtnBlock;
@property (nonatomic, copy) ClickAttentionBlockType clickAttentionBlock;
@property (nonatomic, copy) ClickThumbListBlockType clickThumbListBlock;

// communityDetailModel


@end
