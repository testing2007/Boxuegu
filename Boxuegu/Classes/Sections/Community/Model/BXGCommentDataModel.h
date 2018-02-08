//
//  BXGCommentDataModel.h
//  CommunityPrj
//
//  Created by apple on 2017/9/1.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark -- will be replace or delete
@interface BXGCommentDataModel : NSObject
@property(nonatomic, strong) NSString *commentId;
@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) NSArray *arrMediaImage;
@property(nonatomic, strong) NSMutableArray<BXGCommentDataModel*> *arrReplyContent;
@end
