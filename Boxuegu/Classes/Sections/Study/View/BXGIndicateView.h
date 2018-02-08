//
//  BXGIndicateView.h
//  FSCalendar
//
//  Created by apple on 17/5/23.
//  Copyright © 2017年 wenchaoios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGIndicateView : UIView

//@property(nonatomic, strong) NSString *strSelectDay;

@property (weak, nonatomic) IBOutlet UILabel *selectDayLabel;
@property (weak, nonatomic) IBOutlet UIButton *breakBtn;
@property (weak, nonatomic) IBOutlet UIButton *lessonBtn;

+(BXGIndicateView*)acquireCustomView;
-(void)installUI;
-(void)setSelDay:(NSString*)strSelectDay;
@end
