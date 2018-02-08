//
//  BXGAttentionContentCell.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGCommunityPostModel.h"

typedef void(^ClickReportBtnBlockType)(BXGCommunityPostModel *model);
typedef void(^ClickPraiseBtnBlockType)(BXGCommunityPostModel *model);
typedef void(^ClickMsgBtnBlockType)(BXGCommunityPostModel *model, UIButton *sender);
typedef void(^ClickThumbListBlockType)(BXGCommunityPostModel *model);


@interface BXGAttentionContentCell : UITableViewCell
@property (nonatomic, strong) BXGCommunityPostModel *model;
@property (nonatomic, copy) ClickReportBtnBlockType clickReportBtnBlock;
@property (nonatomic, copy) ClickPraiseBtnBlockType clickPraiseBtnBlock;
@property (nonatomic, copy) ClickMsgBtnBlockType clickMsgBtnBlock;
@property (nonatomic, copy) ClickThumbListBlockType clickThumbListBlock;


@end
