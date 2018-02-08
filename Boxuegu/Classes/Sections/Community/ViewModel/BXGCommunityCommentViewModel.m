//
//  BXGCommunityCommentViewModel.m
//  Boxuegu
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommunityCommentViewModel.h"

@implementation BXGCommunityCommentViewModel

//-(void)setDataModel:(BXGCommentDataModel *)dataModel
//{
//    _dataModel = dataModel;
//    [self parseData:_dataModel];
//}
//
//-(void)parseData:(BXGCommentDataModel *)dataModel
//{
//    _txtFrame = CGRectZero;
//    _contentMediaFrame = CGRectZero;
//    _replyTableViewFrame = CGRectZero;
//    _nineGridLayout = [BXGNineGridLayoutHelper new];
//    _cellHeight = 0;
//
//    int txtLabelHeight = 0;
//    int mediaContentHeight = 0;
//    int replyTableViewHeight = 0;
//
//    if(dataModel.text)
//    {
//        txtLabelHeight = [[BXGUtil shareInstance] calculateFontWidthByString:dataModel.text
//                                                                        font:[UIFont systemFontOfSize:12]
//                                                               limitMaxWidth:kCommentLableWidth];
//    }
//    _cellHeight += kCommentViewPadding;
//    if(txtLabelHeight>0)
//    {
//        _txtFrame = CGRectMake(kCommentViewPadding, _cellHeight, kCommentLableWidth, txtLabelHeight);
//        _cellHeight += txtLabelHeight;
//        _cellHeight += kCommentViewPaddingCell;
//    }
//    if(dataModel.arrMediaImage && dataModel.arrMediaImage.count>0)
//    {
//        [_nineGridLayout gridWithSepcialWidth:kCommentMediaViewWidth
//                                    numPerRow:3
//                                     totalNum:dataModel.arrMediaImage.count
//                                  viewPadding:kCommentViewPadding
//                              viewPaddingCell:kCommentViewPaddingCell];
//        mediaContentHeight = _nineGridLayout.gridContainerSize.height;
//    }
//    if(mediaContentHeight>0)
//    {
//        _contentMediaFrame = CGRectMake(kCommentViewPadding, _cellHeight, kCommentMediaViewWidth, mediaContentHeight);
//        _cellHeight += mediaContentHeight;
//        _cellHeight += kCommentViewPaddingCell;
//    }
//    //*/
//    if(dataModel.arrReplyContent && dataModel.arrReplyContent.count>0)
//    {
//        BXGCommentReplyViewModel *replyHelper = [BXGCommentReplyViewModel new];
//        CGFloat sumCommentReplyHeight = 0;
//        for(BXGCommentDataModel* replyDataModelItem in dataModel.arrReplyContent)
//        {
//            [replyHelper parseData:replyDataModelItem];
//            sumCommentReplyHeight += replyHelper.cellHeight;
//        }
//        replyTableViewHeight = sumCommentReplyHeight;
//    }
//    if(replyTableViewHeight>0)
//    {
//        _replyTableViewFrame = CGRectMake(kCommentViewPadding, _cellHeight, kReplyTableViewWidth, replyTableViewHeight);
//        NSLog(@"replyTableViewFrame(x=%lf, y=%lf, w=%lf, h=%lf)", _replyTableViewFrame.origin.x, _replyTableViewFrame.origin.y,
//              _replyTableViewFrame.size.width, _replyTableViewFrame.size.height);
//        _cellHeight += replyTableViewHeight;
//        _cellHeight += kCommentViewPaddingCell;
//    }
//    //*/
//    _cellHeight += kCommentViewPadding;
//}


@end
