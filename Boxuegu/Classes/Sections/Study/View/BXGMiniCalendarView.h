//
//  BXGMiniCalendarView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/26.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ClickLeftBtnBlockType)(NSDate *date);
typedef void(^ClickRightBtnBlockType)(NSDate *date);
typedef void(^ClickCenterBtnBlockType)(NSDate *date);
typedef void(^DateDidChangeBlockType)(NSDate *date);

@interface BXGMiniCalendarView : UIView
@property (nonatomic, copy) ClickLeftBtnBlockType clickLeftBtnBlock;
@property (nonatomic, copy) ClickRightBtnBlockType clickRightBtnBlock;
@property (nonatomic, copy) ClickCenterBtnBlockType clickCenterBtnBlock;
@property (nonatomic, copy) DateDidChangeBlockType dateDidChangeBlock;

@property (nonatomic, strong) NSDate* currentDate;
@end
