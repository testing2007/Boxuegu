//
//  BXGNineGridLayoutHelper.h
//  CommunityPrj
//
//  Created by apple on 2017/9/2.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXGNineGridLayoutHelper : NSObject

@property(nonatomic, assign) CGSize gridContainerSize;

@property(nonatomic, strong) NSMutableArray *arrGridView;

-(void)gridWithSepcialWidth:(NSInteger)widthRange
                  numPerRow:(NSInteger)numPerRow
                   totalNum:(NSInteger)totalNum
                viewPadding:(CGFloat)viewPadding
            viewPaddingCell:(CGFloat)viewPaddingCell;
@end
