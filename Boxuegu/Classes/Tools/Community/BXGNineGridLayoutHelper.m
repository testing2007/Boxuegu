//
//  BXGNineGridLayoutHelper.m
//  CommunityPrj
//
//  Created by apple on 2017/9/2.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "BXGNineGridLayoutHelper.h"

@implementation BXGNineGridLayoutHelper

-(void)gridWithSepcialWidth:(NSInteger)widthRange
                  numPerRow:(NSInteger)numPerRow
                totalNum:(NSInteger)totalNum
             viewPadding:(CGFloat)viewPadding
         viewPaddingCell:(CGFloat)viewPaddingCell

{
    if(numPerRow<=0||totalNum<=0||numPerRow>9||totalNum>9)
    {
        NSLog(@"参数有误");
        return ;
    }
    
    _arrGridView = [NSMutableArray new];
    if(numPerRow>totalNum)
    {
        numPerRow = totalNum;
    }
    
    CGFloat cellWidth = 0;
    CGFloat cellHeight = 0;
    if(1==totalNum)
    {
        cellWidth = (widthRange-viewPadding*2-(numPerRow-1)*viewPaddingCell) * 2/3;
    }
    else
    {
        cellWidth = (widthRange-viewPadding*2-(numPerRow-1)*viewPaddingCell) / numPerRow;
    }
    cellHeight = cellWidth;
    
    long nLastCol = numPerRow-1;
    long nRow = 0;
    long nCol = 0;
    long nIndex = 0;
    
    CGRect  lastRC = CGRectZero;
    CGRect rc = CGRectZero;
    for(int i=0; i<totalNum; ++i)
    {
        if(nRow==0)
        {
            rc.origin.y = viewPadding;
        }
        else
        {
            if(nCol==0)
            {
                rc.origin.y = CGRectGetMaxY(lastRC)+viewPaddingCell;
            }
            else
            {
                rc.origin.y = lastRC.origin.y;//  CGRectGetMaxY(lastRC);
            }
        }
        if(nCol==0)
        {
            rc.origin.x = viewPadding;
        }
        else if(nCol==nLastCol)
        {
            rc.origin.x = CGRectGetMaxX(lastRC)+viewPaddingCell;
        }
        else
        {
            rc.origin.x = CGRectGetMaxX(lastRC)+viewPaddingCell;
        }
        
        rc.size.width = cellWidth;
        rc.size.height = cellHeight;
        
        UIView *v = [[UIView alloc] initWithFrame:rc];
        [_arrGridView addObject:v];
        
        lastRC = rc;
        nCol++;
        nIndex++;
        if(nIndex%numPerRow==0)
        {
            nRow++;
            nCol = 0;
        }
    }//end for
    
    if(!CGRectIsEmpty(lastRC))
    {
        _gridContainerSize = CGSizeMake(CGRectGetMaxX(lastRC)+viewPadding,
                                        CGRectGetMaxY(lastRC)+viewPadding);
    }
    else
    {
        _gridContainerSize = CGSizeZero;
    }
}

@end
