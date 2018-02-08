//
//  BXGVolumeAdjustView.m
//  Boxuegu
//
//  Created by apple on 2017/6/27.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGVolumeAdjustView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface BXGVolumeAdjustView()
{
    UISlider* volumeViewSlider;
    float systemVolume;//系统音量值
    float changingVolume;
    CGPoint startPoint;//起始位置
}
@end

@implementation BXGVolumeAdjustView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        //获取系统音量
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        volumeViewSlider = nil;
        for (UIView *view in [volumeView subviews])
        {
            if ([view.class.description isEqualToString:@"MPVolumeSlider"])
            {
                volumeViewSlider = (UISlider *)view;
                break;
            }
        }
        if(volumeViewSlider!=nil)
        {
            systemVolume = volumeViewSlider.value;
            changingVolume = systemVolume;
        }
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(event.allTouches.count == 1){
        //保存当前触摸的位置
        CGPoint point = [[touches anyObject] locationInView:self];
        startPoint = point;
        changingVolume = systemVolume;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if(event.allTouches.count == 1){
        //计算位移
        CGPoint point = [[touches anyObject] locationInView:self];
        float dy = point.y - startPoint.y;
        int nGridVolume = 0;
        if(dy>0){
            nGridVolume = abs((int)dy) / 10;//每10个像素声音减一格
                NSLog(@"%.2f",systemVolume);
                    changingVolume = systemVolume-(nGridVolume*0.05)<0 ? 0 : systemVolume-(nGridVolume*0.05);
                    [volumeViewSlider setValue:changingVolume animated:YES];
                    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        else{
            nGridVolume = abs((int)dy)/10;
            NSLog(@"+x ==%d", nGridVolume);
                NSLog(@"%.2f",systemVolume);
                    changingVolume = systemVolume+(nGridVolume*0.05)>1 ? 1 : systemVolume+(nGridVolume*0.05);
                    [volumeViewSlider setValue:changingVolume animated:YES];
                    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(event.allTouches.count == 1){
        //保存当前触摸的位置
        CGPoint point = [[touches anyObject] locationInView:self];
        startPoint = point;
        systemVolume = changingVolume;
    }
}

@end
