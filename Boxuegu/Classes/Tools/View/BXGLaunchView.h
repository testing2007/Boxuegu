//
//  BXGLaunchView.h
//  LaunchPagePrj
//
//  Created by apple on 2017/10/31.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGPageControl.h"

typedef  NS_ENUM(NSInteger, LaunchViewMode){
    LaunchViewMode_Introduce, //启动介绍页
    LaunchViewMode_Recycle,   //循环轮播方式
};

@interface BXGLaunchRes : NSObject
@property(nonatomic, strong) NSString *topicImagePath;
@property(nonatomic, strong) NSString *textImagePath;
@end

@interface BXGLaunchItemView : UIView
-(instancetype)initWithLaunchRes:(BXGLaunchRes*)launchRes;
- (BXGLaunchItemView*)duplicate;

@end

@protocol LaunchViewDelegate<NSObject>

@optional

-(void)onFinishIntroduce;

@end

@interface BXGLaunchView : UIView

@property(nonatomic, weak) id<LaunchViewDelegate> delegate;
@property(nonatomic, assign) LaunchViewMode mode;
-(void)addLaunchItemView:(BXGLaunchItemView*)launchItemView;
-(void)layout;



@end
