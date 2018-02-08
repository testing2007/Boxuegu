//
//  BXGCommunityPostAuxView.h
//  Boxuegu
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, COMMUNITY_PAGE_TYPE)
{
  COMMUNITY_POST_PAGE_TYPE_CONCERN,     //关注
  COMMUNITY_POST_PAGE_TYPE_DETAIL_TOPIC,//帖子详情页主题
};

@protocol BXGCommunityPostAuxViewDelegate;
@class BXGCommunityDetailModel;

@interface BXGCommunityPostAuxView : UIView

-(void)installUIByType:(COMMUNITY_PAGE_TYPE)type
           andDelegate:(id<BXGCommunityPostAuxViewDelegate>)delegate
andCommunityDetailModel:(BXGCommunityDetailModel*)detailModel;

@property (nonatomic, weak) id<BXGCommunityPostAuxViewDelegate> delegate;

@end
