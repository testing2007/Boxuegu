//
//  BXGSquareContentCCell.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGCommunityPostModel.h"

@interface BXGSquareContentCCell : UICollectionViewCell
@property (nonatomic, strong) BXGCommunityPostModel *model;
@property (nonatomic, assign) BOOL isLeft;
@end
