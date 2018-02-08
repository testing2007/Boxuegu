//
//  LoopView.h
//  Boxuegu
//
//  Created by apple on 2017/7/12.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkImageView : UIImageView

typedef BOOL (^TapImageBlock)(NSInteger tag);

-(instancetype)initWithImage:(UIImage *)image
                      andTag:(NSInteger)tag
                 andTapBlock:(TapImageBlock)tapBlock;

-(instancetype)initWithImageURL:(NSURL*)imageURL
            andPlaceholderImage:(UIImage*)placeholderImage
                         andTag:(NSInteger)tag
                    andTapBlock:(TapImageBlock)tapBlock;

@property(nonatomic, assign) NSInteger tag;
@property(nonatomic, copy) TapImageBlock tapImageBlock;

@end

typedef  NS_ENUM(NSInteger, LoopViewMode){
    LoopViewMode_Introduce, //启动介绍页
    LoopViewMode_Recycle,   //循环轮播方式
};


@protocol LoopViewDelegate<NSObject>

@optional

-(void)onFinishIntroduce;

@end

@interface LoopView : UIView

-(instancetype)initLinkImageViews:(NSArray*)arrLinkImageView
                       andRunMode:(LoopViewMode)loopViewMode
                      andDelegate:(id<LoopViewDelegate>)delegate;

-(void)addLinkImageViews:(NSArray*)arrLinkImageView
              andRunMode:(LoopViewMode)loopViewMode
             andDelegate:(id<LoopViewDelegate>)delegate;

@end
