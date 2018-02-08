//
//  ImageScrollView.h
//  Boxuegu
//
//  Created by apple on 2017/8/29.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ExitCallBack)();

@interface ImageScrollView : UIScrollView

-(void) addImageView:(UIImageView *)imageView;
-(void)setCurrentIndex:(NSInteger)currentIndex;

@property(nonatomic, copy) ExitCallBack exitCallback;

@end
